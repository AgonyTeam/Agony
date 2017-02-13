--local item_Tantrum = Isaac.GetItemIdByName("Tantrum")
CollectibleType["AGONY_C_TANTRUM"] = Isaac.GetItemIdByName("Tantrum");
local tantrum =  {
	hasItem = false,
	costumeID = nil,
	TearBool = false,
	playerHasFullCharge = false
}
tantrum.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_hyperactive.anm2")

function tantrum:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		tantrum.hasItem = false
	end
	if tantrum.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_TANTRUM) then
		--player:AddNullCostume(tantrum.costumeID)
		tantrum.hasItem = true
	end

	if player:HasCollectible(CollectibleType.AGONY_C_TANTRUM) then
		if player:GetActiveItem() ~= nil then
			if player:NeedsCharge() then 
				if tantrum.playerHasFullCharge then
					r = math.random(4)+3
					for i = 1, r*AGONY_C_SUICIDE_GOD, 1 do
					player:UseActiveItem(player:GetActiveItem(), false, true, true, false)
					end
					player:RemoveCollectible(player:GetActiveItem())
					tantrum.playerHasFullCharge = false
				end
			else
				tantrum.playerHasFullCharge = true
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, tantrum.onPlayerUpdate)