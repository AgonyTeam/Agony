--local pill_PartyPills = Isaac.GetPillEffectByName("Party Pills!")
PillEffect["AGONY_PEFF_PARTY_PILLS"] = Isaac.GetPillEffectByName("Party Pills!");
local partypills = {
	--IsTimeToParty = false,
	Room = nil,
	FormerScale = nil
}

function partypills:DistortEnemies(npc)
	if partypills.Room == Game():GetLevel():GetCurrentRoomIndex() and npc.Type ~= EntityType.ENTITY_FIREPLACE then
		npc.Scale = 1+0.3*math.sin(Game():GetFrameCount()/2)
		npc.SpriteRotation = math.sin(Game():GetFrameCount()/2)*15
		if Game():GetFrameCount() % 60 == math.random(1,5) then
		npc:MakeSplat(0.1)
		end
	end
end

function partypills:DistortPlayer(player)
	if Game():GetLevel():GetCurrentRoomIndex() == partypills.Room then
		player.SpriteScale = Vector (1,1) * (1+0.3*math.sin(Game():GetFrameCount()/2))
		player.SpriteRotation = math.sin(Game():GetFrameCount()/2)*15
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
		local player = Isaac.GetPlayer(0)
		player.SpriteScale = partypills.FormerScale
		player.SpriteRotation = 0
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, partypills.DistortEnemies)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, partypills.DistortPlayer)
Agony:AddCallback(ModCallbacks.MC_USE_PILL, partypills.StartTheParty, PillEffect.AGONY_PEFF_PARTY_PILLS)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, partypills.StopTheParty)