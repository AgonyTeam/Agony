
local BowlCut =  {
}

function BowlCut:onUpdate()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_BOWL_CUT) and not Game():GetLevel():GetCurrentRoom():IsClear() and math.random(969) == 1 then
		player:AddSoulHearts(1)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, BowlCut.onUpdate)