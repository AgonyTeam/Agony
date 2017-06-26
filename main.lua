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
--require("code/Systems/HelperFunctions")
--require("code/Systems/RoomFairness")

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
		EternalsList[Type] = {[Variant] = {name = Name, danger = Danger or 20}}
	else
		EternalsList[Type][Variant] = {name = Name, danger = Danger or 20}
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

function Agony:getEternal(Type,Variant)
	if Agony:HasEternalSubtype(Type,Variant) then
		return EternalsList[Type][Variant]
	end
	return nil
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

		Agony:fireTearProj(var, sub, pos, vel:Normalized():Rotated(deg) * speed, tearConf)
	end
end

--Kinda like Ministro. Not fully.
function Agony:fireMinistroTearProj(var, sub, pos, vel, tearConf, num, rng, overrideConf)
	overrideConf = overrideConf or {}
	for i = 1, num do
		local deg = rng:RandomInt(32)-15 -- -10 to 10
		local speed = vel:Length() * (rng:RandomFloat()+0.5)
		
		--Monstro shot standards
		tearConf.FallingAcceleration = overrideConf.FallingAcceleration or 0.8
		tearConf.FallingSpeed = overrideConf.FallingSpeed or (-7 - rng:RandomInt(10))
		tearConf.Scale = overrideConf.Scale or (1 + (rng:RandomInt(4)-2)/8)

		Agony:fireTearProj(var, sub, pos, vel:Normalized():Rotated(deg) * speed, tearConf)
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

--[[
--Enemies
require("code/Monsters/YellowBlock")
require("code/Monsters/HunchBone")
require("code/Monsters/FatFly")
require("code/Monsters/Delusion")

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
require("code/Monsters/Eternals/TickingSpider");
require("code/Monsters/Eternals/Horf");
--Eternal Spirit
require("code/Monsters/Eternals/Spirit");
--Flaming Alts
require("code/Monsters/Flaming Alts/core") --load fire damage detection

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
require("code/Monsters/PlayerClone");

--Items
require("code/Items/Collectibles/LuckysPaw");
require("code/Items/Collectibles/DoubleDown");
require("code/Items/Collectibles/GrowingAnxiety");
require("code/Items/Collectibles/TheRock");
require("code/Items/Collectibles/Tourette");
require("code/Items/Collectibles/Runestone");
require("code/Items/Collectibles/MagicKit");
require("code/Items/Collectibles/LittleSugarDumdum");
require("code/Items/Collectibles/LoadedDice");
require("code/Items/Collectibles/Hyperactive");
require("code/Items/Collectibles/Cyanide");
require("code/Items/Collectibles/ElectricHair");
require("code/Items/Collectibles/TDDUA");
require("code/Items/Collectibles/PythagoresBody");
require("code/Items/Collectibles/YeuxRevolver");
require("code/Items/Collectibles/BrotherCancer");
require("code/Items/Collectibles/RememberMeNow");
require("code/Items/Collectibles/Cornucopia");
require("code/Items/Collectibles/PandorasChest");
require("code/Items/Collectibles/Ferrofluid");
require("code/Items/Collectibles/FragileConception");
require("code/Items/Collectibles/RigidMind")
require("code/Items/Collectibles/PersonalBubble")
require("code/Items/Collectibles/Infestation3")
require("code/Items/Collectibles/TheWay")
require("code/Items/Collectibles/LilRedBook")
require("code/Items/Collectibles/SacramentalWine")
require("code/Items/Collectibles/PyriteNugget")
require("code/Items/Collectibles/IrritatingBracelets")
require("code/Items/Collectibles/BirthdayGift")
require("code/Items/Collectibles/CashewMilk")
require("code/Items/Collectibles/SocialAnxiety")
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



--Pickups
--Pills
--Cards
require("code/Items/Pick Ups/Cards/Reload")
require("code/Items/Pick Ups/Cards/RepairWrench")
--Coins
require("code/Items/Pick Ups/Coins/PyriteCoin")
--Chests
--Hearts
require("code/Items/Pick Ups/Other/Cherry")

--Familiars
require("code/Familiars/GospelChild");
require("code/Familiars/GrudgeHolder");
require("code/Familiars/Soulmates");
require("code/Familiars/DrunkenFly");
require("code/Familiars/MetalBaby");
require("code/Familiars/GoatFetus");
require("code/Familiars/MommysDemon");
require("code/Familiars/TeslaBaby");
require("code/Familiars/BurntBaby");
require("code/Familiars/ChestOfChests");
require("code/Familiars/GrandpaFly");
require("code/Familiars/BloatedBaby");
require("code/Familiars/Despair");

--Characters
require("code/Characters/Hannah")
]]

--Agony END

--Callbacks
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.rotateTears)
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
--Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Agony.trackUnlockFlags)
Agony:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Agony.cancelRoomFunctions)


--/\/\/\/\/\/\/\/\/\/\/\/\--
--		old code above    --
local function run()
	Agony.FW = ExtraFW:addMod(Agony)

	require("code/Bosses/Dross Bros/Slicker")
end

if ExtraFW then
	run()
else
	runExtraFW = runExtraFW or {}
	runExtraFW[#runExtraFW+1] = run
end