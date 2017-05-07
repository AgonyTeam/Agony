local strangeLiquid = {
  leaderTear = nil,
  lastTear = nil
}

function strangeLiquid:onUpdate()
  local player = Isaac.GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_STRANGE_LIQUID) then
    
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
          
          if strangeLiquid.leaderTear == nil then
            strangeLiquid.leaderTear = e
            strangeLiquid.lastTear = e
            e:GetSprite().Color = Color(1.0,1.0,1.0,1.0,255,0,0)
          elseif not strangeLiquid.leaderTear:Exists() then
            strangeLiquid.leaderTear = e
            strangeLiquid.lastTear = e
            e:GetSprite().Color = Color(1.0,1.0,1.0,1.0,255,0,0)
          end
          
          if strangeLiquid.leaderTear ~= e then
            e:GetData().tleader = strangeLiquid.lastTear
          end
          
          strangeLiquid.lastTear = e
        end
        
        if e:GetData().tleader ~= nil and e:GetData().tleader:Exists() then
          
          --Follow Leader
          local dir2 = e:GetData().tleader.Position - e.Position
          dir2:Normalize()
          local dist = e.Velocity:Length()
          e.Velocity = dir2 * dist
          
        end
        
      end
    end
    
    if dir.X ~= 0 or dir.Y ~= 0 and strangeLiquid.leaderTear ~= nil and strangeLiquid.leaderTear:Exists() then
      local dist = strangeLiquid.leaderTear.Velocity:Length()
      strangeLiquid.leaderTear.Velocity = dir * dist
    end
    
  end
end

function strangeLiquid:cacheUpdate(player,cacheFlag)
  if player:HasCollectible(CollectibleType.AGONY_C_STRANGE_LIQUID) then
    if cacheFlag == CacheFlag.CACHE_RANGE then
      player.TearFallingSpeed = player.TearFallingSpeed + 2
			player.TearFallingAcceleration = player.TearFallingAcceleration * 0.5
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.FireDelay = player.FireDelay * 0.8 - 1
		end
  end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, strangeLiquid.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, strangeLiquid.cacheUpdate)