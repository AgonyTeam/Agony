EternalPooter = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_POOTER,0,"Pooter")

--Eternal Pooters
function EternalPooter:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()

	--Replace regular entity with eternal version
	if (rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15 and entity.Variant == 0 and entity.SpawnerType ~= EntityType.ENTITY_FAMILIAR) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Pooter/animation.anm2", true);
		--entity.HitPoints = 16;
		--entity.MaxHitPoints = 16;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
	
	if (entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK and entity.Variant == 0) then
		entity.ProjectileDelay = -1 --prevent original shot
		local PlayerPos = entity:GetPlayerTarget().Position;
		if (sprite:IsEventTriggered("EternalShoot")) then
			entity:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 0, false, 1.0)
			local t = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 13)):Rotated(math.random(20)-10), entity);
			t.SpawnerEntity = entity 
		end
		
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalPooter.ai_main, EntityType.ENTITY_POOTER);