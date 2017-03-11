CollectibleType["AGONY_C_TESLA_BABY"] = Isaac.GetItemIdByName("Tesla Baby")
FamiliarVariant["AGONY_F_TESLA_BABY"] = Isaac.GetEntityVariantByName("Tesla Baby")

local teslaBaby = {}

--main behaviour function
function teslaBaby:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	--Shoot bouncing laser
	local entA = fam 
	local entB = Agony:getNearestEnemy(fam)
	if entB ~= entA and math.random(60) == 1 then
		for j = 1, 3, 1 do
			if entB.Position:Distance(entA.Position) < 150 and entB ~= entA then
				l = player:FireTechLaser(entA.Position, 0, entB.Position:__sub(entA.Position), false, true)
				l:SetMaxDistance(entB.Position:Distance(entA.Position))
				entA = entB
				entB = Agony:getNearestEnemy(entA)
			else
				break 
			end
		end
		famSprite:Play("Shoot", true)
	end
	if famSprite:IsFinished("Shoot") then
		famSprite:Play("Idle", false)
	end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function teslaBaby:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function teslaBaby:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_TESLA_BABY, player:GetCollectibleNum(CollectibleType.AGONY_C_TESLA_BABY), player:GetCollectibleRNG(CollectibleType.AGONY_C_TESLA_BABY)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, teslaBaby.updateFam, FamiliarVariant.AGONY_F_TESLA_BABY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, teslaBaby.initFam, FamiliarVariant.AGONY_F_TESLA_BABY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, teslaBaby.cacheUpdate)