CollectibleType["AGONY_C_SOULMATES"] = Isaac.GetItemIdByName("Soulmates")
FamiliarVariant["AGONY_F_SOULMATE_JULIET"] = Isaac.GetEntityVariantByName("Juliet")
FamiliarVariant["AGONY_F_SOULMATE_ROMEO"] = Isaac.GetEntityVariantByName("Romeo")

local soulmates = {}

--main behaviour function
function soulmates:updateFamJuliet(fam)
	local player = Isaac.GetPlayer(0)
	fam.OrbitDistance = Vector (125,150)
	fam.OrbitSpeed = 0.03
	fam.OrbitLayer = 68
	fam.Velocity = fam:GetOrbitPosition(player.Position:__add(player.Velocity)):__sub(fam.Position)
	fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
end

function soulmates:updateFamRomeo(fam)
	local player = Isaac.GetPlayer(0)
	fam.OrbitDistance = Vector (150,125)
	fam.OrbitSpeed = 0.03
	fam.OrbitLayer = 69
	fam.Velocity = fam:GetOrbitPosition(player.Position:__add(player.Velocity)):__sub(fam.Position)
	fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
end

--called on init
function soulmates:initFam(fam)
	fam:GetSprite():Play("Idle")
end

--needed or else the familiar won't appear
function soulmates:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_SOULMATE_JULIET, player:GetCollectibleNum(CollectibleType.AGONY_C_SOULMATES), player:GetCollectibleRNG(CollectibleType.AGONY_C_SOULMATES)) --no idea what the rng is for, but it's needed
		player:CheckFamiliar(FamiliarVariant.AGONY_F_SOULMATE_ROMEO, player:GetCollectibleNum(CollectibleType.AGONY_C_SOULMATES), player:GetCollectibleRNG(CollectibleType.AGONY_C_SOULMATES)) --no idea what the rng is for, but it's needed
	end
end

function soulmates:onTakeDmg(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
	if DamageSource.Variant == FamiliarVariant.AGONY_F_SOULMATE_ROMEO or DamageSource.Variant == FamiliarVariant.AGONY_F_SOULMATE_JULIET then
		if math.random(5) == 1 then
			TookDamage:AddCharmed(60)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, soulmates.updateFamJuliet, FamiliarVariant.AGONY_F_SOULMATE_JULIET)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, soulmates.updateFamRomeo, FamiliarVariant.AGONY_F_SOULMATE_ROMEO)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, soulmates.initFam, FamiliarVariant.AGONY_F_SOULMATE_JULIET)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, soulmates.initFam, FamiliarVariant.AGONY_F_SOULMATE_ROMEO)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, soulmates.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, soulmates.onTakeDmg)