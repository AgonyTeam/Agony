eternalSpit = {
	
};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_SUCKER,0,"Sucker")

--Eternal Attack Flies
function eternalSpit:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Variant == 1 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
end

function eternalSpit:tearDeath(pos, vel, spawner, ent)
	local v = pos:Distance(Isaac.GetPlayer(0).Position) / 30.0
	Agony:fireIpecacTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Agony:calcTearVel(pos, Isaac.GetPlayer(0).Position, v), {SpawnerEntity = spawner}, {Scale = 0.5})
end

function eternalSpit:ai_dmg(ent, dmg, flags, src, countdown)
	if ent.Variant == 1 and ent.SubType == 15 and dmg >= ent.HitPoints then
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
			
			local v = pos:Distance(Isaac.GetPlayer(0).Position) / 30.0
			local tearConf = {
				SpawnerEntity = ent,
				Functions = {
					onDeath = eternalSpit.tearDeath
				}
			}
			
			Agony:fireIpecacTearProj(0, Agony.TearSubTypes.ETERNAL, pos, Agony:calcTearVel(pos, Isaac.GetPlayer(0).Position, v), tearConf, {Scale = 0.5})
		
		end, {pos=ent.Position,ent=ent}, true)
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSpit.ai_main, EntityType.ENTITY_SUCKER)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalSpit.ai_dmg, EntityType.ENTITY_SUCKER)