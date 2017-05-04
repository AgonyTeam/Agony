local cocoon2 = {
	spawnCooldown = 60, -- cooldown in entity updates until the next spider can be spawned
	maxSpiders = 3, -- max number of spiders from single cocoon 1 on screen
	spiders = Agony.ENUMS["EnemyLists"]["SpiderCocoon"],
	spawnChance = 0.7
}

function cocoon2:ai_update(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_CHASING then
		local data = ent:GetData()
		local rng = ent:GetDropRNG()
		
		--init variables in entdata
		if ent.State == NpcState.STATE_INIT then
			data.spawnCooldown = cocoon2.spawnCooldown
			data.spiders = {}
			ent.V1 = ent.Position
			ent.State = NpcState.STATE_IDLE
		else
			--decrease cooldown
			if data.spawnCooldown > 0 then
				data.spawnCooldown = data.spawnCooldown - 1
			elseif data.spawnCooldown == 0 and ent.State == NpcState.STATE_MOVE and #data.spiders < cocoon2.maxSpiders and rng:RandomFloat() < cocoon2.spawnChance then
				ent.State = NpcState.STATE_ATTACK
			else
				data.spawnCooldown = cocoon2.spawnCooldown
			end
		end
	end
end

function cocoon2:ai_reset_spiders(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_CHASING then
		--remove dead spiders from spider list
		if ent.State > NpcState.STATE_INIT then
			local data = ent:GetData()
			for i, sp in pairs(data.spiders) do
				if not sp:Exists() then
					data.spiders[i] = nil
				end
			end
		end
	end
end

function cocoon2:ai_movement(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_CHASING then
		local rng = ent:GetDropRNG()
		--stick to place if not awake
		if ent.State > NpcState.STATE_INIT and ent.State ~= NpcState.STATE_MOVE and ent.State ~= NpcState.STATE_ATTACK then
			ent.Velocity = ent.V1:__sub(ent.Position)
		--chase player if awake
		elseif ent.State == NpcState.STATE_MOVE then
			ent.Velocity = Agony:calcEntVel(ent, ent:GetPlayerTarget(), (4+(1.5*rng:RandomFloat()+0.1)))
			debug_text = ent.Velocity:Length()
		--stop while attacking
		elseif ent.State == NpcState.STATE_ATTACK then
			ent.Velocity = ent.Velocity:__add(ent.Velocity:__mul(-0.15))
		end
	end
end

function cocoon2:ai_take_damage(ent, dmg, _,_,_)
	ent = ent:ToNPC()
	--if hit and not chasing, awake
	if ent.Variant == Agony.CocoonVariant.COCOON_CHASING and ent.State == NpcState.STATE_IDLE then
		ent.State = NpcState.STATE_MOVE
	end
end

function cocoon2:ai_sprite(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_CHASING then
		if ent.State == NpcState.STATE_ATTACK then
		end
	end
end

function cocoon2:ai_attack(ent)
	ent = ent:ToNPC()
	
	if ent.Variant == Agony.CocoonVariant.COCOON_CHASING and ent.State == NpcState.STATE_ATTACK then
		local data = ent:GetData()
		if ent.Velocity:Length() <= 1 then
			EntityNPC.ThrowSpider(ent.Position, ent, Isaac.GetFreeNearPosition(ent.Position, 75), false, 1)
			ent:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 1.2)
			--table.insert(data.spiders, spider) --spider registration code handled in SpiderCocoon.lua
			data.spawnCooldown = cocoon2.spawnCooldown
			ent.State = NpcState.STATE_MOVE
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon2.ai_update, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon2.ai_reset_spiders, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon2.ai_movement, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon2.ai_sprite, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon2.ai_attack, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, cocoon2.ai_take_damage, EntityType.AGONY_ETYPE_COCOON)