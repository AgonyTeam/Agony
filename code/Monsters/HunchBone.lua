local hunchbone = {
	minFrames = 300,
	fallChance = 0.4,
	chanceCooldown = 20
}

function hunchbone:ai_move(ent)
	ent.Velocity = Agony:calcEntVel(ent, ent:GetPlayerTarget(), 2)
end

function hunchbone:ai_attack(ent)
	local data = ent:GetData()
	local rng = ent:GetDropRNG()
	
	if data.chanceCooldown == nil then
		data.chanceCooldown = hunchbone.chanceCooldown
	elseif data.chanceCooldown > 0 then
		data.chanceCooldown = data.chanceCooldown - 1
	end
	
	if ent.FrameCount >= hunchbone.minFrames and data.chanceCooldown == 0 then
		if rng:RandomFloat() < hunchbone.fallChance then
			for i=0, 7 do --shoot bones in 8 directions
				local vel = Vector.FromAngle(0):Rotated((360/8)*i):__mul(7)
				Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 1, 0, ent.Position, vel, ent)
			end
			for i=1, rng:RandomInt(3)+2 do --spawn 2-4 boneys
				Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, Isaac.GetFreeNearPosition(ent.Position, 50), Vector(0,0), ent)
			end
			ent:Die()
		else
			data.chanceCooldown = hunchbone.chanceCooldown
		end
	end
end

function hunchbone:ai_killed(hurtEnt, dmgAmount, dmgFlags, sourceEnt, dmgCountdown)
	local rng = hurtEnt:GetDropRNG()
	if dmgAmount > hurtEnt.HitPoints then
		for i=1, rng:RandomInt(2)+1 do --spawn 1-2 boneys
			Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, Isaac.GetFreeNearPosition(hurtEnt.Position, 50), Vector(0,0), hurtEnt)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, hunchbone.ai_move, EntityType.AGONY_ETYPE_HUNCHBONE)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, hunchbone.ai_attack, EntityType.AGONY_ETYPE_HUNCHBONE)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, hunchbone.ai_killed, EntityType.AGONY_ETYPE_HUNCHBONE)