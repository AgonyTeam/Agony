
local ferrofluid =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	TearBool = false
}
ferrofluid.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_ferrofluid.anm2")

function ferrofluid:cacheUpdate (player,cacheFlag)
	--Damage and tears up
	if (player:HasCollectible(CollectibleType.AGONY_C_FERROFLUID)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + 1.69*player:GetCollectibleNum(CollectibleType.AGONY_C_FERROFLUID)
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			ferrofluid.TearBool = true
		end
	end
end

function ferrofluid:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		ferrofluid.hasItem = false
	end
	if ferrofluid.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_FERROFLUID) then
		player:AddNullCostume(ferrofluid.costumeID)
		ferrofluid.hasItem = true
	end
end

--FireDelay workaround
function ferrofluid:updateFireDelay()
	local player = Isaac.GetPlayer(0);
	if (ferrofluid.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay - player.MaxFireDelay*0.2*player:GetCollectibleNum(CollectibleType.AGONY_C_FERROFLUID);
		ferrofluid.TearBool = false;
	end
end

function ferrofluid:onUpdate()
	--Tears attract each other
	local player = Isaac.GetPlayer(0);
	if player:HasCollectible(CollectibleType.AGONY_C_FERROFLUID) then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR and (entities[i].Parent.Type == 1 or (entities[i].Parent.Type == 3 and entities[i].Parent.Variant == 80))) then --player == 1.0.0, incubus == 3.80.0
				for j = 1, #entities do
					if j ~= i and (entities[j].Type == EntityType.ENTITY_TEAR and (entities[j].Parent.Type == 1 or (entities[j].Parent.Type == 3 and entities[j].Parent.Variant == 80))) then --player == 1.0.0, incubus == 3.80.0
						entities[j]:AddVelocity((entities[j].Position:__sub(entities[i].Position)):__div(entities[j].Position:DistanceSquared(entities[i].Position)/-99))
					end
				end
			end
		end
	end	
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, ferrofluid.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, ferrofluid.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ferrofluid.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ferrofluid.cacheUpdate)