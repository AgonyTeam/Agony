
local tumor =  {
	costumeID = nil,
	hasItem = nil
}

tumor.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_tumor.anm2")

function tumor:onUse()
	--Spawn a tumor collectible which does nothing
	local player = Isaac.GetPlayer(0)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.AGONY_C_TUMOR, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0, 0), player)
	return true
end

function tumor:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		tumor.hasItem = false
	end
	if tumor.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_TUMOR) then
		player:AddNullCostume(tumor.costumeID)
		tumor.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, tumor.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, tumor.onUse, CollectibleType.AGONY_C_BROTHER_CANCER)