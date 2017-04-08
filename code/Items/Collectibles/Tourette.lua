--local item_Tourette = Isaac.GetItemIdByName("Tourette")
local tourette =  {
	TearBool = false,
}

function tourette:randomTear()

	local player = Isaac.GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	local luckMult = math.floor(player.Luck)
	local shootJoy = player:GetShootingJoystick()
	local pos = player.Position
	local vel =  Vector (20*player.ShotSpeed * (.5+(math.random()/2)*(-1*math.random(2))) , 20*player.ShotSpeed * (.5+(math.random()/2)*(-1*math.random(2))))
	--Ludo synergy
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR and entities[i].Parent.Type == 1) then --player == 1.0.0, incubus == 3.80.0
				pos = entities[i].Position
				goto skip
			end
		end	
		::skip::
	end
	--if player is shooting, fire random tears
	if (shootJoy.X ~= 0 or shootJoy.Y ~= 0) or player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
		if (player:HasCollectible(CollectibleType.AGONY_C_TOURETTE)) then
			--Take luck into account
			local Prob = 0
			if luckMult > 0 then
				Prob = Game():GetFrameCount()%(math.ceil(45/((luckMult/2)+1)))
			elseif luckMult == 0 then
				Prob = Game():GetFrameCount()%45
			else
				Prob = Game():GetFrameCount()%(-45*(luckMult-1))
			end	
			if Prob == 0 then
				--Synergies
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
					player:FireDelayedBrimstone(math.random(360), player)
				elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
					player:FireBomb(pos, vel)
				elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
					player:FireTechXLaser(pos, vel, math.random(10)*player.Damage)
				elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
					player:FireTechLaser(pos, 0, vel, false, true)
				else
					player:FireTear(pos, vel, true, true, false)
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, tourette.randomTear)