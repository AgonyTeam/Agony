
local wormKnot = {
	wormTrinkets = Agony.ENUMS["Trinkets"]["Worms"],
	hasWormTrinket = false
}

function wormKnot:onUse()
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_WORM_KNOT)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, wormKnot.wormTrinkets[rng:RandomInt(#wormKnot.wormTrinkets)+1], Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
	return true
end

function wormKnot:onPlayerUpdate(player)
	if player:HasCollectible(CollectibleType.AGONY_C_WORM_KNOT) then
		local bool = false
		for i = 1, #wormKnot.wormTrinkets do
			if player:HasTrinket(wormKnot.wormTrinkets[i]) then
				bool = true
			end
		end
		wormKnot.hasWormTrinket = bool
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

function wormKnot:cacheUpdate(player,cacheFlag)
	if wormKnot.hasWormTrinket and player:HasCollectible(CollectibleType.AGONY_C_WORM_KNOT) then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage+1.69
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed*1.2
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck +1
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = math.floor(player.MaxFireDelay *0.8)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, wormKnot.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, wormKnot.onUse, CollectibleType.AGONY_C_WORM_KNOT)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, wormKnot.onPlayerUpdate)