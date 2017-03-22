
local Sacks3 = {
	--levelSeed = saveData.Sacks3.levelSeed
	roomID = saveData.Sacks3.roomID
}
local Sacks2 = {
	levelSeed = saveData.Sacks2.levelSeed,
	sackItems = {}
}
--all sackitems that can be spawned
table.insert(Sacks2.sackItems, CollectibleType.COLLECTIBLE_BOMB_BAG)
table.insert(Sacks2.sackItems, CollectibleType.COLLECTIBLE_RUNE_BAG)
table.insert(Sacks2.sackItems, CollectibleType.COLLECTIBLE_SACK_OF_SACKS)
table.insert(Sacks2.sackItems, CollectibleType.COLLECTIBLE_MYSTERY_SACK)
table.insert(Sacks2.sackItems, CollectibleType.COLLECTIBLE_SACK_OF_PENNIES)

--local helper functions
local function updateLevelSeed()
	Sacks2.levelSeed = Game():GetLevel():GetDungeonPlacementSeed()
	saveData.Sacks2.levelSeed = Sacks2.levelSeed
	Agony:SaveNow()
end

local function updateRoomID()
	Sacks3.roomID = Game():GetLevel():GetCurrentRoomIndex()
	saveData.Sacks3.roomID = Sacks3.roomID
	Agony:SaveNow()
end

--main behaviour function
function Sacks3:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local rng = fam:GetDropRNG()
	
	if Sacks3.roomID == nil then
		updateRoomID()
	elseif Sacks3.roomID ~= Game():GetLevel():GetCurrentRoomIndex() and rng:RandomInt(100) < 25 and player:GetCollectibleNum(CollectibleType.AGONY_C_SACK_OF_SACKS_OF_SACKS) > player:GetCollectibleNum(CollectibleType.AGONY_C_SACK_OF_BAGS) then
		player:AddCollectible(CollectibleType.AGONY_C_SACK_OF_BAGS, 0, false)
		famSprite:Play("Spawn")
		updateRoomID()
	elseif Sacks3.roomID ~= Game():GetLevel():GetCurrentRoomIndex() then
		updateRoomID()
	end
	
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

function Sacks2:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_SACK_OF_BAGS)
	
	if Sacks2.levelSeed == nil then
		updateLevelSeed()
	elseif Sacks2.levelSeed ~= Game():GetLevel():GetDungeonPlacementSeed() then
		for i=1, player:GetCollectibleNum(CollectibleType.AGONY_C_SACK_OF_BAGS) do
			local r = rng:RandomInt(100)
			if r < 50 then
				local availableSacks = {}
				for _, collID in pairs(Sacks2.sackItems) do
					if not player:HasCollectible(collID) then
						table.insert(availableSacks, collID)
					end
				end
				
				if #availableSacks > 0 then
					player:AddCollectible(availableSacks[rng:RandomInt(#availableSacks)+1], 0, false)
				end
			elseif r == 99 then
				player:AddCollectible(CollectibleType.AGONY_C_SACK_OF_BAGS, 0, false)
			end
		end
		famSprite:Play("Spawn")
		
		updateLevelSeed()
	elseif Sacks2.levelSeed ~= Game():GetLevel():GetDungeonPlacementSeed() then
		updateLevelSeed()
	end
	
	
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function Sacks3:initFam(fam)
	fam:GetSprite():Play("FloatDown")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
end

--needed or else the familiar won't appear
function Sacks3:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_SACK_OF_SACKS_OF_SACKS, player:GetCollectibleNum(CollectibleType.AGONY_C_SACK_OF_SACKS_OF_SACKS), player:GetCollectibleRNG(CollectibleType.AGONY_C_SACK_OF_SACKS_OF_SACKS)) --no idea what the rng is for, but it's needed
		player:CheckFamiliar(FamiliarVariant.AGONY_F_SACK_OF_BAGS, player:GetCollectibleNum(CollectibleType.AGONY_C_SACK_OF_BAGS), player:GetCollectibleRNG(CollectibleType.AGONY_C_SACK_OF_BAGS))
	end
end

function Sacks3:resetSaveData()
	if Game():GetFrameCount() <= 1 then
		Sacks3.roomID = nil
		Sacks2.levelSeed = nil
		saveData.Sacks3 = {}
		saveData.Sacks2 = {}
		Agony:SaveNow()
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Sacks3.updateFam, FamiliarVariant.AGONY_F_SACK_OF_SACKS_OF_SACKS)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Sacks2.updateFam, FamiliarVariant.AGONY_F_SACK_OF_BAGS)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Sacks3.initFam, FamiliarVariant.AGONY_F_SACK_OF_SACKS_OF_SACKS)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Sacks3.initFam, FamiliarVariant.AGONY_F_SACK_OF_BAGS)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Sacks3.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Sacks3.resetSaveData)