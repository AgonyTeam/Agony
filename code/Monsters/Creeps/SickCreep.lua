local sickCreep = {
	Wall = {
		UP = 0,
		RIGHT = 1,
		DOWN = 2,
		LEFT = 3
	},
	playerTrigger = 10,
	playerTriggerRegain = 0.1,
	attackCooldown = 60,
}

function sickCreep:ai_update(ent)
	local room = Game():GetRoom()
	local rng = ent:GetDropRNG()
	local data = ent:GetData()

	if ent.State == NpcState.STATE_INIT then
		data.playerTrigger = sickCreep.playerTrigger
		data.attackCooldown = 0

		ent.GridCollisionClass = GridCollisionClass.COLLISION_NONE 

		local topLeft = ent.Position:__sub(room:GetTopLeftPos())
		local botRight = room:GetBottomRightPos():__sub(ent.Position)

		--determine wall
		local smallest = 696969

		if topLeft.Y < smallest then
			smallest = topLeft.Y
			data.Wall = sickCreep.Wall.UP
		end 

		if topLeft.X < smallest then
			smallest = topLeft.X
			data.Wall = sickCreep.Wall.LEFT
		end

		if botRight.Y < smallest then
			smallest = botRight.Y
			data.Wall = sickCreep.Wall.DOWN
		end

		if botRight.X < smallest then
			smallest = botRight.X
			data.Wall = sickCreep.Wall.RIGHT
		end

		ent.State = NpcState.STATE_MOVE
	elseif ent.State == NpcState.STATE_MOVE then
		sickCreep:ai_movement(ent, data, room)
		
		--if player is about in line of sight for 4 frames and attackCooldown is 0, attack
		if (data.Wall == sickCreep.Wall.UP or data.Wall == sickCreep.Wall.DOWN) and math.abs(ent.Position.X - ent:GetPlayerTarget().Position.X) <= 16 then
			if data.playerTrigger > 0 then
				data.playerTrigger = data.playerTrigger - 1
			elseif data.playerTrigger <= 0 and data.attackCooldown <= 0 then
				ent.State = NpcState.STATE_ATTACK
				data.playerTrigger = sickCreep.playerTrigger
			end
		elseif (data.Wall == sickCreep.Wall.LEFT or data.Wall == sickCreep.Wall.RIGHT) and math.abs(ent.Position.Y - ent:GetPlayerTarget().Position.Y) <= 16 then
			if data.playerTrigger > 0 then
				data.playerTrigger = data.playerTrigger - 1
			elseif data.playerTrigger <= 0 and data.attackCooldown <= 0 then
				ent.State = NpcState.STATE_ATTACK
				data.playerTrigger = sickCreep.playerTrigger
			end
		else
			data.playerTrigger = math.min(sickCreep.playerTrigger, data.playerTrigger + sickCreep.playerTriggerRegain)
		end

		if data.attackCooldown > 0 then
			data.attackCooldown = data.attackCooldown - 1
		end
	elseif ent.State == NpcState.STATE_ATTACK then --attack
		if ent:GetSprite():IsFinished("Attack") then
			ent.State = NpcState.STATE_MOVE
			data.attackCooldown = sickCreep.attackCooldown
		else
			sickCreep:ai_stick(ent, data, room) --dont move while attacking
			if ent:GetSprite():IsEventTriggered("Attack") then
				sickCreep:ai_attack(ent, data, rng)
			end
		end
	end

	sickCreep:ai_anim(ent, ent:GetSprite(), data) --update animations
end

function sickCreep:ai_movement(ent, data, room)
	local entPos = ent.Position
	local tarPos = ent:GetPlayerTarget().Position
	local tl = room:GetTopLeftPos()
	local br = room:GetBottomRightPos()
	local speed = 2

	if data.Wall == sickCreep.Wall.UP and math.abs(entPos.X - tarPos.X) > speed and entPos.X > tl.X and entPos.X < br.X then
		local x = 0
		if tarPos.X < entPos.X then
			x = -speed
		elseif tarPos.X > entPos.X then
			x = speed
		end
		ent.Velocity = Vector(x, tl.Y+4-entPos.Y)
		
	elseif data.Wall == sickCreep.Wall.RIGHT and math.abs(entPos.Y - tarPos.Y) > speed and entPos.Y > tl.Y and entPos.Y < br.Y then
		local y = 0
		if tarPos.Y < entPos.Y then
			y = -speed
		elseif tarPos.Y > entPos.Y then
			y = speed
		end
		ent.Velocity = Vector(br.X-4-entPos.X, y)
		
	elseif data.Wall == sickCreep.Wall.DOWN and math.abs(entPos.X - tarPos.X) > speed and entPos.X > tl.X and entPos.X < br.X then
		local x = 0
		if tarPos.X < entPos.X then
			x = -speed
		elseif tarPos.X > entPos.X then
			x = speed
		end
		ent.Velocity = Vector(x, br.Y-4-entPos.Y)
		
	elseif data.Wall == sickCreep.Wall.LEFT and math.abs(entPos.Y - tarPos.Y) > speed and entPos.Y > tl.Y and entPos.Y < br.Y then
		local y = 0
		if tarPos.Y < entPos.Y then
			y = -speed
		elseif tarPos.Y > entPos.Y then
			y = speed
		end
		ent.Velocity = Vector(tl.X+4-entPos.X, y)
		
	else
		sickCreep:ai_stick(ent, data, room) --correct position if out of bounds
	end
end

function sickCreep:ai_stick(ent, data, room)
	local tl = room:GetTopLeftPos()
	local br = room:GetBottomRightPos()
	
	--either stick to the place, or correct it when out of bounds
	if data.Wall == sickCreep.Wall.UP then
		if ent.Position.X < tl.X then
			ent.Position = Vector(tl.X+2, ent.Position.Y)
		elseif ent.Position.X > br.X then
			ent.Position  = Vector(br.X-2, ent.Position.Y)
		end
		ent.Velocity = Vector(0, tl.Y+4-ent.Position.Y)
	elseif data.Wall == sickCreep.Wall.RIGHT then
		if ent.Position.Y < tl.Y then
			ent.Position = Vector(ent.Position.X, tl.Y+2)
		elseif ent.Position.Y > br.Y then
			ent.Position  = Vector(ent.Position.X, br.Y-2)
		end
		ent.Velocity = Vector(br.X-4-ent.Position.X, 0)
	elseif data.Wall == sickCreep.Wall.DOWN then
		if ent.Position.X < tl.X then
			ent.Position = Vector(tl.X+2, ent.Position.Y)
		elseif ent.Position.X > br.X then
			ent.Position  = Vector(br.X-2, ent.Position.Y)
		end
		ent.Velocity = Vector(0, br.Y-4-ent.Position.Y)
	elseif data.Wall == sickCreep.Wall.LEFT then
		if ent.Position.Y < tl.Y then
			ent.Position = Vector(ent.Position.X, tl.Y+2)
		elseif ent.Position.Y > br.Y then
			ent.Position  = Vector(ent.Position.X, br.Y-2)
		end
		ent.Velocity = Vector(tl.X+4-ent.Position.X, 0)
	end


end

function sickCreep:ai_attack(ent, data, rng)
	
	SFXManager():Play(SoundEffect.SOUND_SPIDER_SPIT_ROAR, 1, 0, false, 1)
	
	local tearConf = Agony:TearConf()

	tearConf.SpawnerEntity = ent

	if data.Wall == sickCreep.Wall.UP then
		Agony:fireIpecacTearProj(1, 0, Vector(ent.Position.X, ent.Position.Y+4), Vector(0,6), tearConf)
	elseif data.Wall == sickCreep.Wall.RIGHT then
		Agony:fireIpecacTearProj(1, 0, Vector(ent.Position.X-4, ent.Position.Y), Vector(-6,0), tearConf)
	elseif data.Wall == sickCreep.Wall.DOWN then
		Agony:fireIpecacTearProj(1, 0, Vector(ent.Position.X, ent.Position.Y-4), Vector(0,-6), tearConf)
	elseif data.Wall == sickCreep.Wall.LEFT then
		Agony:fireIpecacTearProj(1, 0, Vector(ent.Position.X+4, ent.Position.Y), Vector(6,0), tearConf)
	end
end

function sickCreep:ai_anim(ent, sprite, data)
	if ent.State ~= NpcState.STATE_ATTACK then
		if not sprite:IsPlaying("Attack") then
			ent:AnimWalkFrame("Walk", "Walk", 0.1)
		end
	elseif ent.State == NpcState.STATE_ATTACK and not sprite:IsPlaying("Attack") then
		sprite:Play("Attack")
	end

	if data.Wall == sickCreep.Wall.DOWN then
		sprite.Rotation = 180
	elseif data.Wall == sickCreep.Wall.LEFT or data.Wall == sickCreep.Wall.RIGHT then
		sprite.Rotation = 90
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, sickCreep.ai_update, EntityType.AGONY_ETYPE_SICK_CREEP)