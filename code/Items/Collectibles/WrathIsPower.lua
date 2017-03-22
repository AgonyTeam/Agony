--local item_WIP = Isaac.GetItemIdByName("Wrath Is Power");
local WIP =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
WIP.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_wrathequalspower.anm2")

function WIP:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_WIP)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + 0.08 * player:GetNumBombs()*player:GetCollectibleNum(CollectibleType.AGONY_C_WIP)
	end
end

function WIP:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		WIP.hasItem = false
	end

	if player:HasCollectible(CollectibleType.AGONY_C_WIP) then
		--Force the game to evaluate the cache every 10 frames, only way I found to update the stat when picking up keys
		--Will improve the code as we get more callbacks nicolo pls
		if Game():GetFrameCount()%10 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
		if WIP.hasItem == false then
			player:AddNullCostume(WIP.costumeID)
			WIP.hasItem = true
		end
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, WIP.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, WIP.cacheUpdate)