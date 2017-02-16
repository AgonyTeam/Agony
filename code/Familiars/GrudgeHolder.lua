CollectibleType["AGONY_C_GRUDGE_HOLDER"] = Isaac.GetItemIdByName("Grudge Holder")
FamiliarVariant["AGONY_F_GRUDGE_HOLDER"] = Isaac.GetEntityVariantByName("Grudge Holder")

local GrudgeHolder = {}

--main behaviour function
function GrudgeHolder:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	fam.OrbitDistance = Vector (100,100)
	fam.OrbitSpeed = 0.03
	fam.OrbitLayer = 7
	fam.Velocity = fam:GetOrbitPosition(player.Position:__add(player.Velocity)):__sub(fam.Position)
	if Game():GetFrameCount()%player.MaxFireDelay*20 == 0 and (player:GetShootingJoystick().X ~= 0 or player:GetShootingJoystick().Y ~= 0) then
		player:FireTear(fam.Position, player.Position:__sub(fam.Position):__mul(0.1), false, true, false)
	end
end

--called on init
function GrudgeHolder:initFam(fam)
	fam:GetSprite():Play("Directions")
end

--needed or else the familiar won't appear
function GrudgeHolder:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_GRUDGE_HOLDER, player:GetCollectibleNum(CollectibleType.AGONY_C_GRUDGE_HOLDER), player:GetCollectibleRNG(CollectibleType.AGONY_C_GRUDGE_HOLDER)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, GrudgeHolder.updateFam, FamiliarVariant.AGONY_F_GRUDGE_HOLDER)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, GrudgeHolder.initFam, FamiliarVariant.AGONY_F_GRUDGE_HOLDER)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, GrudgeHolder.cacheUpdate)