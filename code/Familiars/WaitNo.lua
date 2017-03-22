
local waitNo = {}

--main behaviour function
function waitNo:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	--Fires ipecac on hit
	local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if math.random(45) == 1 and (entities[i]:IsVulnerableEnemy()) and entities[i].Position:Distance(fam.Position) < 50 then
				Game():ButterBeanFart(fam.Position, 100, fam, true)
				famSprite:Play("Hit", true)
			end
		end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function waitNo:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function waitNo:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_WAIT_NO, player:GetCollectibleNum(CollectibleType.AGONY_C_WAIT_NO), player:GetCollectibleRNG(CollectibleType.AGONY_C_WAIT_NO)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, waitNo.updateFam, FamiliarVariant.AGONY_F_WAIT_NO)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, waitNo.initFam, FamiliarVariant.AGONY_F_WAIT_NO)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, waitNo.cacheUpdate)