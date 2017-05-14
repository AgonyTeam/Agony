local partyPooper = {}

function partyPooper:onPlayerUpdate(player)
	if player:HasTrinket(TrinketType.AGONY_T_PARTY_POOPER) then
		local room = Game():GetLevel():GetCurrentRoom()
		if math.random(60*60) == 1 then
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			local poop = 4
			if math.random(3) == 1 then
				poop = 3
			end
			Game():SpawnParticles(player.Position, EffectVariant.FIREWORKS, 3, 1, col, 0)
			room:SpawnGridEntity(room:GetGridIndex(Isaac.GetFreeNearPosition(Game():GetPlayer(0).Position, 25)), GridEntityType.GRID_POOP, poop, RNG():GetSeed(), 1)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, partyPooper.onPlayerUpdate)