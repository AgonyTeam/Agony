CollectibleType["AGONY_C_BOWL_CUT"] = Isaac.GetItemIdByName("Bowl Cut");

local BowlCut =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
BowlCut.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_bowlcut.anm2")

function BowlCut:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		BowlCut.hasItem = false
	end
	if BowlCut.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_BOWL_CUT) then
		--player:AddNullCostume(BowlCut.costumeID)
		BowlCut.hasItem = true
	end
end

function BowlCut:onUpdate()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_BOWL_CUT) and not Game():GetLevel():GetCurrentRoom():IsClear() and math.random(969) == 1 then
		player:AddSoulHearts(1)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BowlCut.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, BowlCut.onUpdate)