local item_TilDeathDoUsApart = Isaac.GetItemIdByName("Til Death Do Us Apart");
local tilDeath = {};

local CONVERT_LUCK_BASE = 0.10
local CONVERT_LUCK_MULTI = 0.07
local rng = RNG()

function tilDeath:ConvertEntity(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    if hurtEntity.HitPoints < dmgAmount 
			and not hurtEntity:IsBoss()
			and player:HasCollectible(item_TilDeathDoUsApart)
            and hurtEntity:IsVulnerableEnemy() then
        local threshold = CONVERT_LUCK_BASE + player.Luck * CONVERT_LUCK_MULTI
        if rng:RandomFloat() < threshold then
			hurtEntity.HitPoints = hurtEntity.MaxHitPoints + dmgAmount; --because function is called before damage os taken. this will make sure the enemy stays alive if the player deals massive dmg
			hurtEntity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM);
		end
    end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, tilDeath.ConvertEntity);