EternalRoundWorm = {};
--entity_roundworm = Isaac.GetEntityTypeByName("Round Worm");

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_ROUND_WORM,0,"Round Worm",38)

--Eternal Round Worms
function EternalRoundWorm:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	--TODO: put in a function, unless we decide to split up Eternals into multiple files
	if (false and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Round Worm/animation.anm2", true);
		--entity.HitPoints = 20;
		--entity.MaxHitPoints = 20;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
		
	end
	
	if (entity.Type == EntityType.ENTITY_ROUND_WORM and entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK) then
		local PlayerPos = entity:GetPlayerTarget().Position;
		local tearConf = Agony:TearConf()
		tearConf.SpawnerEntity = entity

		if (sprite:IsEventTriggered("EternalShoot3") == true) then
			--Host-like triple shot
			entity:PlaySound(SoundEffect.SOUND_WORM_SPIT, 1.0, 0, false, 1.0)

			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 11)):Rotated(-10), tearConf)
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 12)), tearConf)
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 11)):Rotated(10), tearConf)
		elseif (sprite:IsEventTriggered("EternalShoot2") == true) then
			--V-shape double shot like Shroomers from EtG
			entity:PlaySound(SoundEffect.SOUND_WORM_SPIT, 1.0, 0, false, 1.0)
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 11)):Rotated(-5), tearConf)
			Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 11)):Rotated(5), tearConf)
		end
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalRoundWorm.ai_main, EntityType.ENTITY_ROUND_WORM);