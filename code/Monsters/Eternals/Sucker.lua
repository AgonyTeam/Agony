eternalSucker = {
	tearVel = 5,
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
		local v = eternalSucker.tearVel
		Agony:fireTearProj(1, 0, ent.Position, Vector(v,v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
		Agony:fireTearProj(1, 0, ent.Position, Vector(-v,v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
		Agony:fireTearProj(1, 0, ent.Position, Vector(v,-v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
		Agony:fireTearProj(1, 0, ent.Position, Vector(-v,-v), {SpawnerEntity=ent, Functions={onUpdate=eternalSucker.tearUpdate} })
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSucker.ai_main, EntityType.ENTITY_SUCKER)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalSucker.ai_dmg, EntityType.ENTITY_SUCKER)