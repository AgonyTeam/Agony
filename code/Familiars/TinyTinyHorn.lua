CollectibleType["AGONY_C_TINY_TINY_HORN"] = Isaac.GetItemIdByName("Tiny Tiny Horn")
FamiliarVariant["AGONY_F_TINY_TINY_HORN"] = Isaac.GetEntityVariantByName("Tiny Tiny Horn")

local TinyTinyHorn = {
	Cooldown = 60,
	MaxOrbCount = 3--[[,
	dbg = {no = "entries"},
	dbg2 = {data = "orbs"}]]--
}

--main behaviour function
function TinyTinyHorn:updateFam(fam)
	local data = fam:GetData()
	local player = Isaac.GetPlayer(0)
	local fireDir = player:GetFireDirection()
	local famSprite = fam:GetSprite()
	
	if data.Cooldown <= 0 and #data.Orbs < TinyTinyHorn.MaxOrbCount and fireDir ~= Direction.NO_DIRECTION then --if the cooldown is 0, the orb per familiar cap isn't reached and the player is actually firing
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
		
		--spawn the orb
		local orb = Isaac.Spawn(EntityType.ENTITY_LITTLE_HORN, 1, 0, fam.Position, Vector(0,0), nil)
		orb:ToNPC().Scale = 0.5
		orb:SetSize(1, Vector(1,1), 8) --need this to set the numGridCollisionPoints
		orb:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_DONT_OVERWRITE | EntityFlag.FLAG_CHARM | EntityFlag.FLAG_NO_STATUS_EFFECTS )
		orb:ToNPC().CanShutDoors = false
		orb.CollisionDamage = 0 --this apparently only affects the player, enemies are still damaged through charm
		
		local tmpTarget = Agony:getNearestEnemy(orb) --target nearest enemy
		if tmpTarget == orb or tmpTarget == player then --target the familiar if there are no enemies or the player gets targeted
			orb.Target = fam
		else
			orb.Target = tmpTarget
		end
		
		data.Orbs[#data.Orbs+1] = orb --save it to orb-table of the familiar
		data.Cooldown = TinyTinyHorn.Cooldown --reset cooldown
	elseif data.Cooldown > 0 then
		if famSprite:IsFinished("FloatShootDown") or famSprite:IsFinished("FloatShootUp") or famSprite:IsFinished("FloatShootSide") then
			fam:GetSprite():Play("FloatDown")
		end
	
		data.Cooldown = data.Cooldown - 1
	end
	
	for entry, orb in pairs(data.Orbs) do
		if not orb:Exists() then
			data.Orbs[entry] = nil --delete all orbs that were killed so new ones can be made
		else
			local tmpTarget = Agony:getNearestEnemy(orb)
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
	local data = fam:GetData()
	data.Cooldown = data.Cooldown or 0
	data.Orbs = data.Orbs or {}
	--TinyTinyHorn.dbg = data
	--TinyTinyHorn.dbg2 = data.Orbs
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