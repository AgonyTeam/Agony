Agony = RegisterMod("The Agony of Isaac", 1);
--StartDebug();

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
Include("code/Monsters/EternalMonsters.lua");
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

--Pills
Include("code/Items/Pick Ups/PartyPills.lua");


--respawnV2's vars
local ent_before = {};
local rspwn_allow = false;
local spwn_list = {};
local level_seed_backup = 666;

local respawnIDs = { --holds all IDs that need to be respawned
	yb_entitytype,
	treasurehoarder.entityType
}

function Agony:respawnV2()
	local room = Game():GetRoom();
	local level = Game():GetLevel();

	local level_seed = level:GetDungeonPlacementSeed(); --level identification
	local room_seed = room:GetSpawnSeed(); --for room identification
	
	--debug_text = tostring(room:IsClear()) .. " " .. tostring(room:IsFirstVisit()) --room_seed .. " | " .. level_seed .. " | GameFrmcnt: " .. Game():GetFrameCount();-- " | RoomFrmcnt: " .. room:GetFrameCount() .. " | GameFrmcnt: " .. Game():GetFrameCount() .. " | IsClear: " .. tostring(room:IsClear());
	--debug_text = Isaac.LoadModData(Agony) .. " | " .. tostring(Isaac.HasModData(Agony));
	
	if(Isaac.HasModData(Agony) == true and Game():GetFrameCount() > 1 and level_seed_backup == 666) then --restore data when continuing run after having the game closed
		spwn_list = string_totable(Isaac.LoadModData(Agony));
		level_seed_backup = level_seed;
		rspwn_allow = true;
	end
	
	if(Game():GetFrameCount() == 1 or (level_seed ~= level_seed_backup and Game():GetFrameCount() > 1)) then --reset vars and delete savedata when restarting run and entering a new level
		spwn_list = {};
		rspwn_allow = false;
		ent_before = {};
		Isaac.RemoveModData(Agony);
		level_seed_backup = level_seed;
	end

	for i = 1, #spwn_list, 6 do
		--Isaac.RenderText(spwn_list[i], 400, 100 + ((i / 6) *10), 255, 0, 0, 255);
		if (room:IsFirstVisit() == false and room:IsClear() == true and spwn_list[i] == room_seed and room:GetFrameCount() == 1) then
			rspwn_allow = true;
		end	
	end
	
	if (room:IsFirstVisit() == false and room:IsClear() == true and rspwn_allow == true) then --run only if this room truly has been visited before and actually cleared (not skipped with e.g. bombs)
		for i = 1, #spwn_list, 6 do
			if (spwn_list[i] == room_seed) then
				Isaac.Spawn(spwn_list[i+1], spwn_list[i+2], spwn_list[i+3], Vector(spwn_list[i+4], spwn_list[i+5]), Vector(0,0), Isaac.GetPlayer(0));
			end	
		end
		rspwn_allow = false; --avoid looping the respawn and remove
	elseif (room:IsFirstVisit() == true and room:GetFrameCount() == 1) then --check if new room has respawnable entity inside, only once on the first room entry
		ent_before = Isaac.GetRoomEntities();
		for i = 1, #ent_before do
			for j=1, #respawnIDs do
				if (ent_before[i].Type == respawnIDs[j]) then
					table.insert(spwn_list, 1, room_seed);
					table.insert(spwn_list, 2, ent_before[i].Type);
					table.insert(spwn_list, 3, ent_before[i].Variant);
					table.insert(spwn_list, 4, ent_before[i].SubType);
					table.insert(spwn_list, 5, ent_before[i].Position.X);
					table.insert(spwn_list, 6, ent_before[i].Position.Y);
				end
			end	
		end
		Isaac.SaveModData(Agony, table_tostring(spwn_list)); --save the latest table for the case of game exit
	end
end

function table_tostring(t)
	local s = "";
	for i = 1, #t do
		s = s .. t[i] .. " ";
	end
	s = s:sub(1, -2) --remove last space
	
	return s;
end

function string_totable(s)
	local t = {};
	for part in string.gmatch(s, "%S+") do
		t[#t + 1] = tonumber(part);
	end
	
	return t;
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

