Lists = {
	--Custom "pools" of items
	ItemPools = {
		Mushrooms = {
			CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
			CollectibleType.COLLECTIBLE_ODD_MUSHROOM_RATE,
			CollectibleType.COLLECTIBLE_ODD_MUSHROOM_DAMAGE,
			CollectibleType.COLLECTIBLE_ONE_UP,
			CollectibleType.COLLECTIBLE_BLUE_CAP,
			CollectibleType.COLLECTIBLE_GODS_FLESH,
			CollectibleType.COLLECTIBLE_MINI_MUSH
		},
			
		Garbage = {
			--Vanilla
			--Passives
			CollectibleType.COLLECTIBLE_ABEL,
			CollectibleType.COLLECTIBLE_BLACK_BEAN,
			CollectibleType.COLLECTIBLE_BOOM,
			CollectibleType.COLLECTIBLE_CAINS_OTHER_EYE,
			CollectibleType.COLLECTIBLE_DEAD_BIRD,
			CollectibleType.COLLECTIBLE_DESSERT,
			CollectibleType.COLLECTIBLE_DINNER,
			CollectibleType.COLLECTIBLE_HOLY_WATER,
			CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
			CollectibleType.COLLECTIBLE_PEEPER,
			CollectibleType.COLLECTIBLE_SAMSONS_CHAINS,
			CollectibleType.COLLECTIBLE_BETRAYAL,
			CollectibleType.COLLECTIBLE_MILK,
			CollectibleType.COLLECTIBLE_GLAUCOMA,
			CollectibleType.COLLECTIBLE_KING_BABY,
			CollectibleType.COLLECTIBLE_MOLDY_BREAD,
			CollectibleType.COLLECTIBLE_YO_LISTEN,
			CollectibleType.COLLECTIBLE_VARICOSE_VEINS,
			CollectibleType.COLLECTIBLE_BLOODSHOT_EYE,
			CollectibleType.COLLECTIBLE_BEAN,
			CollectibleType.COLLECTIBLE_MINE_CRAFTER,
			CollectibleType.COLLECTIBLE_ANEMIC,
			CollectibleType.COLLECTIBLE_BOBS_BRAIN,
			CollectibleType.COLLECTIBLE_BOX,
			CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
			CollectibleType.COLLECTIBLE_GHOST_BABY,
			CollectibleType.COLLECTIBLE_HARLEQUIN_BABY,
			CollectibleType.COLLECTIBLE_LEECH,
			CollectibleType.COLLECTIBLE_LUCKY_FOOT,
			CollectibleType.COLLECTIBLE_PUNCHING_BAG,
			CollectibleType.COLLECTIBLE_SMART_FLY,
			CollectibleType.COLLECTIBLE_LOST_FLY,
			CollectibleType.COLLECTIBLE_PAPA_FLY,
			CollectibleType.COLLECTIBLE_OBSESSED_FAN,
			CollectibleType.COLLECTIBLE_SHADE,
						--Actives
			CollectibleType.COLLECTIBLE_BUTTER_BEAN,
			CollectibleType.COLLECTIBLE_KIDNEY_BEAN,
			CollectibleType.COLLECTIBLE_POOP,
			CollectibleType.COLLECTIBLE_BREATH_OF_LIFE,
			CollectibleType.COLLECTIBLE_MOMS_PAD,
			CollectibleType.COLLECTIBLE_NOTCHED_AXE,
			CollectibleType.COLLECTIBLE_ISAACS_TEARS,
			CollectibleType.COLLECTIBLE_BEST_FRIEND,
			
						--Agony Garbage
			CollectibleType.AGONY_C_PERSONAL_BUBBLE,
			CollectibleType.AGONY_C_PYRITE_NUGGET,
			CollectibleType.AGONY_C_THE_ROCK,
			CollectibleType.AGONY_C_WAIT_NO,
			CollectibleType.AGONY_C_BIRTHDAY_GIFT, --Infinite Garbage, hell yeah
		},
			
		FragileConceptionFams = {
			CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
			CollectibleType.COLLECTIBLE_STEVEN,
			CollectibleType.COLLECTIBLE_ROBO_BABY,
			CollectibleType.COLLECTIBLE_SISTER_MAGGY,
			CollectibleType.COLLECTIBLE_ABEL,
			CollectibleType.COLLECTIBLE_HARLEQUIN_BABY,
			CollectibleType.COLLECTIBLE_RAINBOW_BABY,
			CollectibleType.COLLECTIBLE_PEEPER,
			CollectibleType.COLLECTIBLE_BUM_FRIEND,
			CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL,
			CollectibleType.COLLECTIBLE_CUBE_OF_MEAT,
			CollectibleType.COLLECTIBLE_PUNCHING_BAG,
			CollectibleType.COLLECTIBLE_GEMINI,
			CollectibleType.COLLECTIBLE_KEY_BUM,
			CollectibleType.COLLECTIBLE_LIL_GURDY,
			CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES,
			CollectibleType.COLLECTIBLE_BUMBO,
		},
	},
	--Custom enemy lists
	EnemyLists = {
		Spooders = { --for spooderboi
			{EntityType.ENTITY_SPIDER, 0},
			{EntityType.ENTITY_SPIDER_L2, 0},
			{EntityType.ENTITY_BABY_LONG_LEGS, 0},
			{EntityType.ENTITY_CRAZY_LONG_LEGS, 0},
			{EntityType.ENTITY_BABY_LONG_LEGS, 1}, --small version
			{EntityType.ENTITY_CRAZY_LONG_LEGS, 1}, --small version
			{EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER}, --blue spider
			{EntityType.ENTITY_TICKING_SPIDER, 0},
			{EntityType.ENTITY_BIGSPIDER, 0},
			{EntityType.ENTITY_HOPPER, 1}, --Trite
			{EntityType.ENTITY_RAGLING, 0},
			{303, 0}, --Blister,
		},
	},
}

return Lists