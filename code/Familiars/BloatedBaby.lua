CollectibleType["AGONY_C_BLOATED_BABY"] = Isaac.GetItemIdByName("Bloated Baby")
FamiliarVariant["AGONY_F_BLOATED_BABY"] = Isaac.GetEntityVariantByName("Bloated Baby")

local bloatedBaby = {}

--main behaviour function
function bloatedBaby:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	--Fires ipecac on hit
	local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_PROJECTILE) and entities[i].Position:Distance(fam.Position) < 30 then
				local t = player:FireTear(fam.Position, Vector(math.random(2)-1, math.random(2)-1):__mul(3), false, true, false)
				t.Variant = TearVariant.BOBS_HEAD
				t.Color:SetColorize(0, 1, 0, 1)
				entities[i]:Remove()
				famSprite:Play("Hit", true)
			end
		end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function bloatedBaby:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function bloatedBaby:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_BLOATED_BABY, player:GetCollectibleNum(CollectibleType.AGONY_C_BLOATED_BABY), player:GetCollectibleRNG(CollectibleType.AGONY_C_BLOATED_BABY)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bloatedBaby.updateFam, FamiliarVariant.AGONY_F_BLOATED_BABY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, bloatedBaby.initFam, FamiliarVariant.AGONY_F_BLOATED_BABY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bloatedBaby.cacheUpdate)