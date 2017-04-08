local jaundice =  {}

function jaundice:onUpdate()
  local ents = Isaac.GetRoomEntities()
  local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_JAUNDICE) then
    if player.Luck > 0 then
      prob = math.floor(math.random(5000)%(math.floor(300/(player.Luck+1))))
    elseif player.Luck == 0 then
      prob = math.random(5000)%300
    else
      prob = math.random(5000)%(-300*(player.Luck-1))
    end
    for _,entity in pairs(ents) do
      if entity.Type == EntityType.ENTITY_TEAR then
        if entity.FrameCount == 1 and prob == 1 then
          --TODO : Change gfx to yellow stuff idk
          entity:GetSprite():ReplaceSpritesheet(0, "gfx/effect/tear_jaundice.png")
          entity:GetSprite():LoadGraphics()
          entity.SubType = AgonyTearSubtype.JAUNDICE
        end
      end
    end
  end
end

function jaundice:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    if source.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == AgonyTearSubtype.JAUNDICE then
      local col = Color(0, 0, 0, 0, 0, 0, 0)
      col:Reset()
      Game():SpawnParticles(source.Position, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 1, 0, col, 0)
    end
end
function jaundice:cacheUpdate (player,cacheFlag)
  -- tears up
  if (player:HasCollectible(CollectibleType.AGONY_C_JAUNDICE)) then
    if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
      player.MaxFireDelay = player.MaxFireDelay - player.MaxFireDelay*0.2*player:GetCollectibleNum(CollectibleType.AGONY_C_JAUNDICE);
    end
  end
end


Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, jaundice.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, jaundice.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, jaundice.onTakeDmg);