local item_MagicKit = Isaac.GetItemIdByName("Magic Kit")
local magicKit = {
	rseed = 1
}

function magicKit:spawnRune(player)
	local room = Game():GetRoom()
	local rand = (room:GetDecorationSeed()*magicKit.rseed)%9
	magicKit.rseed = (RNG():GetSeed()*magicKit.rseed)%100
	local vTrans = Vector (25,0)
	vTrans = vTrans:Rotated(math.random(360))

	Isaac.Spawn(5, 300, 32+rand, player.Position:__add(vTrans), Vector (0,0), player)
end

function magicKit:OpenKit()
	local player = Game():GetPlayer(0)
	if (player:HasCollectible(item_MagicKit)) then
		for i = 1, player.Luck + 3, 1 do
			magicKit:spawnRune(player)
		end
		player:RemoveCollectible(item_MagicKit)		
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, magicKit.OpenKit, item_MagicKit)