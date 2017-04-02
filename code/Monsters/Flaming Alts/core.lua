local flaming = {}

function flaming:ai_detectFire(hurtEntity, _, dmgFlags, _, _)
	if Agony:HasFlags(dmgFlags, DamageFlag.DAMAGE_FIRE) and hurtEntity.SubType == 0 then
		hurtEntity:ToNPC():Morph(hurtEntity.Type, hurtEntity.Variant, 20, -1)
		return false
	elseif Agony:HasFlags(dmgFlags, DamageFlag.DAMAGE_FIRE) and hurtEntity.SubType == 20 then
		return false
	end
end

--Callbacks
for _, entId in pairs(Agony.ENUMS["EnemyLists"]["FlamingAlts"]) do
	Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, flaming.ai_detectFire, entId)
end