--local item_LuckyLeg = Isaac.GetItemIdByName("Lucky Leg");
CollectibleType["AGONY_C_LUCKY_LEG"] = Isaac.GetItemIdByName("Lucky Leg");

local luckyLeg =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
luckyLeg.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_luckyleg.anm2")

--Grants +1 Luck and gives a *2 multiplier to Luck
function luckyLeg:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_LUCKY_LEG)) and (cacheFlag == CacheFlag.CACHE_LUCK) then
		player.Luck = (player.Luck + 1)*2;
	end
end

function luckyLeg:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		luckyLeg.hasItem = false
	end
	if luckyLeg.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_LUCKY_LEG) then
		player:AddNullCostume(luckyLeg.costumeID)
		luckyLeg.hasItem = true
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, luckyLeg.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, luckyLeg.cacheUpdate)