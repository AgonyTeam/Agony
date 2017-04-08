--local item_ElectricHair = Isaac.GetItemIdByName("Electric Hair");
local electricHair =  {}

--Grants +0.2 speed
function electricHair:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_ELECTRIC_HAIR)) and (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed + 0.2;
	end
end

function electricHair:onUpdate()
	--Shoots a laser at nearby enemies
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_ELECTRIC_HAIR)
	
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
				if rng:RandomInt(100) == 1 then
					for k = 1, #vulList, 1 do
						--for each copy the player has do
						--This makes it twice likely to shoot a laser if the player has two copies
						for l = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_ELECTRIC_HAIR) do
							if rng:RandomInt(100) > 50 and k ~= j and vulList[k]:Distance(vulList[j]) < 150 then
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
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, electricHair.onUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, electricHair.cacheUpdate)