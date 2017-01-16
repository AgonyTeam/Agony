local item_LuckyLeg = Isaac.GetItemIdByName("Lucky Leg");
local luckyLeg =  {};

--Grants +1 Luck and gives a *2 multiplier to Luck
function luckyLeg:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(item_LuckyLeg)) and (cacheFlag == CacheFlag.CACHE_LUCK) then
		player.Luck = (player.Luck + 1)*2;
	end
end



Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, luckyLeg.cacheUpdate);