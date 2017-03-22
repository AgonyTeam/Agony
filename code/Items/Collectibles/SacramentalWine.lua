
local sacramentalWine =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
sacramentalWine.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_sacramentalwine.anm2")

function sacramentalWine:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SACRAMENTAL_WINE)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + (1.69*player:GetCollectibleNum(CollectibleType.AGONY_C_SACRAMENTAL_WINE))
	end
end

function sacramentalWine:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		sacramentalWine.hasItem = false
	end
	

	if player:HasCollectible(CollectibleType.AGONY_C_SACRAMENTAL_WINE) then
		if sacramentalWine.hasItem == false then
			--player:AddNullCostume(sacramentalWine.costumeID)
			sacramentalWine.hasItem = true
		end

		local redHearts = player:GetMaxHearts()
		if redHearts > 0 then
			player:AddMaxHearts(-redHearts, false)
			player:AddSoulHearts(redHearts)
		end

		local entities = Isaac.GetRoomEntities()

		for i = 1, #entities, 1 do
			if entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_HEART then
				if entities[i].SubType == HeartSubType.HEART_HALF then
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, entities[i].Position, Vector (0,0), player)
					entities[i]:Remove()
				elseif (entities[i].SubType == HeartSubType.HEART_BLACK or entities[i].SubType == HeartSubType.HEART_FULL or entities[i].SubType == HeartSubType.HEART_DOUBLEPACK or entities[i].SubType == HeartSubType.HEART_BLENDED) then
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, entities[i].Position, Vector (0,0), player)
					entities[i]:Remove()
				end				
			end
		end

	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, sacramentalWine.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, sacramentalWine.cacheUpdate)