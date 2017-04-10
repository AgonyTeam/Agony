
local rootOfAnger = {
	mult = 1,
	isRooted = false
}

function rootOfAnger:onPlayerUpdate(player)
	if player:HasCollectible(CollectibleType.AGONY_C_THE_ROOT_OF_ANGER) then
		if rootOfAnger.isRooted and rootOfAnger.mult < 2 then
			rootOfAnger.mult = rootOfAnger.mult + 0.03
		end
		if Game():GetFrameCount()%3 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			if Game():GetFrameCount()%9 == 0 then
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			end
			player:EvaluateItems()
		end
	end
end

function rootOfAnger:onUse()
	local player = Isaac.GetPlayer(0);
	rootOfAnger.isRooted = not rootOfAnger.isRooted
	rootOfAnger.mult = 1
	return true
end

function rootOfAnger:cacheUpdate (player,cacheFlag)
	if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
		player.MaxFireDelay = math.floor(player.MaxFireDelay/rootOfAnger.mult)
	end
	if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage*rootOfAnger.mult
	end
end

function rootOfAnger:onInput(entity,hook,action)
	if entity ~= nil then
		local player = entity:ToPlayer()

		if player and player:HasCollectible(CollectibleType.AGONY_C_THE_ROOT_OF_ANGER) and rootOfAnger.isRooted then
			if action == ButtonAction.ACTION_UP
			or action == ButtonAction.ACTION_DOWN
			or action == ButtonAction.ACTION_LEFT
			or action == ButtonAction.ACTION_RIGHT
			then
				if hook == InputHook.GET_ACTION_VALUE then
					return 0
				else
					return false
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_INPUT_ACTION, rootOfAnger.onInput)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, rootOfAnger.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rootOfAnger.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, rootOfAnger.onUse, CollectibleType.AGONY_C_THE_ROOT_OF_ANGER)