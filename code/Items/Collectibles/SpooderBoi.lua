CollectibleType["AGONY_C_SPOODER_BOI"] = Isaac.GetItemIdByName("Spooderboi");

local spooderBoi =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
spooderBoi.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_spooderboi.anm2")


function spooderBoi:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		spooderBoi.hasItem = false
	end
	if spooderBoi.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI) then
		player:AddNullCostume(spooderBoi.costumeID)
		spooderBoi.hasItem = true
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI) then
		if math.random(300) == 1 then
			local sack = Isaac.Spawn(EntityType.ENTITY_BOIL, 2, 0, player.Position, Vector (0,0), player)
			sack:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM);
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, spooderBoi.onPlayerUpdate)
--Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, spooderBoi.cacheUpdate)