local parasites =  {}

function parasites:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_PARASITES) then
		if not hurtEntity:IsBoss() and hurtEntity:IsActiveEnemy() and source.Entity.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == Agony.TearSubTypes.INFESTATION_3 and hurtEntity.Type ~= EntityType.ENTITY_MAGGOT then
			if hurtEntity:GetData().IsInfested ~= true then
				hurtEntity:AddPoison(EntityRef(player), 10, player.Damage / 1.5)
				hurtEntity:GetData().IsInfested = true
			end

			if hurtEntity:GetData().IsInfested == true and dmgAmount >= hurtEntity.HitPoints then
				Isaac.Spawn(EntityType.ENTITY_MAGGOT, 0, 0, hurtEntity.Position:__add(Vector(math.random(20)-10,math.random(20)-10)), Vector(0,0), hurtEntity).HitPoints = 1
			end
		end
	end
end

function parasites:onUpdate()
	local player = Isaac.GetPlayer(0)
	local ent = Isaac.GetRoomEntities()
	if player:HasCollectible(CollectibleType.AGONY_C_PARASITES) then
		if player.Luck > 0 then
			Prob = math.floor(math.random(5000)%(math.floor(300/(player.Luck+1))))
		elseif player.Luck == 0 then
			Prob = math.random(5000)%300
		else
			Prob = math.random(5000)%(-300*(player.Luck-1))
		end

		for i = 1, #ent do
			if ent[i].Type == EntityType.ENTITY_TEAR and ent[i].SpawnerType == EntityType.ENTITY_PLAYER and ent[i].SubType ~= Agony.TearSubTypes.INFESTATION_3 and ent[i].FrameCount == 1 then
				if Prob <= 15 then
					-- ent[i]:GetSprite():ReplaceSpritesheet(0, "gfx/effect/tear_jaundice.png")
					-- ent[i]:GetSprite():LoadGraphics()
					ent[i].SubType = Agony.TearSubTypes.INFESTATION_3
				end
			end
		end
	end
end


Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, parasites.onTakeDmg)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, parasites.onUpdate)
