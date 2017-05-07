local soakedRemote = {
  effects = {
    
    function (ent) --Reverse
      ent.Velocity = ent.Velocity * -1
    end,
    
    function (ent) --Slow Reverse
      ent.Velocity = ent.Velocity * -0.5
    end,
    
    function (ent) --Pause
      ent.Velocity = Vector(0,0)
    end
    
  }
}

function soakedRemote:onUse()
  local entities = Isaac:GetRoomEntities()
  local effect = soakedRemote.effects[ math.random( #(soakedRemote.effects) ) ]
  local count = 0
  for i, ent in pairs(entities) do
    if ent.Type == EntityType.ENTITY_PROJECTILE then
      count = count + 1
      effect(ent)
    end
  end
  --Feedback/Beep
  if count == 0 then
    SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 0.8, 0, false, 1.5)
  else
    SFXManager():Play(SoundEffect.SOUND_BEEP, 1.2, 0, false, 1)
  end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, soakedRemote.onUse, CollectibleType.AGONY_C_SOAKED_REMOTE)