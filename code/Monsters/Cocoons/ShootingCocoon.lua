local cocoon3 = {
	shootCooldown = 60, -- cooldown in entity updates until the next spider can spawn when hurt
	shootChance = 0.8,
}

function cocoon3:ai_update(ent)
	if ent.Variant == Agony.CocoonVariant.COCOON_SHOOTING then
		local data = ent:GetData()
		local rng = ent:GetDropRNG()

		--init variables in entdata
		if ent.State == NpcState.STATE_INIT then
			data.shootCooldown = cocoon3.shootCooldown
			ent.V1 = ent.Position
			ent.State = NpcState.STATE_IDLE
		else
			cocoon3:ai_movement(ent)
			cocoon3:ai_animation(ent, ent:GetSprite())
			--decrease cooldown
			if data.shootCooldown > 0 then
				data.shootCooldown = data.shootCooldown - 1
			elseif data.shootCooldown == 0 and rng:RandomFloat() < cocoon3.shootChance then
				cocoon3:ai_attack(ent, rng)
				data.shootCooldown = cocoon3.shootCooldown
			elseif data.shootCooldown == 0 then
				data.shootCooldown = cocoon3.shootCooldown/2
			end
		end
	end
end

function cocoon3:ai_movement(ent)
	--stick to place
	ent.Velocity = ent.V1:__sub(ent.Position)
end

function cocoon3:ai_attack(ent, rng)
	ent = ent:ToNPC()
	
	local tearConf = Agony:TearConf()
	tearConf.SpawnerEntity = ent
	tearConf.Color = Color(1,1,1,1,180,180,180)
	tearConf.Functions.onDeath = cocoon3.tear_onDeath

	ent:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES, 1, 0, false, 1)
	Agony:fireMonstroTearProj(1, 0, ent.Position, Agony:calcTearVel(ent.Position, ent:GetPlayerTarget().Position, 3), tearConf, 8, rng)
end

function cocoon3:ai_take_damage(ent, dmg, _,_,_)
	if ent.Variant == Agony.CocoonVariant.COCOON_SHOOTING and ent.HitPoints < dmg then
		ent = ent:ToNPC()
		local rng = ent:GetDropRNG()

		cocoon3:ai_attack(ent, rng)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_WHITE, 0, ent.Position, Vector(0,0), ent)
	end
end

function cocoon3:ai_animation(ent, sprite)
	ent = ent:ToNPC()
end

function cocoon3:tear_onDeath(pos, vel, ent)
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_WHITE, 0, pos, Vector(0,0), ent)
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, cocoon3.ai_update, EntityType.AGONY_ETYPE_COCOON)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, cocoon3.ai_take_damage, EntityType.AGONY_ETYPE_COCOON)
