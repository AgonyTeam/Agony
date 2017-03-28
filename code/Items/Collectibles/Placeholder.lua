--1 Detect when the player picks up a new item
--2 Filter the active items out
--3 Give a copy (make sure the copy doesnt trigger)

local placeholder =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	items = saveData.placeholder.items or {},
	newestItem = saveData.placeholder.newestItem or nil
}
placeholder.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_placeholder.anm2")

function placeholder:onUpdate()
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_PLACEHOLDER)
	
	if player:HasCollectible(CollectibleType.AGONY_C_PLACEHOLDER) then
		local currItems = Agony:getCurrentItems()
		if #placeholder.items ~= #currItems then
			local newItem = nil
			for i = 1, #currItems do
				local isNew = true
				for j = 1, #placeholder.items do
					if currItems[i] == placeholder.items[j] then
						isNew = false
					end
				end
				if isNew then
					newItem = currItems[i]
					if newItem ~= player:GetActiveItem() and newItem ~= placeholder.newestItem and newItem ~= CollectibleType.AGONY_C_PLACEHOLDER then
						if placeholder.newestItem ~= nil then
							player:RemoveCollectible(placeholder.newestItem)
						end
						placeholder.newestItem = newItem
						player:AddCollectible(placeholder.newestItem, 0, true)
						saveData.placeholder.newestItem = placeholder.newestItem
						Agony:SaveNow()
					end
				end
			end  
 			placeholder.items = Agony:getCurrentItems()
 			saveData.placeholder.items = placeholder.items
 			Agony:SaveNow()
		end
	end
end

function placeholder:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		placeholder.hasItem = false
	end
	if placeholder.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_PLACEHOLDER) then
		player:AddNullCostume(placeholder.costumeID)
		placeholder.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, placeholder.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, placeholder.onPlayerUpdate)