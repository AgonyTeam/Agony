local doubleDown = {}

-- Doubles player damage
function doubleDown:cacheUpdate (player,cacheFlag)
	if player:HasCollectible(CollectibleType.AGONY_C_DOUBLE_DOWN) and cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage*2*player:GetCollectibleNum(CollectibleType.AGONY_C_DOUBLE_DOWN)
	end
end

-- Doubles damage taken
function doubleDown:onTakeDmg(entity,dmgAmount)
	local player = Isaac.GetPlayer(0);
	if player:HasCollectible(CollectibleType.AGONY_C_DOUBLE_DOWN) then
		--For each double down the player has
		for i = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_DOUBLE_DOWN) do
			for i=1, dmgAmount do
				if player:GetSoulHearts() > 0 then
					if player:IsBlackHeart(player:GetSoulHearts()) then
						player:AddBlackHearts(-1)
					else
						player:AddSoulHearts(-1)
					end
				else
					player:AddHearts(-1)
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, doubleDown.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, doubleDown.onTakeDmg, EntityType.ENTITY_PLAYER)