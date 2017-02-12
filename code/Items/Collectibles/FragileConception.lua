CollectibleType["AGONY_C_FRAGILE_CONCEPTION"] = Isaac.GetItemIdByName("Fragile Conception");

local fragileConception =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	stage = nil,
	dmgTot = 0,
	famSpawned = 0,
	famList = {}
}
fragileConception.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_fragileconception.anm2")

--Make a table with all the familiars this item can spawn
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_BROTHER_BOBBY)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_STEVEN)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_ROBO_BABY)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_SISTER_MAGGY)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_ABEL)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_HARLEQUIN_BABY)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_RAINBOW_BABY)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_PEEPER)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_BUM_FRIEND)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_CUBE_OF_MEAT)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_PUNCHING_BAG)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_GEMINI)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_KEY_BUM)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_LIL_GURDY)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES)
table.insert(fragileConception.famList,CollectibleType.COLLECTIBLE_BUMBO)

function fragileConception:onUpdate()
	--Check fi the player has taken damage this stage
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_FRAGILE_CONCEPTION) then
		if fragileConception.stage == nil then
			fragileConception.stage = Game():GetLevel():GetStage()
		elseif fragileConception.stage ~= Game():GetLevel():GetStage() then
			fragileConception.stage = Game():GetLevel():GetStage()
			if fragileConception.dmgTot < player:GetTotalDamageTaken() then
				fragileConception.dmgTot = player:GetTotalDamageTaken()
			else
				player:AddCollectible(fragileConception.famList[math.random(#fragileConception.famList+1)], 0, false)
			end
		end
	end
end

function fragileConception:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		fragileConception.hasItem = false
	end
	if fragileConception.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_FRAGILE_CONCEPTION) then
		--player:AddNullCostume(fragileConception.costumeID)
		fragileConception.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, fragileConception.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, fragileConception.onPlayerUpdate)