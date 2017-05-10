local blindFaith = {
  leaderTear = nil,
  lastTear = nil,
  tearFallingAccelerationMult = 0.4,
  tearFallingAccelerationOff = 0,
  tearFallingSpeedMult = 1,
  tearFallingSpeedOff = 2,
  fireDelayMult = 0.75,
  fireDelayOff = -1,
  damageMult = 0.75,
  damageOff = 0,
  noDirectionTime = 0,
  noDirectionTimeout = 8, --If no shoot direction pressed for x frames, force a new leader Tear
  forceNewLeaderTear = true,
  tearOscillator = false,
  knifeRotationSpeed = 5
}

function blindFaith:makeLeader(e)
  blindFaith.leaderTear = e
  blindFaith.lastTear = e
  
  if e.Type == EntityType.ENTITY_TEAR then
    local t = e:ToTear()
    t.TearFlags = t.TearFlags & ~TearFlags.TEAR_ORBIT --Remove Orbit Effect for Leader Tear
    t.TearFlags = t.TearFlags & ~TearFlags.TEAR_HOMING
    if e:GetSprite() ~= nil then
      local sheet = "gfx/effect/tear_blindfaith_a.png"
      if e:GetData().leaderSpriteSheet ~= nil then
        sheet = e:GetData().leaderSpriteSheet
      end
      e:GetSprite():ReplaceSpritesheet(0, sheet)
      e:GetSprite():LoadGraphics()
    end
  else
    e:GetSprite().Color = Color(1,1,1,1,255,10,10)
  end
end

function blindFaith:projectileTryLeader(e)
  if blindFaith.leaderTear == nil or blindFaith.forceNewLeaderTear then
    blindFaith:makeLeader(e)
    blindFaith.forceNewLeaderTear = false
  elseif not blindFaith.leaderTear:Exists() then
    blindFaith:makeLeader(e)
  end
end

function blindFaith:projectileInit(e)
  if e:GetData().tleader == nil then
    if blindFaith.leaderTear ~= e then
      e:GetData().tleader = blindFaith.lastTear
      
      --if blindFaith.lastTear:GetData().followerTear == nil then
      --  blindFaith.lastTear:GetData().followerTear = {}
      --end
      --table.insert(blindFaith.lastTear:GetData().followerTear, e)
      
      --Remove Orbit effect for every second non-leader tear
      if blindFaith.tearOscillator and e.tearFlags ~= nil and e.Type == EntityType.ENTITY_TEAR and Agony:HasFlags(e.TearFlags, TearFlags.TEAR_ORBIT) then
        local t = e:ToTear()
        t.TearFlags = t.TearFlags & ~TearFlags.TEAR_ORBIT --Remove Orbit Effect for Leader Tear
      end
      blindFaith.tearOscillator = not blindFaith.tearOscillator
    end
    blindFaith.lastTear = e
  end
end

function blindFaith:projectileTryFollow(e)
  if e:GetData().tleader ~= nil and e:GetData().tleader:Exists() and blindFaith.leaderTear ~= e then
    
    --Follow Leader
    local dir2 = e:GetData().tleader.Position - e.Position
    dir2:Normalize()
    local dist = math.max(e.Velocity:Length(),1)
    local tVel = dir2 * dist
    e.Velocity = tVel
    
  end
end

function blindFaith:onUpdate()
  local player = Isaac.GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_BLIND_FAITH) then
    
    local dir = Vector(0,0)
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
      dir = dir + Vector(-1,0)
    end
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
      dir = dir + Vector(1,0)
    end
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
      dir = dir + Vector(0,-1)
    end
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
      dir = dir + Vector(0,1)
    end
    
    if dir.X ~= 0 or dir.Y ~= 0 then
      dir:Normalize()
    end
    
    
    local ents = Isaac.GetRoomEntities()
    for _,e in pairs(ents) do
      if e.Type == EntityType.ENTITY_TEAR then
        
        if e.FrameCount == 1 then
          
          blindFaith:projectileTryLeader(e)
          blindFaith:projectileInit(e)
          
        end
        
        blindFaith:projectileTryFollow(e)
        
      elseif e:ToBomb() ~= nil then
        
        local b = e:ToBomb()
        if b.IsFetus then
          if b.FrameCount == 1 then
            
            blindFaith:projectileTryLeader(b)
            blindFaith:projectileInit(b)
            if e.Friction < 1 then
              e.Friction = math.min(1, e.Friction * 2)
            end
            
          end
          blindFaith:projectileTryFollow(b)
        end
        
      elseif e.Type == EntityType.ENTITY_LASER then
        local l = e:ToLaser()
        if l.Variant == 2 and l.SubType == 2 then
          if l.FrameCount == 1 then
            
            blindFaith:projectileTryLeader(l)
            blindFaith:projectileInit(l)
            
          end
          blindFaith:projectileTryFollow(l)
          debug_text = "Vel "..l.Velocity.X.." ; "..l.Velocity.Y.." Pos "..l.Position.X.." ; "..l.Position.Y
          
        else
          if l.FrameCount == 1 and l.Variant ~= 2 and l.SpawnerType == EntityType.ENTITY_PLAYER then
            
            blindFaith.brimstoneLaser = l
            
            local vel = Vector.FromAngle(l.AngleDegrees)
            vel = Vector(vel.X * player.ShotSpeed * 8, vel.Y * player.ShotSpeed * 8)
            
            local t = player:FireTear(player.Position,vel,false,true,true)
            t:GetData().leaderSpriteSheet = "gfx/effect/tear_blindfaith_b.png"
            t.Scale = 1.5
            t:ResetSpriteScale()
            t.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            blindFaith.leaderTear = nil
            
            debug_text = "Vel "..t.Velocity.X.." ; "..t.Velocity.Y
            
          end
          if blindFaith.leaderTear ~= nil and blindFaith.leaderTear:Exists() and
            (l.SpawnerType == EntityType.ENTITY_PLAYER or l.SpawnerType == EntityType.ENTITY_FAMILIAR) then
            l.AngleDegrees = (blindFaith.leaderTear.Position - l.Position):GetAngleDegrees()
          end
        end
        
      elseif e.Type == EntityType.ENTITY_KNIFE then
        local k = e:ToKnife()
        if true then --TODO: Check if Knife is from player
          local dirangle
          if dir.X ~= 0 or dir.Y ~= 0 and k.IsFlying then
            dirangle = dir:GetAngleDegrees()
            local targetangle = k.Rotation
            if targetangle > dirangle + 180 then
              targetangle = targetangle - 360
            elseif targetangle < dirangle - 180 then
              targetangle = targetangle + 360
            end
            k.Rotation = (targetangle - dirangle) * 0.5 + dirangle
            if targetangle > dirangle then
              k.Rotation = math.max(dirangle, targetangle - blindFaith.knifeRotationSpeed)
            elseif targetangle < dirangle then
              k.Rotation = math.min(dirangle, targetangle + blindFaith.knifeRotationSpeed)
            end
          end
          debug_text = "Rot"..k.Rotation.." RotOff"..k.RotationOffset.." Dir"..dirangle
        end
      elseif e.Type == EntityType.ENTITY_EFFECT and e.SpawnerType == EntityType.ENTITY_PLAYER or e.SpawnerType == EntityType.ENTITY_FAMILIAR then
        
        if e.Variant == 52 then --Flame from Ghost Pepper and probably other items?
          debug_text = "FLAME"
          if e.FrameCount == 1 then
            --blindFaith:projectileTryLeader(e)
            local originalLTear = blindFaith.lastTear
            blindFaith.lastTear = blindFaith.leaderTear
            blindFaith:projectileInit(e)
            blindFaith.lastTear = originalLTear
            if e.Friction < 1 then
              e.Friction = 1
            end
          end
          blindFaith:projectileTryFollow(e)
          
        elseif e.Variant == 30 then --Epic Fetus Marker
          debug_text = "EPIC FETUS MARKER"
          if blindFaith.leaderTear ~= e then
            blindFaith:makeLeader(e)
          end
          
        end
        
      end
    end
    
    if (dir.X ~= 0 or dir.Y ~= 0) and blindFaith.leaderTear ~= nil and blindFaith.leaderTear:Exists() then
      local dist = blindFaith.leaderTear.Velocity:Length()
      blindFaith.leaderTear.Velocity = dir * dist
    end
    
    if dir.X == 0 and dir.Y == 0 then
      if blindFaith.noDirectionTime >= blindFaith.noDirectionTimeout then
        blindFaith.forceNewLeaderTear = true
      end
      blindFaith.noDirectionTime = blindFaith.noDirectionTime + 1
    else
      blindFaith.noDirectionTime = 0
    end
    
  end
end

function blindFaith:cacheUpdate(player,cacheFlag)
  if player:HasCollectible(CollectibleType.AGONY_C_BLIND_FAITH) then
    if cacheFlag == CacheFlag.CACHE_RANGE then
      player.TearFallingSpeed = player.TearFallingSpeed * blindFaith.tearFallingSpeedMult + blindFaith.tearFallingSpeedOff
			player.TearFallingAcceleration = player.TearFallingAcceleration * blindFaith.tearFallingAccelerationMult + blindFaith.tearFallingAccelerationOff
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay * blindFaith.fireDelayMult + blindFaith.fireDelayOff
		end
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
      player.Damage = player.Damage * blindFaith.damageMult + blindFaith.damageOff
    end
  end
end

--Prevent Brimstone canceling
function blindFaith:onInput(entity,hook,action)
	if entity ~= nil and blindFaith.brimstoneLaser ~=nil and blindFaith.brimstoneLaser:Exists() then
		local player = entity:ToPlayer()

		if player and player:HasCollectible(CollectibleType.AGONY_C_BLIND_FAITH) then
			if action == ButtonAction.ACTION_SHOOTUP
			or action == ButtonAction.ACTION_SHOOTDOWN
			or action == ButtonAction.ACTION_SHOOTLEFT
			or action == ButtonAction.ACTION_SHOOTRIGHT
			then
				if hook == InputHook.GET_ACTION_VALUE then
					return 0
				else
					return false
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, blindFaith.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, blindFaith.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_INPUT_ACTION, blindFaith.onInput)
--Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, blindFaith.onDamage)