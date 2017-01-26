local item_Cyanide = Isaac.GetItemIdByName("Cyanide")
local cyanide =  {}

function cyanide:killPlayer()
	local player = Game():GetPlayer(0)
	player:RemoveCollectible(item_Cyanide)
	player:Kill()
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, cyanide.killPlayer, item_Cyanide)