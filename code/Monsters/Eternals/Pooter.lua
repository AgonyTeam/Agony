 EternalPooter = {};

--Add the id, variant and name to the EternalsList
table.insert(EternalsList, EntityType.ENTITY_POOTER);
table.insert(EternalsList, 0);
table.insert(EternalsList, "Pooter");

--Eternal Pooters
function EternalPooter:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();

	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_POOTER and math.random(10) == 1 and room:GetFrameCount() <= 10 and entity.SubType ~= 15 and entity.Variant == 0) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Pooter/animation.anm2", true);
		entity.HitPoints = 16;
		
	end
	
	if (entity.Type == EntityType.ENTITY_POOTER and entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK and entity.Variant == 0) then
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