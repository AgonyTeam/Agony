local hannah = {
	unlockableItems = {},
}

function hannah:initStats(player, cacheFlag)
	if player:GetPlayerType() == PlayerType.AGONY_PLAYER_HANNAH then --init hannah stats
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 2
		elseif cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearHeight = player.TearHeight + 6
		elseif cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 1
		elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 2
		end
	end
end

function hannah:initItems(player)
	if player:GetPlayerType() == PlayerType.AGONY_PLAYER_HANNAH then
		player:AddNullCostume(NullItemID.AGONY_ID_HANNAH)
		for _,col in pairs(hannah.unlockableItems) do
			if not saveData.lockedItems[col] then
				player:AddCollectible(col, nil, true)
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, hannah.initStats)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, hannah.initItems)