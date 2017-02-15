CollectibleType["AGONY_C_PERSONAL_BUBBLE"] = Isaac.GetItemIdByName("Personal Bubble");

local personalBubble =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	cooldown = 0
}
personalBubble.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_personalbubble.anm2")

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

function personalBubble:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		personalBubble.hasItem = false
	end
	if personalBubble.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_PERSONAL_BUBBLE) then
		player:AddNullCostume(personalBubble.costumeID)
		personalBubble.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, personalBubble.onUpdate)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, personalBubble.onNpcUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, personalBubble.onPlayerUpdate)