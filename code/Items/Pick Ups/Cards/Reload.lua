local reload = {
	pedChests = {
		[4] = PickupVariant.PICKUP_LOCKEDCHEST,
		[5] = PickupVariant.PICKUP_REDCHEST,
		[6] = PickupVariant.PICKUP_BOMBCHEST,
		[7] = PickupVariant.PICKUP_SPIKEDCHEST,
		[8] = PickupVariant.PICKUP_ETERNALCHEST,
	},
}

function reload:onUse()
	local player = Game():GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	Agony:AnimGiantBook("reload.png", "Appear")
	for i = 1, #entities, 1 do
		local eSprite = entities[i]:GetSprite()
		if entities[i].Type == EntityType.ENTITY_PICKUP 
		and (entities[i].Variant == PickupVariant.PICKUP_REDCHEST
		or entities[i].Variant == PickupVariant.PICKUP_LOCKEDCHEST
		or entities[i].Variant == PickupVariant.PICKUP_CHEST
		or entities[i].Variant == PickupVariant.PICKUP_ETERNALCHEST
		or entities[i].Variant == PickupVariant.PICKUP_BOMBCHEST
		or entities[i].Variant == PickupVariant.PICKUP_SPIKEDCHEST
		--[[or entities[i].Variant == PickupVariant.AGONY_PICKUP_SAFE]])
		and entities[i].SubType == ChestSubType.CHEST_OPENED then
			local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, entities[i].Variant, ChestSubType.CHEST_CLOSED, entities[i].Position, Vector (0,0), player)
			--Special safe synergy/easter egg
			--if entities[i].Variant == PickupVariant.AGONY_PICKUP_SAFE then
			--	local oldchestData = entities[i]:GetData()
			--	local newChestData = newChest:GetData()
			--	newChestData.storedItem = oldchestData.storedItem
			--end
			entities[i]:Remove()
		--Special safe synergy/easter egg
		elseif entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE and eSprite:GetFilename() == Agony.Pedestals.ANIMFILE and eSprite:GetOverlayFrame() == Agony.Pedestals.PEDESTAL_SAFE then
			local pos = nil
			local oldchestData = entities[i]:GetData()
			if entities[i].SubType == 0 then --remove the empty pedestal and respawn the chest at the exact same place as before
				pos = entities[i].Position
				entities[i]:Remove()
			else
				pos = Isaac.GetFreeNearPosition(entities[i].Position, 50) --respawn chest next to pedestal
			end
			local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.AGONY_PICKUP_SAFE, ChestSubType.CHEST_CLOSED, pos, Vector (0,0), player)
			local newChestData = newChest:GetData()
			newChestData.storedItem = oldchestData.storedItem
			if entities[i]:Exists() then --change to normal pedestal if it exists
				eSprite:SetOverlayFrame("Alternates", 0) 
			end
		elseif entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE 
		and (eSprite:GetOverlayFrame() == 4 --the frames are the different pedestal visuals, check the pedChests table for meaning of each frame
		or eSprite:GetOverlayFrame() == 5
		or eSprite:GetOverlayFrame() == 6
		or eSprite:GetOverlayFrame() == 7
		or eSprite:GetOverlayFrame() == 8) then
			local pos = nil
			if entities[i].SubType == 0 then --remove the empty pedestal and respawn the chest at the exact same place as before
				pos = entities[i].Position
				entities[i]:Remove()
			else
				pos = Isaac.GetFreeNearPosition(entities[i].Position, 50) --respawn chest next to pedestal
			end
			local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, reload.pedChests[eSprite:GetOverlayFrame()], ChestSubType.CHEST_CLOSED, pos, Vector (0,0), player)
			if entities[i]:Exists() then --change to normal pedestal if it exists
				eSprite:SetOverlayFrame("Alternates", 0) 
			end
		end
	end
end

function reload:getCard(rng, currentCard, cards, runes, onlyRunes)
	if not onlyRunes and rng:RandomFloat() < (1/Card.NUM_CARDS) then
		return Card.AGONY_CARD_RELOAD
	elseif not onlyRunes and not runes and rng:RandomFloat() < (1/(Card.NUM_CARDS-10)) then
		return Card.AGONY_CARD_RELOAD
	end
end
Agony:AddCallback(ModCallbacks.MC_USE_CARD, reload.onUse, Card.AGONY_CARD_RELOAD)
Agony:AddCallback(ModCallbacks.MC_GET_CARD, reload.getCard)