--StartDebug();
--local item_GasolineJuicebox = Isaac.GetItemIdByName("Gasoline Juicebox");
CollectibleType["AGONY_C_GASOLINE_JB"] = Isaac.GetItemIdByName("Gasoline Juicebox");
local gasolinejb = {
	TearBool = false,
	hasItem = nil,
	costumeID = nil
};
gasolinejb.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_gasolinejuicebox.anm2")


function gasolinejb:cacheUpdate(player, cacheFlag)
	
	if (player:HasCollectible(CollectibleType.AGONY_C_GASOLINE_JB) == true) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage - 1;
		end
		
		--CACHE_FIREDELAY is broken rn so we need to use workarounds
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			gasolinejb.TearBool = true;
		end
		
		--Not really sure how to set range. Documentation gives me 3 different attributes for range
		if (cacheFlag == CacheFlag.CACHE_RANGE) then
			player.TearFallingSpeed = player.TearFallingSpeed - .5
		end
	end
end

function gasolinejb:TearsToFlames()
	local player = Isaac.GetPlayer(0);
	local entities = Isaac.GetRoomEntities();
	local velocity = nil;
	local pos = nil;
	local tearParent = nil;
	
	--Replace tears with fires
	if (player:HasCollectible(CollectibleType.AGONY_C_GASOLINE_JB) == true) then
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR and (entities[i].Parent.Type == 1 or (entities[i].Parent.Type == 3 and entities[i].Parent.Variant == 80))) then --player == 1.0.0, incubus == 3.80.0
				
				velocity = entities[i].Velocity;
				pos = entities[i].Position;
				tearParent = entities[i].Parent;
				
				entities[i]:Remove();
				
				local fire = Isaac.Spawn(1000, 52, 1, pos, velocity, tearParent);
				fire.CollisionDamage = player.Damage;
				if (player:HasCollectible(CollectibleType.COLLECTIBLE_CANDLE)) then --blue fires if the player has blue candle
					fire:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_blue.png")
					fire:GetSprite():LoadGraphics();
				end
				
				
				if (player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and fire.SpawnerType == 3 and fire.SpawnerVariant == 80) then --double the damage of incubus' fires if player has bffs!
					fire.CollisionDamage = player.Damage*2;
				end
				
				pos = nil;
				velocity = nil;
				tearParent = nil;
			end
			
			--Fires dissappear after time, unless isaac has the red candle
			if (entities[i].Type == 1000 and entities[i].Variant == 52 and (entities[i].SpawnerType == 1 or entities[i].SpawnerType == 3) and entities[i].SubType == 1 and not player:HasCollectible(CollectibleType.COLLECTIBLE_RED_CANDLE)) then
				if (entities[i].FrameCount % 100 == 0) then
					if (entities[i]:GetSprite():IsPlaying("FireStage00") == true) then
						entities[i]:GetSprite():Play("FireStage01");
					elseif (entities[i]:GetSprite():IsPlaying("FireStage01") == true) then
						entities[i]:GetSprite():Play("FireStage02");
					elseif (entities[i]:GetSprite():IsPlaying("FireStage02") == true) then
						entities[i]:GetSprite():Play("FireStage03");
					elseif (entities[i]:GetSprite():IsPlaying("FireStage03") == true) then
						entities[i]:Remove();
					end
				end
			end
			
			--Fires have homing effect when the player has blue candle
			if (entities[i].Type == 1000 and entities[i].Variant == 52 and (entities[i].SpawnerType == 1 or entities[i].SpawnerType == 3) and entities[i].SubType == 1 and player:HasCollectible(CollectibleType.COLLECTIBLE_CANDLE)) then
				entities[i].Velocity = entities[i].Velocity:__add(Agony:calcTearVel(entities[i].Position, (Agony:getNearestEnemy(entities[i])).Position, 0.5))
			end
			
			--destroy poop
			if (entities[i].Type == 1000 and entities[i].Variant == 52 and (entities[i].SpawnerType == 1 or entities[i].SpawnerType == 3) and entities[i].SubType == 1) then
				local room = Game():GetRoom();
				local grident_r = room:GetGridEntityFromPos(Vector(entities[i].Position.X + 25, entities[i].Position.Y));
				local grident_l = room:GetGridEntityFromPos(Vector(entities[i].Position.X - 25, entities[i].Position.Y));
				local grident_u = room:GetGridEntityFromPos(Vector(entities[i].Position.X, entities[i].Position.Y - 25));
				local grident_d = room:GetGridEntityFromPos(Vector(entities[i].Position.X, entities[i].Position.Y + 25));
				--debug_text = "toast "
				if ((grident_r ~= nil) and (grident_r.Desc.Type == GridEntityType.GRID_POOP)) then
					grident_r:Destroy(true);
					--debug_text = debug_text .. "plop r"
				end
				if ((grident_l ~= nil) and (grident_l.Desc.Type == GridEntityType.GRID_POOP)) then
					grident_l:Destroy(true);
					--debug_text = debug_text .. "plop l"
				end
				if ((grident_u ~= nil) and (grident_u.Desc.Type == GridEntityType.GRID_POOP)) then
					grident_u:Destroy(true);
					--debug_text = debug_text .. "plop u"
				end
				if ((grident_d ~= nil) and (grident_d.Desc.Type == GridEntityType.GRID_POOP)) then
					grident_d:Destroy(true);
					--debug_text = debug_text .. "plop d"
				end
			end
		end
	end
end

--FireDelay workaround
function gasolinejb:updateFireDelay()
	local player = Isaac.GetPlayer(0);
	if (gasolinejb.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay * 1.5 + 2;
		gasolinejb.TearBool = false;
	end
end


--Checks if player has item, and gives him the costume
function gasolinejb:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		gasolinejb.hasItem = false
	end
	if gasolinejb.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_GASOLINE_JB) then
		player:AddNullCostume(gasolinejb.costumeID)
		gasolinejb.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, gasolinejb.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, gasolinejb.cacheUpdate);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, gasolinejb.TearsToFlames);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, gasolinejb.updateFireDelay);