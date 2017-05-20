local stuffedCreep = {
	Wall = {
		UP = 0,
		RIGHT = 1,
		DOWN = 2,
		LEFT = 3
	},
	maxCharge = 8,
	playerTrigger = 16,
	holdCharge = 4,
	attackCooldown = 60,
}

function stuffedCreep:ai_update(ent)
	local room = Game():GetRoom()
	local rng = ent:GetDropRNG()
	local data = ent:GetData()

	if ent.State == NpcState.STATE_INIT then
		data.Charge = 0
		data.holdCharge = 0
		data.playerTrigger = stuffedCreep.playerTrigger
		data.attackCooldown = 0

		ent.GridCollisionClass = GridCollisionClass.COLLISION_NONE 

		local topLeft = ent.Position:__sub(room:GetTopLeftPos())
		local botRight = room:GetBottomRightPos():__sub(ent.Position)

		--determine wall
		local smallest = 696969

		if topLeft.Y < smallest then
			smallest = topLeft.Y
			data.Wall = stuffedCreep.Wall.UP
		end 

		if topLeft.X < smallest then
			smallest = topLeft.X
			data.Wall = stuffedCreep.Wall.LEFT
		end

		if botRight.Y < smallest then
			smallest = botRight.Y
			data.Wall = stuffedCreep.Wall.DOWN
		end

		if botRight.X < smallest then
			smallest = botRight.X
			data.Wall = stuffedCreep.Wall.RIGHT
		end

		ent.State = NpcState.STATE_MOVE
	elseif ent.State == NpcState.STATE_MOVE then
		stuffedCreep:ai_movement(ent, data, room)
		
		--if player is about in line of sight for 4 frames and attackCooldown is 0, attack
		if (data.Wall == stuffedCreep.Wall.UP or data.Wall == stuffedCreep.Wall.DOWN) and math.abs(ent.Position.X - ent:GetPlayerTarget().Position.X) <= 16 then
			if data.playerTrigger > 0 then
				data.playerTrigger = data.playerTrigger - 1
			elseif data.playerTrigger == 0 and data.attackCooldown == 0 then
				ent.State = NpcState.STATE_ATTACK
				data.playerTrigger = stuffedCreep.playerTrigger
			end
		elseif (data.Wall == stuffedCreep.Wall.LEFT or data.Wall == stuffedCreep.Wall.RIGHT) and math.abs(ent.Position.Y - ent:GetPlayerTarget().Position.Y) <= 16 then
			if data.playerTrigger > 0 then
				data.playerTrigger = data.playerTrigger - 1
			elseif data.playerTrigger == 0 and data.attackCooldown == 0 then
				ent.State = NpcState.STATE_ATTACK
				data.playerTrigger = stuffedCreep.playerTrigger
			end
		else
			data.playerTrigger = stuffedCreep.playerTrigger
		end

		if data.attackCooldown > 0 then
			data.attackCooldown = data.attackCooldown - 1
		end
	elseif ent.State == NpcState.STATE_ATTACK then --attack
		stuffedCreep:ai_stick(ent, data, room) --dont move while attacking

		if data.Charge == stuffedCreep.maxCharge then --if charged
			stuffedCreep:ai_attack(ent, data, rng)
			data.Charge = 0
			data.attackCooldown = stuffedCreep.attackCooldown
			ent.State = NpcState.STATE_MOVE
		else
			data.Charge = data.Charge + 1
		end
	end

	stuffedCreep:ai_anim(ent, ent:GetSprite(), data) --update animations
end

function stuffedCreep:ai_movement(ent, data, room)
	local entPos = ent.Position
	local tarPos = ent:GetPlayerTarget().Position
	local tl = room:GetTopLeftPos()
	local br = room:GetBottomRightPos()
	local speed = 2.5

	if data.Wall == stuffedCreep.Wall.UP and math.abs(entPos.X - tarPos.X) > speed and entPos.X > tl.X and entPos.X < br.X then
		local x = 0
		if tarPos.X < entPos.X then
			x = -speed
		elseif tarPos.X > entPos.X then
			x = speed
		end
		ent.Velocity = Vector(x, tl.Y+4-entPos.Y)
		
	elseif data.Wall == stuffedCreep.Wall.RIGHT and math.abs(entPos.Y - tarPos.Y) > speed and entPos.Y > tl.Y and entPos.Y < br.Y then
		local y = 0
		if tarPos.Y < entPos.Y then
			y = -speed
		elseif tarPos.Y > entPos.Y then
			y = speed
		end
		ent.Velocity = Vector(br.X-4-entPos.X, y)
		
	elseif data.Wall == stuffedCreep.Wall.DOWN and math.abs(entPos.X - tarPos.X) > speed and entPos.X > tl.X and entPos.X < br.X then
		local x = 0
		if tarPos.X < entPos.X then
			x = -speed
		elseif tarPos.X > entPos.X then
			x = speed
		end
		ent.Velocity = Vector(x, br.Y-4-entPos.Y)
		
	elseif data.Wall == stuffedCreep.Wall.LEFT and math.abs(entPos.Y - tarPos.Y) > speed and entPos.Y > tl.Y and entPos.Y < br.Y then
		local y = 0
		if tarPos.Y < entPos.Y then
			y = -speed
		elseif tarPos.Y > entPos.Y then
			y = speed
		end
		ent.Velocity = Vector(tl.X+4-entPos.X, y)
		
	else
		stuffedCreep:ai_stick(ent, data, room) --correct position if out of bounds
	end
end

function stuffedCreep:ai_stick(ent, data, room)
	local tl = room:GetTopLeftPos()
	local br = room:GetBottomRightPos()
	
	--either stick to the place, or correct it when out of bounds
	if data.Wall == stuffedCreep.Wall.UP then
		if ent.Position.X < tl.X then
			ent.Position = Vector(tl.X+2, ent.Position.Y)
		elseif ent.Position.X > br.X then
			ent.Position  = Vector(br.X-2, ent.Position.Y)
		end
		ent.Velocity = Vector(0, tl.Y+4-ent.Position.Y)
	elseif data.Wall == stuffedCreep.Wall.RIGHT then
		if ent.Position.Y < tl.Y then
			ent.Position = Vector(ent.Position.X, tl.Y+2)
		elseif ent.Position.Y > br.Y then
			ent.Position  = Vector(ent.Position.X, br.Y-2)
		end
		ent.Velocity = Vector(br.X-4-ent.Position.X, 0)
	elseif data.Wall == stuffedCreep.Wall.DOWN then
		if ent.Position.X < tl.X then
			ent.Position = Vector(tl.X+2, ent.Position.Y)
		elseif ent.Position.X > br.X then
			ent.Position  = Vector(br.X-2, ent.Position.Y)
		end
		ent.Velocity = Vector(0, br.Y-4-ent.Position.Y)
	elseif data.Wall == stuffedCreep.Wall.LEFT then
		if ent.Position.Y < tl.Y then
			ent.Position = Vector(ent.Position.X, tl.Y+2)
		elseif ent.Position.Y > br.Y then
			ent.Position  = Vector(ent.Position.X, br.Y-2)
		end
		ent.Velocity = Vector(tl.X+4-ent.Position.X, 0)
	end


end

function stuffedCreep:ai_attack(ent, data, rng)
	
	SFXManager():Play(SoundEffect.SOUND_SPIDER_SPIT_ROAR, 1, 0, false, 1)
	
	local tearConf = Agony:TearConf()

	tearConf.SpawnerEntity = ent
	tearConf.Color = Color(1,1,1,1, 150,100,50) --still sceptic about the orange

	if data.Wall == stuffedCreep.Wall.UP then
		Agony:fireMonstroTearProj(1, 0, Vector(ent.Position.X, ent.Position.Y+4), Vector(0,3), tearConf, 8, rng)
	elseif data.Wall == stuffedCreep.Wall.RIGHT then
		Agony:fireMonstroTearProj(1, 0, Vector(ent.Position.X-4, ent.Position.Y), Vector(-3,0), tearConf, 8, rng)
	elseif data.Wall == stuffedCreep.Wall.DOWN then
		Agony:fireMonstroTearProj(1, 0, Vector(ent.Position.X, ent.Position.Y-4), Vector(0,-3), tearConf, 8, rng)
	elseif data.Wall == stuffedCreep.Wall.LEFT then
		Agony:fireMonstroTearProj(1, 0, Vector(ent.Position.X+4, ent.Position.Y), Vector(3,0), tearConf, 8, rng)
	end
end

function stuffedCreep:ai_anim(ent, sprite, data)
	if ent.State ~= NpcState.STATE_ATTACK then
		if not sprite:IsPlaying("Attack") then
			ent:AnimWalkFrame("Walk", "Walk", 0.1)
		end
	elseif ent.State == NpcState.STATE_ATTACK then
		sprite:SetFrame("Charge", data.Charge)
		if data.Charge == 8 then
			sprite:Play("Attack", true)
		end
	end

	if data.Wall == stuffedCreep.Wall.DOWN then
		sprite.Rotation = 180
	elseif data.Wall == stuffedCreep.Wall.LEFT or data.Wall == stuffedCreep.Wall.RIGHT then
		sprite.Rotation = 90
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, stuffedCreep.ai_update, EntityType.AGONY_ETYPE_STUFFED_CREEP)