--local item_TheRock = Isaac.GetItemIdByName("The Rock")
CollectibleType["AGONY_C_THE_ROCK"] = Isaac.GetItemIdByName("The Rock");
local theRock =  {
	rseed = 1
}

function theRock:spawnRock()
	local room = Game():GetRoom()
	local rock = nil
	local player = Game():GetPlayer(0)
	--3% chance to spawn a tinted, rock bomb or metal block
	if (room:GetDecorationSeed()*theRock.rseed)%33 == 1 then
		rock = GridEntityType.GRID_ROCKT
	elseif (room:GetDecorationSeed()*theRock.rseed)%33 == 2 then
		rock = GridEntityType.GRID_ROCKB
	elseif (room:GetDecorationSeed()*theRock.rseed)%33 == 3 then
		rock = GridEntityType.GRID_ROCK_BOMB
	else
		rock = GridEntityType.GRID_ROCK
	end
	theRock.rseed = (RNG():GetSeed()*theRock.rseed)%100
	room:SpawnGridEntity(room:GetGridIndex(Isaac.GetFreeNearPosition(Game():GetPlayer(0).Position, 25)), rock, 0, RNG():GetSeed(), 1)
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, theRock.spawnRock, CollectibleType.AGONY_C_THE_ROCK)