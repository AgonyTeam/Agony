

local pandorasChest = {
	
}

function pandorasChest:onUse(collectibleType, RNG)
	local player = Isaac.GetPlayer(0)
	if collectibleType == CollectibleType.AGONY_C_PANDORASCHEST0 then
		for i = 1, 5, 1 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NULL, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0, 0), player)
		end
		player:RemoveCollectible(collectibleType)
	else
		player:AddCollectible(collectibleType + 1, 0, false)
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pandorasChest.onUse , CollectibleType.AGONY_C_PANDORASCHEST5)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pandorasChest.onUse , CollectibleType.AGONY_C_PANDORASCHEST4)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pandorasChest.onUse , CollectibleType.AGONY_C_PANDORASCHEST3)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pandorasChest.onUse , CollectibleType.AGONY_C_PANDORASCHEST2)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pandorasChest.onUse , CollectibleType.AGONY_C_PANDORASCHEST1)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, pandorasChest.onUse , CollectibleType.AGONY_C_PANDORASCHEST0)
