local slicker = {
	normSpeed = 1.5,
	attackCooldown = 120,
}

local slickerAI = Agony.FW.Classes.AI()

function slicker.ai_update(ent, state, rng, data, ai)
	data = data.Agony
	--debug_tbl1 = ai.updateFns
	--debug_tbl2 = ai.eventFns
	if data.attackCooldown > 0 and state == NpcState.STATE_MOVE then
		data.attackCooldown = data.attackCooldown - 1
	elseif data.attackCooldown == 0 then
		local add = rng:RandomInt(2)
		ai:setState(NpcState.STATE_ATTACK + add)
		data.attackCooldown = slicker.attackCooldown
	end
end

function slicker.ai_move(ent, state, rng, data, ai)
	data = data.Agony
	if state == NpcState.STATE_MOVE then --follow player
		data.stickPos = nil
		local targetPos = ent:GetPlayerTarget().Position

		ent.Velocity = Agony.FW:calcEntVel(ent, targetPos, slicker.normSpeed)
	elseif (state == NpcState.STATE_IDLE or state == NpcState.STATE_ATTACK2) and data.stickPos ~= nil then --confused state, stick to place
		ent.Velocity = Vector(0,0)--data.stickPos - ent.Position
	end
end

function slicker.ai_creeptrail(ent, state, rng, data, ai)
	if ent:IsFrame(6, 0) then
		Agony.FW:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, ent.Position, Vector(0,0), ent)
	end
end

function slicker.ai_attack(ent, state, rng, data, ai)
	data = data.Agony
	if state == NpcState.STATE_ATTACK then
		if ent.StateFrame > 150 then
			ai:setState(NpcState.STATE_ATTACK2)
			return
		end

		local target = ent:GetPlayerTarget()
		local tl = Game():GetRoom():GetTopLeftPos()
		local br = Game():GetRoom():GetBottomRightPos()
		 local tc = {
			Functions = {
				onDeath = function (tear)
					Agony.FW:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, tear.Position, Vector(0,0), tear.SpawnerEntity)
				end
			},
			SpawnerEntity = ent
		}

		if target.Position.X <= ent.Position.X + target.Size and target.Position.X >= ent.Position.X - target.Size and data.targetPos == nil then
			local y
			if math.abs(tl.Y - target.Position.Y) < math.abs(br.Y - target.Position.Y) then
				y = tl.Y
			else
				y = br.Y
			end
			data.targetPos = Vector(ent.Position.X, y)
		elseif target.Position.Y <= ent.Position.Y + target.Size and target.Position.Y >= ent.Position.Y - target.Size and data.targetPos == nil then
			local x
			if math.abs(tl.X - target.Position.X) < math.abs(br.X - target.Position.X) then
				x = tl.X
			else
				x = br.X
			end
			data.targetPos = Vector(x, ent.Position.Y)
		--note to ded: turn the two if statements above into some sort of helper function too
		elseif ent:CollidesWithGrid() then
			Game():ShakeScreen(4)
			Agony.FW:makeSplat(ent.Position, EffectVariant.CREEP_BLACK, 2.6, ent)
			Agony.FW:fireMeatballTearProj(0, 0, ent.Position, Vector(0, 3.5), tc, 7 + rng:RandomInt(5), rng)
			data.targetPos = nil
			data.stickPos = ent.Position
			ai:setState(NpcState.STATE_IDLE)
			return
		end

		if data.targetPos ~= nil then
			ent.Velocity = Agony.FW:calcEntVel(ent, data.targetPos, slicker.normSpeed * 3)
		else
			ent.Velocity = Agony.FW:calcEntVel(ent, target.Position, slicker.normSpeed) --still follow isaac until in a direct line to him
		end
	elseif state == NpcState.STATE_ATTACK2 then
		if data.stickPos == nil then
			data.stickPos = ent.Position
		end
	end
end

function slicker.ai_endconfusion(ent, state, rng, data, ai)
	data = data.Agony

	ai:setState(ai.defState)
	data.stickPos = nil
end

function slicker.shoot(ent, state, rng, data, ai) 
 	if ent:IsFrame(2, 0) then
 		local tc = {
			Functions = {
				onDeath = function (tear)
					Agony.FW:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, tear.Position, Vector(0,0), tear.SpawnerEntity)
				end
			},
			SpawnerEntity = ent
		}
 		Agony.FW:fireMeatballTearProj(0, 0, ent.Position, Vector(0, 3.5), tc, 1, rng)
	end 
end

function slicker.ai_shootstart(ent, state, rng, data, ai)
	ai:addFn(Agony.FW.fnTypes.UPDATE, slicker.shoot, "Shoot")
end

function slicker.ai_endshoot(ent, state, rng, data, ai)
	data = data.Agony
	ai:removeFn(Agony.FW.fnTypes.UPDATE, "Shoot")

	ai:setState(ai.defState)
	data.stickPos = nil
end

function slicker.ai_anim(ent, state, rng, data, sprite, ai)
	if state == NpcState.STATE_IDLE then
		sprite:Play("AttackUp")
	elseif state == NpcState.STATE_ATTACK2 then
		sprite:Play("AttackDown")
	else
		sprite:Play("WalkHori")
	end
end

slickerAI.defState = NpcState.STATE_MOVE
slickerAI.initData = {
	Agony = {attackCooldown = 30}
}
slickerAI:addFn(Agony.FW.fnTypes.UPDATE, slicker.ai_move)
slickerAI:addFn(Agony.FW.fnTypes.UPDATE, slicker.ai_creeptrail)
slickerAI:addFn(Agony.FW.fnTypes.UPDATE, slicker.ai_update)
slickerAI:addFn(Agony.FW.fnTypes.UPDATE, slicker.ai_attack)
slickerAI:addFn(Agony.FW.fnTypes.ANIM, slicker.ai_anim)
slickerAI:addFn(Agony.FW.fnTypes.EVENT, slicker.ai_endconfusion, "ConfusionEnd")
slickerAI:addFn(Agony.FW.fnTypes.EVENT, slicker.ai_shootstart, "ShootStart")
slickerAI:addFn(Agony.FW.fnTypes.EVENT, slicker.ai_endshoot, "ShootEnd")

Agony.FW:addNPC(slickerAI, EntityType.AGONY_ETYPE_DROSS_BROS, 0)