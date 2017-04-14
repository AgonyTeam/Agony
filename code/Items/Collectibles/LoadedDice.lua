--local item_LoadedDice = Isaac.GetItemIdByName("Loaded Dice")
local loadedDice =  {
	beans = Agony.ENUMS["ItemPools"]["Beans"]
}

function loadedDice:onUse()
	local ent = Isaac.GetRoomEntities()
	for i = 1, #ent, 1 do
		if ent[i].Type == 5 and ent[i].Variant == 100 then
			local rng = Game():GetPlayer(0):GetCollectibleRNG(CollectibleType.AGONY_C_LOADED_DICE)
			ent[i]:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, loadedDice.beans[rng:RandomInt(#loadedDice.beans)+1],true)
			--POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(ent[i].Position, EffectVariant.POOF01, 1, 1, col, 0)
		end
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, loadedDice.onUse, CollectibleType.AGONY_C_LOADED_DICE)