roomGridFairness = 0

local checkedPositions = {}
local rfdebug = {}
local freedomSum = 0
local gridSize = 40

function Agony:GetGridCountAroundPos(oPos)
	local room = Game():GetRoom()
	local count = 0
	local pos = oPos
	if not Agony:IsPosInRoom(pos) or room:GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then count = count + 1 end
	pos = oPos + Vector(gridSize,0)
	if not Agony:IsPosInRoom(pos) or room:GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then count = count + 1 end
	pos = oPos + Vector(-gridSize,0)
	if not Agony:IsPosInRoom(pos) or room:GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then count = count + 1 end
	pos = oPos + Vector(0,gridSize)
	if not Agony:IsPosInRoom(pos) or room:GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then count = count + 1 end
	pos = oPos + Vector(0,-gridSize)
	if not Agony:IsPosInRoom(pos) or room:GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then count = count + 1 end
	return count
end

function Agony:GetGridCountAroundPlayer()
	local player = Isaac.GetPlayer(0)
	if player.CanFly then
		return 0
	end
	return Agony:GetGridCountAroundPos(player.Position)
end

function Agony:ProcessFillNode(pos)
	local room = Game():GetRoom()
	--Is Node in Room
	if not Agony:IsPosInRoom(pos) then return end
	local i = room:GetGridIndex(pos)
	--Was Node already processed?
	if checkedPositions[i] ~= nil then return end
	checkedPositions[i] = true
	
	local nodeFreedom = 0
	
	--RIGHT
	local tpos = pos + Vector(gridSize,0)
	if Agony:IsPosInRoom(tpos) then
		if room:GetGridCollision(room:GetGridIndex(tpos)) == GridCollisionClass.COLLISION_NONE then
			Isaac.DebugString("col "..tostring(room:GetGridCollisionAtPos(tpos)))
			Isaac.DebugString("i "..tostring(room:GetGridIndex(tpos)))
			Isaac.DebugString("pos "..tostring(math.floor(tpos.X)).." - "..tostring(math.floor(tpos.Y)))
			--Increase NodeFreedom by 1 for empty spaces
			nodeFreedom = nodeFreedom + 1
			Agony:ProcessFillNode(tpos)
		else
			
			local gtype = room:GetGridEntity(room:GetGridIndex(tpos)):GetType()
			Isaac.DebugString("gtype "..tostring(gtype).." - "..tostring(room:GetGridEntity(room:GetGridIndex(tpos)).CollisionClass))
			local v = nil
			if gtype == GridEntityType.GRID_POOP then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIKES_ONOFF then
				v = 0.2
			elseif gtype == GridEntityType.GRID_TNT then
				v = 0.3
			elseif gtype == GridEntityType.GRID_PRESSURE_PLATE then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIDERWEB then
				v = 0.9
			end
			Isaac.DebugString(tostring(gtype).."gtype - "..(v or "nil").."v")
			if v ~= nil and false then -- Disabled until i figure out the bug
				nodeFreedom = nodeFreedom + v
				Agony:ProcessFillNode(tpos)
			end
		
		end
	end
	
	--LEFT
	tpos = pos + Vector(-gridSize,0)
	if Agony:IsPosInRoom(tpos) then
		if room:GetGridCollision(room:GetGridIndex(tpos)) == GridCollisionClass.COLLISION_NONE then
			Isaac.DebugString("col "..tostring(room:GetGridCollisionAtPos(tpos)))
			Isaac.DebugString("i "..tostring(room:GetGridIndex(tpos)))
			Isaac.DebugString("pos "..tostring(math.floor(tpos.X)).." - "..tostring(math.floor(tpos.Y)))
			--Increase NodeFreedom by 1 for empty spaces
			nodeFreedom = nodeFreedom + 1
			Agony:ProcessFillNode(tpos)
		else
			
			local gtype = room:GetGridEntity(room:GetGridIndex(tpos)):GetType()
			Isaac.DebugString("gtype "..tostring(gtype).." - "..tostring(room:GetGridEntity(room:GetGridIndex(tpos)).CollisionClass))
			local v = nil
			if gtype == GridEntityType.GRID_POOP then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIKES_ONOFF then
				v = 0.2
			elseif gtype == GridEntityType.GRID_TNT then
				v = 0.3
			elseif gtype == GridEntityType.GRID_PRESSURE_PLATE then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIDERWEB then
				v = 0.9
			end
			Isaac.DebugString(tostring(gtype).."gtype - "..(v or "nil").."v")
			if v ~= nil and false then -- Disabled until i figure out the bug
				nodeFreedom = nodeFreedom + v
				Agony:ProcessFillNode(tpos)
			end
		
		end
	end
	
	--DOWN
	tpos = pos + Vector(0,gridSize)
	if Agony:IsPosInRoom(tpos) then
		if room:GetGridCollision(room:GetGridIndex(tpos)) == GridCollisionClass.COLLISION_NONE then
			Isaac.DebugString("col "..tostring(room:GetGridCollisionAtPos(tpos)))
			Isaac.DebugString("i "..tostring(room:GetGridIndex(tpos)))
			Isaac.DebugString("pos "..tostring(math.floor(tpos.X)).." - "..tostring(math.floor(tpos.Y)))
			--Increase NodeFreedom by 1 for empty spaces
			nodeFreedom = nodeFreedom + 1
			Agony:ProcessFillNode(tpos)
		else
			
			local gtype = room:GetGridEntity(room:GetGridIndex(tpos)):GetType()
			Isaac.DebugString("gtype "..tostring(gtype).." - "..tostring(room:GetGridEntity(room:GetGridIndex(tpos)).CollisionClass))
			local v = nil
			if gtype == GridEntityType.GRID_POOP then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIKES_ONOFF then
				v = 0.2
			elseif gtype == GridEntityType.GRID_TNT then
				v = 0.3
			elseif gtype == GridEntityType.GRID_PRESSURE_PLATE then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIDERWEB then
				v = 0.9
			end
			Isaac.DebugString(tostring(gtype).."gtype - "..(v or "nil").."v")
			if v ~= nil and false then -- Disabled until i figure out the bug
				nodeFreedom = nodeFreedom + v
				Agony:ProcessFillNode(tpos)
			end
		
		end
	end
	
	--UP
	tpos = pos + Vector(0,-gridSize)
	if Agony:IsPosInRoom(tpos) then
		if room:GetGridCollision(room:GetGridIndex(tpos)) == GridCollisionClass.COLLISION_NONE then
			Isaac.DebugString("col "..tostring(room:GetGridCollisionAtPos(tpos)))
			Isaac.DebugString("i "..tostring(room:GetGridIndex(tpos)))
			Isaac.DebugString("pos "..tostring(math.floor(tpos.X)).." - "..tostring(math.floor(tpos.Y)))
			--Increase NodeFreedom by 1 for empty spaces
			nodeFreedom = nodeFreedom + 1
			Agony:ProcessFillNode(tpos)
		else
			
			local gtype = room:GetGridEntity(room:GetGridIndex(tpos)):GetType()
			Isaac.DebugString("gtype "..tostring(gtype).." - "..tostring(room:GetGridEntity(room:GetGridIndex(tpos)).CollisionClass))
			local v = nil
			if gtype == GridEntityType.GRID_POOP then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIKES_ONOFF then
				v = 0.2
			elseif gtype == GridEntityType.GRID_TNT then
				v = 0.3
			elseif gtype == GridEntityType.GRID_PRESSURE_PLATE then
				v = 0.5
			elseif gtype == GridEntityType.GRID_SPIDERWEB then
				v = 0.9
			end
			Isaac.DebugString(tostring(gtype).."gtype - "..(v or "nil").."v")
			if v ~= nil and false then -- Disabled until i figure out the bug
				nodeFreedom = nodeFreedom + v
				Agony:ProcessFillNode(tpos)
			end
		
		end
	end
	table.insert(rfdebug,{x=pos.X,y=pos.Y,v=nodeFreedom})
	freedomSum = freedomSum + nodeFreedom
end

function Agony:CalculateGridFairness()
	checkedPositions = {}
	rfdebug = {}
	freedomSum = 0
	local sPos = Isaac.GetPlayer(0).Position
	Agony:ProcessFillNode(sPos)
	Isaac.DebugString("DONE - "..tostring(freedomSum))
end

function Agony:RenderGridFairnessDebug()
	local room = Game():GetRoom()
	for _,node in pairs(rfdebug) do
		local p = Isaac.WorldToRenderPosition(Vector(node.x,node.y),true) + room:GetRenderScrollOffset()
		Isaac.RenderScaledText(tostring(node.v), p.X, p.Y, 0.5, 0.5, 1, 1, 1, 0.5)
	end
end

function Agony:D()
	local room = Game():GetRoom()
	if room:GetGridCollisionAtPos(Isaac.GetPlayer(0).Position) == GridCollisionClass.COLLISION_NONE then
		debug_text = "WOOOOB"
	else
		debug_text = "NEEEEEG"
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Agony.CalculateGridFairness)
--Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.D)