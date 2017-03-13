CollectibleType["AGONY_C_BURNT_BABY"] = Isaac.GetItemIdByName("Burnt Baby")
FamiliarVariant["AGONY_F_BURNT_BABY"] = Isaac.GetEntityVariantByName("Burnt Baby")

local burntBaby = {
	maxCooldown = 60,
	maxAnimCooldown = 8
}

--main behaviour function
function burntBaby:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local famData = fam:GetData()
	local fireDir = player:GetFireDirection()
	local dirV = nil
	debug_tbl1 = famData
	--debug_text = tostring(famSprite:GetFrame())
	
	if famData.Cooldown <= 0 and fireDir ~= Direction.NO_DIRECTION then
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
		famData.Cooldown = burntBaby.maxCooldown
		famData.animCooldown = burntBaby.maxAnimCooldown
		local fire = Isaac.Spawn(1000, 52, 1, fam.Position, dirV:__mul(5), fam);
		fire.CollisionDamage = 2;
	end
	
	if famData.Cooldown > 0 then
		famData.Cooldown = famData.Cooldown - 1
	end
	
	if famData.animCooldown == 0 then                                                                                         --------------------------------------------
		if fireDir == Direction.DOWN and not famSprite:IsPlaying("FloatDown") then                                            --  This stops the FloatShoot* anims when	--
			famSprite:Play("FloatDown")                                                                                       --  animCooldown is 0	  					--
			famSprite.FlipX = false                                                                                           --------------------------------------------
		elseif fireDir == Direction.UP and not famSprite:IsPlaying("FloatUp") then                                            
			famSprite:Play("FloatUp")                                                                                         
			famSprite.FlipX = false
		elseif fireDir == Direction.LEFT and not (famSprite:IsPlaying("FloatSide") and famSprite.FlipX) then
			famSprite:Play("FloatSide")
			famSprite.FlipX = true --only one animation for the side, have to flip it for left
		elseif fireDir == Direction.RIGHT and not (famSprite:IsPlaying("FloatSide") and not famSprite.FlipX) then
			famSprite:Play("FloatSide")
			famSprite.FlipX = false
		end
	else
		if fireDir == Direction.DOWN and not famSprite:IsPlaying("FloatShootDown") then                                         ------------------------------------------ 
			famSprite:Play("FloatShootDown")                                                                                    --	This block adjusts the anims while	-- 
			famSprite.FlipX = false                                                                                             --	the familiar is shooting, but the   -- 
		elseif fireDir == Direction.UP and not famSprite:IsPlaying("FloatShootUp") then                                         --	player changes fireDir, until		-- 
			famSprite:Play("FloatShootUp")                                                                                      --	animCooldown reaches 0				-- 
			famSprite.FlipX = false                                                                                             ------------------------------------------
		elseif fireDir == Direction.LEFT and not (famSprite:IsPlaying("FloatShootSide") and famSprite.FlipX)then                
			famSprite:Play("FloatShootSide")                                                                                    
			famSprite.FlipX = true --only one animation for the side, have to flip it for left                                  
		elseif fireDir == Direction.RIGHT and not (famSprite:IsPlaying("FloatShootSide") and not famSprite.FlipX) then          
			famSprite:Play("FloatShootSide")                                                                                    
			famSprite.FlipX = false                                                                                             
		end                                                                                                                     
		famData.animCooldown = famData.animCooldown - 1
	end
	
	if fireDir == Direction.NO_DIRECTION and not famSprite:IsPlaying("FloatDown") then                                           -----------------------------------------
		if famData.noDirCooldown == 0 then                                                                                       --  If the player stops firing, but the--
			famSprite:Play("FloatDown")                                                                                          --  familiar isn't playing the right   --
			famSprite.FlipX = false                                                                                              --  anim, it'll set it to FloatDown    --
			famData.noDirCooldown = burntBaby.maxAnimCooldown                                                                    --  after a cooldown                   --
		else																													 -----------------------------------------
			famData.noDirCooldown = famData.noDirCooldown - 1
		end
	elseif fireDir ~= Direction.NO_DIRECTION then
		famData.noDirCooldown = burntBaby.maxAnimCooldown
	end

	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function burntBaby:initFam(fam)
	fam:GetSprite():Play("FloatDown")
	fam:GetData().Cooldown = 0  --init them Cooldowns
	fam:GetData().animCooldown = 0
	fam:GetData().noDirCooldown = 0
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function burntBaby:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_BURNT_BABY, player:GetCollectibleNum(CollectibleType.AGONY_C_BURNT_BABY), player:GetCollectibleRNG(CollectibleType.AGONY_C_BURNT_BABY)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, burntBaby.updateFam, FamiliarVariant.AGONY_F_BURNT_BABY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, burntBaby.initFam, FamiliarVariant.AGONY_F_BURNT_BABY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, burntBaby.cacheUpdate)