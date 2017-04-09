local tumor =  {}

function tumor:onUse()
	--Spawn a tumor collectible which does nothing
	local player = Isaac.GetPlayer(0)
	local pos = Isaac.GetFreeNearPosition(player.Position, 25)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.AGONY_C_TUMOR, pos, Vector(0, 0), player)
	--POOF!
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	Game():SpawnParticles(pos, EffectVariant.POOF01, 1, 1, col, 0)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, tumor.onUse, CollectibleType.AGONY_C_BROTHER_CANCER)