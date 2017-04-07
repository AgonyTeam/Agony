--local item_Hyperactive = Isaac.GetItemIdByName("Hyperactive")
local hyperactive =  {}

function hyperactive:autoUseItem(player)
	if player:HasCollectible(CollectibleType.AGONY_C_HYPERACTIVE) then
		if not player:NeedsCharge() then
			-- scales with nbr of copies
			for i = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_HYPERACTIVE) do
				player:UseActiveItem(player:GetActiveItem(), true, true, true, false)
			end
			player:DischargeActiveItem()
		end
	end
end

function hyperactive:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_HYPERACTIVE)) then 
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = (player.MoveSpeed +0.5*player:GetCollectibleNum(CollectibleType.AGONY_C_HYPERACTIVE))
		elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 5*player:GetCollectibleNum(CollectibleType.AGONY_C_HYPERACTIVE)
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, hyperactive.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, hyperactive.autoUseItem)