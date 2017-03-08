EternalSuperPooter = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_POOTER,1,"Super Pooter")

--V-shot helper function
local function doVShot(entity, playerPos, angle)
	entity:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 0, false, 1.0)
	local t = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, playerPos, 13)):Rotated(angle - 2*angle), entity);
	local t2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, playerPos, 13)):Rotated(angle), entity);
	t.SpawnerEntity = entity 
	t2.SpawnerEntity = entity
end

--Eternal Super Pooters
function EternalSuperPooter:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()

	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_POOTER and rng:RandomInt(10) == 1 and entity.FrameCount <= 10 and entity.SubType ~= 15 and entity.Variant == 1) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Super Pooter/animation.anm2", true);
		entity.HitPoints = 16;
		
	end
	
	if (entity.Type == EntityType.ENTITY_POOTER and entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK and entity.Variant == 1) then
		entity.ProjectileDelay = -1 --prevent original shot
		local PlayerPos = entity:GetPlayerTarget().Position;
		if (sprite:IsEventTriggered("EternalShoot")) then
			doVShot(entity, PlayerPos, 45)
		elseif (sprite:IsEventTriggered("EternalShoot2")) then
			doVShot(entity, PlayerPos, 30)
		elseif (sprite:IsEventTriggered("EternalShoot3")) then
			doVShot(entity, PlayerPos, 15)
		end
		
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalSuperPooter.ai_main, EntityType.ENTITY_POOTER);