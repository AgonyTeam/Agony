
local personalBubble =  {
	cooldown = 0
}

function personalBubble:onUpdate()
	if personalBubble.cooldown > 0 then
		personalBubble.cooldown = personalBubble.cooldown - 1
	end
end

function personalBubble:onNpcUpdate(npc)
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_PERSONAL_BUBBLE) then
		if personalBubble.cooldown == 0 then
			if npc.Position:Distance(player.Position) < 50 then
				Game():ButterBeanFart(player.Position, 100*player:GetCollectibleNum(CollectibleType.AGONY_C_PERSONAL_BUBBLE), player, true)
				local luckMult = nil
				if player.Luck > 0 then
				 	luckMult = player.Luck+1
				elseif player.Luck == 0 then
					luckMult = 1
				else
					luckMult = player.Luck
				end
				personalBubble.cooldown = 15+60/luckMult
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, personalBubble.onUpdate)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, personalBubble.onNpcUpdate)