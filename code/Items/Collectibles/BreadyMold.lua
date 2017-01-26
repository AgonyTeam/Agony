local breadyMold = {}
local itemIds = {
    breadymold = Isaac.GetItemIdByName("Bready Mold")
}

local breadymoldSpawned = false

function breadyMold:PickedUp()
	local player = Isaac.GetPlayer(0);
	local game = Game()
	if player:HasCollectible(itemIds.breadymold) then
		if breadymoldSpawned == false then
		local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true)
		local StatRandom = math.random(7)
			if StatRandom == 1 then 
			Isaac.Spawn(5, 100, 11, pos, Vector(0,0), nil)
			end
			if StatRandom == 2 then 
			Isaac.Spawn(5, 100, 342, pos, Vector(0,0), nil)
			end
			if StatRandom == 3 then 
			Isaac.Spawn(5, 100, 12, pos, Vector(0,0), nil)
			end
			if StatRandom == 4 then 
			Isaac.Spawn(5, 100, 71, pos, Vector(0,0), nil)
			end
			if StatRandom == 5 then 
			Isaac.Spawn(5, 100, 121, pos, Vector(0,0), nil)
			end
			if StatRandom == 6 then 
			Isaac.Spawn(5, 100, 120, pos, Vector(0,0), nil)
			end
			if StatRandom == 7 then 
			Isaac.Spawn(5, 350, 32, pos, Vector(0,0), nil)
			end
		--Game():GetPlayer(0):AddNullCostume(bmoldcostume)
		breadymoldSpawned = true
		end
	end
end

function breadyMold:checkForNewRun()
	breadymoldSpawned = false
end

breadyMold:AddCallback(ModCallbacks.MC_POST_UPDATE, breadyMold.PickedUp)
breadyMold:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, breadyMold.checkForNewRun)