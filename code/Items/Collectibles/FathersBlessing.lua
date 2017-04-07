local fathersBlessing =  {
	cooldown = 0
}

function fathersBlessing:onUpdate()
	if fathersBlessing.cooldown > 0 then
		fathersBlessing.cooldown = fathersBlessing.cooldown - 1
	end
end

function fathersBlessing:onNpcUpdate(npc)
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_FATHERS_BLESSING) and npc:IsVulnerableEnemy() then
		if fathersBlessing.cooldown == 0 then
			if npc.Position:Distance(player.Position) < 50 then
				local col = Color(0, 0, 0, 0, 0, 0, 0)
      			col:Reset()
				Game():SpawnParticles(npc.Position, EffectVariant.CRACK_THE_SKY, 1, 0, col, 0)
				local luckMult = nil
				if player.Luck > 0 then
				 	luckMult = player.Luck+1
				elseif player.Luck == 0 then
					luckMult = 1
				else
					luckMult = player.Luck
				end
				fathersBlessing.cooldown = 15+60/luckMult
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, fathersBlessing.onUpdate)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, fathersBlessing.onNpcUpdate)