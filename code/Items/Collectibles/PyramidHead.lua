--local item_PyramidHead = Isaac.GetItemIdByName("Pyramid Head");
CollectibleType["AGONY_C_PYRAMID_HEAD"] = Isaac.GetItemIdByName("Pyramid Head");
local pyramidHead =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
pyramidHead.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_pyramidhead.anm2")

--Grants +1 Luck and gives a *2 multiplier to Luck
function pyramidHead:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_PYRAMID_HEAD)) and (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed - 0.3
	end
end

function pyramidHead:onUpdate(player)
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
	if player:HasCollectible(CollectibleType.AGONY_C_PYRAMID_HEAD) then
		if npc.Position:Distance(player.Position) < 500 then			
			if math.random(60*3) == 1 then
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
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, pyramidHead.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, pyramidHead.cacheUpdate)