--local item_TheBigRock = Isaac.GetItemIdByName("The Big Rock")
local theBigRock =  {
	hasTriedToMorphSmallRock = false,
	seed = nil,
}

--Grants + 2.69 DMG and -0.4 SPD
function theBigRock:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_THE_BIG_ROCK)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
		player.Damage = player.Damage + 3.69;
		end
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed - 0.5;
		end
	end
end



-- Morphs the small rock item 1/20th of the time into the big rock
function theBigRock:morphSmallRock()
	if theBigRock.seed ~= RNG():GetSeed() then
		theBigRock.hasTriedToMorphSmallRock = false
		theBigRock.seed = RNG():GetSeed()
	end
	if theBigRock.hasTriedToMorphSmallRock == false then
		local entList = Isaac.GetRoomEntities()
		for i = 1, #entList, 1 do
			if entList[i].Type == 5 and entList[i].Variant == 100 and entList[i].SubType == 90 then
				if RNG():GetSeed()%20 == 1 then
					entList[i]:ToPickup():Morph(entList[i].Type, entList[i].Variant, CollectibleType.AGONY_C_THE_BIG_ROCK, true)
				end
				theBigRock.hasTriedToMorphSmallRock = true
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, theBigRock.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, theBigRock.morphSmallRock)