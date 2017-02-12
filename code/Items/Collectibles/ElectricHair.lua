--local item_ElectricHair = Isaac.GetItemIdByName("Electric Hair");
CollectibleType["AGONY_C_ELECTRIC_HAIR"] = Isaac.GetItemIdByName("Electric Hair");
local electricHair =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
electricHair.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_electrichair.anm2")

--Grants +0.2 speed
function electricHair:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_ELECTRIC_HAIR)) and (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed + 0.2;
	end
end

function electricHair:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		electricHair.hasItem = false
	end
	if electricHair.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_ELECTRIC_HAIR) then
		--player:AddNullCostume(electricHair.costumeID)
		electricHair.hasItem = true
	end
end

function electricHair:onUpdate()
	--Shoots a laser at nearby enemies
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_ELECTRIC_HAIR) then
		local entList = Isaac.GetRoomEntities()
		local vulList = {}
		for i = 1, #entList, 1 do
			if entList[i]:IsVulnerableEnemy() then
				table.insert(vulList,entList[i].Position)
			end
		end
		for j = 1, #vulList, 1 do
			if vulList[j]:Distance(player.Position) < 500 then			
				if math.random(100) == 1 then
					for k = 1, #vulList, 1 do
						if math.random(100) > 50 and k ~= j and vulList[k]:Distance(vulList[j]) < 150 then
							local laser = player:FireTechLaser(vulList[j], 0, Vector (vulList[k].X - vulList[j].X,vulList[k].Y - vulList[j].Y), false, true)
							laser:SetTimeout(1)
							laser:SetMaxDistance(vulList[k]:Distance(vulList[j]))
						end
					end
				end
			end
		end
	end
end



Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, electricHair.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, electricHair.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, electricHair.cacheUpdate)