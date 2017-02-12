CollectibleType["AGONY_C_THE_LUDOVICO_EXPERIMENT"] = Isaac.GetItemIdByName("The Ludovico Experiment");

local ludoExp =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	attractor = nil,
	room = nil
}
ludoExp.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_theludovicoexperiment.anm2")

function ludoExp:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		ludoExp.hasItem = false
	end
	if ludoExp.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_THE_LUDOVICO_EXPERIMENT) then
		--player:AddNullCostume(ludoExp.costumeID)
		ludoExp.hasItem = true
	end
end

function ludoExp:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_THE_LUDOVICO_EXPERIMENT)) then
		player.TearFallingSpeed = 5
		player.TearFallingAcceleration = 0
		player.TearFlags = 1
		player.TearHeight = player.TearHeight*1.1
	end
end

function ludoExp:attractTears()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_THE_LUDOVICO_EXPERIMENT) then
		if ludoExp.room == nil then
			ludoExp.room = Game():GetLevel():GetCurrentRoomIndex()
		elseif ludoExp.room ~= Game():GetLevel():GetCurrentRoomIndex() then
			ludoExp.room = Game():GetLevel():GetCurrentRoomIndex()
		end
		--ludoExp.attractor = player.Position:__add(Vector(100,0):Rotated((Game():GetFrameCount()*2)%360))
		ludoExp.attractor = player.Position:__add(player:GetShootingJoystick():__mul(100):Rotated(10))
		Game():SpawnParticles(ludoExp.attractor, EffectVariant.CROSS_POOF, 1, 1, player.Color, 0)
		local entList = Isaac.GetRoomEntities()
		for i = 1, #entList, 1 do
			if entList[i].Type == EntityType.ENTITY_TEAR then
				local attrV = ludoExp.attractor:__sub(entList[i].Position)
				entList[i].Velocity = entList[i].Velocity:__div(1)
				entList[i]:AddVelocity(attrV:__div(attrV:LengthSquared()/99))
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, ludoExp.attractTears)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ludoExp.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ludoExp.onPlayerUpdate)