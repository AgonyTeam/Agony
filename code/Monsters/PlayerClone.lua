local clone = {}

function clone:ai_animation(ent)
	local player = Isaac.GetPlayer(0)
	local pSprite = player:GetSprite()
	local sprite = ent:GetSprite()
	local fireDir = player:GetFireDirection()
	local moveDir = player:GetMovementDirection()
	
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

function clone:ai_movement(ent)
	local player = Isaac.GetPlayer(0)
	--debug_text = tostring(player:CanShoot()) .. " " .. tostring(player:GetAimDirection():Length())
	debug_text = tostring(player:GetName())
	if ent.FrameCount <= 1 then
		ent:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
	end
	ent.Velocity = Isaac.GetPlayer(0).Velocity:__mul(2)
end

function clone:ai_damage(hurtEnt, dmgAmount, dmgFlag, sourceEnt, dmgCountdown)
	if dmgAmount > hurtEnt.HitPoints then
		local data = Isaac.GetPlayer(0):GetData()
		data.Clones = data.Clones - 1
		saveData.cherry.Clones = data.Clones
		Agony:SaveNow()
	end
end

function clone:ai_attack(ent)
	local player = Isaac.GetPlayer(0)
	if player:HasWeaponType(WeaponType.WEAPON_TEARS) then
		if player.FireDelay == 0 and player:GetShootingInput():Length() ~= 0 then
			local vel = player:GetShootingInput():Clamped(-1,-1,1,1):__mul(player.ShotSpeed*10):__add(ent.Velocity:__mul(0.5*player:GetShootingInput():Clamped(-1,-1,1,1):Length()))
			-- v = shooting input, clamped to 4 possible directions, multiplied by shotspeed times 10. when the entity is moving, half of its velocity  is added to the shooting velocity
			player:FireTear(ent.Position, vel, true, true, true)
		end
	elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
		if player.FireDelay == 0 and player:GetShootingInput():Length() ~= 0 then
			player:FireBomb(ent.Position, player:GetShootingInput():Clamped(-1,-1,1,1):__mul(player.ShotSpeed*10))
		end
	end
end

--[[function clone:ai_render()
	local player = Isaac.GetPlayer(0)
	local ents = Isaac.GetRoomEntities()
	for _,ent in pairs(ents) do
		if ent.Type == EntityType.AGONY_ETYPE_PLAYER_CLONE then
			player:RenderBody(Isaac.WorldToRenderPosition(ent.Position))
			player:RenderHead(Isaac.WorldToRenderPosition(ent.Position))
		end
	end
end]]

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, clone.ai_animation, EntityType.AGONY_ETYPE_PLAYER_CLONE)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, clone.ai_movement, EntityType.AGONY_ETYPE_PLAYER_CLONE)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, clone.ai_attack, EntityType.AGONY_ETYPE_PLAYER_CLONE)
--Agony:AddCallback(ModCallbacks.MC_POST_RENDER, clone.ai_render)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, clone.ai_damage, EntityType.AGONY_ETYPE_PLAYER_CLONE)