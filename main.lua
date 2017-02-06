--StartDebug();
Agony = RegisterMod("The Agony of Isaac", 1);
local json = require("json")

--https://www.reddit.com/r/themoddingofisaac/comments/5ml25i/how_to_make_it_so_a_stat_modification_only_lasts/dc6uhnf/
--needed to load other lua files right now and it only works when --luadebug is set in game properties
--later nicalis will add require() preoperly
function Include(aFilename)
  local sourcePath = debug.getinfo(1, "S").source:sub(2)
  local baseDir = sourcePath:match(".*/") or "./"

  dofile( ("%s%s"):format(baseDir, aFilename) )
end


--Debug
Include("Debug.lua");
--Enemies
Include("code/Monsters/YellowBlock.lua");
--Eternals
Include("code/Monsters/Eternals/RoundWorm.lua");
--Other Entities
Include("code/Items/Slots/TreasureHoarder.lua");
--Items
Include("code/Items/Collectibles/LuckyLeg.lua");
Include("code/Items/Collectibles/DoubleDown.lua");
Include("code/Items/Collectibles/GrowingAnxiety.lua");
Include("code/Items/Collectibles/TheBigRock.lua");
Include("code/Items/Collectibles/GasolineJuicebox.lua");
Include("code/Items/Collectibles/RadioactivePizza.lua");
Include("code/Items/Collectibles/Triplopia.lua");
Include("code/Items/Collectibles/TheRock.lua");
Include("code/Items/Collectibles/VomitCake.lua");
Include("code/Items/Collectibles/Tourette.lua");
Include("code/Items/Collectibles/Runestone.lua");
Include("code/Items/Collectibles/MagicKit.lua");
Include("code/Items/Collectibles/LittleSugarDumdum.lua");
Include("code/Items/Collectibles/YoureABigGuy.lua");
Include("code/Items/Collectibles/KnowledgeIsPower.lua");
Include("code/Items/Collectibles/WrathIsPower.lua");
Include("code/Items/Collectibles/LoadedDice.lua");
Include("code/Items/Collectibles/Hyperactive.lua");
Include("code/Items/Collectibles/Tantrum.lua");
Include("code/Items/Collectibles/D3.lua");
Include("code/Items/Collectibles/Cyanide.lua");
Include("code/Items/Collectibles/SuicideGod.lua");
Include("code/Items/Collectibles/PyramidHead.lua");
Include("code/Items/Collectibles/BreadyMold.lua");
Include("code/Items/Collectibles/OvergrownSpine.lua");
Include("code/Items/Collectibles/SolomonsCrown.lua");
Include("code/Items/Collectibles/Tech9000.lua");
Include("code/Items/Collectibles/ElectricHair.lua");
Include("code/Items/Collectibles/TDDUA.lua");
Include("code/Items/Collectibles/PythagoresBody.lua");
Include("code/Items/Collectibles/YeuxRevolver.lua");
Include("code/Items/Collectibles/PovertyIsPower.lua");
Include("code/Items/Collectibles/BrotherCancer.lua");
Include("code/Items/Collectibles/RememberMeNow.lua");
Include("code/Items/Collectibles/Cornucopia.lua");
Include("code/Items/Collectibles/PandorasChest.lua");
Include("code/Items/Collectibles/Despair.lua");
Include("code/Items/Collectibles/D5.lua");
Include("code/Items/Collectibles/SpecialOne.lua");
--Include("code/Items/Collectibles/TheLudovicoExperiment.lua"); --This needs to be reworked, it's not an interesting item atm
Include("code/Items/Collectibles/Ferrofluid.lua");

--Pills
Include("code/Items/Pick Ups/PartyPills.lua");

--SaveData
if Isaac.HasModData(Agony) then
	saveData = json.decode(Isaac.LoadModData(Agony));
else
	saveData = {};
end

--respawnV2's vars
local ent_before = {};
local rspwn_allow = false;
saveData.spwn_list = saveData.spwn_list or {}; --either load list from save, or make an empty one
local level_seed_backup = 666;
local redo = false;
local redo2 = false;

local respawnIDs = { --holds all IDs that need to be respawned
	EntityType.AGONY_ETYPE_TREASURE_HOARDER,
	EntityType.AGONY_ETYPE_YELLOW_BLOCK
}

--make the game save the saveData table
function SaveNow()
	Isaac.SaveModData(Agony, json.encode(saveData));
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
		rspwn_allow = false;
		ent_before = {};
		--Isaac.RemoveModData(Agony);
		SaveNow();
		level_seed_backup = level_seed;
	end

	for i = 1, #saveData.spwn_list, 6 do
		--Isaac.RenderText(spwn_list[i], 400, 100 + ((i / 6) *10), 255, 0, 0, 255);
		if (room:IsFirstVisit() == false and room:IsClear() == true and saveData.spwn_list[i] == room_seed and room:GetFrameCount() == 1) then
			rspwn_allow = true;
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
	elseif ((room:IsFirstVisit() == true and room:GetFrameCount() == 1) or redo2 == true) then --check if new room has respawnable entity inside, only once on the first room entry
		ent_before = Isaac.GetRoomEntities();
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
		SaveNow();
	end
end

--recreates entries for spwn_list of current room
function Agony:redoSpawnList()
	redo = true;
end

--Calculates the velocity a tear needs to have to hit a target Position
function Agony:calcTearVel(sourcePos, targetPos, multiplier)
	return targetPos:__sub(sourcePos):Normalized():__mul(multiplier);
end

--returns the nearest Enemy
function Agony:getNearestEnemy(sourceEnt)
	local entities = Isaac.GetRoomEntities();
	local smallestDist = nil;
	local nearestEnt = nil;
	
	for i = 1, #entities do
		if (entities[i] ~= sourceEnt and entities[i]:IsVulnerableEnemy()) then
			if (smallestDist == nil or sourceEnt.Position:Distance(entities[i].Position) < smallestDist) then
				smallestDist = sourceEnt.Position:Distance(entities[i].Position);
				nearestEnt = entities[i];
			end
		end
	end
	
	if (nearestEnt == nil) then
		return sourceEnt;
	else	
		return nearestEnt;
	end
end

--Agony END


--Callbacks
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.respawnV2);