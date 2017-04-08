--local item_techninek = Isaac.GetItemIdByName("Technology 9000");
local techninek = {
	TearBool = false,
}

function techninek:TearsToLaser()
	local player = Isaac.GetPlayer(0);
	local entities = Isaac.GetRoomEntities();
	local velocity = nil;
	local pos = nil;
	local tearParent = nil;
	
	--Replace tears with fires after gettign shot down
	if (player:HasCollectible(CollectibleType.AGONY_C_TECH_9000) == true) then
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR and (entities[i].Parent.Type == 1 or (entities[i].Parent.Type == 3 and entities[i].Parent.Variant == 80))) then --player == 1.0.0, incubus == 3.80.0
				
				velocity = entities[i].Velocity;
				pos = entities[i].Position;
				if pos:Distance(player.Position) > (125 + math.random(200)) then
					local fire = Isaac.Spawn(1000, 52, 1, pos, Vector (0,0), player);
					fire.CollisionDamage = player.Damage/10;
					entities[i]:Remove()
					local laser = player:FireTechLaser(player.Position, 0, Vector (pos.X-player.Position.X,pos.Y-player.Position.Y), false, true)
					laser:SetMaxDistance(pos:Distance(player.Position))
					pos = nil;
					velocity = nil;
					tearParent = nil;
				end
			end
			--Fires dissappear after time
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
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, techninek.TearsToLaser);