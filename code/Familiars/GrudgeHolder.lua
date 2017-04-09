
local GrudgeHolder = {}

--main behaviour function
function GrudgeHolder:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local dirVec = fam:GetData().dirVec
	local famSprite = fam:GetSprite()
	fam.OrbitDistance = Vector (100,100)
	fam.OrbitSpeed = 0.03
	fam.OrbitLayer = 70
	fam.Velocity = fam:GetOrbitPosition(player.Position:__add(player.Velocity)):__sub(fam.Position)
	if Game():GetFrameCount()%player.MaxFireDelay*20 == 0 and (player:GetShootingJoystick().X ~= 0 or player:GetShootingJoystick().Y ~= 0) then
		player:FireTear(fam.Position, player.Position:__sub(fam.Position):__mul(0.1), false, true, false)
	end
	dirVec = player.Position:__sub(fam.Position):Normalized()
	if dirVec.X <= 0.5 and dirVec.X >= -0.5 and dirVec.Y >= 0.5 and not famSprite:IsPlaying("float front")  then
		famSprite.FlipX = false
		famSprite:Play("float front")
	elseif dirVec.X >= 0.5 and dirVec.Y <= 0.5 and dirVec.Y >= -0.5 and not famSprite:IsPlaying("float side") then
		famSprite.FlipX = false
		famSprite:Play("float side")
	elseif dirVec.X <= 0.5 and dirVec.X >= -0.5 and dirVec.Y <= -0.5 and not famSprite:IsPlaying("float back") then
		famSprite.FlipX = false
		famSprite:Play("float back")
	elseif dirVec.X <= -0.5 and dirVec.Y <= 0.5 and dirVec.Y >= -0.5 and not famSprite:IsPlaying("float side") then
		famSprite.FlipX = true
		famSprite:Play("float side")
	end
	debug_text = tostring(player.Position:__sub(fam.Position):Normalized().X) .. " Y: " .. tostring(player.Position:__sub(fam.Position):Normalized().Y)
end

--called on init
function GrudgeHolder:initFam(fam)
	fam:GetSprite():Play("float front")
	fam:GetData().dirVec = Vector(0,1)
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