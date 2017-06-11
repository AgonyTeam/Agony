local gospelChild = {
	attackCooldown = 90,
	Speed = 8,
	gospels = {},
	firstGospel = math.huge
}

function gospelChild:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local fireDir = player:GetFireDirection()
	local famData = fam:GetData()
	local room = Game():GetRoom()
	gospelChild.gospels[fam.Index] = fam
	--debug_tbl2.Child = tostring(fam.Child)
	--debug_tbl2.LowestGospel = gospelChild.firstGospel
	--debug_tbl1 = gospelChild.gospels
	--debug_text = fam.Child
	--fam.Parent = nil
	local famSprite = fam:GetSprite()

	if fam.State == NpcState.STATE_IDLE then
		if famData.attackCooldown > 0 then
			famData.attackCooldown = famData.attackCooldown - 1
		elseif famData.attackCooldown <= 0 and fireDir ~= Direction.NO_DIRECTION then
			famData.attackCooldown = gospelChild.attackCooldown
			famData.dir = fireDir
			fam.State = NpcState.STATE_ATTACK
		end
		fam:FollowParent()
		--fam.Parent = Isaac.GetPlayer(0)
	elseif fam.State == NpcState.STATE_ATTACK then
		if famData.dir ~= Direction.NO_DIRECTION then
			gospelChild:attack(fam, famData, famData.dir, room)
		else
			fam.State = NpcState.STATE_IDLE
		end
	end
	gospelChild:anim(fam, famSprite, famData.dir)
end

function gospelChild:attack(fam, data, dir, room)
	if dir == Direction.LEFT then
		fam.Velocity = Vector(-gospelChild.Speed, 0)
		if room:GetGridCollisionAtPos(fam.Position + Vector(-20, 0)) > GridCollisionClass.COLLISION_PIT then
			fam.State = NpcState.STATE_IDLE
		end
	elseif dir == Direction.RIGHT then
		fam.Velocity = Vector(gospelChild.Speed, 0)
		if room:GetGridCollisionAtPos(fam.Position + Vector(20, 0)) > GridCollisionClass.COLLISION_PIT then
			fam.State = NpcState.STATE_IDLE
		end
	elseif dir == Direction.UP then
		fam.Velocity = Vector(0, -gospelChild.Speed)
		if room:GetGridCollisionAtPos(fam.Position + Vector(0, -20)) > GridCollisionClass.COLLISION_PIT then
			fam.State = NpcState.STATE_IDLE
		end
	elseif dir == Direction.DOWN then
		fam.Velocity = Vector(0, gospelChild.Speed)
		if room:GetGridCollisionAtPos(fam.Position + Vector(0, 20)) > GridCollisionClass.COLLISION_PIT then
			fam.State = NpcState.STATE_IDLE
		end
	end
end

function gospelChild:anim(fam, sprite, dir)
	if fam.State == NpcState.STATE_ATTACK then
		sprite.FlipX = false
		if dir == Direction.DOWN then
			sprite:Play("FloatDown")
		elseif dir == Direction.UP then
			sprite:Play("FloatUp")
		elseif dir == Direction.LEFT then
			sprite.FlipX = true
			sprite:Play("FloatSide")
		elseif dir == Direction.RIGHT then
			sprite:Play("FloatSide")
		end
	elseif fam.State == NpcState.STATE_IDLE then
		sprite.FlipX = false
		sprite:Play("FloatDown")
	end
end

function gospelChild:redoTrain(fam)
	local gospelCnt = fam.Player:GetCollectibleNum(CollectibleType.AGONY_C_GOSPEL_CHILD)
	debug_tbl1 = gospelChild.gospels
	debug_text = gospelCnt

	if fam.Variant == FamiliarVariant.AGONY_F_GOSPEL_CHILD then
		for i in pairs(gospelChild.gospels) do --lowest index in the gospels table
			gospelChild.firstGospel = math.min(i, gospelChild.firstGospel)
		end 
		local first = gospelChild.gospels[gospelChild.firstGospel]
		if first.Parent ~= nil then 
			first.Parent.Child = nil --set the original parent of gospel to queue end
		end
		first.Parent = nil --follow isaac

		--when reentering a run the game places the familiars in order of pickup
		--if two or more gospels were picked up directly after another, but the first was moved to the front, the second gospel will be behind the first gospel, creating double familiar queues
		--this reattaches it to the right place the familiar's parent is the first gospel, but the first gospel's child isn't the familiar
		if fam.Index ~= first.Index and fam.Parent ~= nil and first.Child ~= nil and fam.Parent.Index == first.Index and first.Child.Index ~= fam.Index then
			local last = first
			while last.Child ~= nil do
				last = last.Child
			end
			last.Child = fam
			fam.Parent = last
		end
	elseif gospelChild.firstGospel ~= math.huge and fam.IsFollower and fam.Variant ~= FamiliarVariant.AGONY_F_GOSPEL_CHILD and fam.Parent == nil and fam.FrameCount > 1 then
		--debug_text = " run " .. tostring(fam.Index)
		gospelChild.gospels[gospelChild.firstGospel].Child = fam
		fam.Parent = gospelChild.gospels[gospelChild.firstGospel]
	end

	if gospelCnt > 0 and fam.FrameCount % 30 == 0 then
		debug_text = "tick"
		local dmg = fam.Player.Damage / 2
		if fam.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			dmg = dmg * 2
		end

		local ents = Isaac.GetRoomEntities()
		for _,ent in pairs(ents) do
			if ent:IsEnemy() and fam.Position:Distance(ent.Position) <= fam.Size + ent.Size + 8 then
				ent:TakeDamage(dmg, 0, EntityRef(fam), 0)
			end
		end
	end
end

function gospelChild:initFam(fam)
	local famData = fam:GetData()
	local famSprite = fam:GetSprite()
	
	if Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_LILITH then --lilith special sprites
		famSprite:ReplaceSpritesheet(0, "gfx/Familiars/Gospel Child/dark.png")
		famSprite:LoadGraphics()
		famData.Dark = true
	end
	famSprite:Play("FloatDown")

	famData.attackCooldown = 8
	famData.dir = Direction.NO_DIRECTION
	fam.State = NpcState.STATE_IDLE
	fam:AddToFollowers()
end

function gospelChild:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_GOSPEL_CHILD, player:GetCollectibleNum(CollectibleType.AGONY_C_GOSPEL_CHILD), player:GetCollectibleRNG(CollectibleType.AGONY_C_GOSPEL_CHILD))
	end
end

--reset functs
function gospelChild:reset()
	gospelChild.gospels = {}
	gospelChild.firstGospel = math.huge
end

function gospelChild:removeGospels()
	for i,gosp in pairs(gospelChild.gospels) do
		if not gosp:Exists() then
			gospelChild.gospels[i] = nil
			gospelChild.firstGospel = math.huge
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, gospelChild.updateFam, FamiliarVariant.AGONY_F_GOSPEL_CHILD)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, gospelChild.redoTrain)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, gospelChild.initFam, FamiliarVariant.AGONY_F_GOSPEL_CHILD)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, gospelChild.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, gospelChild.reset)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, gospelChild.removeGospels)