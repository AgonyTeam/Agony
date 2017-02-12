CollectibleType["AGONY_C_D5"] = Isaac.GetItemIdByName("D5");
local dfive = {}

function dfive:onUse(player)
	--Rerolls the player's hp
	local heartCount = 0
	local player = Game():GetPlayer(0)
	heartcount = player:GetMaxHearts() + player:GetSoulHearts() + player:GetBlackHearts() + player:GetGoldenHearts()
	player:AddSoulHearts(-player:GetSoulHearts())
	player:AddBlackHearts(-player:GetBlackHearts())
	player:AddMaxHearts(-player:GetMaxHearts(), true)
	player:AddGoldenHearts(-player:GetGoldenHearts())
	player.HitPoints = 0
	player.MaxHitPoints = 0
	for i = 1, heartcount, 1 do
		local r = math.random(100)
		if r > 50 then
			player:AddMaxHearts(1, false)
		elseif r > 30 then
			player:AddSoulHearts(1)
		elseif r > 20 then
			player:AddBlackHearts(1)
		elseif r > 10 then
			player:AddEternalHearts(1)
		elseif r > 5 then
			player:AddGoldenHearts(1)
		end
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, dfive.onUse, CollectibleType.AGONY_C_D5)