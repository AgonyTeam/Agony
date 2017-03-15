CollectibleType["AGONY_C_BIRTHDAY_GIFT"] = Isaac.GetItemIdByName("Birthday Gift");

local birthdayGift = {
	garbageItems = {}
}


--All different garbage items, just add a new line to add another one
--The list is not definitive and will defenitely need ot be reworked
--Vanilla garbage
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BUTTER_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_ABEL)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BLACK_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BOOM)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_CAINS_OTHER_EYE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_DEAD_BIRD)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_DESSERT)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_DINNER)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_HOLY_WATER)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MOMS_LIPSTICK)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_PEEPER)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_SAMSONS_CHAINS)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_SKATOLE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BETRAYAL)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MILK)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_GLAUCOMA)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_KING_BABY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MOLDY_BREAD)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_YO_LISTEN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_VARICOSE_VEINS)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BLOODSHOT_EYE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_KIDNEY_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_POOP)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MOMS_PAD)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BREATH_OF_LIFE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MINE_CRAFTER)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_NOTCHED_AXE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_ISAACS_TEARS)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BEST_FRIEND)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_ANEMIC)
--Agony Garbage
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_PERSONAL_BUBBLE)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_PYRITE_NUGGET)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_THE_ROCK)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_WAIT_NO)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_BIRTHDAY_GIFT) --Infinite garbage hell yeah


function birthdayGift:onUpdate()
	-- If the player has the item, removes it and spawn 2 to 3 garbage items
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	local game = Game()
	if player:HasCollectible(CollectibleType.AGONY_C_BIRTHDAY_GIFT) then
		local r = 2
		if math.random(10) > 7 then
			r = 3
		end
		for i = 1, r, 1 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, birthdayGift.garbageItems[rng:RandomInt(#birthdayGift.garbageItems)+1], Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
		end
		player:RemoveCollectible(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, birthdayGift.onUpdate)
