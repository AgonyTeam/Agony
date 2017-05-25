local faithsReward = {}


function faithsReward:updateCache(player, cache)
	if player:HasCollectible(CollectibleType.AGONY_C_FAITHS_REWARD) and not saveData.faithsReward.tookDevilDeal and Agony:HasFlags(cache, CacheFlag.CACHE_DAMAGE) then
		player.Damage = (player.Damage*2)-1
	end
end

function faithsReward:updateDealChance(player)
	if player:HasCollectible(CollectibleType.AGONY_C_FAITHS_REWARD) and not saveData.faithsReward.tookDevilDeal then
		--debug_text = tostring(saveData.faithsReward.tookDevilDeal) .. " " .. tostring(saveData.faithsReward.devilItems)
		local room = Game():GetRoom()
		local level = Game():GetLevel()

		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_GOAT_HEAD, false) --give 100% deal precedent
		if room:GetType() == RoomType.ROOM_DEVIL then
			local ents = Isaac.GetRoomEntities()

			if saveData.faithsReward.devilItems == nil or room:GetFrameCount() <= 1 then
				saveData.faithsReward.devilItems = 0
				
				for _,ent in pairs(ents) do
					if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
						saveData.faithsReward.devilItems = saveData.faithsReward.devilItems + 1
					end
				end

				Agony:SaveNow()
			end

			local itemCount = 0
			for _, ent in pairs(ents) do
				if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
					itemCount = itemCount + 1
				end
			end

			if itemCount < saveData.faithsReward.devilItems then
				saveData.faithsReward.tookDevilDeal = true
				
				Agony:SaveNow()
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
				--debug_text = "evalled items " .. tostring(Game():GetFrameCount()) 
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, faithsReward.updateCache)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, faithsReward.updateDealChance)
