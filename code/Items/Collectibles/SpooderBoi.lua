CollectibleType["AGONY_C_SPOODER_BOI"] = Isaac.GetItemIdByName("Spooderboi");

local spooderBoi =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	spooderList = Agony.ENUMS["EnemyLists"]["Spooders"]
}
spooderBoi.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_spooderboi.anm2")

--Spawnable monster List
--[[
table.insert(spooderBoi.spooderList, EntityType.ENTITY_SPIDER)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, EntityType.ENTITY_SPIDER_L2)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, EntityType.ENTITY_BABY_LONG_LEGS)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, EntityType.ENTITY_CRAZY_LONG_LEGS)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, EntityType.ENTITY_BABY_LONG_LEGS)
table.insert(spooderBoi.spooderList, 1) --small version
table.insert(spooderBoi.spooderList, EntityType.ENTITY_CRAZY_LONG_LEGS)
table.insert(spooderBoi.spooderList, 1) --small version
table.insert(spooderBoi.spooderList, EntityType.ENTITY_FAMILIAR)  -- blue spider
table.insert(spooderBoi.spooderList, FamiliarVariant.BLUE_SPIDER) -- blue spider
table.insert(spooderBoi.spooderList, EntityType.ENTITY_TICKING_SPIDER)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, EntityType.ENTITY_BIGSPIDER)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, EntityType.ENTITY_HOPPER) --Trite
table.insert(spooderBoi.spooderList, 1) --Trite
table.insert(spooderBoi.spooderList, EntityType.ENTITY_RAGLING)
table.insert(spooderBoi.spooderList, 0)
table.insert(spooderBoi.spooderList, 303) --Blister
table.insert(spooderBoi.spooderList, 0) --Blister
]]--

function spooderBoi:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		spooderBoi.hasItem = false
	end
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_SPOODER_BOI)
	if spooderBoi.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI) then
		player:AddNullCostume(spooderBoi.costumeID)
		spooderBoi.hasItem = true
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI) then
		if math.random(300) == 1 then
			local r = (rng:RandomInt(#spooderBoi.spooderList))+1
			local spooder = Isaac.Spawn(spooderBoi.spooderList[r][1], spooderBoi.spooderList[r][2], 0, player.Position, Vector (0,0), player)
			spooder:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM);
		end
	end
end

function spooderBoi:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI)) then
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed + 0.3;
		end
	end
end


Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, spooderBoi.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, spooderBoi.cacheUpdate)
--Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, spooderBoi.cacheUpdate)