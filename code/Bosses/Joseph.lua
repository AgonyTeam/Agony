local joseph = {
	weakFlyList = Agony.ENUMS["EnemyLists"]["WeakFlies"],
	attackChance = 0.6,
	attackCooldown = 30,
	chaseBaseSpeed = 5.3,
	chaseRandomSpeed = 3
};

function joseph:ai_move(ent, rng, data)
	
	if ent.HitPoints > ent.MaxHitPoints/3 then
		if ent.State == NpcState.STATE_MOVE then
			-- avoid player if too close
			if ent.Position:Distance(ent:GetPlayerTarget().Position) < 200 then
				ent.Pathfinder:EvadeTarget(ent:GetPlayerTarget().Position)
				ent.Velocity = ent.Velocity:Normalized():__mul(4*(rng:RandomFloat()+0.3)+2)
			else
				ent.Velocity = ent.Velocity:__add(ent.Velocity:__mul(-0.15))
			end
			--slow down/stop when attacking
		elseif ent.State == NpcState.STATE_ATTACK2 or ent.State == NpcState.STATE_ATTACK then
			ent.Velocity = ent.Velocity:__add(ent.Velocity:__mul(-0.15))
		end
	else
		--chase player
		if ent.State == NpcState.STATE_MOVE then
			ent.Velocity = Agony:calcEntVel(ent, ent:GetPlayerTarget(), (rng:RandomFloat() * joseph.chaseRandomSpeed + joseph.chaseBaseSpeed))
		elseif ent.State == NpcState.STATE_ATTACK2 or ent.State == NpcState.STATE_ATTACK then
			ent.Velocity = ent.Velocity:__add(ent.Velocity:__mul(-0.15))
		end
	end
end

function joseph:ai_attack(ent, rng, data)
	
	if ent.State == NpcState.STATE_ATTACK then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_YELLOW, 0, ent.Position, Vector (0,0), ent)
		ent.State = NpcState.STATE_MOVE
	end
	if ent.State == NpcState.STATE_ATTACK2 then
		local r = rng:RandomFloat()
		if r < 0.425 then
			Isaac.Spawn(joseph.weakFlyList[rng:RandomInt(#joseph.weakFlyList)+1], 0, 0, ent.Position:__add(Vector(rng:RandomInt(6)-2,rng:RandomInt(6)-2)),Vector (0,0), ent)
		elseif r < 0.85 then
			local player = ent:GetPlayerTarget()
			for i = 1, rng:RandomInt(5)+4, 1 do
				local t = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, ent.Position, (Agony:calcTearVel(ent.Position, player.Position, rng:RandomInt(5)+6)):Rotated(rng:RandomInt(60)-29), ent);
				t.SpawnerEntity = ent
			end
		else
			Game():ButterBeanFart(ent.Position, 1000, ent, true)
		end
		ent.State = NpcState.STATE_MOVE
	end
end

function joseph:ai_init(ent, rng, data)
	
	if ent.State == NpcState.STATE_INIT then
		data.attackCooldown = joseph.attackCooldown
		ent.State = NpcState.STATE_MOVE
	end
	if ent.State == NpcState.STATE_MOVE and data.attackCooldown == 0 then
		if rng:RandomFloat() < joseph.attackChance then
			if rng:RandomFloat() < 0.5 then
				ent.State = NpcState.STATE_ATTACK
			else
				ent.State = NpcState.STATE_ATTACK2
			end
			data.attackCooldown = joseph.attackCooldown
		else
			data.attackCooldown = joseph.attackCooldown
		end
	end
	
	if ent.State == NpcState.STATE_MOVE and data.attackCooldown ~= nil and data.attackCooldown > 0 then
		data.attackCooldown = data.attackCooldown - 1
	elseif ent.State ~= NpcState.STATE_MOVE then
		data.attackCooldown = joseph.attackCooldown
	end
end

function joseph:ai_update(ent)
	local rng = ent:GetDropRNG()
	local data = ent:GetData()
	joseph:ai_init(ent, rng, data)
	joseph:ai_move(ent, rng, data)
	joseph:ai_attack(ent, rng, data)
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, joseph.ai_update, EntityType.AGONY_ETYPE_JOSEPH)