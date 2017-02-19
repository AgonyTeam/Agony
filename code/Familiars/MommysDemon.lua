CollectibleType["AGONY_C_MOMMYS_DEMON"] = Isaac.GetItemIdByName("Mommy's Demon")
FamiliarVariant["AGONY_F_MOMMYS_DEMON"] = Isaac.GetEntityVariantByName("Mommy's Demon")

local mommysDemon = {
	vDisplacement = nil,
	roomID = nil,
	hit = false,
	costumeID = nil
}
mommysDemon.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_mommysdemon.anm2")

--main behaviour function
function mommysDemon:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	--local room = Game():GetRoom();
	local player = Game():GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	local vulBool = false --is There a vulnerable Enemy in the room ?
	--Sort vulBool
	for j = 1, #entities do
		if (entities[j]:IsVulnerableEnemy()) then
			vulBool = true
			goto skip
		end
	end
	::skip::

	--Movement
	--resets on leaving the room
	if mommysDemon.roomID == nil or mommysDemon.roomID ~= Game():GetLevel():GetCurrentRoomIndex() then
		mommysDemon.roomID = Game():GetLevel():GetCurrentRoomIndex()
		mommysDemon:ResetMovement(fam,famSprite)
	end

	--Clamp movement
	fam.Velocity = fam.Velocity:Clamped(-5, -5, 5 , 5)
	if mommysDemon.hit == false then
		--Apply random movement
		if not famSprite:IsPlaying("Shoot") then
			if math.random(17) == 1 then
				fam:AddVelocity(Vector(math.random(10)-5,math.random(10)-5))
				if not famSprite:IsPlaying("Walking") then
						famSprite:Play("Walking", true)
				end
			end
			--Shoot
			if vulBool and math.random(25) == 1 then
				local target = Agony:getNearestEnemy(fam)
				local t = nil
				fam.Velocity = Vector(0, 0)
				famSprite:Play("Shoot", true)
					t = player:FireTear(fam.Position, target.Position:__sub(fam.Position):Normalized():__mul(10), false, true, false)
					t.Scale = t.Scale*1.5
					t.CollisionDamage = 10
			end
		end
	else
		--Run to player
		if fam.Visible then
			if fam.Position:Distance(player.Position) > 20 then
				mommysDemon.vDisplacement = player.Position
				famSprite:Play("Walking", true) --to be replaced by fleeing animation
				fam:AddVelocity(mommysDemon.vDisplacement:__sub(fam.Position):__div(100))
			else
				--make familiar disappear and add costume to player
				--player:AddNullCostume(mommysDemon.costumeID)
				fam.Visible = false
			end
		end
	end

	--Detect if hit
	for i = 1, #entities do
		if (entities[i].Type == EntityType.ENTITY_PROJECTILE or entities[i]:IsEnemy()) and entities[i].Position:Distance(fam.Position) < 10 then
			mommysDemon.hit = true
		end
	end
end

function mommysDemon:ResetMovement(fam,famSprite)
	fam.Velocity = Vector(0, 0)
	famSprite:Play("Idle", false)
	mommysDemon.vDisplacement = nil
	mommysDemon.hit = false
	--player:RemoveCostume(mommysDemon.costumeID)
	fam.Visible = true
end

--called on init
function mommysDemon:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
end

--needed or else the familiar won't appear
function mommysDemon:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_MOMMYS_DEMON, player:GetCollectibleNum(CollectibleType.AGONY_C_MOMMYS_DEMON), player:GetCollectibleRNG(CollectibleType.AGONY_C_MOMMYS_DEMON)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mommysDemon.updateFam, FamiliarVariant.AGONY_F_MOMMYS_DEMON)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mommysDemon.initFam, FamiliarVariant.AGONY_F_MOMMYS_DEMON)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mommysDemon.cacheUpdate)