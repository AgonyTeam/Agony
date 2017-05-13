local brokenSpike = {}

function brokenSpike:onTakeDamage(player,_,flag,_,_)
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(TrinketType.AGONY_T_BROKEN_SPIKE) and flag == DamageFlag.DAMAGE_CURSED_DOOR then
		return false
	end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, brokenSpike.onTakeDamage, EntityType.ENTITY_PLAYER)