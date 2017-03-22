
local TinyTinyHorn = {
	maxCooldown = 60,
	MaxOrbCount = 3,
	maxAnimCooldown = 8--[[,
	dbg = {no = "entries"},
	dbg2 = {data = "orbs"}]]--
}
--Orbspawner helper function
local function spawnOrb(fam)
	local famData = fam:GetData()
	local orb = Isaac.Spawn(EntityType.ENTITY_LITTLE_HORN, 1, 0, fam.Position, Vector(0,0), nil)
	orb:ToNPC().Scale = 0.5
	orb:SetSize(1, Vector(1,1), 8) --need this to set the numGridCollisionPoints
	orb:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_DONT_OVERWRITE | EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_NO_STATUS_EFFECTS )
	orb.MaxHitPoints = 5
	orb.HitPoints = 5
	
	famData.Orbs[#famData.Orbs+1] = orb --save it to orb-table of the familiar
end


--main behaviour function
function TinyTinyHorn:updateFam(fam)
	local famData = fam:GetData()
	local player = Isaac.GetPlayer(0)
	local fireDir = player:GetFireDirection()
	local famSprite = fam:GetSprite()
	
	if famData.Cooldown <= 0 and fireDir ~= Direction.NO_DIRECTION and #famData.Orbs < TinyTinyHorn.MaxOrbCount then
		famSprite.FlipX = false
		if fireDir == Direction.DOWN then
			famSprite:Play("FloatShootDown")
		elseif fireDir == Direction.UP then
			famSprite:Play("FloatShootUp")
		elseif fireDir == Direction.LEFT then
			famSprite:Play("FloatShootSide")
			famSprite.FlipX = true --only one animation for the side, have to flip it for left
		elseif fireDir == Direction.RIGHT then
			famSprite:Play("FloatShootSide")
		end
		famData.Cooldown = TinyTinyHorn.maxCooldown
		famData.animCooldown = TinyTinyHorn.maxAnimCooldown
		spawnOrb(fam)
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
			famData.noDirCooldown = TinyTinyHorn.maxAnimCooldown                                                                    --  after a cooldown                   --
		else																													 -----------------------------------------
			famData.noDirCooldown = famData.noDirCooldown - 1
		end
	elseif fireDir ~= Direction.NO_DIRECTION then
		famData.noDirCooldown = TinyTinyHorn.maxAnimCooldown
	end
	
	for entry, orb in pairs(famData.Orbs) do
		if not orb:Exists() then
			famData.Orbs[entry] = nil --delete all orbs that were killed so new ones can be made
		else
			local tmpTarget = Agony:getNearestEnemy(orb) --set nearest target
			if tmpTarget == orb or tmpTarget == player then
				orb.Target = fam
			else
				orb.Target = tmpTarget
			end
		end
	end
	
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function TinyTinyHorn:initFam(fam)
	local famData = fam:GetData()
	famData.Cooldown = famData.Cooldown or 0
	famData.Orbs = famData.Orbs or {}
	famData.animCooldown = 0
	famData.noDirCooldown = 0
	--TinyTinyHorn.dbg = famData
	--TinyTinyHorn.dbg2 = famData.Orbs
	fam:GetSprite():Play("FloatDown")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function TinyTinyHorn:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_TINY_TINY_HORN, player:GetCollectibleNum(CollectibleType.AGONY_C_TINY_TINY_HORN), player:GetCollectibleRNG(CollectibleType.AGONY_C_TINY_TINY_HORN)) --no idea what the rng is for, but it's needed
	end
end

--[[ debug function
function TinyTinyHorn:dbgtext()
	local count = 0
	local count2 = 0
	for a,b in pairs(TinyTinyHorn.dbg) do
		Isaac.RenderText(tostring(a).. ": " .. tostring(b), 150, 10 + count*10, 0, 255, 0, 255)
		count = count + 1
	end
	for a,b in pairs(TinyTinyHorn.dbg2) do
		Isaac.RenderText(tostring(a).. ": " .. tostring(b), 150, 10 + count2*10 + count*10, 255, 0, 255, 255)
		count2 = count2 + 1
	end
end ]]--

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, TinyTinyHorn.updateFam, FamiliarVariant.AGONY_F_TINY_TINY_HORN)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, TinyTinyHorn.initFam, FamiliarVariant.AGONY_F_TINY_TINY_HORN)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TinyTinyHorn.cacheUpdate)
--Agony:AddCallback(ModCallbacks.MC_POST_RENDER, TinyTinyHorn.dbgtext)