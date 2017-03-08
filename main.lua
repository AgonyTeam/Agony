--StartDebug();
Agony = RegisterMod("The Agony of Isaac", 1);
local json = require("json")

--SaveData
local newestSaveVer = 2;
if Isaac.HasModData(Agony) then
	saveData = json.decode(Isaac.LoadModData(Agony));
	if saveData.saveVer == nil or saveData.saveVer ~= newestSaveVer then
		saveData = {saveVer = newestSaveVer};
	end
else
	saveData = {saveVer = newestSaveVer};
end

saveData.gasolinejb = saveData.gasolinejb or {};
saveData.radioactivePizza = saveData.radioactivePizza or {};
saveData.Sacks3 = saveData.Sacks3 or {};
saveData.Sacks2 = saveData.Sacks2 or {};
saveData.theWay = saveData.theWay or {}

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
	EntityType.AGONY_ETYPE_TREASURE_HOARDER,
	EntityType.AGONY_ETYPE_YELLOW_BLOCK
}

--spritesToRender table
spritesToRender = {}

--make the game save the saveData table
function Agony:SaveNow()
	Isaac.SaveModData(Agony, json.encode(saveData));
end

--Eternal al list
local EternalsList = {}
function Agony:AddEternal(Type,Variant,Name)
	table.insert(EternalsList, Type)
	table.insert(EternalsList, Variant)
	table.insert(EternalsList, Name)
end

function Agony:getEternalList()
	return EternalsList
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

--Calculates the velocity a tear needs to have to hit a target Position
function Agony:calcTearVel(sourcePos, targetPos, multiplier)
	return targetPos:__sub(sourcePos):Normalized():__mul(multiplier);
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
	local giantbook = Sprite()
	giantbook:Load("gfx/ui/giantbook/" .. customAnm2, true)
	giantbook:ReplaceSpritesheet(0, "gfx/ui/giantbook/" .. bookSprite)
	giantbook:LoadGraphics()
	giantbook:Play(animName, true)
	--testsprite:Reload()
	spritesToRender[#spritesToRender+1] = { 
		giantbook,
		Vector((640-128-48)/2, (460-128-48)/2) --640 is the room width, 460 is height. Have to subtract 128 to center the book sprite and 48 because only then it apparently is like the vanilla giant book effect
	}
end

--Render all sprites in spritesToRender
function Agony:renderSprites()
	for _,spriteTable in pairs(spritesToRender) do
		local sprite = spriteTable[1]
		local renderPos = spriteTable[2]
		sprite:Render(renderPos, Vector(0,0), Vector(0,0))
		sprite:Update()
	end
end


--Extra Bits
PickupVariant["AGONY_PICKUP_COIN"] = 520 --Agony Coins

--Debug
require("Debug");
--require("EntityRegister")
--require("entnames")
--require("printentnames")
--Enemies
require("code/Monsters/YellowBlock");
--Eternals
require("code/Monsters/Eternals/RoundWorm");
require("code/Monsters/Eternals/Dip");
require("code/Monsters/Eternals/Squirt");
require("code/Monsters/Eternals/Pooter");
require("code/Monsters/Eternals/SuperPooter");
require("code/Monsters/Eternals/ChampionFetus");
require("code/Monsters/Eternals/Moter");
--Bosses
require("code/Bosses/Joseph");
--Other Entities
require("code/Items/Slots/TreasureHoarder");
--Items
require("code/Items/Collectibles/LuckyLeg");
require("code/Items/Collectibles/DoubleDown");
require("code/Items/Collectibles/GrowingAnxiety");
require("code/Items/Collectibles/TheBigRock");
require("code/Items/Collectibles/GasolineJuicebox");
require("code/Items/Collectibles/RadioactivePizza");
require("code/Items/Collectibles/Triplopia");
require("code/Items/Collectibles/TheRock");
require("code/Items/Collectibles/VomitCake");
require("code/Items/Collectibles/Tourette");
require("code/Items/Collectibles/Runestone");
require("code/Items/Collectibles/MagicKit");
require("code/Items/Collectibles/LittleSugarDumdum");
require("code/Items/Collectibles/YoureABigGuy");
require("code/Items/Collectibles/KnowledgeIsPower");
require("code/Items/Collectibles/WrathIsPower");
require("code/Items/Collectibles/LoadedDice");
require("code/Items/Collectibles/Hyperactive");
require("code/Items/Collectibles/Tantrum");
require("code/Items/Collectibles/D3");
require("code/Items/Collectibles/Cyanide");
require("code/Items/Collectibles/SuicideGod");
require("code/Items/Collectibles/PyramidHead");
require("code/Items/Collectibles/BreadyMold");
require("code/Items/Collectibles/OvergrownSpine");
require("code/Items/Collectibles/SolomonsCrown");
require("code/Items/Collectibles/Tech9000");
require("code/Items/Collectibles/ElectricHair");
require("code/Items/Collectibles/TDDUA");
require("code/Items/Collectibles/PythagoresBody");
require("code/Items/Collectibles/YeuxRevolver");
require("code/Items/Collectibles/PovertyIsPower");
require("code/Items/Collectibles/BrotherCancer");
require("code/Items/Collectibles/RememberMeNow");
require("code/Items/Collectibles/Cornucopia");
require("code/Items/Collectibles/PandorasChest");
require("code/Items/Collectibles/Despair");
require("code/Items/Collectibles/D5");
require("code/Items/Collectibles/SpecialOne");
--require("code/Items/Collectibles/TheLudovicoExperiment"); --This needs to be reworked, it's not an interesting item atm
require("code/Items/Collectibles/Ferrofluid");
require("code/Items/Collectibles/LeprechaunsContract");
require("code/Items/Collectibles/FragileConception");
--require("code/Items/Collectibles/TheLudovicoTheory"); --God damn these Ludovico variation are hard to get right
require("code/Items/Collectibles/RigidMind")
require("code/Items/Collectibles/DiceTattoo")
require("code/Items/Collectibles/SomeonesShoe")
require("code/Items/Collectibles/PersonalBubble")
require("code/Items/Collectibles/BowlCut")
require("code/Items/Collectibles/Parasites")
require("code/Items/Collectibles/SpooderBoi")
require("code/Items/Collectibles/TheWay")
require("code/Items/Collectibles/GoldMan")
require("code/Items/Collectibles/LilRedBook")
require("code/Items/Collectibles/SacramentalWine")
require("code/Items/Collectibles/PyriteNugget")

--Trinkets
require("code/Items/Trinkets/SwallowedDice")
require("code/Items/Trinkets/PartyPooper")

--Transformations
require("code/Misc/Transformations/God")

--Pills
require("code/Items/Pick Ups/Pills/PartyPills");

--Cards
require("code/Items/Pick Ups/Cards/Reload")

--Coins
require("code/Items/Pick Ups/Coins/PyriteCoin")

--Familiars
require("code/Familiars/TinyTinyHorn");
require("code/Familiars/GrudgeHolder");
require("code/Familiars/Soulmates");
require("code/Familiars/DrunkenFly");
require("code/Familiars/MetalBaby");
require("code/Familiars/GoatFetus");
require("code/Familiars/MommysDemon");
require("code/Familiars/SackOfSacksOfSacks");
require("code/Familiars/TeslaBaby");
require("code/Familiars/BurntBaby");
require("code/Familiars/ChestOfChests");
require("code/Familiars/GrandpaFly");
require("code/Familiars/BloatedBaby");
require("code/Familiars/WaitNo");

--Extra Bits 2
local num_collectibles = 0 --update NUM_COLLECTIBLES to include all new items
for name, id in pairs(CollectibleType) do --because #CollectibleType is 0 for some reason, I'll have to count them this way
	if name ~= "NUM_COLLECTIBLES" then
		num_collectibles = num_collectibles + 1
	end
end
CollectibleType.NUM_COLLECTIBLES = num_collectibles 

--Agony END

--Callbacks
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, Agony.respawnV2);
Agony:AddCallback(ModCallbacks.MC_POST_RENDER, Agony.renderSprites);
