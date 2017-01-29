local item_PythB = Isaac.GetItemIdByName("Pythagore's Body");
local pythB =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
pythB.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_pythagorebody.anm2")


function pythB:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		pythB.hasItem = false
	end
	if pythB.hasItem == false and player:HasCollectible(item_PythB) then
		--player:AddNullCostume(pythB.costumeID)
		pythB.hasItem = true
	end
end

function pythB:ExplodeOnDeath(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    if hurtEntity.HitPoints < dmgAmount and player:HasCollectible(item_PythB) and hurtEntity:IsVulnerableEnemy() and not hurtEntity:IsBoss() then
    	hurtEntity:Remove()
    	Game():BombExplosionEffects(hurtEntity.Position, 10, player.TearFlags, player.Color, hurtEntity, 1, false, false)
    end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, pythB.ExplodeOnDeath)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, pythB.onUpdate)