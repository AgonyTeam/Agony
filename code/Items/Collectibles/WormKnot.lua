
local wormKnot = {
	wormTrinkets = Agony.ENUMS["Trinkets"]["Worms"]
}



function wormKnot:onUse()
	-- If the player has the item, removes it and spawn 2 to 3 garbage items
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	local game = Game()
	local r = 2
	if math.random(10) > 7 then
		r = 3
	end
	for i = 1, r, 1 do
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, wormKnot.garbageItems[rng:RandomInt(#wormKnot.garbageItems)+1], Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
	end
	player:RemoveCollectible(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, wormKnot.onUse, CollectibleType.AGONY_C_BIRTHDAY_GIFT)