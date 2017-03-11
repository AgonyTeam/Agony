TrinketType["AGONY_T_LUCKY_EGG"] = Isaac.GetTrinketIdByName("Lucky Egg")

local luckyEgg = {
	luckBuff = saveData.luckyEgg.luckBuff or 0,
	stage = saveData.luckyEgg.stage or nil
}

function luckyEgg:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(TrinketType.AGONY_T_LUCKY_EGG) then		
		luckyEgg:applyLckBuff()
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
end

function luckyEgg:cacheUpdate (player,cacheFlag)
	if (cacheFlag == CacheFlag.CACHE_LUCK) then
		player.Luck = player.Luck + luckyEgg.luckBuff
	end
end

function luckyEgg:applyLckBuff()
	luckyEgg.luckBuff = luckyEgg.luckBuff + 0.69
	saveData.luckyEgg.luckBuff = luckyEgg.luckBuff
	Agony:SaveNow()
end

function luckyEgg:onUpdate()
	if Game():GetFrameCount() == 1 or luckyEgg.stage == nil then
		luckyEgg.luckBuff = Game():GetLevel():GetStage()
		saveData.luckyEgg.luckBuff = luckyEgg.luckBuff
		Agony:SaveNow()
	end
	if luckyEgg.stage ~= Game():GetLevel():GetStage() then
		luckyEgg.stage = Game():GetLevel():GetStage()
		luckyEgg.luckBuff = 0
		saveData.luckyEgg.luckBuff = luckyEgg.luckBuff
		saveData.luckyEgg.stage = luckyEgg.stage
		Agony:SaveNow()
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, luckyEgg.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, luckyEgg.onUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, luckyEgg.onTakeDmg, EntityType.ENTITY_PLAYER)