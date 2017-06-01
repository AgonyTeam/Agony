--StartDebug();
Agony = RegisterMod("The Agony of Isaac", 1);
local json = require("json")

--Constants
Agony.ETERNAL_SPAWN_CHANCE = 0.2 --Eternals spawn chance constant

--Register Agony's IDs
require("AgonyIDs")
Agony.ENUMS = require("ExtraEnums")
Agony.Pedestals = Agony.ENUMS.Pedestals --shortcuts
Agony.CocoonVariant = Agony.ENUMS.CocoonVariant
Agony.EnemySubTypes = Agony.ENUMS.EnemySubTypes
Agony.TearSubTypes = Agony.ENUMS.TearSubTypes
Agony.Callbacks = Agony.ENUMS.Callbacks
Agony.JumpVariant = Agony.ENUMS.JumpVariant

--Systems
require("code/Systems/HelperFunctions")
require("code/Systems/RoomFairness")

--SaveData
local newestSaveVer = 3
if Agony:HasData() then
	saveData = json.decode(Agony:LoadData())
	if saveData.saveVer == nil or saveData.saveVer ~= newestSaveVer then
		saveData = {saveVer = newestSaveVer}
	end
else
	saveData = {saveVer = newestSaveVer}
end

saveData.theWay = saveData.theWay or {}
saveData.LSD = saveData.LSD or {}
saveData.bloodyNut = saveData.bloodyNut or {}
saveData.luckyEgg = saveData.luckyEgg or {}
saveData.despair = saveData.despair or {}
saveData.placeholder = saveData.placeholder or {}
saveData.cherry = saveData.cherry or {}
saveData.delusion = saveData.delusion or {}
saveData.saintsHood = saveData.saintsHood or {}

--unlocks and stuff
saveData.lockedItems = saveData.lockedItems or {}
saveData.unlockFlags = saveData.unlockFlags or {}
saveData.unlockFlags.Hannah = saveData.unlockFlags.Hannah or Agony.ENUMS.DefUnlockFlags
unlockBoss = nil


--respawnV2's vars
local ent_before = {};
local rspwn_allow = false;
saveData.spwn_list = saveData.spwn_list or {}; --either load list from save, or make an empty one
saveData.rseed_list = saveData.rseed_list or {};
local level_seed_backup = 666;
local redo = false;
local redo2 = false;
local glowingHourglass_allow = true;

local respawnIDs = { --holds all IDs that need to be respawned
	-- EntityType.AGONY_ETYPE_TREASURE_HOARDER,
	EntityType.AGONY_ETYPE_YELLOW_BLOCK
}

--spritesToRender table
spritesToRender = {}
--All custom pedestals that need to stay that way
pedestalsToRender = {}
--pickups
pickUpTable = {}
pickUpTree = {}
--tearProjectiles
tearTable = {}
--Helper Callbacks
callbackTable = {}
--Delayed Functions
local dfTime = 0
delayedFunctions = {}

--make the game save the saveData table
function Agony:SaveNow()
	Isaac.SaveModData(Agony, json.encode(saveData));
end

--Eternal al list
local EternalsList = {}
function Agony:AddEternal(Type,Variant,Name,Danger)
	if EternalsList[Type] == nil then
		EternalsList[Type] = {[Variant] = {name = Name, danger = Danger}}
	else
		EternalsList[Type][Variant] = {name = Name, danger = Danger}
	end
end

function Agony:getEternalList()
	return EternalsList
end 

function Agony:HasEternalSubtype(Type,Variant)
	return EternalsList[Type] ~= nil and EternalsList[Type][Variant] ~= nil
end

function Agony:IsEternal(Type,Variant,Subtype)
	return Agony:HasEternalSubtype(Type,Variant) and Subtype == 15
end

function Agony:IsEntityEternal(ent)
	return Agony:HasEternalSubtype(ent.Type,ent.Variant) and ent.SubType == 15
end

function Agony:respawnV2()
	local room = Game():GetRoom();
	local level = Game():GetLevel();

	local level_seed = level:GetDungeonPlacementSeed(); --level identification
	local room_seed = room:GetSpawnSeed(); --for room identification
	
	--debug_text = tostring(room:IsClear()) .. " " .. tostring(room:IsFirstVisit()) --room_seed .. " | " .. level_seed .. " | GameFrmcnt: " .. Game():GetFrameCount();-- " | RoomFrmcnt: " .. room:GetFrameCount() .. " | GameFrmcnt: " .. Game():GetFrameCount() .. " | IsClear: " .. tostring(room:IsClear());
	--debug_text = Isaac.LoadModData(Agony) .. " | " .. tostring(Isaac.HasModData(Agony));
	
	if(Isaac.HasModData(Agony) == true and Game():GetFrameCount() > 1 and level_seed_backup == 666) then --restore data when continuing run after having the game closed
		--spwn_list = string_totable(Isaac.LoadModData(Agony));
		--saveData.spwn_list = ;
		level_seed_backup = level_seed;
		rspwn_allow = true;
	end
	
	if(Game():GetFrameCount() == 1 or (level_seed ~= level_seed_backup and Game():GetFrameCount() > 1)) then --reset vars and delete savedata when restarting run and entering a new level
		saveData.spwn_list = {};
		saveData.rseed_list = {};
		rspwn_allow = false;
		glowingHourglass_allow = true;
		ent_before = {};
		--Isaac.RemoveModData(Agony);
		Agony:SaveNow();
		level_seed_backup = level_seed;
	end

	for i = 1, #saveData.spwn_list, 6 do
		--Isaac.RenderText(spwn_list[i], 400, 100 + ((i / 6) *10), 255, 0, 0, 255);
		if (room:IsFirstVisit() == false and room:IsClear() == true and saveData.spwn_list[i] == room_seed and room:GetFrameCount() == 1) then
			rspwn_allow = true;
		end	
	end
	
	for i=1, #saveData.rseed_list do
		if (saveData.rseed_list[i] == room_seed) then
			glowingHourglass_allow = false;
		end
	end
	
	if (redo == true) then
		local tmp = {};
		
		for i=1, #saveData.spwn_list, 6 do
			if (saveData.spwn_list[i] ~= room_seed) then --save all entries from other rooms
				table.insert(tmp, 1, saveData.spwn_list[i]);
				table.insert(tmp, 2, saveData.spwn_list[i+1]);
				table.insert(tmp, 3, saveData.spwn_list[i+2]);
				table.insert(tmp, 4, saveData.spwn_list[i+3]);
				table.insert(tmp, 5, saveData.spwn_list[i+4]);
				table.insert(tmp, 6, saveData.spwn_list[i+5]);
			end
		end
		
		saveData.spwn_list = tmp; --removes all entries of the current room
		redo = false;
		redo2 = true; --allow recreation of entries in current room
	end
	
	if (room:IsFirstVisit() == false and room:IsClear() == true and rspwn_allow == true) then --run only if this room truly has been visited before and actually cleared (not skipped with e.g. bombs)
		for i = 1, #saveData.spwn_list, 6 do
			if (saveData.spwn_list[i] == room_seed) then
				Isaac.Spawn(saveData.spwn_list[i+1], saveData.spwn_list[i+2], saveData.spwn_list[i+3], Vector(saveData.spwn_list[i+4], saveData.spwn_list[i+5]), Vector(0,0), Isaac.GetPlayer(0));
			end	
		end
		rspwn_allow = false; --avoid looping the respawn and remove
	elseif ((room:IsFirstVisit() == true and room:GetFrameCount() == 1 and glowingHourglass_allow == true) or redo2 == true) then --check if new room has respawnable entity inside, only once on the first room entry
		ent_before = Isaac.GetRoomEntities();
		table.insert(saveData.rseed_list, 1 ,room_seed)
		for i = 1, #ent_before do
			for j=1, #respawnIDs do
				if (ent_before[i].Type == respawnIDs[j]) then
					table.insert(saveData.spwn_list, 1, room_seed);
					table.insert(saveData.spwn_list, 2, ent_before[i].Type);
					table.insert(saveData.spwn_list, 3, ent_before[i].Variant);
					table.insert(saveData.spwn_list, 4, ent_before[i].SubType);
					table.insert(saveData.spwn_list, 5, ent_before[i].Position.X);
					table.insert(saveData.spwn_list, 6, ent_before[i].Position.Y);
				end
			end	
		end
		--Isaac.SaveModData(Agony, table_tostring(spwn_list)); --save the latest table for the case of game exit
		redo2 = false;
		Agony:SaveNow();
	elseif (room:GetFrameCount() > 10 and glowingHourglass_allow == false) then
		glowingHourglass_allow = true;
	end
end

--recreates entries for spwn_list of current room
function Agony:redoSpawnList()
	redo = true;
end

--Caclulates DamagePerSecond for current Isaac-stats
--Doesn't account for tear-effects like burn, double shot
function Agony:calcDPS(player)
	return (player.Damage / player.MaxFireDelay) * 30.0
end

--Caclulates DamagePerFrame for current Isaac-stats
--Doesn't account for tear-effects like burn, double shot
function Agony:calcDPF(player)
	return player.Damage / player.MaxFireDelay
end

--Calculates the velocity a tear needs to have to hit a target Position
function Agony:calcTearVel(sourcePos, targetPos, multiplier)
	return (targetPos - sourcePos):Normalized() * multiplier;
end

--returns the nearest Enemy
function Agony:getNearestEnemy(sourceEnt, whiteList, blackList)
	whiteList = whiteList or {0}
	blackList = blackList or {}
	local entities = Isaac.GetRoomEntities();
	local smallestDist = nil;
	local nearestEnt = nil;
	
	::redo::
	if blackList.mode == "only_same_ent" then
		local tmp = {}
		for i=1, #entities do
			if entities[i].Type == sourceEnt.Type and entities[i].Variant == sourceEnt.Variant and entities[i].SubType == sourceEnt.SubType then
				table.insert(tmp, 1, entities[i])
			end
		end
		entities = tmp
	elseif blackList.mode == "only_whitelist" then
		local tmp = {}
		for i=1, #entities do
			for j=1, #whiteList do
				if entities[i].Type == whiteList[j] then
					table.insert(tmp, 1, entities[i])
				end
			end
		end
		entities = tmp
	elseif blackList.mode == nil then
		for i=1, #blackList do
			local tmp = {}
			for j=1, #entities do
				if entities[j].Type ~= blackList[i] then
					 table.insert(tmp, 1, entities[j])
				end
			end
			entities = tmp
		end
	else
		blackList.mode = nil
		goto redo
	end
	
	for i = 1, #entities do
		for j = 1, #whiteList do
			if (entities[i].Index ~= sourceEnt.Index and (entities[i]:IsVulnerableEnemy() or entities[i].Type == whiteList[j])) then
				if (smallestDist == nil or sourceEnt.Position:Distance(entities[i].Position) < smallestDist) then
					smallestDist = sourceEnt.Position:Distance(entities[i].Position);
					nearestEnt = entities[i];
				end
			end
		end
	end
	
	if (nearestEnt == nil) then
		return sourceEnt;
	else	
		return nearestEnt;
	end
end

--returns the furthest enemy
function Agony:getFurthestEnemy(sourceEnt, whiteList, blackList)
	whiteList = whiteList or {0}
	blackList = blackList or {}
	local entities = Isaac.GetRoomEntities();
	local largestDist = nil;
	local furthestEnt = nil;
	
	::redo::
	if blackList.mode == "only_same_ent" then
		local tmp = {}
		for i=1, #entities do
			if entities[i].Type == sourceEnt.Type and entities[i].Variant == sourceEnt.Variant and entities[i].SubType == sourceEnt.SubType then
				table.insert(tmp, 1, entities[i])
			end
		end
		entities = tmp
	elseif blackList.mode == "only_whitelist" then
		local tmp = {}
		for i=1, #entities do
			for j=1, #whiteList do
				if entities[i].Type == whiteList[j] then
					table.insert(tmp, 1, entities[i])
				end
			end
		end
		entities = tmp
	elseif blackList.mode == nil then
		for i=1, #blackList do
			local tmp = {}
			for j=1, #entities do
				if entities[j].Type ~= blackList[i] then
					 table.insert(tmp, 1, entities[j])
				end
			end
			entities = tmp
		end
	else
		blackList.mode = nil
		goto redo
	end
	
	for i = 1, #entities do
		for j=1, #whiteList do
			if entities[i].Index ~= sourceEnt.Index and (entities[i]:IsVulnerableEnemy() or entities[i].Type == whiteList[j]) then
				if (largestDist == nil or sourceEnt.Position:Distance(entities[i].Position) > largestDist) then
					largestDist = sourceEnt.Position:Distance(entities[i].Position);
					furthestEnt = entities[i];
				end
			end
		end
	end
	
	if (furthestEnt == nil) then
		return sourceEnt;
	else	
		return furthestEnt;
	end
end

--Display Giant Book anim take 2
function Agony:AnimGiantBook(bookSprite, animName, customAnm2)
	customAnm2 = customAnm2 or "giantbook.anm2"

	local pos = Vector((640-128-48)/2, (460-128-48)/2)
	local rS = {
		[0] = "gfx/ui/giantbook/" .. tostring(bookSprite),
	}
	local aQ = {
		{
			Name = tostring(animName),
			Loops = 1
		},
		--[[ some testing stuff for the rewritten addToRender()
		{
			Name = "Idle",
			Loops = 3,
			killLoop = 10
		},
		{
			Name = "Shake",
			Loops = -1,
			killLoop = 120
		}]]
	}
	Agony:addToRender("gfx/ui/giantbook/" .. tostring(customAnm2), aQ, pos, 30, rS)
end

--Render all sprites in spritesToRender
function Agony:renderSprites()
	for _,spriteTable in pairs(spritesToRender) do
		local sprite = spriteTable.Sprite
		local renderPos = spriteTable.Position
		local anims = spriteTable.Animations
		local fps = spriteTable.fps or 60
		
		::reload::
		local animObj = anims[1]
		if animObj ~= nil then
			animObj.Name = tostring(animObj.Name)
			--debug_text = tostring(animObj.Name) .. " " .. tostring(animObj.Loops) .. " " .. tostring(animObj.killLoop) .. " " .. tostring(Game():GetFrameCount())
			if not sprite:IsPlaying(animObj.Name) and animObj.Loops > 0 then --play one loop
				sprite:Play(animObj.Name, true)
				animObj.Loops = animObj.Loops - 1
			elseif sprite:IsFinished(animObj.Name) and animObj.Loops == 0 then --remove if no more loops
				table.remove(anims, 1)
				goto reload
			elseif not sprite:IsPlaying(animObj.Name) and animObj.Loops < 0 and animObj.killLoop == nil then --loop forever if loop is negative and no killLoop is given
				sprite:Play(animObj.Name, true)
			elseif animObj.killLoop ~= nil and animObj.killLoop > 0 then --if killLoop is greater than zero, play until is zero
				if animObj.killLoopBackup == nil then
					animObj.killLoopBackup = animObj.killLoop
				end
				if not sprite:IsPlaying(animObj.Name) then
					sprite:Play(animObj.Name, true)
				end
				if Game():GetFrameCount() % (60/fps) == 0 then --only count rendered frames
					animObj.killLoop = animObj.killLoop - 1
				end
			elseif animObj.killLoop ~= nil and animObj.killLoop <= 0 then 
				if animObj.Loops > 0 then --start a new loop
					sprite:Play(animObj.Name, true)
					animObj.killLoop = animObj.killLoopBackup
					animObj.Loops = animObj.Loops - 1
				elseif animObj.Loops <= 0 then --remove if no more loops
					table.remove(anims, 1)
					goto reload					
				end
			end
		end

		sprite:Render(renderPos, Vector(0,0), Vector(0,0))
		if Game():GetFrameCount() % (60/fps) == 0 and not Game():IsPaused() then
			sprite:Update()
		end
		
		if #anims == 0 then
			spritesToRender[_] = nil
		end

	end
end

--Add sprite to render list
--          animQueue
--			/ 		\
--		animTbl1	animTbl2
--		/   |   \
--	 Name Loops *killLoop
--
function Agony:addToRender(anm2, animQueue, pos, fps, replaceGfx)
	anm2 = tostring(anm2)
	pos = pos or Vector(0,0)
	fps = fps or 60
	replaceGfx = replaceGfx or {}

	local sprite = Sprite()
	sprite:Load(anm2, false) --init sprite

	for layerId, gfx in pairs(replaceGfx) do
		sprite:ReplaceSpritesheet(layerId, tostring(gfx))
	end
	sprite:LoadGraphics() --replace spritesheets

	spritesToRender[#spritesToRender+1] = { --add to tbl
		Sprite = sprite,
		Position = pos,
		Animations = animQueue,
		fps = fps
	}
	
	return spritesToRender[#spritesToRender].Sprite, #spritesToRender --returns sprite and the index in the table
end

--clears savedata on new run
function Agony:clearSaveData()
	if Game():GetFrameCount() <= 1 then
		for group,_ in pairs(saveData) do
			if group ~= "saveVer" and group ~= "lockedItems" and group ~= "unlockFlags" then
				saveData[group] = {}
			end
		end
		Agony:SaveNow()
		Isaac.DebugString("Reset Agony Savedata")
	end
end

--fixes the bug bug that allowed charmed enemies to persist through rooms when restarting the game (#128 on git)
--this is a bug in the actual game, wtf nicolo, why do I have to fix this
function Agony:removeFriendlyEnemies()
	local ents = Isaac.GetRoomEntities()
	--debug_text = Game():GetFrameCount()
	for _,entity in pairs(ents) do
		if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM) and not (entity.Type == 23 and entity.Variant == 0 and entity.SubType == 1) then --not 23.0.1 because that's that leech item
			entity:Remove()
		end
	end
end

function Agony:dataCopy(originData,targetData)
	for k, v in pairs(originData) do
		targetData[k] = v
	end
end

--returns the items the player currently has
--a list of items can be specified to check if the player has any of these
function Agony:getCurrentItems(pool)
	local itemCfg = Isaac.GetItemConfig()
	local numCol = #(itemCfg:GetCollectibles())
	if type(numCol) ~= "number" then
		numCol = 9999 --Mac seems to have trouble with this number thing
	end
	pool = pool or {}
	local currList = {}
	local player = Isaac.GetPlayer(0)
	for id=1, numCol do
		if itemCfg:GetCollectible(id) ~= nil then
			if #pool == 0 then
				if player:HasCollectible(id) then
					table.insert(currList, id)
				end
			else
				for _, poolId in pairs(pool) do
					if id == poolId and player:HasCollectible(id) then
						table.insert(currList, id)
					end
				end
			end
		end
	end
	--debug_tbl1 = currList
	return currList
end

--these are some Flag manipulation functions, they are similar to the EntityFlags functions
function Agony:AddFlags(flagSource, flags)
	return flagSource | flags
end

function Agony:HasFlags(flagSource, flags)
	return (flagSource & flags) ~= 0
end

function Agony:ClearFlags(flagSource, flags)
	return flagSource & (~flags)
end

--gets the sprite path of a collectible
function Agony:getItemGfxFromId(id)
	--id = tonumber(id) or 1
	local item = Isaac.GetItemConfig():GetCollectible(id)
	return item.GfxFileName
end

--loads a custom pedestal sprite
function Agony:loadCustomPedestal(ped, pType, data, index)
	pType = pType or 0
	index = index or #pedestalsToRender+1
	data = data or ped:GetData()
	local sprite = ped:GetSprite()
	
	for k, v in pairs(data) do
		ped:GetData()[k] = v
	end
	sprite:Load("gfx/Items/Pick Ups/Pedestals/animation.anm2", true)
	sprite:ReplaceSpritesheet(1, Agony:getItemGfxFromId(ped.SubType))
	sprite:LoadGraphics()
	sprite:SetOverlayFrame("Alternates", pType)
	sprite:Play("Idle")
	pedestalsToRender[index] = {ped, pType, ped:GetData()}
end

--reload custom pedestal gfx when the item changes
function Agony:reloadPedestal()
	for index, pedTbl in pairs(pedestalsToRender) do
		local ped = pedTbl[1]
		local pType = pedTbl[2]
		local pData = pedTbl[3]
		if ped:GetSprite():GetFilename() ~= "gfx/Items/Pick Ups/Pedestals/animation.anm2" then
			Agony:loadCustomPedestal(ped, pType, pData, index)
		end
		if not ped:Exists() or ped:GetSprite():GetOverlayFrame() == 0 then
			pedestalsToRender[index] = nil
		end
	end
end

function Agony:rotateTears()
	local ents = Isaac.GetRoomEntities()
	for i=1,#ents do
		if ents[i].Type == EntityType.ENTITY_TEAR and
			(ents[i].SubType == Agony.TearSubTypes.BIG_D
			or ents[i].SubType == Agony.TearSubTypes.TOY_HAMMER
			or ents[i].SubType == Agony.TearSubTypes.MILKMAN
			or ents[i].SubType == Agony.TearSubTypes.TECH_LESS_THAN_3) then
			if ents[i].Velocity.X > 0 then
				ents[i]:GetSprite().Rotation = ents[i]:GetSprite().Rotation + 10
			else
				ents[i]:GetSprite().Rotation = ents[i]:GetSprite().Rotation - 10
			end
		end
	end
end


function Agony:TransformationUpdate(player, trans, data, hasCostume)
	if Game():GetFrameCount() == 1 then
		trans.hasItem = false
		trans.Items = {}
		data.Items = {}
		Agony:SaveNow()
	end
	for i = 1, #trans.requireditems do
		if player:HasCollectible(trans.requireditems[i]) then
			local isNew = true
			for j = 1, #trans.Items do
				if trans.Items[j] == trans.requireditems[i] then
					isNew = false 
				end
			end
			if isNew then
				table.insert(trans.Items, trans.requireditems[i])
				data.Items = trans.Items
				Agony:SaveNow()
			end
		end
	end
	if #trans.Items > 2 then
		if trans.hasItem ~= true then
			if hasCostume then
				player:AddNullCostume(trans.costumeID)
			end
			trans.hasItem = true
			--POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(player.Position, EffectVariant.POOF01, 1, 1, col, 0)
		end
	end
end

--returns a velocity an entity must have to get closer to target
--this differs from calcTearVel() by adding small normalized vectors to an existing velocity and normalizing the result instead of just calculating a vector pointing from ent to target
--better suited for enemies because that way knockback has an effect on the enemy
function Agony:calcEntVel(ent, target, mul)
	local fMul = 1
	if ent:HasEntityFlags(EntityFlag.FLAG_FEAR) then
		fMul = -1
	end
	return ent.Velocity:__add(target.Position:__sub(ent.Position):Normalized():__mul(fMul)):Normalized():__mul(mul)
end

--add a custom PickUp to the PickupHandler
--functions are optional, but it would make sense to pass a pickupF
function Agony:addPickup(type, var, sub, pickupF, spawnF, updateF)
	local t = {
		Type = type,
		Variant = var,
		SubType = sub,
		onPickup = pickupF,
		spawnPickup = spawnF,
		onUpdate = updateF
	}
  --Tree structure
  --         pickUpTree = table of variants
  --           /  \    
  --    varianta   variantb = table of subtypes
  --      /          |     \
  --    subtypea   sub_b    sub_c = pickUp
  --
  if pickUpTree[type] == nil then
    pickUpTree[type] = {}
  end
  
  if pickUpTree[type][var] == nil then
    pickUpTree[type][var] = {}
  end
  
  pickUpTree[type][var][sub] = t
  
  --Store for easy iteration
  table.insert(pickUpTable, t)
end

--the main PickupHandler Function
--it runs the onPickup, spawnPickup and onUpdate functions of our custom PickUps
function Agony:updatePickups()
	local ents = Isaac.GetRoomEntities()
	local player = Isaac.GetPlayer(0)
	local sound = SFXManager()

	for _,ent in pairs(ents) do
    
    local isAgonyPickup = false
    
    --Check existence in pickUpTree
    local variants = pickUpTree[ent.Type]
    if variants ~= nil then
      local subtypes = variants[ent.Variant]
      if subtypes ~= nil then
        local pickUpObj = subtypes[ent.SubType]
        if pickUpObj ~= nil then
          
          isAgonyPickup = true
          
          local data = ent:GetData()
          local sprite = ent:GetSprite()
          
          --called every frame for the pickup, if an update function is given
          if pickUpObj.onUpdate ~= nil then
            pickUpObj:onUpdate(player, sound, data, sprite, ent)
          end
          
          --Pick up the PickUp and run the pickup code
          if player.Position:Distance(ent.Position) <= player.Size + ent.Size + 8 and (data.Picked == nil or data.Picked == false) then
            data.Picked = true
            ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            ent.Velocity = Vector(0,0)
            sprite:Play("Collect")
            if pickUpObj.onPickup ~= nil then
              pickUpObj:onPickup(player, sound, data, sprite, ent)
            end
          elseif data.Picked and sprite:GetFrame() == 6 then
            ent:Remove()
          end
          
        end
      end
    end
    
    --On pickup spawn
    if isAgonyPickup == false and ent.FrameCount <= 1 then
      for _, pickUpObj in pairs(pickUpTable) do
        if pickUpObj.spawnPickup ~= nil then
          pickUpObj:spawnPickup(ent, ent:GetDropRNG())
        end
      end
    end
    
	end
end

function Agony:TearConf()
	local t = {}
	t.TearFlags = 0
	t.SpawnerEntity = nil
	t.Height = -23
	t.FallingAcceleration = 0
	t.FallingSpeed = 0
	t.Color = Color(1,1,1,1,0,0,0)
	t.Data = {}
	t.Scale = 1 --goes in 1/6 steps for the bigger tearsprite
	t.Functions = {} --supported functions are onDeath, onUpdate and onHit

	return t
end

function Agony:updateTears()
	for i, tearObj in pairs(tearTable) do
		local tear = tearObj[1]
		local func = tearObj[2]

		local player = Game():GetNearestPlayer(tear.Position)
		local tData = tear:GetData()

		if not tear:Exists() then
			--run onDeath when the tear doesn't exist
			if func ~= nil and func.onDeath ~= nil then
				func:onDeath(tear.Position, tear.Velocity, tear.SpawnerEntity, tear)
			end
			tearTable[i] = nil
		elseif player.Position:Distance(tear.Position) <= player.Size + tear.Size + 8 and tear.Height >= -30 then
			player:TakeDamage(1, 0, EntityRef(tear), 0)
			--run onHit when tear hits the player
			if func ~= nil and func.onHit ~= nil then
				func:onHit(tear)
			end
			--don't remove the tear if piercing
			if not Agony:HasFlags(tear.TearFlags, TearFlags.TEAR_PIERCING) then
				tear:Die()
			end
		elseif tData.Agony ~= nil and tData.Agony.homing then
			tear.Velocity = Agony:calcTearVel(tear.Position, player.Position, tear.Velocity:Length())
		end

		--run onUpdate on every frame of existance
		if tear:Exists() and func ~= nil and func.onUpdate ~= nil then
			func:onUpdate(tear)
		end
	end
end

function Agony:deleteTears()
	tearTable = {}
end

function Agony:fireTearProj(var, sub, pos, vel, tearConf)
	local t = Isaac.Spawn(EntityType.ENTITY_TEAR, var, sub, pos, vel, tearConf.SpawnerEntity):ToTear()
	t.SpawnerEntity = tearConf.SpawnerEntity
	if tearConf.SpawnerEntity ~= nil then
		t.SpawnerType = tearConf.SpawnerEntity.Type
		t.SpawnerVariant = tearConf.SpawnerEntity.Variant
	end
	t.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	t.TearFlags = tearConf.TearFlags or t.TearFlags
	t.Height = tearConf.Height or -23
	t.FallingAcceleration = tearConf.FallingAcceleration or 0
	t.FallingSpeed = tearConf.FallingSpeed or 0
	t.Color = tearConf.Color or t.Color
	t.Scale = tearConf.Scale or 1

	if tearConf.Data ~= nil then
		Agony:dataCopy(tearConf.Data, t:GetData())
	end

	table.insert(tearTable, {t, tearConf.Functions})
end

function Agony:fireMonstroTearProj(var, sub, pos, vel, tearConf, num, rng, overrideConf)
	overrideConf = overrideConf or {}
	for i = 1, num do
		local deg = rng:RandomInt(21)-10 -- -10 to 10
		local speed = vel:Length() * (1+((rng:RandomInt(8)+1)/10))
		
		--Monstro shot standards
		tearConf.FallingAcceleration = overrideConf.FallingAcceleration or 0.5
		tearConf.FallingSpeed = overrideConf.FallingSpeed or (-5 - rng:RandomInt(11)) -- -15 to -5
		tearConf.Scale = overrideConf.Scale or (1 + (rng:RandomInt(5)-2)/6) -- 4/6 to 8/6

		Agony:fireTearProj(var, sub, pos, vel:Normalized():Rotated(deg):__mul(speed), tearConf)
	end
end

function Agony:fireIpecacTearProj(var, sub, pos, vel, tearConf, overrideConf)
	overrideConf = overrideConf or {}

	tearConf.TearFlags = tearConf.TearFlags or 0
	if not Agony:HasFlags(tearConf.TearFlags, TearFlags.TEAR_EXPLOSIVE) then
		tearConf.TearFlags = Agony:AddFlags(tearConf.TearFlags, TearFlags.TEAR_EXPLOSIVE)
	end

	--Ipecec tear standards
	tearConf.Color = overrideConf.Color or Color(0.5, 1, 0.5, 1, 0, 0, 0)
	tearConf.Height = overrideConf.Height or -35
	tearConf.FallingAcceleration = overrideConf.FallingAcceleration or 0.6
	tearConf.FallingSpeed = overrideConf.FallingSpeed or -10
	tearConf.Scale = overrideConf.Scale or 1
	tearConf.Scale = tearConf.Scale * (1 + 1/3)


	Agony:fireTearProj(var, sub, pos, vel, tearConf)
end

function Agony:fireHomingTearProj(var, sub, pos, vel, tearConf, overrideConf)
	overrideConf = overrideConf or {}
	--Homing tear standards
	tearConf.Color = overrideConf.Color or Color(1, 0.5, 1, 1, 0, 0, 0)
	tearConf.Data.Agony = tearConf.Data.Agony or {}
	tearConf.Data.Agony.homing = true
	
	Agony:fireTearProj(var, sub, pos, vel, tearConf)
end

function Agony:addHelperCallback(callbackType, func, arg)
	if callbackTable[callbackType] == nil then
		callbackTable[callbackType] = {}
	end
	table.insert(callbackTable[callbackType], {func, arg})
end

function Agony:triggerCallback(callbackType, args, callbackArg)
	if callbackTable[callbackType] ~= nil then
		local t = callbackTable[callbackType]
		for i = 1, #t do
			local func = t[i][1]
			local desiredArg = t[i][2] --the wanted argument passed in addHelperCallback()

			if desiredArg == nil or callbackArg == desiredArg then --only run the function if the wanted argument is passed by updateHelperCallbacks()
				func(args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]) --pass up to 10 arguments to function
			end
			if args.cancel == true then
				break
			end
		end
	end
	return args
end

function Agony:updateHelperCallbacks()
	if callbackTable[Agony.Callbacks.ENTITY_SPAWN] ~= nil then
		local ents = Isaac.GetRoomEntities()
		for i = 1, #ents do
			if ents[i].FrameCount <= 1 then
				Agony:triggerCallback(Agony.Callbacks.ENTITY_SPAWN, {ents[i]}, ents[i].Type)
			end
		end
	end
end

function Agony:getCurrTime()
	return dfTime
end

--For example:
--addDelayedFunction(Agony:GetCurrTime() + 30, function (data) DO.STUFF end, {target=69})
--30 frames later
function Agony:addDelayedFunction(time, func, data, cancelOnRoomChange)
	local t = {
		time = time,
		func = func,
		data = data,
		cancelOnRoom = cancelOnRoomChange
	}
	table.insert(delayedFunctions, t)
end

function Agony:updateDelayedFunctions()
	for k,v in pairs(delayedFunctions) do
		if v.time <= dfTime then
			v.func(v.data)
			delayedFunctions[k] = nil
		end
	end
	dfTime = dfTime + 1
end

function Agony:cancelRoomFunctions()
	for k,v in pairs(delayedFunctions) do
		if v.cancelOnRoom == true then
			delayedFunctions[k] = nil
		end
	end
end

function Agony:makeSplat(pos, var, size, ent)
	if size > 1 then
		local num = 2^(2+size) - 8 --calculate number of spawns
		local power = 1 --used to know which ring we're on
		for i=1, num do
			local sub = 2^(2+power) - 8 --need to clean i of the previous ring's numbers for incPowerTrig
			local cleanI = i-sub-1

			local splatNum = 2^(2+power) --how many splats the current ring contains

			if cleanI == splatNum then --start new ring
				power = power+1
			end

			local step = math.pi*(i/(2+2^power)) --input of sin and cos
			Isaac.Spawn(EntityType.ENTITY_EFFECT, var, 0, pos:__add(Vector(power*16*math.sin(step),power*16*math.cos(step))), Vector(0,0), ent)
		end
	else
		Isaac.Spawn(EntityType.ENTITY_EFFECT, var, 0, pos, Vector(0,0), ent)
	end
end

function Agony:getItemNameFromID(id)
	--debug_text = tostring(Isaac.GetItemConfig():GetCollectible(id).Name)
	if id > 0 then
		return tostring(Isaac.GetItemConfig():GetCollectible(id).Name)
	else
		return "zero"
	end
end

--originally wrote this for rerollLockedItems(), but then I thought of something way better
--[[function Agony:pickRandomCol(rng, poolType, includeLocked) 
	poolType = poolType or ItemPoolType.POOL_NULL

	--local numCol = #(Isaac.GetItemConfig():GetCollectibles())
	--if type(numCol) ~= "number" then
	--	numCol = CollectibleType.NUM_COLLECTIBLES
	--end
	-- local col = 0

	local col = Game():GetItemPool():GetCollectible(poolType, false, rng:GetSeed())
	local colName = Agony:getItemNameFromID(col)

	if not includeLocked then
		while saveData.lockedItems[colName] do
			col = Game():GetItemPool():GetCollectible(poolType, false, rng:GetSeed())
			colName = Agony:getItemNameFromID(col)
		end
	end

	return col
end]]

function Agony:removeLockedItems()
	local itemPools = Game():GetItemPool()
	for item, locked in pairs(saveData.lockedItems) do
		if locked then
			itemPools:RemoveCollectible(Isaac.GetItemIdByName(tostring(item)))
		end
	end
end

function Agony:trackUnlockFlags(player)
	--todo: add greed and greedier
	local abort = false
	local unlockTbl = nil
	if player:GetPlayerType() == PlayerType.AGONY_PLAYER_HANNAH then
		unlockTbl = saveData.unlockFlags.Hannah
	else
		abort = true
	end

	if abort then
		Agony:RemoveCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Agony.trackUnlockFlags)
	else
		--debug_tbl2 = unlockTbl
		local room = Game():GetRoom()
		local level = Game():GetLevel()
		local stage = level:GetStage()

		if room:GetType() == RoomType.ROOM_BOSS then
			if not Game():IsGreedMode() then
				if stage == LevelStage.STAGE3_2 and not unlockTbl.Mom and room:IsClear() then --depths 2, mom fight
					Agony:triggerUnlockFlag(unlockTbl, "Mom")
				elseif stage == LevelStage.STAGE4_2 and not unlockTbl.Heart and room:IsClear() then --womb 2, heart fight
					Agony:triggerUnlockFlag(unlockTbl, "Heart")
				elseif stage == LevelStage.STAGE4_3 and not unlockTbl.Hush and room:IsClear() then --womb "3", hush fight
					Agony:triggerUnlockFlag(unlockTbl, "Hush")
				elseif stage == LevelStage.STAGE5 and room:IsClear() then --sheol or cathedral, boss fight
					if level:IsAltStage() and not unlockTbl.Isaac then --cathedral is alt
						Agony:triggerUnlockFlag(unlockTbl, "Isaac") 
					elseif not level:IsAltStage() and not unlockTbl.Satan then --sheol
						Agony:triggerUnlockFlag(unlockTbl, "Satan")
					end
				elseif stage == LevelStage.STAGE6 and room:IsClear() then --dark room and chest, boss fight
					if level:IsAltStage() and not unlockTbl.BlueBaby then --chest is alt
						Agony:triggerUnlockFlag(unlockTbl, "BlueBaby") 
					elseif not level:IsAltStage() and not unlockTbl.Lamb then --dark room
						Agony:triggerUnlockFlag(unlockTbl, "Lamb")
					end
				elseif stage == LevelStage.STAGE7 and room:GetBossID() == 70 and not unlockTbl.Delirium and room:IsClear() then --delirium
					Agony:triggerUnlockFlag(unlockTbl, "Delirium")
				elseif stage == LevelStage.STAGE6 and room:GetBossID() == 55 and not unlockTbl.MegaSatan and room:IsClear() then --mega stan
					Agony:triggerUnlockFlag(unlockTbl, "MegaSatan")
				end
			else
				if stage == LevelStage.STAGE7_GREED and room:GetBossID() == 62 and room:IsClear() then
					if Game().Difficulty == Difficulty.DIFFICULTY_GREEDIER then
						Agony:triggerUnlockFlag(unlockTbl, "Greedier")
					else
						Agony:triggerUnlockFlag(unlockTbl, "Greed")
					end
				end
			end
		elseif room:GetType() == RoomType.ROOM_BOSSRUSH and not unlockTbl.BossRush and room:IsAmbushDone() then --boss rush
			Agony:triggerUnlockFlag(unlockTbl, "BossRush")
		end
	end
end

function Agony:triggerUnlockFlag(unlocks, flag)
	unlocks[flag] = true
	Agony:SaveNow()
	
	--todo: add unlock animation stuff
end

--Debug
require("Debug");
--Enemies
require("code/Monsters/YellowBlock")
require("code/Monsters/HunchBone")
require("code/Monsters/FatFly")
require("code/Monsters/Delusion")
--Eternals
require("code/Monsters/Eternals/RoundWorm");
require("code/Monsters/Eternals/Dip");
require("code/Monsters/Eternals/Squirt");
require("code/Monsters/Eternals/Pooter");
require("code/Monsters/Eternals/SuperPooter");
require("code/Monsters/Eternals/ChampionFetus");
require("code/Monsters/Eternals/Moter");
require("code/Monsters/Eternals/Fly");
require("code/Monsters/Eternals/AttackFly");
require("code/Monsters/Eternals/RedBoomFly");
require("code/Monsters/Eternals/BoomFly");
require("code/Monsters/Eternals/Corn");
require("code/Monsters/Eternals/Sucker");
require("code/Monsters/Eternals/Spider");
require("code/Monsters/Eternals/FullFly");
require("code/Monsters/Eternals/Spit");
require("code/Monsters/Eternals/WalkingSack");
require("code/Monsters/Eternals/BigSpider");
require("code/Monsters/Eternals/WalkingGut");
--Flaming Alts
require("code/Monsters/Flaming Alts/core") --load fire damage detection
--require("code/Monsters/Flaming Alts/Clotty")
--Cocoons
require("code/Monsters/Cocoons/SpiderCocoon")
require("code/Monsters/Cocoons/ChasingCocoon")
require("code/Monsters/Cocoons/ShootingCocoon")
--Creeps
require("code/Monsters/Creeps/StuffedCreep")
require("code/Monsters/Creeps/SickCreep")
--Bosses
require("code/Bosses/Joseph");
--Other entities
-- require("code/Items/Slots/TreasureHoarder");
require("code/Monsters/PlayerClone");

--Items
require("code/Items/Collectibles/LuckysPaw");
require("code/Items/Collectibles/DoubleDown");
require("code/Items/Collectibles/GrowingAnxiety");
-- require("code/Items/Collectibles/TheBigRock");
-- require("code/Items/Collectibles/GasolineJuicebox");
-- require("code/Items/Collectibles/RadioactivePizza");
-- require("code/Items/Collectibles/Triplopia");
require("code/Items/Collectibles/TheRock");
-- require("code/Items/Collectibles/VomitCake");
require("code/Items/Collectibles/Tourette");
require("code/Items/Collectibles/Runestone");
require("code/Items/Collectibles/MagicKit");
require("code/Items/Collectibles/LittleSugarDumdum");
-- require("code/Items/Collectibles/YoureABigGuy");
-- require("code/Items/Collectibles/KnowledgeIsPower");
-- require("code/Items/Collectibles/WrathIsPower");
require("code/Items/Collectibles/LoadedDice");
require("code/Items/Collectibles/Hyperactive");
-- require("code/Items/Collectibles/Tantrum");
-- require("code/Items/Collectibles/D3");
require("code/Items/Collectibles/Cyanide");
--require("");
-- require("code/Items/Collectibles/PyramidHead");
-- require("code/Items/Collectibles/BreadyMold");
--require("code/Items/Collectibles/OvergrownSpine");
--require("");
-- require("code/Items/Collectibles/Tech9000");
require("code/Items/Collectibles/ElectricHair");
require("code/Items/Collectibles/TDDUA");
require("code/Items/Collectibles/PythagoresBody");
require("code/Items/Collectibles/YeuxRevolver");
-- require("code/Items/Collectibles/PovertyIsPower");
require("code/Items/Collectibles/BrotherCancer");
require("code/Items/Collectibles/RememberMeNow");
require("code/Items/Collectibles/Cornucopia");
require("code/Items/Collectibles/PandorasChest");
-- require("code/Items/Collectibles/D5");
-- require("code/Items/Collectibles/SpecialOne");
--require("code/Items/Collectibles/TheLudovicoExperiment"); --This needs to be reworked, it's not an interesting item atm
require("code/Items/Collectibles/Ferrofluid");
-- require("code/Items/Collectibles/LeprechaunsContract");
require("code/Items/Collectibles/FragileConception");
--require("code/Items/Collectibles/TheLudovicoTheory"); --God damn these Ludovico variation are hard to get right
require("code/Items/Collectibles/RigidMind")
-- require("code/Items/Collectibles/DiceTattoo")
-- require("code/Items/Collectibles/SomeonesShoe")
require("code/Items/Collectibles/PersonalBubble")
--require("code/Items/Collectibles/BowlCut")
require("code/Items/Collectibles/Infestation3")
-- require("code/Items/Collectibles/SpooderBoi")
require("code/Items/Collectibles/TheWay")
-- require("code/Items/Collectibles/GoldMan")
require("code/Items/Collectibles/LilRedBook")
require("code/Items/Collectibles/SacramentalWine")
require("code/Items/Collectibles/PyriteNugget")
require("code/Items/Collectibles/IrritatingBracelets")
-- require("code/Items/Collectibles/ProductiveSeizure")
require("code/Items/Collectibles/BirthdayGift")
require("code/Items/Collectibles/CashewMilk")
-- require("code/Items/Collectibles/SafeSpace")
require("code/Items/Collectibles/SocialAnxiety")
-- require("code/Items/Collectibles/Jaundice")
require("code/Items/Collectibles/Vanity")
require("code/Items/Collectibles/Placeholder")
require("code/Items/Collectibles/FathersBlessing")
require("code/Items/Collectibles/TheFireplace")
require("code/Items/Collectibles/ToyHammer")
require("code/Items/Collectibles/TechLessThan3")
require("code/Items/Collectibles/PilgrimsShoe")
require("code/Items/Collectibles/WormKnot")
require("code/Items/Collectibles/EasterEgg")
require("code/Items/Collectibles/SmokersLung")
require("code/Items/Collectibles/StinkEye")
require("code/Items/Collectibles/TheRootOfAnger")
require("code/Items/Collectibles/EggBeater")
-- require("code/Items/Collectibles/NutMilk")
--require("code/Items/Collectibles/SoakedRemote")
require("code/Items/Collectibles/BlindFaith")
require("code/Items/Collectibles/SaintsHood")

--Trinkets
require("code/Items/Trinkets/SwallowedDice")
require("code/Items/Trinkets/PartyPooper")
require("code/Items/Trinkets/BloodyNut")
require("code/Items/Trinkets/LuckyEgg")
require("code/Items/Trinkets/NuclearStone")
require("code/Items/Trinkets/SuicideGod");
require("code/Items/Trinkets/SolomonsCrown");
require("code/Items/Trinkets/BrokenSpike");

--Transformations
-- require("code/Misc/Transformations/God")
-- require("code/Misc/Transformations/MisterBean")
-- require("code/Misc/Transformations/BigD")
-- require("code/Misc/Transformations/Milkman")

--Pickups
--Pills
-- require("code/Items/Pick Ups/Pills/PartyPills");
--Cards
require("code/Items/Pick Ups/Cards/Reload")
--require("code/Items/Pick Ups/Cards/LotteryTicket")
require("code/Items/Pick Ups/Cards/RepairWrench")
--Coins
require("code/Items/Pick Ups/Coins/PyriteCoin")
--Chests
-- require("code/Items/Pick Ups/Chests/Safe")
--Hearts
require("code/Items/Pick Ups/Other/Cherry")

--Familiars
--require("code/Familiars/TinyTinyHorn");
require("code/Familiars/GrudgeHolder");
require("code/Familiars/Soulmates");
require("code/Familiars/DrunkenFly");
require("code/Familiars/MetalBaby");
require("code/Familiars/GoatFetus");
require("code/Familiars/MommysDemon");
-- require("code/Familiars/SackOfSacksOfSacks");
require("code/Familiars/TeslaBaby");
require("code/Familiars/BurntBaby");
require("code/Familiars/ChestOfChests");
require("code/Familiars/GrandpaFly");
require("code/Familiars/BloatedBaby");
-- require("code/Familiars/WaitNo");
require("code/Familiars/Despair");

--Characters
require("code/Characters/Hannah")

--Extra Bits 2

--Agony END

--Callbacks
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.rotateTears)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.respawnV2)
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, Agony.renderSprites)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Agony.clearSaveData)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Agony.removeFriendlyEnemies)
Agony:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Agony.removeFriendlyEnemies)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.reloadPedestal)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.updatePickups)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.updateTears)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Agony.deleteTears)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.updateHelperCallbacks)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.updateDelayedFunctions)
Agony:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Agony.removeLockedItems)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Agony.trackUnlockFlags)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Agony.cancelRoomFunctions)

--ShaderTest
shader_test_strength = 0.0
function Agony:GetShaderParams(shaderName)
	local params = {
		Strength = shader_test_strength,
		Time = Isaac.GetFrameCount() / 30.0
	}
	return params;
end
function Agony:Dmg()
	shader_test_strength = math.min(8,shader_test_strength + 0.5)
end
function Agony:ShaderParamUpdate()
	shader_test_strength = math.max(0,shader_test_strength - 0.05)
end
--Agony:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, Agony.GetShaderParams)
--Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Agony.Dmg)
--Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.ShaderParamUpdate)