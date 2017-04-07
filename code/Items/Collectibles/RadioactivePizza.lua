--local item_RadioActivePizza = Isaac.GetItemIdByName("Radioactive Pizza")
local radioactivePizza =  {}

--Gives a bonus to one stat, a malus to another one
function radioactivePizza:cacheUpdate(player,cacheFlag)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_RADIOACTIVE_PIZZA)
	
	if player:HasCollectible(CollectibleType.AGONY_C_RADIOACTIVE_PIZZA) then
		local r1 = saveData.radioactivePizza.r1 or (rng:RandomInt(3) + 1)
		local r2 = saveData.radioactivePizza.r2 or (rng:RandomInt(3) + 1)
		--Make sure the stat isnt the same
		while r1 == r2 do
			r2 = ((r1 +1)%3) +1
		end
		--Save the numbers
		saveData.radioactivePizza.r1 = r1
		saveData.radioactivePizza.r2 = r2
		Agony:SaveNow()
		--Upgrades a stat
		if r1 == 1 and cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 5
		elseif r1 == 2 and cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay -7
		elseif r1 == 3 and cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 1.5
		end
		--Downgrade another one
		if r2 == 1 and cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 2.5
		elseif r2 == 2 and cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay +7
		elseif r2 == 3 and cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.7
		end 
	end
end

function radioactivePizza:reset(player)
	if Game():GetFrameCount() <= 1 then
		saveData.radioactivePizza.r1 = nil
		saveData.radioactivePizza.r2 = nil
		Agony:SaveNow();
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, radioactivePizza.cacheUpdate)
--Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, radioactivePizza.reset)