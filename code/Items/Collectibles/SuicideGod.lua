--local item_SuicideGod = Isaac.GetItemIdByName("Suicide God");
CollectibleType["AGONY_C_SUICIDE_GOD"] = Isaac.GetItemIdByName("Suicide God");
local suicideGod =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
suicideGod.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_suicidegod.anm2")

function suicideGod:checkIfPlayerDying()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_SUICIDE_GOD) then
		local sprite = player:GetSprite()

		if sprite:IsPlaying("Death") and sprite:GetFrame() == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
			for j = 1, 5, 1 do
	   	    	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
	   	    end
		end
	end
end

function suicideGod:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		suicideGod.hasItem = false
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SUICIDE_GOD) then
		if suicideGod.hasItem == false then
			player:AddNullCostume(suicideGod.costumeID)
			suicideGod.hasItem = true
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, suicideGod.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, suicideGod.checkIfPlayerDying)