TrinketType["AGONY_T_BLOODY_NUT"] = Isaac.GetTrinketIdByName("Bloody Nut")

local bloodyNut = {
	dmgBuff = saveData.bloodyNut.dmgBuff or 0
}

function bloodyNut:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(TrinketType.AGONY_T_BLOODY_NUT) then
		local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_D3)
		local luck = math.floor(player.Luck)
		if hurtEntity.HitPoints < dmgAmount and not hurtEntity:IsBoss() and hurtEntity:IsVulnerableEnemy() then
			if rng:RandomInt(100)*(1+(luck/20)) > 75 then
				bloodyNut:applyDmgBuff()
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
			end
        end
	end
end

function bloodyNut:cacheUpdate (player,cacheFlag)
	if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + bloodyNut.dmgBuff
	end
end

function bloodyNut:applyDmgBuff()
	bloodyNut.dmgBuff = bloodyNut.dmgBuff + 0.01
	saveData.bloodyNut.dmgBuff = bloodyNut.dmgBuff
	Agony:SaveNow()
end

function bloodyNut:onUpdate()
	if Game():GetFrameCount() == 1 then
		bloodyNut.dmgBuff = 0
		saveData.bloodyNut.dmgBuff = 0
		Agony:SaveNow()
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bloodyNut.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, bloodyNut.onUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, bloodyNut.onTakeDmg)