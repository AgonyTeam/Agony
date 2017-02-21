CollectibleType["AGONY_C_PARASITES"] = Isaac.GetItemIdByName("Parasites");

local parasites =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
parasites.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_parasites.anm2")

function parasites:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_PARASITES)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + 2.69*player:GetCollectibleNum(CollectibleType.AGONY_C_PARASITES);
	end
end

function parasites:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		parasites.hasItem = false
	end
	if parasites.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_PARASITES) then
		--player:AddNullCostume(parasites.costumeID)
		parasites.hasItem = true
	end
end

function parasites:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    player:AddKeys(1)
    if hurtEntity.HitPoints < dmgAmount 
			and not hurtEntity:IsBoss()
			and player:HasCollectible(CollectibleType.AGONY_C_PARASITES)
            and hurtEntity:IsVulnerableEnemy()
            and hurtEntity.Type ~= EntityType.ENTITY_SPIDER then
    	player:AddCoins(1)
    end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, parasites.onTakeDmg)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, parasites.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, parasites.cacheUpdate)