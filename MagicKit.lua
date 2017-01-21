local item_MagicKit = Isaac.GetItemIdByName("Magic Kit")
local magicKit = {
	rseed = 1
}

function magicKit:spawnRune(player)
	local rune = nil
	local room = Game():GetRoom()
	local rand = (room:GetDecorationSeed()*magicKit.rseed)%9
	magicKit.rseed = (RNG():GetSeed()*magicKit.rseed)%100
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

function magicKit:OpenKit()
	local player = Game():GetPlayer(0)
	if (player:HasCollectible(item_MagicKit)) then
		for i = 1, player.Luck + 3, 1 do
			magicKit:spawnRune(player)
		end
		player:RemoveCollectible(item_MagicKit)		
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, magicKit.OpenKit, item_MagicKit)