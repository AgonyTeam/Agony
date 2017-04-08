local leprechaunContract =  {}

function leprechaunContract:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_LEPRECHAUNS_CONTRACT)) then
		if (cacheFlag == CacheFlag.CACHE_LUCK) then
			player.Luck = player.Luck + player.Damage*2
		end
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage * 0.75
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, leprechaunContract.cacheUpdate)