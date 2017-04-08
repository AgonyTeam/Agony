--local item_KIP = Isaac.GetItemIdByName("Knowledge Is Power");
local KIP =  {}

function KIP:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_KIP)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + 0.08 * player:GetNumKeys()*player:GetCollectibleNum(CollectibleType.AGONY_C_KIP)
	end
end

function KIP:onPlayerUpdate(player)
	if player:HasCollectible(CollectibleType.AGONY_C_KIP) then
		--Force the game to evaluate the cache every 10 frames, only way I found to update the stat when picking up keys
		--Will improve the code as we get more callbacks nicolo pls
		if Game():GetFrameCount()%10 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, KIP.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KIP.cacheUpdate)