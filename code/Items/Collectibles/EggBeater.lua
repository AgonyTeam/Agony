
local eggBeater =  {}

function eggBeater:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_EGG_BEATER) then
    for _,entity in pairs(ents) do
    	if entity.Type == EntityType.ENTITY_TEAR then
    		if entity.FrameCount == 1 then
    			entity.Velocity = entity.Velocity:Rotated(math.random(100)-50)
    		end
    	end
    end
  end
end

function eggBeater:cacheUpdate (player,cacheFlag)
  if (player:HasCollectible(CollectibleType.AGONY_C_EGG_BEATER)) then
    if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
      player.Damage = player.Damage + 1.420
    end
    if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
      player.MaxFireDelay = math.ceil(player.MaxFireDelay/2)
    end
    if (cacheFlag == CacheFlag.CACHE_SHOTSPEED) then
      player.ShotSpeed = player.ShotSpeed*1.3
    end
  end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, eggBeater.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eggBeater.onTakeDmg);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, eggBeater.onUpdate)