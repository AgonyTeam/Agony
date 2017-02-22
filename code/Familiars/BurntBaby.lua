CollectibleType["AGONY_C_BURNT_BABY"] = Isaac.GetItemIdByName("Burnt Baby")
FamiliarVariant["AGONY_F_BURNT_BABY"] = Isaac.GetEntityVariantByName("Burnt Baby")

local burntBaby = {
	cooldown = 0
}

--main behaviour function
function burntBaby:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local fireDir = player:GetFireDirection()
	local dirV = nil

	if player:GetShootingJoystick().X ~= 0 or player:GetShootingJoystick().Y ~= 0 then
		if burntBaby.cooldown <= 0  then
			famSprite.FlipX = false
			if fireDir == Direction.DOWN then
				famSprite:Play("FloatShootDown")
				dirV = Vector(0,1)
			elseif fireDir == Direction.UP then
				famSprite:Play("FloatShootUp")
				dirV = Vector(0,-1)
			elseif fireDir == Direction.LEFT then
				famSprite:Play("FloatShootSide")
				dirV = Vector(-1,0)
				famSprite.FlipX = true --only one animation for the side, have to flip it for left
			elseif fireDir == Direction.RIGHT then
				famSprite:Play("FloatShootSide")
				dirV = Vector(1,0)
			end
			burntBaby.cooldown = 60
			local fire = Isaac.Spawn(1000, 52, 1, fam.Position, dirV:__mul(5), fam);
			fire.CollisionDamage = 2;
		else
			famSprite:Play("FloatDown", false)
		end
	end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function burntBaby:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function burntBaby:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_BURNT_BABY, player:GetCollectibleNum(CollectibleType.AGONY_C_BURNT_BABY), player:GetCollectibleRNG(CollectibleType.AGONY_C_BURNT_BABY)) --no idea what the rng is for, but it's needed
	end
end

function burntBaby:onUpdate()
	if burntBaby.cooldown > 0 then
		burntBaby.cooldown = burntBaby.cooldown -1
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, burntBaby.updateFam, FamiliarVariant.AGONY_F_BURNT_BABY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, burntBaby.initFam, FamiliarVariant.AGONY_F_BURNT_BABY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, burntBaby.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, burntBaby.onUpdate)