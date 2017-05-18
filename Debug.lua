local debugScript = {
	show_debug = true, --TODO[ ] Set to false on release
	button_pressed = false
}

debug_text = "I like debugging - Toggle with 0"
debug_tbl1 = {one_no = "entries"}
debug_tbl2 = {two_no = "entries"}
debug_entity = nil

function debugScript:displayEntities()
	if not debugScript.show_debug then return end
	
	local entList = Isaac.GetRoomEntities()
	for i = 1, #entList, 1 do
		Isaac.RenderText(tostring(entList[i].Type) .. " " .. tostring(entList[i].Variant) .. " " .. tostring(entList[i].SubType), 40, 10 + (10*i), 255, 0, 0, 255)
	end
end
 
function debugScript:universalDebugText()
	if not debugScript.show_debug then return end
	
	Isaac.RenderText(tostring(debug_text), 40, 250, 255, 255, 0, 255);
	if debug_entity ~= nil then
		Isaac.RenderText(tostring(debug_entity.State), 10, 250, 255, 255, 255, 255);
	end
end

function debugScript:universalTableParser()
	if not debugScript.show_debug then return end
	
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

function debugScript:checkToggle()
	if Input.IsButtonPressed(Keyboard.KEY_0,0) then
		if debugScript.button_pressed ~= true then
			debugScript.button_pressed = true
			debugScript.show_debug = not debugScript.show_debug
		end
	else
		debugScript.button_pressed = false
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.displayEntities)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.universalDebugText)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.universalTableParser)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, debugScript.stateReader, EntityType.ENTITY_POOTER)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, debugScript.checkToggle)