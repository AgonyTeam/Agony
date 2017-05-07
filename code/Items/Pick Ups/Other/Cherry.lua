local cherry = {}

function cherry:onPickup(player, sound, data, sprite, ent)
	sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES, 1, 0, false, 1)
	--spawn a clone!
	local c = Isaac.Spawn(EntityType.AGONY_ETYPE_PLAYER_CLONE, 0, 0, Isaac.GetFreeNearPosition(player.Position, 200), Vector(0,0), player)
	--familiar spawn stuff
	--for _, entity in pairs(ents) do
	--	if entity.Type == EntityType.ENTITY_FAMILIAR and not (entity.Parent ~= nil and entity.Parent.Type == EntityType.AGONY_ETYPE_PLAYER_CLONE) then
	--		local f = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, c.Position, Vector(0,0), c)
	--		f.Parent = c
	--	end
	--end
	player:GetData().Clones = player:GetData().Clones + 1
	saveData.cherry.Clones = player:GetData().Clones
	Agony:SaveNow()
end

function cherry:initPlayer(player)
	player:GetData().Clones = saveData.cherry.Clones or 0
	if Game():GetFrameCount() <= 1 then
		player:GetData().Clones = 0
		saveData.cherry.Clones = 0
		Agony:SaveNow()
	end
end

function cherry:resetClones()
	local player = Isaac.GetPlayer(0)
	player:GetData().Clones = 0
	saveData.cherry.Clones = 0
	Agony:SaveNow()
end

function cherry:respawnClones()
	local player = Isaac.GetPlayer(0)
	for i=1, player:GetData().Clones do
		local c = Isaac.Spawn(EntityType.AGONY_ETYPE_PLAYER_CLONE, 0, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0,0), player)
		--familiar spawn stuff
		--for _, entity in pairs(ents) do
		--	if entity.Type == EntityType.ENTITY_FAMILIAR and not (entity.Parent ~= nil and entity.Parent.Type == EntityType.AGONY_ETYPE_PLAYER_CLONE) then
		--		local f = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, c.Position, Vector(0,0), c)
		--		f.Parent = c
		--	end
		--end
	end
end

function cherry:replacePickup(ent, rng)
	if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_HEART and ent.SubType ~= HeartSubType.AGONY_HEART_CHERRY and ent:GetSprite():IsPlaying("Appear") and rng:RandomFloat() <= (1/22) then
		--debug_text = "spawn cherry"
		Isaac.Spawn(ent.Type, ent.Variant, HeartSubType.AGONY_HEART_CHERRY, ent.Position, ent.Velocity, nil)
		ent:Remove()
	end	
end

Agony:addPickup(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.AGONY_HEART_CHERRY, cherry.onPickup, cherry.replacePickup, nil)

--Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, cherry.onPickup)
--Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, cherry.replacePickup)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, cherry.initPlayer)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, cherry.resetClones)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, cherry.respawnClones)