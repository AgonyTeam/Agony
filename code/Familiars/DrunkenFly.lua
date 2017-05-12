
local drunkenFly = {}

--main behaviour function
function drunkenFly:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	fam.OrbitDistance = Vector (100,100)
	fam.OrbitSpeed = 0.03
	fam.OrbitLayer = 71
	local orbitPos = fam:GetOrbitPosition( player.Position + player.Velocity )
	local swingMotion = math.sin( Game():GetFrameCount() / 3 + fam:GetData().swingOffset ) / 5
	fam.Velocity = orbitPos - fam.Position + ( ( player.Position - fam.Position ) * swingMotion )
end

--called on init
function drunkenFly:initFam(fam)
	local player = Isaac.GetPlayer(0)
	fam:GetSprite():Play("Idle")
	fam.OrbitLayer = 71
	fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
	fam:GetData().swingOffset = math.random(1000) / 200.0
end

--needed or else the familiar won't appear
function drunkenFly:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_DRUNKEN_FLY, player:GetCollectibleNum(CollectibleType.AGONY_C_DRUNKEN_FLY), player:GetCollectibleRNG(CollectibleType.AGONY_C_DRUNKEN_FLY)) --no idea what the rng is for, but it's needed
	end
end

function drunkenFly:onTakeDmg(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
	if DamageSource.Variant == FamiliarVariant.AGONY_F_DRUNKEN_FLY and DamageSource.Type == 3 then
		if math.random(5) == 1 then
			TookDamage:AddConfusion(DamageSource, 60, false)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, drunkenFly.updateFam, FamiliarVariant.AGONY_F_DRUNKEN_FLY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, drunkenFly.initFam, FamiliarVariant.AGONY_F_DRUNKEN_FLY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, drunkenFly.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, drunkenFly.onTakeDmg)