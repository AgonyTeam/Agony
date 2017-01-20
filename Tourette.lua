local item_Tourette = Isaac.GetItemIdByName("Tourette")
local tourette =  {
	TearBool = false
}

function tourette:randomTear()

	local player = Isaac.GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	local distance = nil
	local luckMult = math.floor(player.Luck)
	local shootJoy = player:GetShootingJoystick()
	if shootJoy.X ~= 0 or shootJoy.Y ~= 0 then
		if (player:HasCollectible(item_Tourette)) then
			local Prob = 0
			if luckMult > 0 then
				Prob = Game():GetFrameCount()%(math.ceil(45/(luckMult+1)))
			elseif luckMult == 0 then
				Prob = Game():GetFrameCount()%45
			else
				Prob = Game():GetFrameCount()%(-45*(luckMult-1))
			end	
			if Prob == 0 then
				player:FireTear(player.Position, Vector (20*player.ShotSpeed * (.5+(math.random()/2)*(-1*math.random(2))) , 20*player.ShotSpeed * (.5+(math.random()/2)*(-1*math.random(2)))) , true, true, false)
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, tourette.randomTear)