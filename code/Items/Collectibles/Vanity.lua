local vanity =  {}

function vanity:onUse()
	local player = Game():GetPlayer(0)
	player:AddMaxHearts(2, false)
	player:AddGoldenHearts(1)
	player:AddSoulHearts(2)
	player:AddBlackHearts(2)
	player:AddHearts(2)
	player:AddEternalHearts(1)
	player:RemoveCollectible(CollectibleType.AGONY_C_VANITY)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, vanity.onUse, CollectibleType.AGONY_C_VANITY)