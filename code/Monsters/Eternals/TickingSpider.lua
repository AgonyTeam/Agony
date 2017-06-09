eternalTickingSpider = {
		explosionDelay = 5,
		explosionDmg = 15,
		explosions = {}
}

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_TICKING_SPIDER,0,"Ticking Spider", 35)

function eternalTickingSpider:ai_main(ent)
end

function eternalTickingSpider:ai_dmg(ent, dmg, flags, src, countdown)
	if ent.Variant == 0 and ent.SubType == 15 and dmg >= ent.HitPoints then
		local explosionX1 = { pos = ent.Position, dir = Vector(45.2548339959,45.2548339959), time = 0 }
		local explosionX2 = { pos = ent.Position, dir = Vector(45.2548339959,-45.2548339959), time = 0 }
		local explosionY1 = { pos = ent.Position, dir = Vector(-45.2548339959,-45.2548339959), time = 0 }
		local explosionY2 = { pos = ent.Position, dir = Vector(-45.2548339959,45.2548339959), time = 0 }
		table.insert(eternalTickingSpider.explosions, explosionX1)
		table.insert(eternalTickingSpider.explosions, explosionX2)
		table.insert(eternalTickingSpider.explosions, explosionY1)
		table.insert(eternalTickingSpider.explosions, explosionY2)
	end
end

function eternalTickingSpider:update()
	local explosions = eternalTickingSpider.explosions
	for k,expl in pairs(explosions) do
		if Game():GetRoom():IsPositionInRoom(expl.pos, 0) then
			if expl.time > eternalTickingSpider.explosionDelay then
				Isaac.Explode(expl.pos, nil, eternalTickingSpider.explosionDmg)
				expl.pos = expl.pos + expl.dir
				expl.time = 0
			end
			expl.time = expl.time + 1
		else
			explosions[k] = nil
		end
	end
end

function eternalTickingSpider:newRoom()
	eternalTickingSpider.explosions = {}
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalTickingSpider.ai_main, EntityType.ENTITY_TICKING_SPIDER)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalTickingSpider.ai_dmg, EntityType.ENTITY_TICKING_SPIDER)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, eternalTickingSpider.update)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, eternalTickingSpider.newRoom)