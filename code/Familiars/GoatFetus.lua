CollectibleType["AGONY_C_GOAT_FETUS"] = Isaac.GetItemIdByName("Goat Fetus")
FamiliarVariant["AGONY_F_GOAT_FETUS"] = Isaac.GetEntityVariantByName("Goat Fetus")

local goatFetus = {
	v = Vector(3,3)
}

--main behaviour function
function goatFetus:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local EntList = Isaac.GetRoomEntities()

	--Attract enemy projectiles
	local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_PROJECTILE) and entities[i].Position:Distance(fam.Position) < 200 then
				entities[i]:AddVelocity((entities[i].Position:__sub(fam.Position)):__div(entities[i].Position:DistanceSquared(fam.Position)/-99))
				famSprite:Play("Hit", true)
			end
		end
	--Movement
	local room = Game():GetRoom();

	local col_up = room.GetGridCollisionAtPos(room, Vector(fam.Position.X, fam.Position.Y - 20));
	local col_down = room.GetGridCollisionAtPos(room, Vector(fam.Position.X, fam.Position.Y + 20));
	local col_left = room.GetGridCollisionAtPos(room, Vector(fam.Position.X - 20, fam.Position.Y));
	local col_right = room.GetGridCollisionAtPos(room, Vector(fam.Position.X + 20, fam.Position.Y));
		
		if(col_up == 1 or 
		   col_up == 3 or 
		   col_up == 4) then
		   
		  goatFetus.v = Vector(fam.Velocity.X, 3);
		end  
		
		if(col_down == 1 or 
		   col_down == 3 or 
		   col_down == 4) then
		   
		   goatFetus.v = Vector(fam.Velocity.X, -3);
		end

		if(col_left == 1 or
		   col_left == 3 or 
		   col_left == 4) then
		   
		   goatFetus.v = Vector(3, fam.Velocity.Y);
		end  
		
		if(col_right == 1 or
		   col_right == 3 or 
		   col_right == 4) then
		   
		   goatFetus.v = Vector(-3, fam.Velocity.Y);
		end

		fam.Velocity = goatFetus.v
end

--called on init
function goatFetus:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function goatFetus:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_GOAT_FETUS, player:GetCollectibleNum(CollectibleType.AGONY_C_GOAT_FETUS), player:GetCollectibleRNG(CollectibleType.AGONY_C_GOAT_FETUS)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, goatFetus.updateFam, FamiliarVariant.AGONY_F_GOAT_FETUS)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, goatFetus.initFam, FamiliarVariant.AGONY_F_GOAT_FETUS)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, goatFetus.cacheUpdate)