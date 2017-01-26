local item_Tantrum = Isaac.GetItemIdByName("Tantrum")
local tantrum =  {
	hasItem = false,
	costumeID = nil,
	TearBool = false,
	playerHasFullCharge = false
}
tantrum.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_hyperactive.anm2")

function tantrum:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		tantrum.hasItem = false
	end
	if tantrum.hasItem == false and player:HasCollectible(item_Tantrum) then
		--player:AddNullCostume(tantrum.costumeID)
		tantrum.hasItem = true
	end

	if player:HasCollectible(item_Tantrum) then
		if player:GetActiveItem() ~= nil then
			if player:NeedsCharge() then 
				if tantrum.playerHasFullCharge then
					for i = 1, 5, 1 do
					player:UseActiveItem(player:GetActiveItem(), false, true, true, false)
					end
					player:RemoveCollectible(player:GetActiveItem())
					tantrum.playerHasFullCharge = false
					player:AddCoins(1)
				end
			else
				tantrum.playerHasFullCharge = true
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, tantrum.onUpdate)
