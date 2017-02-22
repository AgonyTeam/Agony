CollectibleType["AGONY_C_GRANDPA_FLY"] = Isaac.GetItemIdByName("Grandpa Fly")
FamiliarVariant["AGONY_F_GRANDPA_FLY"] = Isaac.GetEntityVariantByName("Grandpa Fly")

local grandpaFly = {}

--main behaviour function
function grandpaFly:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	if math.random(300) == 1 then
		famSprite:Play("Attack", true)
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BROWN_NUGGET_POOTER, 0, fam.Position, Vector (0,0), player)
	end
	if not famSprite:IsPlaying("Attack") then
		famSprite:Play("Fly", false)
	end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function grandpaFly:initFam(fam)
	fam:GetSprite():Play("Fly")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function grandpaFly:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_GRANDPA_FLY, player:GetCollectibleNum(CollectibleType.AGONY_C_GRANDPA_FLY), player:GetCollectibleRNG(CollectibleType.AGONY_C_GRANDPA_FLY)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, grandpaFly.updateFam, FamiliarVariant.AGONY_F_GRANDPA_FLY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, grandpaFly.initFam, FamiliarVariant.AGONY_F_GRANDPA_FLY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, grandpaFly.cacheUpdate)