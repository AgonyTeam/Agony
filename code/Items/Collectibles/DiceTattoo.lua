local diceTattoo =  {
	roomID = nil,
	isRoomClear = nil
}
diceTattoo.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_dicetattoo.anm2")

function diceTattoo:onUpdate()
	--Rerolls a random item on the player on clearing the room
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_DICE_TATTOO)
	
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
			    	local colletibles = Agony:getCurrentItems()
		       		player:RemoveCollectible(colletibles[rng:RandomInt(#colletibles)+1])
		        	player:AddCollectible(rng:RandomInt(CollectibleType.NUM_COLLECTIBLES-1)+1, 0, true)
	    		end
	    	end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, diceTattoo.onUpdate)