local fatfly = {
  fastFlapRate = 5,
  fastFlapRateOffset = 0,
  restRate = 10,
  restRateOffset = 1,
  flapVelocity = 9,
  fastFlapVelocity = 20,
  fastFlapPredictionScale = 0.5,
  splatScale = 2.0,
  restAnimationRepeats = 3,
  
  stateRest = 20
}

function fatfly:ai_switch_state(ent, state)
  ent.State = state
  ent.StateFrame = 0
end

function fatfly:ai_try_rest(ent, sprite)
  if Game():GetRoom():GetGridCollisionAtPos(ent.Position) == GridCollisionClass.COLLISION_NONE then
    ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    fatfly:ai_switch_state(ent, fatfly.stateRest)
  else
    ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    fatfly:ai_switch_state(ent, NpcState.STATE_MOVE)
  end
end

function fatfly:ai_init(ent, sprite, player)
  
  ent.Friction = 0.9
  ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
  
  fatfly:ai_switch_state(ent, NpcState.STATE_MOVE)
  
end

function fatfly:ai_fly(ent, sprite, player)
  
  ent.Friction = 0.9
  ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    
  if sprite:IsFinished("Fly") or ent.StateFrame == 1 then
    
    ent.I1 = ent.I1 + 1 --Increase FlapCount
    
    if ( ent.I1 + fatfly.fastFlapRateOffset ) % fatfly.fastFlapRate == 0 then
      fatfly:ai_switch_state(ent, NpcState.STATE_JUMP) --Fast Flap
      
    elseif ( ent.I1 + fatfly.restRateOffset ) % fatfly.restRate == 0 then
      fatfly:ai_try_rest(ent, sprite) --Try Rest
      
    else
      sprite:Play("Fly",true) --Normal Flap
    end
    
  end
  
  if sprite:IsEventTriggered("wingstrike") then
    
    local dir = (player.Position + player.Velocity) - ent.Position
    dir:Normalize()
    dir = dir * fatfly.flapVelocity
    
    ent.Velocity = ent.Velocity + dir
    
  end
  
end

function fatfly:ai_fly_fast(ent, sprite, player)
  
  ent.Friction = 0.9
  ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
  
  if ent.StateFrame == 1 then
    sprite:Play("Fly2", true)
  end
  
  if sprite:IsFinished("Fly2") then
    fatfly:ai_switch_state(ent, NpcState.STATE_MOVE)
  end
  
  if sprite:IsEventTriggered("wingstrike") then
    
    local dist = player.Position:Distance(ent.Position)
    
    local dir = (player.Position + player.Velocity * dist * fatfly.fastFlapPredictionScale) - ent.Position
    dir:Normalize()
    dir = dir * fatfly.fastFlapVelocity
    
    ent.Velocity = ent.Velocity + dir
    
  end
  
end

function fatfly:ai_rest(ent, sprite, player)
  
  ent.Friction = 0.5
  
  local data = ent:GetData()
  
  if ent.StateFrame == 1 then
    sprite:Play("Down",true)
    ent.I2 = fatfly.restAnimationRepeats
    data.restState = 0
  elseif data.restState == 0 then
    
    if sprite:IsEventTriggered("land") then
      ent:MakeSplat(fatfly.splatScale)
    end
    
    if sprite:IsFinished("Down") then
      data.restState = 1
      sprite:Play("Sit")
    end
    
  elseif data.restState == 1 then
    
    if sprite:IsFinished("Sit") then
      ent.I2 = ent.I2 - 1
      if ent.I2 < 0 then
        data.restState = 2
        sprite:Play("Up")
      else
        sprite:Play("Sit",true)
      end
    end
    
  elseif data.restState == 2 then
    
    if sprite:IsFinished("Up") then
      fatfly:ai_switch_state(ent, NpcState.STATE_MOVE)
    end
    
  end
  
end

function fatfly:ai_update(ent)
  local player = Isaac.GetPlayer(0)
  local sprite = ent:GetSprite()
  
  if ent.State == NpcState.STATE_INIT then
    fatfly:ai_init(ent, sprite, player)
    
  elseif ent.State == NpcState.STATE_MOVE then
    fatfly:ai_fly(ent, sprite, player)
    
  elseif ent.State == NpcState.STATE_JUMP then
    fatfly:ai_fly_fast(ent, sprite, player)
    
  elseif ent.State == fatfly.stateRest then
    fatfly:ai_rest(ent, sprite, player)
    
  end
  
  ent.StateFrame = ent.StateFrame + 1
  
end

function fatfly:ai_damage(ent, dmg, flags, source, countdown)
  
  if ent.HitPoints - dmg <= 0 then --Death
    
    ent:BloodExplode()
    
    ent:Remove()
    
  end
  
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, fatfly.ai_update, EntityType.AGONY_ETYPE_FATFLY);
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, fatfly.ai_damage, EntityType.AGONY_ETYPE_FATFLY);