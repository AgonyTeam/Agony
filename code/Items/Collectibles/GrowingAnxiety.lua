--local item_GrowingAnxiety = Isaac.GetItemIdByName("Growing Anxiety")
local growingAnxiety =  {
	FormerScale = {},
	CurrentScaleMulti = 1,
	Room = {},
    hasItem = nil, --used for costume
    costumeID = nil
}
growingAnxiety.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_growinganxiety.anm2")

--Shrinks the player upon getting hit
function growingAnxiety:onTakeDmg()
	local player = Isaac.GetPlayer(0)
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()
	if player:HasCollectible(CollectibleType.AGONY_C_GROWING_ANXIETY) then
		if growingAnxiety.CurrentScaleMulti == 1 then
			growingAnxiety.FormerScale = player.SpriteScale
			growingAnxiety.Room = Game():GetLevel():GetCurrentRoomIndex()
		end
		if growingAnxiety.CurrentScaleMulti > 0.5 then
			growingAnxiety.CurrentScaleMulti = growingAnxiety.CurrentScaleMulti - growingAnxiety.CurrentScaleMulti*0.1*player:GetCollectibleNum(CollectibleType.AGONY_C_GROWING_ANXIETY)
			Game():SpawnParticles(player.Position, EffectVariant.POOF01, 1, 1, col, 0)
		end
		player.SpriteScale = growingAnxiety.FormerScale*growingAnxiety.CurrentScaleMulti
	end
end

--Resets the player size after leaving the room
function growingAnxiety:onPlayerUpdate(player)
	if growingAnxiety.Room ~= nil and Game():GetLevel():GetCurrentRoomIndex() ~= growingAnxiety.Room then
		growingAnxiety.Room = nil
		growingAnxiety.CurrentScaleMulti = 1
		player.SpriteScale = growingAnxiety.FormerScale
	end

	if Game():GetFrameCount() == 1 then
        growingAnxiety.hasItem = false
    end
    if growingAnxiety.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_GROWING_ANXIETY) then
        player:AddNullCostume(growingAnxiety.costumeID)
        growingAnxiety.hasItem = true
    end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, growingAnxiety.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, growingAnxiety.onTakeDmg, EntityType.ENTITY_PLAYER)