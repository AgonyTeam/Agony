CollectibleType["AGONY_C_DESPAIR"] = Isaac.GetItemIdByName("Despair");

local despair =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	TearBool = false,
	stage = saveData.despair.stage or nil
}
despair.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_despair.anm2")

function despair:cacheUpdate (player,cacheFlag)
	--Lowers stats on the floor of pickup but increases them upon reaching a new stage
	if (player:HasCollectible(CollectibleType.AGONY_C_DESPAIR)) then
		local collNum = player:GetCollectibleNum(CollectibleType.AGONY_C_DESPAIR)
		if despair.stage == nil then 
			despair.stage = Game():GetLevel():GetStage()
			saveData.despair.stage = despair.stage
			Agony:SaveNow()
		end
		if (cacheFlag == CacheFlag.CACHE_LUCK) then
			player.Luck = player.Luck - 2*collNum
			if despair.stage ~= nil then
				player.Luck = player.Luck + (Game():GetLevel():GetStage() - despair.stage)*collNum
			end
		end
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage - 2*collNum
			if despair.stage ~= nil then
				player.Damage = player.Damage + (Game():GetLevel():GetStage() - despair.stage)*3*collNum
			end
		end
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = player.MoveSpeed - 0.5
			if despair.stage ~= nil then
				player.MoveSpeed = player.MoveSpeed + (Game():GetLevel():GetStage() - despair.stage)*0.2*collNum
			end
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			despair.TearBool = true
		end
	else
		despair:reset()
	end
end

function despair:reset()
	--Resets variable if the item is rerolled or lost (or if restarting the run)
	despair.stage = nil
	saveData.despair.stage = nil
	Agony:SaveNow()
end

function despair:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		despair.hasItem = false
	end
	if despair.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_DESPAIR) then
		--player:AddNullCostume(despair.costumeID)
		despair.hasItem = true
	end

	if despair.stage ~= nil and despair.stage ~= Game():GetLevel():GetStage() then
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

--FireDelay workaround
function despair:updateFireDelay(player)
	if (despair.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay + 5*player:GetCollectibleNum(CollectibleType.AGONY_C_DESPAIR)
		if despair.stage ~= nil then
			player.MaxFireDelay = player.MaxFireDelay - (Game():GetLevel():GetStage() - despair.stage)*3*player:GetCollectibleNum(CollectibleType.AGONY_C_DESPAIR)
		end
		despair.TearBool = false;
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, despair.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, despair.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, despair.cacheUpdate)