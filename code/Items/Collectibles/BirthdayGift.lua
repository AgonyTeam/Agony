CollectibleType["AGONY_C_BIRTHDAY_GIFT"] = Isaac.GetItemIdByName("Birthday Gift");

local birthdayGift = {
	garbageItems = Agony.ENUMS["ItemPools"]["Garbage"]
}


--All different garbage items, just add a new line to add another one
--The list is not definitive and will defenitely need ot be reworked
--Vanilla garbage
--Passives
--[[
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
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BETRAYAL)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MILK)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_GLAUCOMA)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_KING_BABY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MOLDY_BREAD)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_YO_LISTEN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_VARICOSE_VEINS)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BLOODSHOT_EYE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MINE_CRAFTER)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_ANEMIC)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BOBS_BRAIN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BOX)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BROTHER_BOBBY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_GHOST_BABY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_HARLEQUIN_BABY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_LEECH)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_LUCKY_FOOT)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_PUNCHING_BAG)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_SMART_FLY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_LOST_FLY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_PAPA_FLY)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_OBSESSED_FAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_SHADE)
--Actives
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BUTTER_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_KIDNEY_BEAN)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_POOP)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BREATH_OF_LIFE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_MOMS_PAD)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_NOTCHED_AXE)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_ISAACS_TEARS)
table.insert(birthdayGift.garbageItems,CollectibleType.COLLECTIBLE_BEST_FRIEND)

--Agony Garbage
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_PERSONAL_BUBBLE)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_PYRITE_NUGGET)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_THE_ROCK)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_WAIT_NO)
table.insert(birthdayGift.garbageItems,CollectibleType.AGONY_C_BIRTHDAY_GIFT) --Infinite garbage hell yeah
 ]]--

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
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, birthdayGift.garbageItems[rng:RandomInt(#birthdayGift.garbageItems)+1], Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
	end
	player:RemoveCollectible(CollectibleType.AGONY_C_BIRTHDAY_GIFT)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, birthdayGift.onUse, CollectibleType.AGONY_C_BIRTHDAY_GIFT)