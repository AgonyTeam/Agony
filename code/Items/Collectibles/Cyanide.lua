local item_Cyanide = Isaac.GetItemIdByName("Cyanide")
local cyanide =  {}

function cyanide:killPlayer()
	local player = Game():GetPlayer(0)
	player:RemoveCollectible(item_Cyanide)
	for i = 1, 5, 1 do
		Game():GetLevel():SetStage(LevelStage.STAGE7, StageType.STAGETYPE_AFTERBIRTH)
		Game():StartStageTransition(true, 1)
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, cyanide.killPlayer, item_Cyanide)