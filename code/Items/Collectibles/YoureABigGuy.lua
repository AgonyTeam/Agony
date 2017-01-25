local item_BigGuy = Isaac.GetItemIdByName("You're a Big Guy");
local bigGuy =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
bigGuy.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_bigguy.anm2")

function bigGuy:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(item_BigGuy)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + 1.69420;
		end
	 	player.SpriteScale = player.SpriteScale*1.1
	end
end

function bigGuy:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		bigGuy.hasItem = false
	end
	if bigGuy.hasItem == false and player:HasCollectible(item_BigGuy) then
		-- commented out until we have a costume
		--player:AddNullCostume(bigGuy.costumeID)
		bigGuy.hasItem = true
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, bigGuy.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bigGuy.cacheUpdate)