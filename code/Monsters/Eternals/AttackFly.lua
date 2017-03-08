EternalAttackFly = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_ATTACKFLY,0,"Attack Fly")

--Eternal Attack Flies
function EternalAttackFly:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_ATTACKFLY and entity.Variant == 0 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Attack Fly/animation.anm2", true);
		entity.HitPoints = 10;
	end

	--Random Dashes
	if (entity.Type == EntityType.ENTITY_ATTACKFLY and entity.Variant == 0 and entity.SubType == 15 and rng:RandomFloat() < 0.15) then
		entity.Velocity = entity.Velocity:__add(Vector.FromAngle(rng:RandomInt(360)):__mul(rng:RandomInt(10)+1))
	end

end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalAttackFly.ai_main, EntityType.ENTITY_ATTACKFLY);