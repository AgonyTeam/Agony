CollectibleType["AGONY_C_DICE_TATTOO"] = Isaac.GetItemIdByName("Dice Tattoo");

local diceTattoo =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	roomID = nil,
	isRoomClear = nil
}
diceTattoo.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_dicetattoo.anm2")

function diceTattoo:onUpdate()
	--Rerolls a random item on the player on clearing the room
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_DICE_TATTOO) then
		local lvl = Game():GetLevel()
		local room = lvl:GetCurrentRoom()
		--Detect room clearing
		if diceTattoo.roomID == nil or diceTattoo.roomID ~= lvl:GetCurrentRoomIndex() then
			diceTattoo.roomID = lvl:GetCurrentRoomIndex()
			diceTattoo.isRoomClear = room:IsClear()
		elseif diceTattoo.isRoomClear == false and room:IsClear() then
			diceTattoo.isRoomClear = true
			--For each DiceTattoo the player has
			for i = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_DICE_TATTOO), 1 do
				--Reroll a random item
				if player:GetCollectibleCount() >= 1 then --If the player has collectibles
			    	local colletibles = {}
		        	for name, id in pairs(CollectibleType) do --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
		        	    if (name ~= "NUM_COLLECTIBLES" and player:HasCollectible(id)) then --If they have it add it to the table
		        	        table.insert(colletibles, id)
		         	   end
		       	 	end
		       		player:RemoveCollectible(colletibles[player:GetCollectibleRNG(CollectibleType.AGONY_C_DICE_TATTOO):RandomInt(#colletibles)+1])
		        	player:AddCollectible(player:GetCollectibleRNG(CollectibleType.AGONY_C_DICE_TATTOO):RandomInt(CollectibleType.NUM_COLLECTIBLES)+1, 0, true)
	    		end
	    	end
		end
	end
end

function diceTattoo:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		diceTattoo.hasItem = false
	end
	if diceTattoo.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_DICE_TATTOO) then
		--player:AddNullCostume(diceTattoo.costumeID)
		diceTattoo.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, diceTattoo.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, diceTattoo.onPlayerUpdate)