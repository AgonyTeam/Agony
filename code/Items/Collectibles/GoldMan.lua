local goldMan = {
hasBeenUsed = false,
}


function goldMan:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		goldMan.hasBeenUsed = false
	end
	if player:HasCollectible(CollectibleType.AGONY_C_GOLD_MAN) and goldMan.hasBeenUsed == false then
			player:AddGoldenHearts(24)
			goldMan.hasBeenUsed = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, goldMan.onPlayerUpdate)