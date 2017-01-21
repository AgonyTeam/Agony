local item_Runestone = Isaac.GetItemIdByName("Runestone")
local runestone =  {
	rseed = 1
}

function runestone:spawnRune()
	local player = Game():GetPlayer(0)
	local rune = nil
	local room = Game():GetRoom()
	local rand = (room:GetDecorationSeed()*runestone.rseed)%9
	runestone.rseed = (RNG():GetSeed()*runestone.rseed)%100
	if rand == 0 then
		rune = Card.RUNE_HAGALAZ
	elseif rand == 1 then
		rune = Card.RUNE_JERA
	elseif rand == 2 then
		rune = Card.RUNE_EHWAZ
	elseif rand == 3 then
		rune = Card.RUNE_DAGAZ
	elseif rand == 4 then
		rune = Card.RUNE_ANSUZ
	elseif rand == 5 then
		rune = Card.RUNE_PERTHRO
	elseif rand == 6 then
		rune = Card.RUNE_BERKANO
	elseif rand == 7 then
		rune = Card.RUNE_ALGIZ
	else
		rune = Card.RUNE_BLANK
	end
	player:AddCard(rune)
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, runestone.spawnRune, item_Runestone)