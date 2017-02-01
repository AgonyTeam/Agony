--local item_D3 = Isaac.GetItemIdByName("D3")
CollectibleType["AGONY_C_D3"] = Isaac.GetItemIdByName("D3");
local dthree =  {}

function dthree:rerollColl()
	local player = Game():GetPlayer(0)
	if player:GetCollectibleCount() >= 1 then --If the player has collectibles
	    local colletibles = {}
        for name, id in pairs(CollectibleType) do --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
            if (name ~= "NUM_COLLECTIBLES" and player:HasCollectible(id)) then --If they have it add it to the table
                table.insert(colletibles, id)
            end
        end
        player:RemoveCollectible(colletibles[math.random(#colletibles)])
        player:AddCollectible(math.random(CollectibleType.NUM_COLLECTIBLES), 0, true)
    end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, dthree.rerollColl, CollectibleType.AGONY_C_D3)