
local birthdayGift = {
	garbageItems = Agony.ENUMS["ItemPools"]["Garbage"]
}

function birthdayGift:onUse()
	-- If the player has the item, removes it and spawn 2 to 3 garbage items
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	local game = Game()
	local r = 2
	if math.random(10) > 7 then
		r = 3
	end
	for i = 1, r, 1 do
		local pos = Isaac.GetFreeNearPosition(player.Position, 50)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, birthdayGift.garbageItems[rng:RandomInt(#birthdayGift.garbageItems)+1], pos, Vector(0,0), nil)
		--POOF!
		local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
		col:Reset()
		Game():SpawnParticles(pos, EffectVariant.POOF01, 1, 1, col, 0)
	end
	player:RemoveCollectible(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, birthdayGift.onUse, CollectibleType.AGONY_C_BIRTHDAY_GIFT)