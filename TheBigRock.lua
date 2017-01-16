local item_TheBigRock = Isaac.GetItemIdByName("The Big Rock")
local theBigRock =  {}

--Grants + 2.69 DMG and -0.4 SPD
function theBigRock:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(item_TheBigRock)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + 3.69;
		end
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed - 0.5;
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, theBigRock.cacheUpdate);
