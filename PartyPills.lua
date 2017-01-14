local pill_PartyPills = Isaac.GetPillEffectByName("Party Pills!")
local partypills = {
	--IsTimeToParty = false,
	Room = nil,
	FormerScale = nil
}

function partypills:DistortEnemies(npc)
	if partypills.Room == Game():GetLevel():GetCurrentRoomIndex() then
		npc.Scale = 1+0.3*math.sin(Game():GetFrameCount()/2)
	end
end

function partypills:DistortPlayer(player)
	if Game():GetLevel():GetCurrentRoomIndex() == partypills.Room then
		player.SpriteScale = Vector (1,1) * (1+0.3*math.sin(Game():GetFrameCount()/2))
	end
end

function partypills:StartTheParty()
	--partypills.IsTimeToParty = true
	partypills.Room = Game():GetLevel():GetCurrentRoomIndex()
	partypills.FormerScale = Isaac.GetPlayer(0).SpriteScale
end

function partypills:StopTheParty()
	if (partypills.Room ~= nil) and (Game():GetLevel():GetCurrentRoomIndex() ~= partypills.Room) then
		--partypills.IsTimeToParty = false
		partypills.Room = nil
		Isaac.GetPlayer(0).SpriteScale = partypills.FormerScale
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, partypills.DistortEnemies)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, partypills.DistortPlayer)
Agony:AddCallback(ModCallbacks.MC_USE_PILL, partypills.StartTheParty, pill_PartyPills)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, partypills.StopTheParty)

