local item_YeuxRev = Isaac.GetItemIdByName("Yeux Revolver");
local yeuxRev =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	TearBool = false
}
yeuxRev.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_yeuxrevolver.anm2")

--Grants +1 Luck and gives a *2 multiplier to Luck
function yeuxRev:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(item_YeuxRev)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = (player.Damage + 3.42069)
		end
		if (cacheFlag == CacheFlag.CACHE_SHOTSPEED) then
			player.ShotSpeed = (player.ShotSpeed + 1.69420)
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			yeuxRev.TearBool = true
		end
	end
end

function yeuxRev:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		yeuxRev.hasItem = false
	end
	if yeuxRev.hasItem == false and player:HasCollectible(item_YeuxRev) then
		--player:AddNullCostume(yeuxRev.costumeID)
		yeuxRev.hasItem = true
	end
end

--FireDelay workaround
function yeuxRev:updateFireDelay()
	local player = Isaac.GetPlayer(0);
	if (yeuxRev.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay + 4;
		yeuxRev.TearBool = false;
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, yeuxRev.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, yeuxRev.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yeuxRev.cacheUpdate)