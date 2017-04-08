--local item_SolomonCrown = Isaac.GetItemIdByName("Solomon's Crown");
local solomonCrown =  {}

function solomonCrown:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SOLOMON_CROWN)) and player:GetHearts() == player:GetMaxHearts()/2 then
		if (cacheFlag == CacheFlag.CACHE_LUCK) then
			player.Luck = (player.Luck + 2)*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN);
		end
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = (player.Damage + 1.2)*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN);
		end
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = (player.MoveSpeed + 0.3)*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN);
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			player.MaxFireDelay = player.MaxFireDelay - 2*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN)
		end
	end
end

function solomonCrown:evaluateCache(player)
	if player:HasCollectible(CollectibleType.AGONY_C_SOLOMON_CROWN) then
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, solomonCrown.evaluateCache)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, solomonCrown.cacheUpdate)