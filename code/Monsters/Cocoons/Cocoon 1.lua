local cocoon1 = {
	cooldown = 120, -- cooldown in entity updates until the next spider can spawn when hurt
	maxSpiders = 2 -- max number of spiders from single cocoon 1 on screen
}

local spiders = { -- temp table for future rng
	big = EntityType.ENTITY_BIGSPIDER
}

function cocoon1:ai_update(_) -- every entity update decreases cooldown
	if cocoon1.cooldown > 0 then
		cocoon1.cooldown = cocoon1.cooldown - 1
	end
end

function cocoon1:ai_take_damage(entity,_,_,_,_)
	local spidersInRoom = 0
	
	for i, roomEntity in pairs(Isaac.GetRoomEntities()) do
		if roomEntity.EntityType == EntityType.ENTITY_SPIDER and roomEntity.SpawnerEntity == entity then
			spidersInRoom = spidersInRoom + 1
		end
	end
	
	if cocoon1.cooldown == 0 and spidersInRoom <= cocoon1.maxSpiders then
		Isaac.Spawn(EntityType.ENTITY_SPIDER, 0, 0, entity.Position, entity.Velocity, entity)
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.ai_update, EntityType.AGONY_ETYPE_COCOON1)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, cocoon1.ai_take_damage, EntityType.AGONY_ETYPE_COCOON1)