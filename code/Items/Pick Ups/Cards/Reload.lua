Card["AGONY_CARD_RELOAD"] = Isaac.GetCardIdByName("Reload")
local reload = {}

function reload.onUse()
	local player = Game():GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	Agony:AnimGiantBook("reload.png", "Appear")
	for i = 1, #entities, 1 do
		if entities[i].Type == EntityType.ENTITY_PICKUP 
			and (entities[i].Variant == PickupVariant.PICKUP_REDCHEST
			or entities[i].Variant == PickupVariant.PICKUP_LOCKEDCHEST
			or entities[i].Variant == PickupVariant.PICKUP_CHEST
			or entities[i].Variant == PickupVariant.PICKUP_ETERNALCHEST
			or entities[i].Variant == PickupVariant.PICKUP_BOMBCHEST
			or entities[i].Variant == PickupVariant.PICKUP_SPIKEDCHEST)
			and entities[i].SubType == ChestSubType.CHEST_OPENED then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, entities[i].Variant, ChestSubType.CHEST_CLOSED, entities[i].Position, Vector (0,0), player)
			entities[i]:Remove()
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_CARD, reload.onUse, Card.AGONY_CARD_RELOAD)