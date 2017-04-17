local yeuxRev =  {
}

function yeuxRev:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_YEUX_REVOLVER)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = (player.Damage + 3.42069*player:GetCollectibleNum(CollectibleType.AGONY_C_YEUX_REVOLVER))
		end
		if (cacheFlag == CacheFlag.CACHE_SHOTSPEED) then
			player.ShotSpeed = (player.ShotSpeed + 1.69420*player:GetCollectibleNum(CollectibleType.AGONY_C_YEUX_REVOLVER))
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			player.MaxFireDelay = player.MaxFireDelay + 2*player:GetCollectibleNum(CollectibleType.AGONY_C_YEUX_REVOLVER);
		end
	end
end

function yeuxRev:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_YEUX_REVOLVER) then
    for _,entity in pairs(ents) do
    	if entity.Type == EntityType.ENTITY_TEAR then
    		if entity.FrameCount == 0 then
    			--TODO; spawn a white flash on the tear pos
          		Game():ShakeScreen(math.floor(player.Damage/2))
    			entity:GetSprite():ReplaceSpritesheet(0, "gfx/effect/tear_yeuxrevolver.png")
          		entity:GetSprite():LoadGraphics()
          		entity:GetSprite().Rotation = entity.Velocity:GetAngleDegrees()
          	end
    	end
    end
  end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, yeuxRev.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yeuxRev.cacheUpdate)