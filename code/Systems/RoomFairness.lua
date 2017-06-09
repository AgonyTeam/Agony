roomGridFairness = 0

local recalculateGridFairness = false
local roomCalculated = false
local checkedPositions = {}
local rfdebug = {}
local freedomSum = 0
local dangerSum = 0
local maxDanger = 0
local gridSize = 40.0

local eternalRooms = {}
local eternalChance = 0
local eternalChancePerRoom = 0.1

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
	roomCalculated = false
	checkedPositions = {}
	rfdebug = {}
	freedomSum = 0.0
	dangerSum = 0.0
	maxDanger = 0.0
end

function Agony:CalcDangerNonEternal(ent)
	local d = 0
	if ent:IsActiveEnemy(false) then
		d = ent.MaxHitPoints + 5.0
		if not ent:IsVulnerableEnemy() then
			d = 5.0
		end
		if ent.CollisionDamage == 0 then
			d = d * 0.5
		end
	end
	--TODO: Other calculations?
	return d
end

function Agony:UpdateFairness()
	if recalculateGridFairness then
		
		recalculateGridFairness = false
		checkedPositions = {}
		rfdebug = {}
		freedomSum = 0.0
		maxDanger = 0.0
		
		--GRID
		local sPos = Isaac.GetPlayer(0).Position
		sPos = Vector(math.floor(sPos.X/40.0)*40.0,math.floor(sPos.Y/40.0)*40.0)
		Agony:ProcessFillNode(sPos)
		
		--ENEMIES
		dangerSum = 0.0
		local ents = Isaac.GetRoomEntities()
		local possibleEternals = {}
		for _,v in pairs(ents) do
			if Agony:HasEternalSubtype(v.Type,v.Variant) then
				table.insert(possibleEternals,v:ToNPC())
			elseif v:ToNPC() ~= nil then
				local d = Agony:CalcDangerNonEternal(v:ToNPC())
				v:GetData().fairDebug = d
				dangerSum = dangerSum + d
			end
		end
		
		--Shuffle Possible Eternals
		local shuffled = {}
		--Seed by Room for consistency
		math.randomseed(Game():GetRoom():GetSpawnSeed())
		while #possibleEternals > 0 do
			local i = math.random(#possibleEternals)
			table.insert(shuffled, possibleEternals[i])
			table.remove(possibleEternals,i)
		end
		
		--Calc Max Danger
		--An empty 1x1 room will always have a freedomSum of 81.0
		maxDanger = freedomSum / 81.0 --TODO: Multiply based on floor
		maxDanger = maxDanger ^ 0.75 -- Apply a curve
		--            ___---1.0
		--       __-- 
		--    ..
		--  ..
		-- |
		--|0.0
		maxDanger = maxDanger * 100.0 -- * floorDifficulty
		
		local roomi = Game():GetLevel():GetCurrentRoomDesc().GridIndex
		local roomd = eternalRooms[roomi]
		--Spawn Eternals?
		if ((math.random(0,100) * 0.01) < eternalChance or roomd == true) and roomd ~= false then
			
			eternalRooms[roomi] = true;
			local randomDanger = maxDanger * math.random(50,100) * 0.01
			local first = true
			
			for _,v in pairs(shuffled) do
				local et = Agony:getEternal(v.Type,v.Variant)
				local danger = et.danger
				--Limit to maxDanger
				if first or (danger + dangerSum) <= randomDanger then
					first = false
					--Reset Chance. but only if the room is a first visit
					if roomd == nil then
						eternalChance = -eternalChancePerRoom
					end
					dangerSum = dangerSum + danger
					--Morph Eternal
					v:ToNPC():Morph(v.Type, v.Variant, 15, -1)
					v.HitPoints = v.MaxHitPoints
					v:GetData().fairDebug = danger
				else
					local d = Agony:CalcDangerNonEternal(v)
					v:GetData().fairDebug = d
					dangerSum = dangerSum + d
				end
			end
			
		else eternalRooms[roomi] = false end
		
		--Increase Chance. but only if the room is a first visit
		if roomd == nil then
			eternalChance = eternalChance + eternalChancePerRoom
		end
		
		roomCalculated = true
	end
	
	debug_text = "GridFairness: "..tostring(freedomSum).." EnemyDanger: "..tostring(dangerSum).." / "..tostring(maxDanger)
end

function Agony:IsGridFairnessCalculated()
	return roomCalculated
end

function Agony:GetGridFairness()
	return freedomSum
end

function Agony:RenderGridFairnessDebug()
	local room = Game():GetRoom()
	local entList = Isaac.GetRoomEntities()
	
	for _,node in pairs(rfdebug) do
		local p = Isaac.WorldToRenderPosition(Vector(node.x,node.y),true) + room:GetRenderScrollOffset()
		Isaac.RenderScaledText(tostring(node.v), p.X-tostring(node.v):len(), p.Y, 0.5, 0.5, 4-(node.v*4), node.v*2+0.5, node.v*2+0.5, 0.5)
	end
	
	for i = 1, #entList, 1 do
		local e = entList[i]
		local p = Isaac.WorldToRenderPosition(e.Position,true) + room:GetRenderScrollOffset()
		local v = e:GetData().fairDebug
		if v then
			local str = "f: "..tostring(v)
			Isaac.RenderScaledText(str, p.X-str:len(), p.Y, 0.5, 0.5, 4, 0, 0, 0.75)
		end
	end
	
	Isaac.RenderText("eChance:"..tostring(eternalChance), 40, 200, 1, 1, 0, 0.75);
end

function Agony:ResetFairness()
	eternalRooms = {}
	eternalChance = 0
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
Agony:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Agony.ResetFairness)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.UpdateFairness)
--Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.D)