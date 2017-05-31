roomGridFairness = 0

local recalculateGridFairness = false
local checkedPositions = {}
local rfdebug = {}
local freedomSum = 0
local gridSize = 40.0

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

function Agony:TestGrid(pos,doNode)
	local room = Game():GetRoom()
	local v = nil
	if Agony:IsPosInRoom(pos) then
		local gent = room:GetGridEntity(room:GetGridIndex(pos))
		local gtype = 0
		if gent then
			gtype = gent.Desc.Type
		end
		
		--Freedom values for different GridTypes
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
		elseif gtype == GridEntityType.GRID_SPIKES then
			v = nil
		elseif room:GetGridCollision(room:GetGridIndex(pos)) == GridCollisionClass.COLLISION_NONE then
			v = 1.0
		end
		
		--Create and process Node
		if v ~= nil and doNode then
			Agony:ProcessFillNode(pos)
		end
	end
	return v or 0.0
end

function Agony:ProcessFillNode(pos)
	local room = Game():GetRoom()
	--Is Node in Room
	if not Agony:IsPosInRoom(pos) then return end
	local i = room:GetGridIndex(pos)
	--Was Node already processed?
	if checkedPositions[i] ~= nil then return end
	checkedPositions[i] = true
	
	local nodeFreedom = 0.0
	
	--RIGHT
	local tpos = pos + Vector(gridSize,0)
	nodeFreedom = nodeFreedom + Agony:TestGrid(tpos, true)
	
	--LEFT
	tpos = pos + Vector(-gridSize,0)
	nodeFreedom = nodeFreedom + Agony:TestGrid(tpos, true)
	
	--DOWN
	tpos = pos + Vector(0,gridSize)
	nodeFreedom = nodeFreedom + Agony:TestGrid(tpos, true)
	
	--UP
	tpos = pos + Vector(0,-gridSize)
	nodeFreedom = nodeFreedom + Agony:TestGrid(tpos, true)
	
	--MIDDLE
	nodeFreedom = nodeFreedom * Agony:TestGrid(pos, false) * 0.25
	
	table.insert(rfdebug,{x=pos.X,y=pos.Y,v=nodeFreedom})
	freedomSum = freedomSum + nodeFreedom
end

function Agony:CalculateGridFairness()
	recalculateGridFairness = true
end

function Agony:UpdateFairness()
	if recalculateGridFairness then
		recalculateGridFairness = false
		checkedPositions = {}
		rfdebug = {}
		freedomSum = 0
		local sPos = Isaac.GetPlayer(0).Position
		sPos = Vector(math.floor(sPos.X/40.0)*40.0,math.floor(sPos.Y/40.0)*40.0)
		Agony:ProcessFillNode(sPos)
		Isaac.DebugString("DONE - "..tostring(freedomSum))
	end
end

function Agony:RenderGridFairnessDebug()
	local room = Game():GetRoom()
	for _,node in pairs(rfdebug) do
		local p = Isaac.WorldToRenderPosition(Vector(node.x,node.y),true) + room:GetRenderScrollOffset()
		Isaac.RenderScaledText(tostring(node.v), p.X-tostring(node.v):len(), p.Y, 0.5, 0.5, 4-(node.v*4), node.v*2+0.5, node.v*2+0.5, 0.5)
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
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.UpdateFairness)
--Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.D)