EternalSuperPooter = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_POOTER,1,"Super Pooter",28)

--V-shot helper function
local function doVShot(entity, playerPos, angle, tearConf)
	entity:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 0, false, 1.0)
	Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, playerPos, 11)):Rotated(-angle), tearConf)
	Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, playerPos, 11)):Rotated(angle), tearConf)
end

--Eternal Super Pooters
function EternalSuperPooter:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()

	--Replace regular entity with eternal version
	if (false and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15 and entity.Variant == 1) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Super Pooter/animation.anm2", true);
		--entity.HitPoints = 16;
		--entity.MaxHitPoints = 16;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
	
	if (entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK and entity.Variant == 1) then
		entity.ProjectileDelay = -1 --prevent original shot
		local PlayerPos = entity:GetPlayerTarget().Position;
		local tearConf = Agony:TearConf()
		tearConf.SpawnerEntity = entity

		if (sprite:IsEventTriggered("EternalShoot")) then
			doVShot(entity, PlayerPos, 20, tearConf)
		elseif (sprite:IsEventTriggered("EternalShoot2")) then
			doVShot(entity, PlayerPos, 15, tearConf)
		elseif (sprite:IsEventTriggered("EternalShoot3")) then
			doVShot(entity, PlayerPos, 10, tearConf)
		end
		
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalSuperPooter.ai_main, EntityType.ENTITY_POOTER);