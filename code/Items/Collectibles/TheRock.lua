--local item_TheRock = Isaac.GetItemIdByName("The Rock")
local theRock =  {}

function theRock:spawnRock()
	local room = Game():GetRoom()
	local rock = nil
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_THE_ROCK)
	
	--3% chance to spawn a tinted, rock bomb or metal block
	if rng:RandomInt(100) % 33 == 0 then
		rock = GridEntityType.GRID_ROCKT
	elseif rng:RandomInt(100) % 33 == 1 then
		rock = GridEntityType.GRID_ROCKB
	elseif rng:RandomInt(100) % 33 == 2 then
		rock = GridEntityType.GRID_ROCK_BOMB
	else
		rock = GridEntityType.GRID_ROCK
	end
	--theRock.rseed = (RNG():GetSeed()*theRock.rseed)%100
	local pos = Isaac.GetFreeNearPosition(Game():GetPlayer(0).Position, 25)
	room:SpawnGridEntity(room:GetGridIndex(pos), rock, 0, RNG():GetSeed(), 1)
	--POOF!
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	Game():SpawnParticles(pos, EffectVariant.POOF01, 1, 1, col, 0)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, theRock.spawnRock, CollectibleType.AGONY_C_THE_ROCK)