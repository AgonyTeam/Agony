
pyritenugget = {}

function pyritenugget:onUse()
	local player = Isaac.GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_PYRITE_NUGGET)
	
	for i=1, rng:RandomInt(5)+1 do
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.AGONY_PICKUP_COIN, CoinSubType.AGONY_COIN_PYRITE, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0,0), player)
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pyritenugget.onUse, CollectibleType.AGONY_C_PYRITE_NUGGET)