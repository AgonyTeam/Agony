--local item_OvergrownSpine = Isaac.GetItemIdByName("Overgrown Spine");
local overgrownSpine =  {}

function overgrownSpine:linkTears()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_OVERGROWN_SPINE) then
		local entList = Isaac.GetRoomEntities()
		local tearList = {}
		for i = 1, #entList, 1 do
			if entList[i].Type == EntityType.ENTITY_KNIFE or (entList[i].Type == EntityType.ENTITY_TEAR and (entList[i].Parent.Type == 1 or (entList[i].Parent.Type == 3 and entList[i].Parent.Variant == 80))) then
				table.insert(tearList,entList[i].Position)
			end
		end
		for j = 1, #tearList-1, 1 do
			--scales with number of copies
			for k = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_OVERGROWN_SPINE) do
				if math.random(4) == 1 then
					local laser = player:FireTechLaser(tearList[j], 1, Vector (tearList[j+1].X-tearList[j].X,tearList[j+1].Y-tearList[j].Y), false, false)
					laser:SetMaxDistance(tearList[j+1]:Distance(tearList[j]))
					laser:SetTimeout(1)
					--laser:SetColor(Color(0, 0, 0, 10, 0, 0, 0), 2, 1, false, false)
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, overgrownSpine.linkTears)