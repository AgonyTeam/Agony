CollectibleType["AGONY_C_THE_WAY"] = Isaac.GetItemIdByName("The Way");

local theWay =  {
	--Malus multipliers
	damageMalus = nil,
	speedMalus = nil,
	tearMalus = nil,
	luckMalus = nil,
	TearBool = false
}

--Load the maluses or init them otherwise
function theWay:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		theWay.TearBool = false
		theWay.damageMalus = saveData.theWay.damageMalus or 1
		theWay.tearMalus = saveData.theWay.tearMalus or 1
		theWay.speedMalus = saveData.theWay.speedMalus or 1
		theWay.luckMalus = saveData.theWay.luckMalus or 0
		
		saveData.theWay.damageMalus = theWay.damageMalus
		saveData.theWay.tearMalus = theWay.tearMalus
		saveData.theWay.speedMalus = theWay.speedMalus
		saveData.theWay.luckMalus = theWay.luckMalus
		Agony:SaveNow()

		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
end

--Pick a random stat to lower and gives an item to the player
function theWay:onUse()
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_THE_WAY)
	
	local r = rng:RandomInt(4)
	
	if r == 3 then
		theWay.tearMalus = theWay.tearMalus*1.3
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	elseif r == 1 then
		theWay.luckMalus = theWay.luckMalus + 2.69
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
	elseif r == 2 then
		theWay.speedMalus = theWay.speedMalus*0.8
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	else
		theWay.damageMalus = theWay.damageMalus*0.8
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	end

	--player:AddCollectible(rng:RandomInt(CollectibleType.NUM_COLLECTIBLES)+1, 0, true)
	Isaac.Spawn(5, 100, rng:RandomInt(CollectibleType.NUM_COLLECTIBLES)+1 , Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
	player:EvaluateItems()
	

	--Agony:displayGiantBook("Appear","theWay.png")

	return true
end

function theWay:cacheUpdate(player,cacheFlag)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage*theWay.damageMalus
	end
	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed*theWay.speedMalus
	end
	if cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck-theWay.luckMalus
	end
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		theWay.TearBool = true
	end
end

--FireDelay workaround
function theWay:updateFireDelay(player)
	if (theWay.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay * theWay.tearMalus
		theWay.TearBool = false
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, theWay.onPlayerInit)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, theWay.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, theWay.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, theWay.onUse, CollectibleType.AGONY_C_THE_WAY)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, theWay.onPlayerUpdate)