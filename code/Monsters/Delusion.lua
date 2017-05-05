local delusion = {
	morphCooldown = 180, --6 seconds
	seenEnemies = saveData.delusion.seenEnemies or {},
	morphChance = 0.8,
	allowedEnemies = Agony.ENUMS["EnemyLists"]["Delusions"],
}

function delusion:updateSprite(ent)
	local sprite = ent:GetSprite()
--[[	for i=0, sprite:GetLayerCount()-1 do
		sprite:ReplaceSpritesheet(i, "gfx/Monsters/Delusions/" .. tostring(ent.Type) .. "_" .. tostring(ent.Variant) .. "/" .. tostring(i) .. ".png")
	end
	sprite:LoadGraphics()
]]--
	sprite.FlipX = false
end

function delusion:ai_init(ent, data)
	data.delusion = {}
	data.delusion.morphCooldown = 0
	ent.MaxHitPoints = 100
	ent.HitPoints = ent.MaxHitPoints
end


function delusion:ai_morph(ent, data, rng)
	local t, v = nil
	while (t == ent.Type and v == ent.Variant) or t == nil or v == nil do --do not choose the same entity
		local r = rng:RandomInt(#delusion.seenEnemies)+1
		t,v = delusion.seenEnemies[r][1], delusion.seenEnemies[r][2]
	end
	local hp = ent.HitPoints
	
	ent:Morph(t, v , Agony.EnemySubTypes.ST_DELUSIONS, -1)
	--poof
	local col = Color(1,1,1,1,0,0,0)
	Game():SpawnParticles(ent.Position, EffectVariant.POOF01, 1, 1, col, 0)
	
	Agony:dataCopy(data, ent:GetData())
	delusion:updateSprite(ent)
	ent.State = NpcState.STATE_INIT
	--don't play appear anim
	ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	--stop moving
	ent.Velocity = Vector(0,0)
	--keep same hp across entities
	ent.MaxHitPoints = 100
	ent.HitPoints = hp
end

function delusion:ai_update(ent)
	if ent.SubType == Agony.EnemySubTypes.ST_DELUSIONS then
		local data = ent:GetData()
		local rng = ent:GetDropRNG()
		
		if data.delusion == nil then
			--init if not inited
			ent.State = NpcState.STATE_INIT
			delusion:ai_init(ent, data)
		else
			if data.delusion.morphCooldown > 0 then
				data.delusion.morphCooldown = data.delusion.morphCooldown - 1
			elseif data.delusion.morphCooldown == 0 and rng:RandomFloat() < delusion.morphChance and #delusion.seenEnemies > 1 then
				data.delusion.morphCooldown = delusion.morphCooldown
				delusion:ai_morph(ent, data, rng)
			elseif data.delusion.morphCooldown == 0 then
				data.delusion.morphCooldown = delusion.morphCooldown
			end
		end
	end
end

function delusion:trackSeen(ent)
	-- add to list if just spawned and not boss
	if ent.FrameCount <= 1 and not ent:IsBoss() then
		local inList = false
		for _, eTbl in pairs(delusion.seenEnemies) do
			local t, v = eTbl[1], eTbl[2]
			if ent.Type == t and ent.Variant == v then
				inList = true
			end
		end
		if inList == false then
			table.insert(delusion.seenEnemies, {ent.Type, ent.Variant})
			saveData.delusion.seenEnemies = delusion.seenEnemies
			Agony:SaveNow()
			inList = true
		end
	end
end

function delusion:reset()
	if Game():GetFrameCount() <= 1 then
		delusion.seenEnemies = {}
		saveData.delusion.seenEnemies = delusion.seenEnemies
		Agony:SaveNow()
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, delusion.ai_update)
--track all enemies in whitelist
for _,id in pairs(delusion.allowedEnemies) do
	Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, delusion.trackSeen, id)
end
--reset on new run and new level
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, delusion.reset)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, delusion.reset)