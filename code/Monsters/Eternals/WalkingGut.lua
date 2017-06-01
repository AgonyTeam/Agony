EternalWalkingGut = {}

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_WALKINGBOIL,1,"Walking Boil")

function EternalWalkingGut:tearDeath(pos, vel, spawner, ent)
	local tearConf = {
				SpawnerEntity = spawner,
				TearFlags = TearFlags.TEAR_SPECTRAL
			}
	Agony:fireIpecacTearProj(0, Agony.TearSubTypes.ETERNAL, pos, vel, tearConf, {Scale = 0.5})
end

function EternalWalkingGut:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (false and entity.Variant == 1 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
	if entity.Variant == 1 and entity.SubType == 15 then
		
		local roomEnts = Isaac.GetRoomEntities()
		for _, rEnt in pairs(roomEnts) do
			if rEnt.Type == EntityType.ENTITY_PROJECTILE and rEnt.Position:Distance(entity.Position) <= 64 and rEnt.FrameCount <= 5 and rEnt.SpawnerType == EntityType.ENTITY_WALKINGBOIL then
				rEnt:Remove()
			end
		end
		
		if entity:GetSprite():IsEventTriggered("Shoot") then
			SFXManager():Play(SoundEffect.SOUND_BLOODSHOOT,1.2,0,false,0.85)
			local pos = entity.Position
			local v = pos:Distance(Isaac.GetPlayer(0).Position) / 30.0
			local tearConf = {
				SpawnerEntity = entity,
				TearFlags = TearFlags.TEAR_SPECTRAL,
				Functions = {
					onDeath = EternalWalkingGut.tearDeath
				}
			}
			
			Agony:fireIpecacTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Agony:calcTearVel(pos, Isaac.GetPlayer(0).Position, v), tearConf, {Scale = 0.75})
		end
	end
	
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalWalkingGut.ai_main, EntityType.ENTITY_WALKINGBOIL);