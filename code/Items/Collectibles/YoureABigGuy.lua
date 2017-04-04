--local item_BigGuy = Isaac.GetItemIdByName("You're a Big Guy");
local bigGuy =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
bigGuy.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_youreabigguy.anm2")

function bigGuy:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_URA_BIG_GUY)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + 1.69420*player:GetCollectibleNum(CollectibleType.AGONY_C_URA_BIG_GUY);
		end
	end
end

function bigGuy:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		bigGuy.hasItem = false
	end
	if bigGuy.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_URA_BIG_GUY) then
		-- commented out until we have a costume
		player:AddNullCostume(bigGuy.costumeID)
		player.SpriteScale = player.SpriteScale*1.4
		bigGuy.hasItem = true
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, bigGuy.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bigGuy.cacheUpdate)