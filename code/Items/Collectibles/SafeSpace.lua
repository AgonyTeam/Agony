CollectibleType["AGONY_C_SAFE_SPACE"] = Isaac.GetItemIdByName("Safe Space");
local safeSpace =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	storedItem = saveData.safeSpace.storedItem or 0
}
safeSpace.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_safespace.anm2")

function safeSpace:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		safeSpace.hasItem = false
		if safeSpace.storedItem ~= 0 then
			player:AddCollectible(safeSpace.storedItem, 0, true)
			safeSpace.storedItem = 0
			saveData.safeSpace.storedItem = 0
			Agony:SaveNow()
		end
	end
	if safeSpace.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_SAFE_SPACE) then
		--commented out until we have a costume
		--player:AddNullCostume(safeSpace.costumeID)
		safeSpace.hasItem = true
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SAFE_SPACE) then
		
		if player:GetCollectibleCount() >= 1 then --If the player has collectibles
	    local colletibles = {}
        for name, id in pairs(CollectibleType) do --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
            if (name ~= "NUM_COLLECTIBLES" and player:HasCollectible(id)) then --If they have it add it to the table
                table.insert(colletibles, id)
            end
        end
        safeSpace.storedItem = colletibles[rng:RandomInt(#colletibles)+1]
        saveData.safeSpace.storedItem = safeSpace.storedItem
        player:RemoveCollectible(safeSpace.storedItem)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, safeSpace.onPlayerUpdate)