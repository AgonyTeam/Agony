CollectibleType["AGONY_C_GOLD_MAN"] = Isaac.GetItemIdByName("Gold Man");

local goldMan = {
hasBeenUsed = false,
hasItem = false,
costumeID = nil
}
goldMan.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_goldman.anm2")

function goldMan:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		goldMan.hasBeenUsed = false
	end
	if player:HasCollectible(CollectibleType.AGONY_C_GOLD_MAN) and goldMan.hasBeenUsed == false then
			player:AddGoldenHearts(24)
			goldMan = true
	end

	if Game():GetFrameCount() == 1 then
		goldMan.hasItem = false
	end
	if goldMan.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_GOLD_MAN) then
		--player:AddNullCostume(goldMan.costumeID)
		goldMan.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, goldMan.onPlayerUpdate)