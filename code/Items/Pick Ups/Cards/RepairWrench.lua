local repairW = {
	pedSlots = {
		[1] = 3,
		[2] = 2,
		[3] = 1
	}
}

function repairW:onUse()
	local player = Isaac.GetPlayer(0)
	local rng = player:GetCardRNG(Card.AGONY_CARD_REPAIR_WRENCH)
	local ents = Isaac.GetRoomEntities()
	Agony:AnimGiantBook("RepairWrench.png", "Wrench", "giantbook_wrench.anm2")
	for _,ent in pairs(ents) do
		if ent.Type == EntityType.ENTITY_SLOT then
			if (ent.Variant == 10 and ent:GetSprite():IsFinished("Death")) or ent:GetSprite():IsPlaying("Broken") then
				Isaac.Spawn(ent.Type, ent.Variant, ent.SubType, ent.Position, Vector(0,0), player)
				ent:Remove()
			end
		elseif ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE and ent:GetSprite():GetFilename() ~= Agony.Pedestals.ANIMFILE 
		and ent:GetSprite():GetOverlayFrame() >= 1 and ent:GetSprite():GetOverlayFrame() <= 3 then
			local pos = nil
			if ent.SubType == 0 then --remove the empty pedestal and respawn the chest at the exact same place as before
				pos = ent.Position
				ent:Remove()
			else
				pos = Isaac.GetFreeNearPosition(ent.Position, 50) --respawn chest next to pedestal
			end
			Isaac.Spawn(EntityType.ENTITY_SLOT, repairW.pedSlots[ent:GetSprite():GetOverlayFrame()], 0, pos, Vector (0,0), player)
			if ent:Exists() then --change to normal pedestal if it exists
				ent:GetSprite():SetOverlayFrame("Alternates", 0) 
			end
		end
	end
end

function repairW:getCard(rng, currentCard, cards, runes, onlyRunes)
	if not onlyRunes and rng:RandomFloat() < (1/Card.NUM_CARDS) then
		return Card.AGONY_CARD_LOTTERY_TICKET
	elseif not onlyRunes and not runes and rng:RandomFloat() < (1/(Card.NUM_CARDS-10)) then
		return Card.AGONY_CARD_LOTTERY_TICKET
	end
end
Agony:AddCallback(ModCallbacks.MC_USE_CARD, repairW.onUse, Card.AGONY_CARD_REPAIR_WRENCH)
Agony:AddCallback(ModCallbacks.MC_GET_CARD, repairW.getCard)