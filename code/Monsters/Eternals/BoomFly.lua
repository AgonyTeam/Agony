eternalBoomFly = {
		explosionDelay = 5,
		explosionDmg = 15,
		explosions = {}
}

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_BOOMFLY,0,"Boom Fly", 35)

function eternalBoomFly:ai_main(ent)
	local rng = ent:GetDropRNG()
	
	if (false and ent.Variant == 0 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and ent.FrameCount <= 1 and ent.SubType ~= 15) then
		ent:Morph(ent.Type, ent.Variant, 15, -1)
		ent.HitPoints = ent.MaxHitPoints
	end
end

function eternalBoomFly:ai_dmg(ent, dmg, flags, src, countdown)
	if ent.Variant == 0 and ent.SubType == 15 and dmg >= ent.HitPoints then
		local explosionX1 = { pos = ent.Position, dir = Vector(64,0), time = 0 }
		local explosionX2 = { pos = ent.Position, dir = Vector(-64,0), time = 0 }
		local explosionY1 = { pos = ent.Position, dir = Vector(0,64), time = 0 }
		local explosionY2 = { pos = ent.Position, dir = Vector(0,-64), time = 0 }
		table.insert(eternalBoomFly.explosions, explosionX1)
		table.insert(eternalBoomFly.explosions, explosionX2)
		table.insert(eternalBoomFly.explosions, explosionY1)
		table.insert(eternalBoomFly.explosions, explosionY2)
	end
end

function eternalBoomFly:update()
	local explosions = eternalBoomFly.explosions
	for k,expl in pairs(explosions) do
		if Game():GetRoom():IsPositionInRoom(expl.pos, 0) then
			if expl.time > eternalBoomFly.explosionDelay then
				Isaac.Explode(expl.pos, nil, eternalBoomFly.explosionDmg)
				expl.pos = expl.pos + expl.dir
				expl.time = 0
			end
			expl.time = expl.time + 1
		else
			explosions[k] = nil
		end
	end
end

function eternalBoomFly:newRoom()
	eternalBoomFly.explosions = {}
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalBoomFly.ai_main, EntityType.ENTITY_BOOMFLY)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalBoomFly.ai_dmg, EntityType.ENTITY_BOOMFLY)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, eternalBoomFly.update)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, eternalBoomFly.newRoom)