local nuclearStone = {}

function nuclearStone:onUpdate()
	local player = Isaac.GetPlayer(0)
	local damage = player.Damage
	local ents = Isaac.GetRoomEntities()
	
	if player:HasTrinket(TrinketType.AGONY_T_NUCLEAR_STONE) then--nuclear stone
		for _,entity in pairs(ents) do
			if entity.Type == EntityType.ENTITY_TEAR and entity.FrameCount <= 1 then
				Game():ShakeScreen(math.ceil(damage/3))
			elseif entity.Type == EntityType.ENTITY_TEAR and entity:IsDead() then
				Game():ShakeScreen(math.ceil(damage/2))
			end
		end
	end
end

function nuclearStone:onTakeDamage(hurtEntity, dmgAmount, dmgFlags, source, countdown)
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(TrinketType.AGONY_T_NUCLEAR_STONE) and source.Type == EntityType.ENTITY_TEAR then --nuclear stone
		Game():ShakeScreen(math.ceil(dmgAmount/4))
	end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, nuclearStone.onTakeDamage)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, nuclearStone.onUpdate)