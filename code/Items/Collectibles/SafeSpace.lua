local safeSpace =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	storedItem = saveData.safeSpace.storedItem or 0
}
safeSpace.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_safespace.anm2")

function safeSpace:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		safeSpace.hasItem = false
		if saveData.safeSpace.storedItem == nil then
			saveData.safeSpace.storedItem = safeSpace.storedItem
			Agony:SaveNow()
		end
	end
	if saveData.safeSpace.storedItem == 0 then
		safeSpace.storedItem = 0
	end
	if safeSpace.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_SAFE_SPACE) then
		--commented out until we have a costume
		player:AddNullCostume(safeSpace.costumeID)
		safeSpace.hasItem = true
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SAFE_SPACE) and (saveData.safeSpace.storedItem == 0 or saveData.safeSpace.storedItem == nil) then
		if player:GetCollectibleCount() >= 2 then --If the player has collectibles
	    	local colletibles = {}
	    	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_SAFE_SPACE)
        	for name, id in pairs(CollectibleType) do --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
            	if (name ~= "NUM_COLLECTIBLES" and player:HasCollectible(id)) and id ~= CollectibleType.AGONY_C_SAFE_SPACE then --If they have it add it to the table
               		table.insert(colletibles, id)
            	end
        	end
        	safeSpace.storedItem = colletibles[rng:RandomInt(#colletibles)+1]
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