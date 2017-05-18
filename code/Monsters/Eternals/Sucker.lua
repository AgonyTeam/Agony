eternalSucker = {
	tearAVel = 10,
	tearBVel = 7,
	tearRotSpeed = 10
};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_SUCKER,0,"Sucker")

--Eternal Attack Flies
function eternalSucker:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Variant == 0 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
end

function eternalSucker:tearUpdate(t)
	t.Velocity = t.Velocity:Rotated(eternalSucker.tearRotSpeed)
end

function eternalSucker:ai_dmg(ent, dmg, flags, src, countdown)
	if ent.Variant == 0 and ent.SubType == 15 and dmg >= ent.HitPoints then
		Agony:addDelayedFunction(Agony:getCurrTime()+3, function (data)
			
			local pos = data.pos
			local ent = data.ent
			--Try to remove the original tears by Sucker
			local roomEnts = Isaac.GetRoomEntities()
			for _, rEnt in pairs(roomEnts) do
				if rEnt.Type == EntityType.ENTITY_PROJECTILE and rEnt.Position:Distance(ent.Position) <= 64 and rEnt.FrameCount <= 5 and rEnt.SpawnerType == EntityType.ENTITY_SUCKER then
					rEnt:Remove()
				end
			end
			local v = eternalSucker.tearAVel
			
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(v,0), {SpawnerEntity=ent})
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(-v,0), {SpawnerEntity=ent})
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(0,-v), {SpawnerEntity=ent})
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(0,v), {SpawnerEntity=ent})
			
			v = eternalSucker.tearBVel
			
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(v,v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(-v,v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(v,-v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Vector(-v,-v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
		
		end, {pos=ent.Position,ent=ent}, true)
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSucker.ai_main, EntityType.ENTITY_SUCKER)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalSucker.ai_dmg, EntityType.ENTITY_SUCKER)