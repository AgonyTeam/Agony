
local socialAnxiety =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
socialAnxiety.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_socialanxiety.anm2")

function socialAnxiety:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SOCIAL_ANXIETY)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		local dist = Agony:getNearestEnemy(player).Position:Distance(player.Position)
		if dist > 0 and dist < 200 then
			player.Damage = player.Damage + 100/dist
		end
	end
end

function socialAnxiety:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		socialAnxiety.hasItem = false
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SOCIAL_ANXIETY) then
		if socialAnxiety.hasItem == false then
			--player:AddNullCostume(socialAnxiety.costumeID)
			socialAnxiety.hasItem = true
		end
		if Game():GetFrameCount()%5 == 1 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, socialAnxiety.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, socialAnxiety.cacheUpdate)