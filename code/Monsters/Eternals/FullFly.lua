eternalFullFly = {
	projCount = 9,
	projVel = 10,
	projAngleOffset = 0,
	projBCount = 9,
	projBVel = 5,
	projBVelAccel = -0.75,
	projBAngleOffset = 360.0/18.0
}

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_FULL_FLY,0,"Full Fly")

--Eternal Attack Flies
function eternalFullFly:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Variant == 0 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
end

function eternalSucker:tearUpdate(t)
	t.Velocity = t.Velocity + t:GetData().accel
end

function eternalFullFly:ai_dmg(ent, dmg, flags, src, countdown)
	if ent.Variant == 0 and ent.SubType == 15 and dmg >= ent.HitPoints then
		Agony:addDelayedFunction(Agony:getCurrTime()+3, function (data)
			
			local pos = data.pos
			local ent = data.ent
			--Try to remove the original tears by Sucker
			local roomEnts = Isaac.GetRoomEntities()
			for _, rEnt in pairs(roomEnts) do
				if rEnt.Type == EntityType.ENTITY_PROJECTILE and rEnt.Position:Distance(ent.Position) <= 64 and rEnt.FrameCount <= 5 and rEnt.SpawnerType == EntityType.ENTITY_FULL_FLY then
					rEnt:Remove()
				end
			end
			
			--Circle Shot A
			local v = eternalFullFly.projVel
			local i = 0.0
			while i < eternalFullFly.projCount do
				local angle = i / eternalFullFly.projCount * 360.0 + eternalFullFly.projAngleOffset
				local vel = Vector.FromAngle(angle) * v
				Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, vel, {SpawnerEntity=ent})
				i = i + 1.0
			end
			
			--Circle Shot B
			v = eternalFullFly.projBVel
			i = 0.0
			while i < eternalFullFly.projBCount do
				local angle = i / eternalFullFly.projBCount * 360.0 + eternalFullFly.projBAngleOffset
				local velangle = Vector.FromAngle(angle)
				local vel = velangle * v
				Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, pos, vel, {SpawnerEntity=ent})
				i = i + 1.0
			end
		
		end, {pos=ent.Position,ent=ent}, true)
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalFullFly.ai_main, EntityType.ENTITY_FULL_FLY)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalFullFly.ai_dmg, EntityType.ENTITY_FULL_FLY)