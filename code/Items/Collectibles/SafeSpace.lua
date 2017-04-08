local safeSpace =  {
	storedItem = saveData.safeSpace.storedItem or 0
}

function safeSpace:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		if saveData.safeSpace.storedItem == nil then
			saveData.safeSpace.storedItem = safeSpace.storedItem
			Agony:SaveNow()
		end
	end
	if saveData.safeSpace.storedItem == 0 then
		safeSpace.storedItem = 0
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SAFE_SPACE) and (saveData.safeSpace.storedItem == 0 or saveData.safeSpace.storedItem == nil) then
		if player:GetCollectibleCount() >= 2 then --If the player has collectibles
	    	local collectibles = Agony:getCurrentItems()
			for _, id in pairs(collectibles) do
				if id == CollectibleType.AGONY_C_SAFE_SPACE then
					collectibles[_] = nil
				end
			end
	    	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_SAFE_SPACE)
        	safeSpace.storedItem = collectibles[rng:RandomInt(#collectibles)+1]
       		saveData.safeSpace.storedItem = safeSpace.storedItem
       		Agony:SaveNow()
       		player:RemoveCollectible(safeSpace.storedItem)
    	end
	end
end

function safeSpace:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SAFE_SPACE)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + 0.69*player:GetCollectibleNum(CollectibleType.AGONY_C_SAFE_SPACE);
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, safeSpace.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, safeSpace.onPlayerUpdate)