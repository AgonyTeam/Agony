CollectibleType["AGONY_C_CHEST_OF_CHESTS"] = Isaac.GetItemIdByName("Chest of Chests")
FamiliarVariant["AGONY_F_CHEST_OF_CHESTS"] = Isaac.GetEntityVariantByName("Chest of Chests")

local chestOfChests = {
	roomID = nil,
	isRoomClear = false,
	chestList = {}
}

table.insert(chestOfChests.chestList,PickupVariant.PICKUP_CHEST)
table.insert(chestOfChests.chestList,PickupVariant.PICKUP_SPIKEDCHEST)
table.insert(chestOfChests.chestList,PickupVariant.PICKUP_REDCHEST)
table.insert(chestOfChests.chestList,PickupVariant.PICKUP_LOCKEDCHEST)
table.insert(chestOfChests.chestList,PickupVariant.PICKUP_BOMBCHEST)
--table.insert(chestOfChests.chestList,PickupVariant.PICKUP_ETERNALCHEST)



--main behaviour function
function chestOfChests:updateFam(fam)
	local player = Isaac.GetPlayer(0)
	local famSprite = fam:GetSprite()
	local lvl = Game():GetLevel()
	local room = lvl:GetCurrentRoom()
	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
	col:Reset()

	if chestOfChests.roomID == nil or chestOfChests.roomID ~= lvl:GetCurrentRoomIndex() then
		chestOfChests.roomID = lvl:GetCurrentRoomIndex()
		chestOfChests.isRoomClear = room:IsClear()
	elseif chestOfChests.isRoomClear == false and room:IsClear() then
		chestOfChests.isRoomClear = true
		if player:GetCollectibleRNG(CollectibleType.AGONY_C_CHEST_OF_CHESTS):RandomInt(50) == 1 then
			famSprite:Play("Spawn")
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, ChestSubType.CHEST_CLOSED, fam.Position, Vector (0,0), player)
		elseif player:GetCollectibleRNG(CollectibleType.AGONY_C_CHEST_OF_CHESTS):RandomInt(5) == 1 then
			famSprite:Play("Spawn")
			Isaac.Spawn(EntityType.ENTITY_PICKUP, chestOfChests.chestList[player:GetCollectibleRNG(CollectibleType.AGONY_C_CHEST_OF_CHESTS):RandomInt(#chestOfChests.chestList)+1], ChestSubType.CHEST_CLOSED, fam.Position, Vector (0,0), player)
			Game():SpawnParticles(fam.Position, EffectVariant.POOF01, 1, 1, col, 0)
		end
	end
	
	if famSprite:IsFinished("Spawn") then
		famSprite:Play("FloatDown")
	end
	fam:FollowParent() --important so the familiar stays in the line of familiars
end

--called on init
function chestOfChests:initFam(fam)
	fam:GetSprite():Play("Idle")
	fam.IsFollower = true --important, or else it isn't a familiar that follows the player
	chestOfChests.roomID = nil
end

--needed or else the familiar won't appear
function chestOfChests:cacheUpdate(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(FamiliarVariant.AGONY_F_CHEST_OF_CHESTS, player:GetCollectibleNum(CollectibleType.AGONY_C_CHEST_OF_CHESTS), player:GetCollectibleRNG(CollectibleType.AGONY_C_CHEST_OF_CHESTS)) --no idea what the rng is for, but it's needed
	end
end

Agony:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, chestOfChests.updateFam, FamiliarVariant.AGONY_F_CHEST_OF_CHESTS)
Agony:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, chestOfChests.initFam, FamiliarVariant.AGONY_F_CHEST_OF_CHESTS)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, chestOfChests.cacheUpdate)