local theFireplace =  {}

function theFireplace:onUse()
	local room = Game():GetRoom()
	local fire = nil
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_THE_FIREPLACE)
	
	fire = GridEntityType.GRID_FIREPLACE
	room:SpawnGridEntity(room:GetGridIndex(Isaac.GetFreeNearPosition(Game():GetPlayer(0).Position, 75)), fire, 0, RNG():GetSeed(), 1)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, theFireplace.onUse, CollectibleType.AGONY_C_THE_FIREPLACE)