CollectibleType["AGONY_C_CASHEW_MILK"] = Isaac.GetItemIdByName("Cashew Milk");
local CashewMilk =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	TearBool = false
}
CashewMilk.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_knowledgeequalspower.anm2")

function CashewMilk:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_CASHEW_MILK)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + math.sin(Game():GetFrameCount()/60)*player.Damage*2
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			CashewMilk.TearBool = true
		end
	end
end

function CashewMilk:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		CashewMilk.hasItem = false
	end

	if player:HasCollectible(CollectibleType.AGONY_C_CASHEW_MILK) then
		--Force the game to evaluate the cache every 3 frames
		--Will improve the code as we get more callbacks nicolo pls
		if Game():GetFrameCount()%3 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			if Game():GetFrameCount()%60 == 0 then
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			end
			player:EvaluateItems()
		end
		if CashewMilk.hasItem == false then
			--player:AddNullCostume(CashewMilk.costumeID)
			CashewMilk.hasItem = true
		end
	end
end

--FireDelay workaround
function CashewMilk:updateFireDelay(player)

	if (CashewMilk.TearBool == true) then
		local maxFD = math.floor(player.MaxFireDelay + math.sin(Game():GetFrameCount()/60)*player.MaxFireDelay)
		player.MaxFireDelay = maxFD
		CashewMilk.TearBool = false;
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CashewMilk.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CashewMilk.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CashewMilk.cacheUpdate)