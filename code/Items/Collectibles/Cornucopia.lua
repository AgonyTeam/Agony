--local item_Cornucopia = Isaac.GetItemIdByName("Cornucopia")
CollectibleType["AGONY_C_CORNUCOPIA"] = Isaac.GetItemIdByName("Cornucopia");
local cornucopia =  {
	timesUsed = 0
}

function cornucopia:onUse()
	--Spawn a random item on use
	local player = Isaac.GetPlayer(0)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NULL, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0, 0), player)
	cornucopia.timesUsed = cornucopia.timesUsed + 1
	--has an increasing chance to break
	if (math.random(30)+cornucopia.timesUsed) > 29 then
		player:RemoveCollectible(CollectibleType.AGONY_C_CORNUCOPIA)
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, cornucopia.onUse, CollectibleType.AGONY_C_CORNUCOPIA)