--local item_Triplopia = Isaac.GetItemIdByName("Triplopia")
CollectibleType["AGONY_C_TRIPLOPIA"] = Isaac.GetItemIdByName("Triplopia");
local triplopia =  {}

function triplopia:tripleAllCollectibles()
	local entList = Isaac.GetRoomEntities()
	local player = Isaac.GetPlayer(0)
	for i = 1, #entList, 1 do
		if entList[i].Type == 5 and entList[i].Variant == 100 then
			Isaac.Spawn(entList[i].Type, entList[i].Variant, entList[i].SubType, Isaac.GetFreeNearPosition(entList[i].Position, 25), Vector(0, 0), player)
			Isaac.Spawn(entList[i].Type, entList[i].Variant, entList[i].SubType, Isaac.GetFreeNearPosition(entList[i].Position, 25), Vector(0, 0), player)
		end
	end
	player:RemoveCollectible(CollectibleType.AGONY_C_TRIPLOPIA)
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, triplopia.tripleAllCollectibles, CollectibleType.AGONY_C_TRIPLOPIA)