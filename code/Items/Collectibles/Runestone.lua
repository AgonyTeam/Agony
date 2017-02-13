--local item_Runestone = Isaac.GetItemIdByName("Runestone")
CollectibleType["AGONY_C_RUNESTONE"] = Isaac.GetItemIdByName("Runestone");
local runestone =  {}

function runestone:onUse()
	local player = Game():GetPlayer(0)
	local room = Game():GetRoom()
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_RUNESTONE)
	local rand = rng:RandomInt(10)
	local vTrans = Vector (25,0)
	vTrans = vTrans:Rotated(math.random(360))

	Isaac.Spawn(5, 300, 32+rand, player.Position:__add(vTrans), Vector (0,0), player)
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, runestone.onUse, CollectibleType.AGONY_C_RUNESTONE)