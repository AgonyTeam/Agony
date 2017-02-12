--local item_Runestone = Isaac.GetItemIdByName("Runestone")
CollectibleType["AGONY_C_RUNESTONE"] = Isaac.GetItemIdByName("Runestone");
local runestone =  {
	rseed = 1
}

function runestone:onUse()
	local player = Game():GetPlayer(0)
	local room = Game():GetRoom()
	local rand = (room:GetDecorationSeed()*runestone.rseed)%10
	local vTrans = Vector (25,0)
	vTrans = vTrans:Rotated(math.random(360))

	Isaac.Spawn(5, 300, 32+rand, player.Position:__add(vTrans), Vector (0,0), player)
	runestone.rseed = (RNG():GetSeed()*runestone.rseed)%100
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, runestone.onUse, CollectibleType.AGONY_C_RUNESTONE)