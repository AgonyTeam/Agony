local productiveSeizure = {
    hasItem = nil, --used for costume
    costumeID = nil
}
productiveSeizure.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_productiveseizure.anm2")


function productiveSeizure:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Game():GetPlayer(0)
    if player:HasCollectible(CollectibleType.AGONY_C_PRODUCTIVE_SEIZURE) then
        if hurtEntity:IsVulnerableEnemy() then
            local entities = Isaac.GetRoomEntities()
            local vulEnt = {}
            for i = 1, #entities do
                if entities[i]:IsVulnerableEnemy() then
                    table.insert(vulEnt, entities[i])
                end
            end
            for i = 1, #vulEnt do
                local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
                col:Reset()
                vulEnt[i]:AddHealth(-(dmgAmount/#vulEnt))
                if math.random(4) == 1 then
                    Game():SpawnParticles(vulEnt[i].Position, EffectVariant.BLOOD_EXPLOSION, 1, 1, col, 0)
                end
            end
        end
    end
end

function productiveSeizure:onPlayerUpdate(player)
    if Game():GetFrameCount() == 1 then
        productiveSeizure.hasItem = false
    end
    if productiveSeizure.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_PRODUCTIVE_SEIZURE) then
        --player:AddNullCostume(productiveSeizure.costumeID)
        productiveSeizure.hasItem = true
    end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, productiveSeizure.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, productiveSeizure.onTakeDmg);