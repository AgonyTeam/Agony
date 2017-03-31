local pilgrimsShoe =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
pilgrimsShoe.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_pilgrimsshoe.anm2")

function pilgrimsShoe:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_PILGRIMS_SHOE)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + (2-player.MoveSpeed)*1.5
		end
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = player.MoveSpeed*0.7
		end
	end
end

function pilgrimsShoe:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		pilgrimsShoe.hasItem = false
	end

	if player:HasCollectible(CollectibleType.AGONY_C_PILGRIMS_SHOE) then
		--Force the game to evaluate the cache every 3 frames
		--Will improve the code as we get more callbacks nicolo pls
		if Game():GetFrameCount()%3 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, pilgrimsShoe.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, pilgrimsShoe.cacheUpdate)