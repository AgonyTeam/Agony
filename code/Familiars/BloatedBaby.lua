
local bloatedBaby = {}

--main behaviour function
function bloatedBaby:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local famData = fam:GetData()
	--Fires ipecac on hit
	local entities = Isaac.GetRoomEntities()
	for i = 1, #entities do
		if (entities[i].Type == EntityType.ENTITY_PROJECTILE) and entities[i].Position:Distance(fam.Position) < 30 then
			local t = Isaac.Spawn(EntityType.ENTITY_TEAR, 0 , 0, fam.Position, Vector.FromAngle(math.random(360)):__mul(5), fam)
			t:ToTear().TearFlags = Agony:AddFlags(t:ToTear().TearFlags, TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON) --make tears ipecac
			t.Color = Color(0.5, 1, 0.5, 1, 0, 0, 0)
			table.insert(famData.Tears, t:ToTear())
			entities[i]:Remove()
			famSprite:Play("Hit", true)
		end
	end
	for _, tear in pairs(famData.Tears) do
		if tear.Height <= -10 then
			tear.Height = 0.1*(tear.FrameCount + ((player.TearHeight-13.5)/2))^2 + 2*(player.TearHeight-13.5) --ipecac arc function, got it pretty close to looking like vanilla I think
		end
		if not tear:Exists() then
			famData.Tears[_] = nil
		end
	end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function bloatedBaby:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam:GetData().Tears = {}
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function bloatedBaby:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_BLOATED_BABY, player:GetCollectibleNum(CollectibleType.AGONY_C_BLOATED_BABY), player:GetCollectibleRNG(CollectibleType.AGONY_C_BLOATED_BABY)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bloatedBaby.updateFam, FamiliarVariant.AGONY_F_BLOATED_BABY)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, bloatedBaby.initFam, FamiliarVariant.AGONY_F_BLOATED_BABY)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bloatedBaby.cacheUpdate)