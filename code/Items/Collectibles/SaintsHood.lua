local saintsHood = {}


function saintsHood:updateCache(player, cache)
	if player:HasCollectible(CollectibleType.AGONY_C_SAINTS_HOOD) and not saveData.saintsHood.tookDevilDeal and Agony:HasFlags(cache, CacheFlag.CACHE_DAMAGE) then
		player.Damage = (player.Damage*2)-1
	end
end

function saintsHood:updateDealChance(player)
	if player:HasCollectible(CollectibleType.AGONY_C_SAINTS_HOOD) and not saveData.saintsHood.tookDevilDeal then
		--debug_text = tostring(saveData.saintsHood.tookDevilDeal) .. " " .. tostring(saveData.saintsHood.devilItems)
		local room = Game():GetRoom()
		local level = Game():GetLevel()

		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_GOAT_HEAD, false) --give 100% deal precedent
		if room:GetType() == RoomType.ROOM_DEVIL then
			local ents = Isaac.GetRoomEntities()

			if saveData.saintsHood.devilItems == nil or room:GetFrameCount() <= 1 then
				saveData.saintsHood.devilItems = 0
				
				for _,ent in pairs(ents) do
					if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
						saveData.saintsHood.devilItems = saveData.saintsHood.devilItems + 1
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

			if itemCount < saveData.saintsHood.devilItems then
				saveData.saintsHood.tookDevilDeal = true
				
				Agony:SaveNow()
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
				--debug_text = "evalled items " .. tostring(Game():GetFrameCount()) 
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, saintsHood.updateCache)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, saintsHood.updateDealChance)
