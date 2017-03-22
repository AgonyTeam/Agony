
local luckyEgg = {
	realLuckBuff = saveData.luckyEgg.realLuckBuff or 0,
	luckBuff = 0,
	stage = saveData.luckyEgg.stage or nil
}
--luckyEgg.luckBuff = luckyEgg.realLuckBuff

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
	luckyEgg.realLuckBuff = luckyEgg.realLuckBuff + 0.69
	luckyEgg.luckBuff = luckyEgg.realLuckBuff
	saveData.luckyEgg.realLuckBuff = luckyEgg.realLuckBuff
	Agony:SaveNow()
end

function luckyEgg:onUpdate()
	local player = Isaac.GetPlayer(0)
	if Game():GetFrameCount() == 1 or luckyEgg.stage == nil then
		luckyEgg.stage = Game():GetLevel():GetStage()
		saveData.luckyEgg.stage = luckyEgg.stage
		Agony:SaveNow()
	end
	if luckyEgg.stage ~= Game():GetLevel():GetStage() then
		luckyEgg.stage = Game():GetLevel():GetStage()
		luckyEgg.realLuckBuff = 0
		luckyEgg.luckBuff = luckyEgg.realLuckBuff
		saveData.luckyEgg.realLuckBuff = luckyEgg.realLuckBuff
		saveData.luckyEgg.stage = luckyEgg.stage
		Agony:SaveNow()
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
	if not player:HasTrinket(TrinketType.AGONY_T_LUCKY_EGG) then
		luckyEgg.luckBuff = 0
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	elseif player:HasTrinket(TrinketType.AGONY_T_LUCKY_EGG) and luckyEgg.luckBuff ~= luckyEgg.realLuckBuff then
		luckyEgg.luckBuff = luckyEgg.realLuckBuff
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, luckyEgg.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, luckyEgg.onUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, luckyEgg.onTakeDmg, EntityType.ENTITY_PLAYER)