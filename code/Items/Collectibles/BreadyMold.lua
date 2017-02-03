--Credit to otherhand for the code
local breadyMold = {
	seed = nil
}
--local itemIds = {
--   breadymold = Isaac.GetItemIdByName("Bready Mold")
--}
CollectibleType["AGONY_C_BREADY_MOLD"] = Isaac.GetItemIdByName("Bready Mold");

local breadymoldSpawned = false

function breadyMold:PickedUp()
	local player = Isaac.GetPlayer(0);
	local game = Game()
	if player:HasCollectible(CollectibleType.AGONY_C_BREADY_MOLD) then
		if breadymoldSpawned == false then
		
		local StatRandom = math.random(7)
		local r2 = nil 
		repeat
			r2 = math.random(7)
		until r2 ~= StatRandom
			 
			if StatRandom == 1 or r2 == 1 then 
			Isaac.Spawn(5, 100, 11, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
			if StatRandom == 2 or r2 == 2 then 
			Isaac.Spawn(5, 100, 342, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
			if StatRandom == 3 or r2 == 3 then 
			Isaac.Spawn(5, 100, 12, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
			if StatRandom == 4 or r2 == 4 then 
			Isaac.Spawn(5, 100, 71, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
			if StatRandom == 5 or r2 == 5 then 
			Isaac.Spawn(5, 100, 121, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
			if StatRandom == 6 or r2 == 6 then 
			Isaac.Spawn(5, 100, 120, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
			if StatRandom == 7 or r2 == 7 then 
			Isaac.Spawn(5, 350, 32, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), nil)
			end
		--Game():GetPlayer(0):AddNullCostume(bmoldcostume)
		breadymoldSpawned = true
		end
	end
end

function breadyMold:checkForNewRun()
	if breadyMold.seed == nil and breadyMold.seed ~= RNG():GetSeed() then
		breadymoldSpawned = false
		seed = RNG():GetSeed()
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, breadyMold.PickedUp)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, breadyMold.checkForNewRun)