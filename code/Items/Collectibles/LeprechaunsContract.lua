
local leprechaunContract =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
leprechaunContract.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_leprechaunscontract.anm2")

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

function leprechaunContract:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		leprechaunContract.hasItem = false
	end
	if leprechaunContract.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_LEPRECHAUNS_CONTRACT) then
		player:AddNullCostume(leprechaunContract.costumeID)
		leprechaunContract.hasItem = true
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, leprechaunContract.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, leprechaunContract.cacheUpdate)