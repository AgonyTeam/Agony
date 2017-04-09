--local item_Cornucopia = Isaac.GetItemIdByName("Cornucopia")
local cornucopia =  {
	timesUsed = 0
}

function cornucopia:onUse()
	--Spawn a random item on use
	local player = Isaac.GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_CORNUCOPIA)
	local pos = Isaac.GetFreeNearPosition(player.Position, 25)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NULL, pos, Vector(0, 0), player)
	--POOF!
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	Game():SpawnParticles(pos, EffectVariant.POOF01, 1, 1, col, 0)
	cornucopia.timesUsed = cornucopia.timesUsed + 1
	--has an increasing chance to break
	if (rng:RandomInt(30)+cornucopia.timesUsed) > 29 then
		player:RemoveCollectible(CollectibleType.AGONY_C_CORNUCOPIA)
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, cornucopia.onUse, CollectibleType.AGONY_C_CORNUCOPIA)