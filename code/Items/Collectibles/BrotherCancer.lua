--local item_BrotherCancer = Isaac.GetItemIdByName("Brother Cancer")
--local item_Tumor = Isaac.GetItemIdByName("Tumor")
CollectibleType["AGONY_C_BROTHER_CANCER"] = Isaac.GetItemIdByName("Brother Cancer");
CollectibleType["AGONY_C_TUMOR"] = Isaac.GetItemIdByName("Tumor");
local tumor =  {
	costumeID = nil,
	hasItem = nil
}

tumor.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_brothercancer.anm2")

function tumor:spawnTumor()
	local player = Isaac.GetPlayer(0)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.AGONY_C_TUMOR, Isaac.GetFreeNearPosition(player.Position, 25), Vector(0, 0), player)
end

function tumor:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		tumor.hasItem = false
	end
	if tumor.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_TUMOR) then
		--player:AddNullCostume(tumor.costumeID)
		tumor.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, tumor.onUpdate)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, tumor.spawnTumor, CollectibleType.AGONY_C_BROTHER_CANCER)