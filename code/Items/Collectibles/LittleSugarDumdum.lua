local item_LSD = Isaac.GetItemIdByName("Little Sugar Dumdum")
local LSD = {
	--IsTimeToParty = false,
	Room = nil,
	FormerScale = nil,
	MaxFireDelay = nil,
	ShotSpeed = nil,
	Damage = nil,
	TearHeight = nil,
	TearFallingSpeed = nil,
	TearColor = nil,
	MoveSpeed = nil,
	Luck = nil
}

function LSD:DistortEnemies(npc)
	if LSD.Room == Game():GetLevel():GetCurrentRoomIndex() and npc.Type ~= EntityType.ENTITY_FIREPLACE then
		npc.Scale = 1+0.3*math.sin(Game():GetFrameCount()/2)
		npc.SpriteRotation = math.sin(Game():GetFrameCount()/2)*15
		if Game():GetFrameCount() % 60 == math.random(1,5) then
		npc:MakeSplat(0.1)
		end
	end
end

function LSD:DistortPlayer(player)
	if Game():GetLevel():GetCurrentRoomIndex() == LSD.Room then
		player.SpriteScale = Vector (1,1) * (1+0.3*math.sin(Game():GetFrameCount()/2))
		player.SpriteRotation = math.sin(Game():GetFrameCount()/2)*15
		player:EvaluateItems() --Refreshes the random stats
		LSD:cacheUpdate(player)
	end
end

function LSD:StartTheParty()
	--LSD.IsTimeToParty = true
	LSD.Room = Game():GetLevel():GetCurrentRoomIndex()
	LSD.FormerScale = Isaac.GetPlayer(0).SpriteScale
	LSD.MaxFireDelay = player.MaxFireDelay
	LSD.ShotSpeed = player.ShotSpeed
	LSD.Damage = player.Damage
	LSD.TearHeight = player.TearHeight
	LSD.TearFallingSpeed = player.TearFallingSpeed
	LSD.TearColor = player.TearColor
	LSD.MoveSpeed = player.MoveSpeed
	LSD.Luck = player.Luck
end

function LSD:StopTheParty()
	if (LSD.Room ~= nil) and (Game():GetLevel():GetCurrentRoomIndex() ~= LSD.Room) then
		--LSD.IsTimeToParty = false
		LSD.Room = nil
		local player = Isaac.GetPlayer(0)
		player.SpriteScale = LSD.FormerScale
		player.SpriteRotation = 0
		player.MaxFireDelay = LSD.MaxFireDelay
		player.ShotSpeed = LSD.ShotSpeed
		player.Damage = LSD.Damage
		player.TearHeight = LSD.TearHeight
		player.TearFallingSpeed = LSD.TearFallingSpeed
		player.TearColor = LSD.TearColor
		player.MoveSpeed = LSD.MoveSpeed
		player.Luck = LSD.Luck
	end
end

function LSD:cacheUpdate (player,cacheFlag)
	if Game():GetLevel():GetCurrentRoomIndex() == LSD.Room then	
		player.MaxFireDelay = math.random(1,7)
		player.ShotSpeed = math.random(1,6)*0.5
		player.Damage = math.random(0,15)
		--player.TearHeight = math.random(0,1)
		--player.TearFallingSpeed = math.random(0,.5)
		--player.MoveSpeed = math.random(0,2)
		player.Luck = math.random(-10,10)
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LSD.cacheUpdate);
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, LSD.DistortEnemies)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, LSD.DistortPlayer)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, LSD.StartTheParty, item_LSD)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, LSD.StopTheParty)