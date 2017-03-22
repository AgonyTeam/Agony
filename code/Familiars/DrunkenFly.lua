
local soulmates = {}

--main behaviour function
function soulmates:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	fam.OrbitDistance = Vector (100,100)
	fam.OrbitSpeed = 0.03
	fam.OrbitLayer = 71
	fam.Velocity = fam:GetOrbitPosition(player.Position:__add(player.Velocity)):__sub(fam.Position):__add(player.Position:__sub(fam.Position):__mul(math.sin(Game():GetFrameCount()/3)/5))
end

--called on init
function soulmates:initFam(fam)
	local player = Isaac.GetPlayer(0)
	fam:GetSprite():Play("Idle")
	fam.OrbitLayer = 71
	fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
end

--needed or else the familiar won't appear
function soulmates:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_DRUNKEN_FLY, player:GetCollectibleNum(CollectibleType.AGONY_C_DRUNKEN_FLY), player:GetCollectibleRNG(CollectibleType.AGONY_C_DRUNKEN_FLY)) --no idea what the rng is for, but it's needed
	end
end

function soulmates:onTakeDmg(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
	if DamageSource.Variant == FamiliarVariant.AGONY_F_DRUNKEN_FLY then
		if math.random(5) == 1 then
			TookDamage:AddConfusion(DamageSource, 60, false)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, soulmates.updateFam, FamiliarVariant.AGONY_F_DRUNKEN_FLY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, soulmates.initFam, FamiliarVariant.AGONY_F_DRUNKEN_FLY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, soulmates.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, soulmates.onTakeDmg)