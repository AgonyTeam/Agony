--local item_RadioActivePizza = Isaac.GetItemIdByName("Radioactive Pizza")
CollectibleType["AGONY_C_RADIOACTIVE_PIZZA"] = Isaac.GetItemIdByName("Radioactive Pizza");
local radioactivePizza =  {
	TearBool = false,
	bonus = 0,
	hasItem = nil, --used for costume
	costumeID = nil
}
radioactivePizza.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_radioactivepizza.anm2")

--Gives a bonus to one stat, a malus to another one
function radioactivePizza:cacheUpdate(player,cacheFlag)

	if player:HasCollectible(CollectibleType.AGONY_C_RADIOACTIVE_PIZZA) then
		local r1 = saveData.radioactivePizza.r1 or (Game():GetRoom():GetDecorationSeed() % 3) +1
		local r2 = saveData.radioactivePizza.r1 or (Game():GetRoom():GetSpawnSeed() % 3) +1
		--Make sure the stat isnt the same
		while r1 == r2 do
			r2 = ((r1 +1)%3) +1
		end
		
		saveData.radioactivePizza.r1 = r1
		saveData.radioactivePizza.r2 = r2
		Agony:SaveNow()
		--Upgrades a stat
		if r1 == 1 and cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 5
		elseif r1 == 2 and cacheFlag == CacheFlag.CACHE_FIREDELAY then
			--Broken for now
			--player.FireDelay = player.FireDelay - 4
			radioactivePizza.TearBool = true
			radioactivePizza.bonus = 7
			--saveData.radioactivePizza.bonus = 7
			--SaveNow();
		elseif r1 == 3 and cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 1.5
		end
		--Downgrade another one
		if r2 == 1 and cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 2.5
		elseif r2 == 2 and cacheFlag == CacheFlag.CACHE_FIREDELAY then
			--Broken for now
			--player.FireDelay = player.FireDelay + 3
			radioactivePizza.TearBool = true
			radioactivePizza.bonus = -7
			--saveData.radioactivePizza.bonus = -7
			--SaveNow();
		elseif r2 == 3 and cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.7
		end 
	end
end


--FireDelay workaround
function radioactivePizza:updateFireDelay(player)
	if (radioactivePizza.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay - radioactivePizza.bonus;
		radioactivePizza.TearBool = false;
	end
end

function radioactivePizza:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		radioactivePizza.hasItem = false
	end
	if radioactivePizza.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_RADIOACTIVE_PIZZA) then
		player:AddNullCostume(radioactivePizza.costumeID)
		radioactivePizza.hasItem = true
	end
end

function radioactivePizza:reset(player)
	if Game():GetFrameCount() <= 1 then
		saveData.radioactivePizza.r1 = nil
		saveData.radioactivePizza.r2 = nil
		Agony:SaveNow();
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, radioactivePizza.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, radioactivePizza.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, radioactivePizza.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, radioactivePizza.reset)