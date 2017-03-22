
local metalBaby = {}

--main behaviour function
function metalBaby:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	--Reflects enemy tears
	local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_PROJECTILE) and entities[i].Position:Distance(fam.Position) < 30 then
				fam:FireProjectile(entities[i].Velocity:__mul(-1):Clamped(-0.5, -0.5, 0.5, 0.5))
				entities[i]:Remove()
				famSprite:Play("Hit", true)
			end
		end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function metalBaby:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function metalBaby:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_METAL_BABY, player:GetCollectibleNum(CollectibleType.AGONY_C_METAL_BABY), player:GetCollectibleRNG(CollectibleType.AGONY_C_METAL_BABY)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, metalBaby.updateFam, FamiliarVariant.AGONY_F_METAL_BABY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, metalBaby.initFam, FamiliarVariant.AGONY_F_METAL_BABY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, metalBaby.cacheUpdate)