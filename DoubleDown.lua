local item_DoubleDown = Isaac.GetItemIdByName("Double Down")
local doubleDown = {}

-- Doubles player damage
function doubleDown:cacheUpdate (player,cacheFlag)
	local player = Isaac.GetPlayer(0)
	if (player:HasCollectible(item_DoubleDown)) and (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage*2
	end
end

-- Doubles damage taken
function doubleDown:doubleDmgTaken(entity,dmgAmount)
	local player = Isaac.GetPlayer(0);
	if player:HasCollectible(item_DoubleDown) then
		for i=1, dmgAmount do
			if player:GetSoulHearts() > 0 then
				player:AddSoulHearts(-1)
			else
				player:AddHearts(-1)
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, doubleDown.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, doubleDown.doubleDmgTaken, EntityType.ENTITY_PLAYER)