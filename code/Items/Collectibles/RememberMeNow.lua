--local item_RMeNow = Isaac.GetItemIdByName("Remember Me Now")
local RMeNow =  {}

function RMeNow:onUse()
	local player = Game():GetPlayer(0)
	player:RemoveCollectible(CollectibleType.AGONY_C_REMEMBER_ME_NOW)
	local lvl = Game():GetLevel()
	local stage = lvl:GetStage()
	if Game():IsGreedMode() and stage > LevelStage.STAGE1_GREED then
		lvl:SetStage(stage-1, StageType.STAGETYPE_GREEDMODE)
		Game():StartStageTransition(true, 1)
	elseif stage > LevelStage.STAGE1_1 then
		lvl:SetStage(stage-1, StageType.STAGETYPE_AFTERBIRTH)
		Game():StartStageTransition(true, 1)
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, RMeNow.onUse, CollectibleType.AGONY_C_REMEMBER_ME_NOW)