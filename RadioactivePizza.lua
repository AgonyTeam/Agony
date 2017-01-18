local item_RadioActivePizza = Isaac.GetItemIdByName("Radioactive Pizza")
local radioactivePizza =  {}

--Gives a bonus to one stat, a malus to another one
function radioactivePizza:cacheUpdate(player,cacheFlag)
	--This is completely broken and I don't know why
	--Sometimes three stats will be dowgraded, sometime only one will be upgraded
	--What the hell is happening

	if player:HasCollectible(item_RadioActivePizza) then
		local r1 = (Game():GetRoom():GetDecorationSeed() % 4) +1
		local r2 = (Game():GetRoom():GetSpawnSeed() % 4) +1
		--Make sure the stat isnt the same
		while r1 == r2 do
			r2 = ((r1 +1)%4) +1
		end
		--Upgrades a stat
		if r1 == 1 and cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 3
		elseif r1 == 2 and cacheFlag == CacheFlag.CACHE_FIREDELAY then
			--Broken for now
			--player.FireDelay = player.FireDelay - 4
			player.MaxFireDelay = player.MaxFireDelay *0.5
		elseif r1 == 3 and cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + 2
		elseif r1 == 4 and cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 1
		--Downgrade another one
		if r2 == 1 and cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 2.5
		elseif r2 == 2 and cacheFlag == CacheFlag.CACHE_FIREDELAY then
			--Broken for now
			--player.FireDelay = player.FireDelay + 3
			player.MaxFireDelay = player.MaxFireDelay * 2
		elseif r2 == 3 and cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed - 2
		elseif r2 == 4 and cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.7
		end 
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, radioactivePizza.cacheUpdate)
