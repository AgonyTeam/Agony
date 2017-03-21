treasurehoarder = {
	--entityType = nil,
	rseed = 1,
	isPrizeDue = false,
	isGoingToTP = false,
	pos = nil
}
--treasurehoarder.entityType = Isaac.GetEntityTypeByName("Treasure Hoarder")
EntityType["AGONY_ETYPE_TREASURE_HOARDER"] = Isaac.GetEntityTypeByName("Treasure Hoarder");
--local debug_text = nil
local collList = nil

function treasurehoarder:ai_main(npc)
	local room = Game():GetRoom()
	local player = Game():GetPlayer(0)
	local sprite = npc:GetSprite()	

	if (npc.State == NpcState.STATE_INIT) then
		npc.V1 = npc.Position
		npc.Position = npc.V1
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		npc:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
		--npc.CanShutDoors = false
		npc.PositionOffset = Vector(0,8)
		--sprite:SetAnimation ("Idle")
		--sprite:Play("Idle", true) 
		--npc.Friction = 10.0
		npc.State = NpcState.STATE_IDLE
	elseif (npc.State == NpcState.STATE_IDLE) then
		npc.Position = npc.V1
		--npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    end
	


	--debug_text = tostring(sprite:IsPlaying("Idle"))
	--debug_text2 = tostring(sprite:IsPlaying("PayPrize"))
	--debug_text3 = tostring(sprite:IsPlaying("PayNothing"))

    if player.Position:Distance(npc.Position) < 40 and sprite:IsPlaying("Idle") == true then
    	--Play the hoarder
    	--Credit to lombardo2 for this if statement
    	-- This wont accept modded item
    	if player:GetCollectibleCount() >= 1 then --If the player has collectibles
            local colletibles = Agony:getCurrentItems()
            player:RemoveCollectible(colletibles[math.random(#colletibles)]) --Randomly select a collectible from the table and remove it
	    	treasurehoarder.rseed = (room:GetDecorationSeed()*treasurehoarder.rseed)%100
			if treasurehoarder.rseed + ((player.Luck)*2) > 30 then
				--Give Price
				sprite:SetAnimation ("PayPrize")
				sprite:Play("PayPrize", true)
				treasurehoarder.isPrizeDue = true 
			else
				--Gives nothing
				sprite:SetAnimation ("PayNothing")
				sprite:Play("PayNothing", true)

			end
		end
    end

    if sprite:IsPlaying("Idle") == false then
     	if sprite:IsPlaying("PayPrize") == false then
     		if sprite:IsPlaying("PayNothing") == false then
    			sprite:SetAnimation("Idle")
    			sprite:Play("Idle", true)
    		end
    		if treasurehoarder.isPrizeDue == true then
   	    		--Spawn prize
   	    		local randprice = math.random(100+player.Luck)
   	    		if randprice >= 99 then 
   	    			for j = 1, 5, 1 do
   	    				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    				sprite:SetAnimation("Teleport")
   	    				sprite:Play("Teleport", true)
   	    				treasurehoarder.isGoingToTP = true
   	    			end
   	    		elseif randprice > 96 then
   	    			for j = 1, 3, 1 do
   	    				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    			end
   	    		elseif randprice > 92 then
   	    			for j = 1, 2, 1 do
   	    		   	   	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
					    end
   	    		elseif randprice > 75 then
   	    			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    		elseif randprice > 60 then
   	    			for j = 1, 10, 1 do
   	    				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    			end
   	    		elseif randprice > 50 then
   	    			for j = 1, 5, 1 do
   	    				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    			end
   	    		elseif randprice > 25 then
   	    			for j = 1, 3, 1 do
   	    				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    			end
   	    		else
   	    			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 0, Isaac.GetFreeNearPosition(npc.Position, 50), Vector (0,0), npc)
   	    		end
   			 	treasurehoarder.isPrizeDue = false
    		end
    	end
    end 
	
    if sprite:IsPlaying("Teleport") and treasurehoarder.isGoingToTP == true then
    	npc:Remove()
		Agony.redoSpawnList(); --avoid respawning after teleporting away
    end

end


--function treasurehoarder:universalDebugText()
--	Isaac.RenderText(debug_text, 40, 250, 255, 255, 0, 255);
--	Isaac.RenderText(debug_text2, 40, 240, 255, 255, 0, 255);
--	Isaac.RenderText(debug_text3, 40, 230, 255, 255, 0, 255);
--end

-- Register the callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, treasurehoarder.ai_main, EntityType.AGONY_ETYPE_TREASURE_HOARDER)
--Agony:AddCallback(ModCallbacks.MC_POST_RENDER, treasurehoarder.universalDebugText)