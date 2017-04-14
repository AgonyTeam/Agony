local clone = {}

local function dirToVec(dir) --converts a direction to a vector pointing in that direction
	if dir == Direction.UP then
		return Vector(0,-1)
	elseif dir == Direction.DOWN then
		return Vector(0,1)
	elseif dir == Direction.LEFT then
		return Vector(-1,0)
	elseif dir == Direction.RIGHT then
		return Vector(1,0)
	else
		return Vector(0,0)
	end
end

local function pTypeToName(pType) --returns the player name. can't use player:GetName() because that doesn't update when using clicker
	if pType == 0 then
		return "Isaac"
	elseif pType == 1 then
		return "Magdalene"
	elseif pType == 2 then
		return "Cain"
	elseif pType == 3 then
		return "Judas"
	elseif pType == 4 then
		return "Blue Baby"
	elseif pType == 5 then
		return "Eve"
	elseif pType == 6 then
		return "Samson"
	elseif pType == 7 then
		return "Azazel"
	elseif pType == 8 then
		return "Lazarus"
	elseif pType == 9 then
		return "Eden"
	elseif pType == 10 then
		return "The Lost"
	elseif pType == 11 then
		return "Lazarus 2"
	elseif pType == 12 then
		return "Black Judas"
	elseif pType == 13 then
		return "Lilith"
	elseif pType == 14 then
		return "Keeper"
	elseif pType == 15 then
		return "Apollyon"
	end
end

function clone:ai_animation(ent) --mirrors player animation
	local player = Isaac.GetPlayer(0)
	local pSprite = player:GetSprite()
	local sprite = ent:GetSprite()
	local fireDir = player:GetFireDirection()
	local moveDir = player:GetMovementDirection()
	
	if ent.FrameCount <= 1 and pTypeToName(player:GetPlayerType()) ~= "Isaac" then
		sprite:Load("gfx/Monsters/Player Clone/" .. pTypeToName(player:GetPlayerType()) .. ".anm2", true)
		sprite:Play("Appear")
	end
	
	if (player:GetPlayerType() == PlayerType.PLAYER_AZAZEL and sprite:GetFilename() == "gfx/Monsters/Player Clone/Azazel.anm2" ) or (player:GetPlayerType() == PlayerType.PLAYER_THELOST and sprite:GetFilename() == "gfx/Monsters/Player Clone/The Lost.anm2" )then
		if fireDir == Direction.DOWN then
			sprite:SetOverlayFrame("HeadDown", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.RIGHT then
			sprite:SetOverlayFrame("HeadRight", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.LEFT then
			sprite:SetOverlayFrame("HeadLeft", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.UP then
			sprite:SetOverlayFrame("HeadUp", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.NO_DIRECTION then
			if moveDir == Direction.DOWN or moveDir == Direction.NO_DIRECTION then
				sprite:SetOverlayFrame("HeadDown", pSprite:GetOverlayFrame())
			elseif moveDir == Direction.RIGHT then
				sprite:SetOverlayFrame("HeadRight", pSprite:GetOverlayFrame())
			elseif moveDir == Direction.LEFT then
				sprite:SetOverlayFrame("HeadLeft", pSprite:GetOverlayFrame())
			elseif moveDir == Direction.UP then
				sprite:SetOverlayFrame("HeadUp", pSprite:GetOverlayFrame())
			end
		end
		
		if moveDir == Direction.DOWN or moveDir == Direction.NO_DIRECTION then
			sprite:Play("WalkDown")
		elseif moveDir == Direction.RIGHT then
			sprite:Play("WalkRight")
		elseif moveDir == Direction.LEFT then
			sprite:Play("WalkLeft")
		elseif moveDir == Direction.UP then
			sprite:Play("WalkUp")
		end
	else 
		if fireDir == Direction.DOWN then
			sprite:SetOverlayFrame("HeadDown", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.RIGHT then
			sprite:SetOverlayFrame("HeadRight", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.LEFT then
			sprite:SetOverlayFrame("HeadLeft", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.UP then
			sprite:SetOverlayFrame("HeadUp", pSprite:GetOverlayFrame())
		elseif fireDir == Direction.NO_DIRECTION then
			if moveDir == Direction.DOWN or moveDir == Direction.NO_DIRECTION then
				sprite:SetOverlayFrame("HeadDown", pSprite:GetOverlayFrame())
			elseif moveDir == Direction.RIGHT then
				sprite:SetOverlayFrame("HeadRight", pSprite:GetOverlayFrame())
			elseif moveDir == Direction.LEFT then
				sprite:SetOverlayFrame("HeadLeft", pSprite:GetOverlayFrame())
			elseif moveDir == Direction.UP then
				sprite:SetOverlayFrame("HeadUp", pSprite:GetOverlayFrame())
			end
		end
		
		if moveDir == Direction.DOWN then
			sprite:Play("WalkDown")
		elseif moveDir == Direction.RIGHT then
			sprite:Play("WalkRight")
		elseif moveDir == Direction.LEFT then
			sprite:Play("WalkLeft")
		elseif moveDir == Direction.UP then
			sprite:Play("WalkUp")
		elseif moveDir == Direction.NO_DIRECTION and not (pSprite:IsPlaying("WalkRight") or pSprite:IsPlaying("WalkLeft") or pSprite:IsPlaying("WalkDown") or pSprite:IsPlaying("WalkUp")) then
			sprite:SetFrame("WalkDown", pSprite:GetFrame())
		end
	end
end

function clone:ai_movement(ent) --init entity and copy velocity from player
	local player = Isaac.GetPlayer(0)
	if ent.FrameCount >= 3 and not ent:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY) then
		ent:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
	end
	ent.Velocity = player.Velocity:__mul(2)
	ent.EntityCollisionClass = player.EntityCollisionClass
	ent.GridCollisionClass = player.GridCollisionClass
end

function clone:ai_damage(hurtEnt, dmgAmount, dmgFlag, sourceEnt, dmgCountdown) --remove the clone with a poof if hurt
	local data = Isaac.GetPlayer(0):GetData()
	data.Clones = data.Clones - 1
	saveData.cherry.Clones = data.Clones
	Agony:SaveNow()
	
	--POOF!
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	Game():SpawnParticles(hurtEnt.Position, EffectVariant.POOF01, 1, 1, col, 0)
	hurtEnt:Remove()
end

function clone:ai_attack(ent) --attack of clones
	local player = Isaac.GetPlayer(0)
	local fireDir = player:GetFireDirection()
	if player:HasWeaponType(WeaponType.WEAPON_TEARS) then --regular tears
		if player.FireDelay == 0 and fireDir ~= Direction.NO_DIRECTION then
			local vel = dirToVec(fireDir):__mul(player.ShotSpeed*10):__add(ent.Velocity:__mul(0.3))
			player:FireTear(ent.Position, vel, true, true, true)
		end
	elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then --dr. fetus
		if player.FireDelay == 0 and fireDir ~= Direction.NO_DIRECTION then
			player:FireBomb(ent.Position, dirToVec(fireDir):__mul(player.ShotSpeed*10))
		end
	end
end

function clone:ai_swap_player(hurtEnt, dmgAmount, dmgFlag, sourceEnt, dmgCountdown) --if clones exist and the player gets hit, don't take damage and pretend the player was a clone
	if hurtEnt.Type == EntityType.ENTITY_PLAYER then
		local deadClone = Agony:getFurthestEnemy(hurtEnt, {EntityType.AGONY_ETYPE_PLAYER_CLONE}, {mode = "only_whitelist"}) --get furthest clone
		if deadClone ~= hurtEnt then --if there even is a clone
			local data = hurtEnt:GetData()
			data.Clones = data.Clones - 1
			saveData.cherry.Clones = data.Clones
			Agony:SaveNow()
			
			local oldpos = hurtEnt.Position --save old pos for poof
			hurtEnt.Position = deadClone.Position
			
			--POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(oldpos, EffectVariant.POOF01, 1, 1, col, 0)
			deadClone:Remove()
			return false
		end
	end
end


---unused functions---
function clone:ai_orbitals(fam) --this would be used to set the familiars to different layers, but after enough layers, the game crashes
	--debug_text = tostring(fam.Parent.Type)
	if fam.Parent ~= nil and fam.Parent.Type == EntityType.AGONY_ETYPE_PLAYER_CLONE then
		if not fam:GetData().ChangedLayer then
			local layer = fam.OrbitLayer + fam.Parent.Index*100 + 5000
			local distance = fam.OrbitDistance
			local speed = fam.OrbitSpeed
			fam:RemoveFromOrbit()
			fam:AddToOrbit(layer)
			fam.OrbitDistance = distance
			fam.OrbitSpeed = speed
			fam:GetData().ChangedLayer = true
		end
		fam.Velocity = fam:GetOrbitPosition(fam.Parent.Position:__add(fam.Parent.Velocity)):__sub(fam.Position)
		debug_text = tostring(fam.Parent:Exists())
		if not fam.Parent:Exists() then
			--debug_text = "not exists"
			fam:Remove()
		end
	end
	--fam:RecalculateOrbitOffset(fam.OrbitLayer, false)
end

function clone:ai_render() --this would make it posible to copy costumes as well, but this renders on top of any shaders, so it'll look weird, and it fucks up in not normal sized rooms
	local player = Isaac.GetPlayer(0)
	local ents = Isaac.GetRoomEntities()
	for _,ent in pairs(ents) do
		if ent.Type == EntityType.AGONY_ETYPE_PLAYER_CLONE then
			player:RenderBody(Isaac.WorldToRenderPosition(ent.Position))
			player:RenderHead(Isaac.WorldToRenderPosition(ent.Position))
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, clone.ai_animation, EntityType.AGONY_ETYPE_PLAYER_CLONE)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, clone.ai_movement, EntityType.AGONY_ETYPE_PLAYER_CLONE)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, clone.ai_attack, EntityType.AGONY_ETYPE_PLAYER_CLONE)
--Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, clone.ai_orbitals)
--Agony:AddCallback(ModCallbacks.MC_POST_RENDER, clone.ai_render)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, clone.ai_damage, EntityType.AGONY_ETYPE_PLAYER_CLONE)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, clone.ai_swap_player)