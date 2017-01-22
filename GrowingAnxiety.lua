local item_GrowingAnxiety = Isaac.GetItemIdByName("Growing Anxiety")
local growingAnxiety =  {
	FormerScale = {},
	CurrentScaleMulti = 1,
	Room = {}
}

--Shrinks the player upon getting hit
function growingAnxiety:shrinkPlayer()
	local player = Isaac.GetPlayer(0)
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	if player:HasCollectible(item_GrowingAnxiety) then
		if growingAnxiety.CurrentScaleMulti == 1 then
			growingAnxiety.FormerScale = player.SpriteScale
			growingAnxiety.Room = Game():GetLevel():GetCurrentRoomIndex()
		end
		if growingAnxiety.CurrentScaleMulti > 0.5 then
			growingAnxiety.CurrentScaleMulti = growingAnxiety.CurrentScaleMulti*0.9
			Game():SpawnParticles(player.Position, EffectVariant.POOF01, 1, 1, col, 0)
		end
		player.SpriteScale = growingAnxiety.FormerScale*growingAnxiety.CurrentScaleMulti
	end
end

--Resets the player size after leaving the room
function growingAnxiety:resetPlayerSize(player)
	if growingAnxiety.Room ~= nil and Game():GetLevel():GetCurrentRoomIndex() ~= growingAnxiety.Room then
		growingAnxiety.Room = nil
		growingAnxiety.CurrentScaleMulti = 1
		player.SpriteScale = growingAnxiety.FormerScale
	end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, growingAnxiety.shrinkPlayer, EntityType.ENTITY_PLAYER)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, growingAnxiety.resetPlayerSize)			