joseph = {
	weakFlyList = {}
};

table.insert(joseph.weakFlyList,EntityType.ENTITY_FLY)
table.insert(joseph.weakFlyList,EntityType.ENTITY_ATTACKFLY)
table.insert(joseph.weakFlyList,EntityType.ENTITY_MOTER)
table.insert(joseph.weakFlyList,EntityType.ENTITY_DART_FLY)
table.insert(joseph.weakFlyList,EntityType.ENTITY_RING_OF_FLIES)

EntityType["AGONY_ETYPE_JOSEPH"] = Isaac.GetEntityTypeByName("Joseph");



function joseph:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();
	local player = Game():GetPlayer(0)
	
	--Movements
	--Add random movement
	if math.random(15) == 1 then
		entity:AddVelocity(Vector (math.random(4)-2,math.random(4)-2))
	end
	--flee
	if entity.HitPoints > entity.MaxHitPoints/3 then
		--if the player is too close
		if math.random(4) == 1 then
			if entity.Position:Distance(player.Position) < 200 then
				entity:AddVelocity(entity.Position:__sub(player.Position):Normalized():__mul(1))
			elseif math.random(4) == 1 then
				entity.Velocity = Vector(0,0)
			end
		end
		--clamp max speed
		entity.Velocity = entity.Velocity:Normalized():__mul(5)
	else
		--chase player
		if math.random(4) == 1 then
			entity:AddVelocity(player.Position:__sub(entity.Position):Normalized():__mul(2))
		end
		--clamp max speed a little bit higher
		entity.Velocity = entity.Velocity:Normalized():__mul(6.5)
	end

	--Attacks
	if math.random(10) == 1 then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_YELLOW, 0, entity.Position, Vector (0,0), entity)
	end
	if math.random(75) == 1 then
		if math.random(2) == 1 then
			Isaac.Spawn(joseph.weakFlyList[math.random(#joseph.weakFlyList)], 0, 0, entity.Position:__add(Vector (math.random(6)-3,math.random(6)-3)), Vector (0,0), entity)
		elseif math.random(2) == 1 then
			for i = 1, math.random(5)+3, 1 do
				local t = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, (Agony:calcTearVel(entity.Position, player.Position, math.random(5)+5)):Rotated(math.random(60)-30), entity);
				t.SpawnerEntity = entity
			end
		elseif math.random(2) == 1 then
			Game():ButterBeanFart(entity.Position, 1000, entity, true)
		end
	end


end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, joseph.ai_main, EntityType.AGONY_ETYPE_JOSEPH);