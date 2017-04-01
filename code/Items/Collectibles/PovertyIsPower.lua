--local item_PIP = Isaac.GetItemIdByName("Poverty is Power");
local PIP =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
PIP.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_povertyequalspower.anm2")

function PIP:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_PIP)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		local collNum = player:GetCollectibleNum(CollectibleType.AGONY_C_PIP)
		player.Damage = (player.Damage + ((99*3)-(player:GetNumBombs() + player:GetNumKeys() + player:GetNumCoins()))*0.04*collNum)
	end
end

function PIP:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		PIP.hasItem = false
	end
	if player:HasCollectible(CollectibleType.AGONY_C_PIP) then
		if PIP.hasItem == false then
			player:AddNullCostume(PIP.costumeID)
			PIP.hasItem = true
		end
		--Force the game to evaluate the cache every 10 frames, only way I found to update the stat when picking up keys
		--Will improve the code as we get more callbacks nicolo pls
		if Game():GetFrameCount()%10 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, PIP.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PIP.cacheUpdate)