EternalAttackFly = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_ATTACKFLY,0,"Attack Fly",14)

--Eternal Attack Flies
function EternalAttackFly:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (false and entity.Variant == 0 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Attack Fly/animation.anm2", true);
		--entity.HitPoints = 10;
		--entity.MaxHitPoints = 10;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end

	--Random Dashes
	if (entity.Variant == 0 and entity.SubType == 15 and rng:RandomFloat() < 0.15) then
		entity.Velocity = entity.Velocity + Vector.FromAngle(rng:RandomInt(360)) * (rng:RandomInt(10)+1)
	end

end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalAttackFly.ai_main, EntityType.ENTITY_ATTACKFLY);