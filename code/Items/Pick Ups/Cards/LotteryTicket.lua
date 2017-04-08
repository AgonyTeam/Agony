local lotteryT = {
	slots = {
		1, --slot
		2, --blood donation
		3, --forune teller
		--8, --donation
		10, --restock
		--11 --greed donation
	}
}

function lotteryT:onUse()
	local player = Isaac.GetPlayer(0)
	local rng = player:GetCardRNG(Card.AGONY_CARD_LOTTERY_TICKET)
	Isaac.Spawn(EntityType.ENTITY_SLOT, lotteryT.slots[rng:RandomInt(#lotteryT.slots)+1], 0, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0,0), player)
end

function lotteryT:getCard(rng, currentCard, cards, runes, onlyRunes)
	if not onlyRunes and rng:RandomFloat() < (1/Card.NUM_CARDS) then
		return Card.AGONY_CARD_LOTTERY_TICKET
	elseif not onlyRunes and not runes and rng:RandomFloat() < (1/(Card.NUM_CARDS-10)) then
		return Card.AGONY_CARD_LOTTERY_TICKET
	end
end
Agony:AddCallback(ModCallbacks.MC_USE_CARD, lotteryT.onUse, Card.AGONY_CARD_LOTTERY_TICKET)
Agony:AddCallback(ModCallbacks.MC_GET_CARD, lotteryT.getCard)