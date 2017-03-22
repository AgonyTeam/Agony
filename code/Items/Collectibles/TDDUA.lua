--local item_TilDeathDoUsApart = Isaac.GetItemIdByName("Til Death Do Us Apart");
local tilDeath = {
    hasItem = nil, --used for costume
    costumeID = nil
}
tilDeath.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_tilldeathdousappart.anm2")

local CONVERT_LUCK_BASE = 0.10
local CONVERT_LUCK_MULTI = 0.07
local rng = RNG()

function tilDeath:ConvertEntity(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
    col:Reset()
    if hurtEntity.HitPoints < dmgAmount 
			and not hurtEntity:IsBoss()
			and player:HasCollectible(CollectibleType.AGONY_C_TILL_DEATH_DO_US_APART)
            and hurtEntity:IsVulnerableEnemy() then
        local threshold = CONVERT_LUCK_BASE + player.Luck * CONVERT_LUCK_MULTI
        if rng:RandomFloat() < threshold then
	        hurtEntity.HitPoints = hurtEntity.MaxHitPoints + dmgAmount; --because function is called before damage os taken. this will make sure the enemy stays alive if the player deals massive dmg
            hurtEntity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM);
            Game():SpawnParticles(hurtEntity.Position, EffectVariant.POOF01, 1, 1, col, 0)
        end
    end
end

function tilDeath:onPlayerUpdate(player)
    if Game():GetFrameCount() == 1 then
        tilDeath.hasItem = false
    end
    if tilDeath.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_TILL_DEATH_DO_US_APART) then
        player:AddNullCostume(tilDeath.costumeID)
        tilDeath.hasItem = true
    end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, tilDeath.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, tilDeath.ConvertEntity);