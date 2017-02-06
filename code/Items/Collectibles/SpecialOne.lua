CollectibleType["AGONY_C_SPECIAL_ONE"] = Isaac.GetItemIdByName("Special One");

local specialOne =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
specialOne.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_specialone.anm2")

function specialOne:fireWizTears ()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_SPECIAL_ONE) then
		local entList = Isaac.GetRoomEntities()
		for i = 1, #entList, 1 do
			player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_THE_WIZ, false)
			if entList[i].Type == EntityType.ENTITY_TEAR and entList[i].SubType ~= 1 and (entList[i].Parent.Type == EntityType.ENTITY_PLAYER or (entList[i].Parent.Type == 3 and entList[i].Parent.SubType == 80)) and entList[i].FrameCount == 1 then
				local t = player:FireTear(player.Position, entList[i].Velocity:__mul(-1), false, false, true)
				t.SubType = 1
				--Set the subtype to 1 to avoid firing another tear because of this new one
			end
		end
	end
end

function specialOne:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		specialOne.hasItem = false
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SPECIAL_ONE) then
		if specialOne.hasItem == false  then
			--player:AddNullCostume(specialOne.costumeID)
			specialOne.hasItem = true
		end
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, specialOne.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, specialOne.fireWizTears)