--local item_MagicKit = Isaac.GetItemIdByName("Magic Kit")
CollectibleType["AGONY_C_MAGIC_KIT"] = Isaac.GetItemIdByName("Magic Kit");
local magicKit = {}

function magicKit:spawnRune(player)
	local room = Game():GetRoom()
	local rand = player:GetCollectibleRNG(CollectibleType.AGONY_C_MAGIC_KIT):RandomInt(10)
	local vTrans = Vector (25,0)
	vTrans = vTrans:Rotated(math.random(360))

	Isaac.Spawn(5, 300, 32+rand, player.Position:__add(vTrans), Vector (0,0), player)
end

function magicKit:onUse()
	local player = Game():GetPlayer(0)
	if (player:HasCollectible(CollectibleType.AGONY_C_MAGIC_KIT)) then
		for i = 1, player.Luck + 3, 1 do
			magicKit:spawnRune(player)
		end
		player:RemoveCollectible(CollectibleType.AGONY_C_MAGIC_KIT)		
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, magicKit.onUse, CollectibleType.AGONY_C_MAGIC_KIT)