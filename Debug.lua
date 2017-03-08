local debugScript = {}

debug_text = "ayyyy"
debug_tbl1 = {one_no = "entries"}
debug_tbl2 = {two_no = "entries"}
debug_entity = nil

function debugScript:displayEntities()
	local entList = Isaac.GetRoomEntities()
	for i = 1, #entList, 1 do
		Isaac.RenderText(tostring(entList[i].Type) .. " " .. tostring(entList[i].Variant) .. " " .. tostring(entList[i].SubType), 40, 10 + (10*i), 255, 0, 0, 255)
	end
end
 
function debugScript:universalDebugText()
	Isaac.RenderText(debug_text, 40, 250, 255, 255, 0, 255);
	if debug_entity ~= nil then
		Isaac.RenderText(tostring(debug_entity.State), 10, 250, 255, 255, 255, 255);
	end
end

function debugScript:universalTableParser()
	local count = 0
	local count2 = 0
	for a,b in pairs(debug_tbl1) do
		Isaac.RenderText(tostring(a).. ": " .. tostring(b), 150, 10 + count*10, 0, 255, 0, 255)
		count = count + 1
	end
	for a,b in pairs(debug_tbl2) do
		Isaac.RenderText(tostring(a).. ": " .. tostring(b), 150, 10 + count2*10 + count*10, 255, 0, 255, 255)
		count2 = count2 + 1
	end
end

function debugScript:stateReader(ent)
	debug_entity = ent
end

Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.displayEntities)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.universalDebugText)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.universalTableParser)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, debugScript.stateReader, EntityType.ENTITY_POOTER)