local pyramidHead =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
pyramidHead.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_pyramidhead.anm2")

function pyramidHead:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_PYRAMID_HEAD)) and (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed - 0.3
	end
end

function pyramidHead:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		pyramidHead.hasItem = false
	end
	if pyramidHead.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_PYRAMID_HEAD) then
		--player:AddNullCostume(pyramidHead.costumeID)
		pyramidHead.hasItem = true
	end
end

function pyramidHead:fearEnemies(npc)
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_PYRAMID_HEAD)
	
	if player:HasCollectible(CollectibleType.AGONY_C_PYRAMID_HEAD) then
		if npc.Position:Distance(player.Position) < 500 then			
			if rng:RandomInt(180) == 1 then
				npc:AddFear(EntityRef(player), 120)
			end
		end
	end
end

function pyramidHead:darken()
	if Game():GetPlayer(0):HasCollectible(CollectibleType.AGONY_C_PYRAMID_HEAD) then
		Game():Darken(1, 1)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, pyramidHead.darken)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, pyramidHead.fearEnemies)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, pyramidHead.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, pyramidHead.cacheUpdate)