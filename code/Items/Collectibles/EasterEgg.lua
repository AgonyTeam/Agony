
local easterEgg = {
	zanyItems = Agony.ENUMS["ItemPools"]["Zany"]
}

function easterEgg:onUse()
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_EASTER_EGG)
	player:AddCollectible(easterEgg.zanyItems[rng:RandomInt(#easterEgg.zanyItems)+1],true, true)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NULL, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
	player:RemoveCollectible(CollectibleType.AGONY_C_EASTER_EGG)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, easterEgg.onUse, CollectibleType.AGONY_C_EASTER_EGG)