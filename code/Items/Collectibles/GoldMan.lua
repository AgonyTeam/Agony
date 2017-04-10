local goldMan = {
hasBeenUsed = saveData.goldMan.hasBeenUsed or false
}


function goldMan:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		goldMan.hasBeenUsed = false
		saveData.goldMan.hasBeenUsed = false
		Agony:SaveNow()
	end
	if player:HasCollectible(CollectibleType.AGONY_C_GOLD_MAN) and goldMan.hasBeenUsed == false then
			player:AddGoldenHearts(24)
			goldMan.hasBeenUsed = true
			saveData.goldMan.hasBeenUsed = true
			Agony:SaveNow()
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, goldMan.onPlayerUpdate)