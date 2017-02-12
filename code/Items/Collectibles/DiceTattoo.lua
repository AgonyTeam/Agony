CollectibleType["AGONY_C_DICE_TATTOO"] = Isaac.GetItemIdByName("Dice Tattoo");

local diceTattoo =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	roomID = nil,
	isRoomClear = nil
}
diceTattoo.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_dicetattoo.anm2")

function diceTattoo:rerollOnRoomClear()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_DICE_TATTOO) then
		local lvl = Game():GetLevel()
		local room = lvl:GetCurrentRoom()
		if diceTattoo.roomID == nil or diceTattoo.roomID ~= lvl:GetCurrentRoomIndex() then
			diceTattoo.roomID = lvl:GetCurrentRoomIndex()
			diceTattoo.isRoomClear = room:IsClear()
		elseif diceTattoo.isRoomClear == false and room:IsClear() then
			diceTattoo.isRoomClear = true
			if player:GetCollectibleCount() >= 1 then --If the player has collectibles
		    	local colletibles = {}
	        	for name, id in pairs(CollectibleType) do --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
	        	    if (name ~= "NUM_COLLECTIBLES" and player:HasCollectible(id)) then --If they have it add it to the table
	        	        table.insert(colletibles, id)
	         	   end
	       	 	end
	       		player:RemoveCollectible(colletibles[math.random(#colletibles)])
	        	player:AddCollectible(math.random(CollectibleType.NUM_COLLECTIBLES), 0, true)
    		end
		end
	end
end

function diceTattoo:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		diceTattoo.hasItem = false
	end
	if diceTattoo.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_DICE_TATTOO) then
		--player:AddNullCostume(diceTattoo.costumeID)
		diceTattoo.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, diceTattoo.rerollOnRoomClear)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, diceTattoo.onUpdate)