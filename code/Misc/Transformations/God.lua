local god =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
god.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_god.anm2")

function god:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		god.hasItem = false
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOUL) and player:HasCollectible(CollectibleType.COLLECTIBLE_BODY) and player:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then
		if god.hasItem == false then
			--player:AddNullCostume(god.costumeID)
			god.hasItem = true
		end

		if math.random(690) == 69 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_CRACK_THE_SKY, false,true, true, false)
		end
	end
end


Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, god.onPlayerUpdate)