local easterEgg = {
	zanyItems = Agony.ENUMS["ItemPools"]["Zany"]
}

function easterEgg:onUse()
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_EASTER_EGG)
	player:AddCollectible(easterEgg.zanyItems[rng:RandomInt(#easterEgg.zanyItems)+1],99, true)
	local pos = Isaac.GetFreeNearPosition(player.Position, 50)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NULL, pos, Vector(0,0), nil)
	--POOF!
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	Game():SpawnParticles(pos, EffectVariant.POOF01, 1, 1, col, 0)
	Game():SpawnParticles(player.Position, EffectVariant.POOF01, 1, 1, col, 0)
	player:RemoveCollectible(CollectibleType.AGONY_C_EASTER_EGG)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, easterEgg.onUse, CollectibleType.AGONY_C_EASTER_EGG)