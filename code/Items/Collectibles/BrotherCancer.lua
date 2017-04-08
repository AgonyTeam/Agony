local tumor =  {}

function tumor:onUse()
	--Spawn a tumor collectible which does nothing
	local player = Isaac.GetPlayer(0)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.AGONY_C_TUMOR, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0, 0), player)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, tumor.onUse, CollectibleType.AGONY_C_BROTHER_CANCER)