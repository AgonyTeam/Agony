local cocoon1 = {
	spawnCooldown = 30, -- cooldown in entity updates until the next spider can spawn when hurt
	maxSpiders = 3, -- max number of spiders from single cocoon 1 on screen
	spiders = Agony.ENUMS["EnemyLists"]["SpiderCocoon"]
}

function cocoon1:ai_update(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_SPIDER then
		local data = ent:GetData()
		local rng = ent:GetDropRNG()
		--debug_tbl1 = data
		--init variables in entdata
		if ent.State == NpcState.STATE_INIT then
			data.spawnCooldown = cocoon1.spawnCooldown
			data.spiders = {}
			ent.V1 = ent.Position
			ent.State = NpcState.STATE_IDLE
		else
			--decrease cooldown
			if data.spawnCooldown > 0 then
				data.spawnCooldown = data.spawnCooldown - 1
			end
		end
	end
end

function cocoon1:ai_reset_spiders(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_SPIDER then
		--remove dead spiders from spider list
		if ent.State > NpcState.STATE_INIT then
			local data = ent:GetData()
			--debug_tbl2 = data.spiders
			for i, sp in pairs(data.spiders) do
				if not sp:Exists() then
					data.spiders[i] = nil
				end
			end
		end
	end
end

function cocoon1:ai_movement(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_SPIDER then
		--stick to place
		if ent.State > NpcState.STATE_INIT then
			ent.Velocity = ent.V1:__sub(ent.Position)
		end
	end
end

function cocoon1:ai_take_damage(ent, dmg, _,_,_)
	if ent.Variant == Agony.CocoonVariant.COCOON_SPIDER then
		local data = ent:GetData()
		local rng = ent:GetDropRNG()
		ent = ent:ToNPC()
		
		if ent.HitPoints > dmg then
			--spawn a small spider if hit, cooldown is 0 and the spiderlimit isn't reached
			if data.spawnCooldown == 0 and #data.spiders < cocoon1.maxSpiders then
				ent.State = NpcState.STATE_ATTACK
				
				EntityNPC.ThrowSpider(ent.Position, ent, Isaac.GetFreeNearPosition(ent.Position, 75), false, 1)
				--table.insert(data.spiders, spider)
				
				data.spawnCooldown = cocoon1.spawnCooldown
			elseif data.spawnCooldown == 0 then
				data.spawnCooldown = cocoon1.spawnCooldown
			end
		else
			--spawn a random spider on death
			local r = rng:RandomInt(#cocoon1.spiders)+1
			local sp = Isaac.Spawn(cocoon1.spiders[r][1], cocoon1.spiders[r][2], 0, ent.Position, Vector(0,0), ent)
			sp.SpawnerEntity = ent
		end
	end
end

function cocoon1:ai_sound_sprite(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_SPIDER then
		if ent.State == NpcState.STATE_ATTACK then
			ent:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 1.2)
			ent.State = NpcState.STATE_IDLE
		end
	end
end

--prevent the game from replacing trites spawned by the spider cocoon with flaming hoppers/ministros
function cocoon1:unreplaceTrites(ent)
	if ent.SpawnerEntity ~= nil and ent.SpawnerEntity.Type == EntityType.AGONY_ETYPE_COCOON and ent.SpawnerEntity.Variant == Agony.CocoonVariant.COCOON_SPIDER and ent:GetData().unreplaced == nil then
		ent:Morph(EntityType.ENTITY_HOPPER, 1, 0, -1)
		ent.GetData().unreplaced = true
	end
end

--needed because ThrowSpider doesn't return an Entity
function cocoon1:registerSpider(ent)
	if ent.SpawnerType == EntityType.AGONY_ETYPE_COCOON and ent.FrameCount <= 1 and ent:GetData().reg == nil then
		local cocoon = Agony:getNearestEnemy(ent, {EntityType.AGONY_ETYPE_COCOON}, {mode = "only_whitelist"})
		if cocoon:GetData().spiders ~= nil then
			table.insert(cocoon:GetData().spiders, ent)
			ent:GetData().reg = true
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.ai_update, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.ai_reset_spiders, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.ai_movement, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.ai_sound_sprite, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, cocoon1.ai_take_damage, EntityType.AGONY_ETYPE_COCOON)
--have to call this on three different entities
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.unreplaceTrites, EntityType.ENTITY_HOPPER)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.unreplaceTrites, EntityType.ENTITY_FLAMINGHOPPER)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.unreplaceTrites, EntityType.ENTITY_MINISTRO)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon1.registerSpider, EntityType.ENTITY_SPIDER)