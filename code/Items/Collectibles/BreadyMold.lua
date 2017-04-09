local breadyMold = {
	seed = nil,
	shroomItems = Agony.ENUMS["ItemPools"]["Mushrooms"]
}

--All different shroom items, just add a new line to add another one
--[[
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_ODD_MUSHROOM_RATE)
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_ODD_MUSHROOM_DAMAGE)
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_ONE_UP)
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_BLUE_CAP)
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_GODS_FLESH)
table.insert(breadyMold.shroomItems,CollectibleType.COLLECTIBLE_MINI_MUSH)
]]--
function breadyMold:onUpdate()
	-- If the player has the item, removes it and spawn 2 random shroom items, the items can be the same
	local player = Isaac.GetPlayer(0);
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_BREADY_MOLD)
	local game = Game()
	if player:HasCollectible(CollectibleType.AGONY_C_BREADY_MOLD) then
		
		for i = 1, 2, 1 do
			local pos = Isaac.GetFreeNearPosition(player.Position, 50)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, breadyMold.shroomItems[rng:RandomInt(#breadyMold.shroomItems)+1], pos, Vector(0,0), nil)
			--POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(pos, EffectVariant.POOF01, 1, 1, col, 0)
		end
		player:RemoveCollectible(CollectibleType.AGONY_C_BREADY_MOLD)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, breadyMold.onUpdate)
