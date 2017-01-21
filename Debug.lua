local debugScript = {}

function debugScript:displayEntities()
	local entList = Isaac.GetRoomEntities()
	for i = 1, #entList, 1 do
		Isaac.RenderText(tostring(entList[i].Type) .. " " .. tostring(entList[i].Variant) .. " " .. tostring(entList[i].SubType), 100, 10 + (10*i), 255, 0, 0, 255)
	end
	Isaac.RenderText(tostring(item_TheBigRock), 400, 100, 255, 255, 255, 255)
end

Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.displayEntities)