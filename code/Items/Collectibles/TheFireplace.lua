local theFireplace =  {}

function theFireplace:onUse()
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_THE_FIREPLACE)
	local v = nil
	local chance = rng:RandomFloat()
	if chance < 0.375 then
		v = 0 
	elseif chance < 0.75 then
		v = 1 --normal and red fire 37.5% chance each
	elseif chance < 0.875 then
		v = 2
	else 
		v = 3 --blue and purple only 12.5% each
	end
	
	Isaac.Spawn(EntityType.ENTITY_FIREPLACE, v, 0, Isaac.GetFreeNearPosition(player.Position, 75), Vector(0,0), player)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, theFireplace.onUse, CollectibleType.AGONY_C_THE_FIREPLACE)