local debugScript = {
	show_debug = true, --TODO[ ] Set to false on release
	entities_mode = 0,
	toggle_pressed = false
}

debug_text = "I like debugging - Hide with 0 - Change modes with 1-3"
debug_tbl1 = {one_no = "entries"}
debug_tbl2 = {two_no = "entries"}
debug_entity = nil

function debugScript:displayEntities()
	if not debugScript.show_debug then return end
	
	local entList = Isaac.GetRoomEntities()
	if debugScript.entities_mode == 0 then
		for i = 1, #entList, 1 do
			Isaac.RenderText(tostring(entList[i].Type) .. " " .. tostring(entList[i].Variant) .. " " .. tostring(entList[i].SubType), 40, 10 + (10*i), 255, 0, 0, 255)
		end
		
	elseif debugScript.entities_mode == 1 then
		for i = 1, #entList, 1 do
			local p = Isaac.WorldToRenderPosition(entList[i].Position,true)
			local str = tostring(entList[i].Type) .. "." .. tostring(entList[i].Variant) .. "." .. tostring(entList[i].SubType)
			local str2 = ""
			if entList[i].HitPoints > 0 then
				str2 = tostring(entList[i].HitPoints) .. "\\" .. tostring(entList[i].MaxHitPoints) .. " HP"
			end
			if entList[i]:ToNPC() ~= nil then
				local npc = entList[i]:ToNPC()
				str = str.."-"..tostring(npc.State)..":"..tostring(npc.StateFrame)
			end
			--Isaac.RenderText(tostring(entList[i].Type) .. " " .. tostring(entList[i].Variant) .. " " .. tostring(entList[i].SubType), p.X, p.Y, 255, 0, 0, 0.5)
			Isaac.RenderScaledText(str, p.X-str:len()*1.5, p.Y, 0.5, 0.5, 4, 0, 0, 0.75)
			Isaac.RenderScaledText(str2, p.X-str2:len()*1.5, p.Y+5, 0.5, 0.5, 1, 1, 255, 0.75)
		end
		
	elseif debugScript.entities_mode == 2 then
		
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
		if debugScript.toggle_pressed ~= true then
			debugScript.toggle_pressed = true
			debugScript.show_debug = not debugScript.show_debug
		end
	else
		debugScript.toggle_pressed = false
	end
	
	if Input.IsButtonPressed(49,0) then --Key1
		debugScript.entities_mode = 0
	elseif Input.IsButtonPressed(50,0) then --Key2
		debugScript.entities_mode = 1
	elseif Input.IsButtonPressed(51,0) then --Key3
		debugScript.entities_mode = 2
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.displayEntities)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.universalDebugText)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, debugScript.universalTableParser)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, debugScript.stateReader, EntityType.ENTITY_POOTER)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, debugScript.checkToggle)