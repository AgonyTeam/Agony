--local item_VomitCake = Isaac.GetItemIdByName("Vomit Cake")
CollectibleType["AGONY_C_VOMIT_CAKE"] = Isaac.GetItemIdByName("Vomit Cake");
local vomitCake =  {	
	hasItem = nil, --used for costume
	costumeID = nil
}
vomitCake.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_vomitcake.anm2")

function vomitCake:spawnCreep(player)
	if player:HasCollectible(CollectibleType.AGONY_C_VOMIT_CAKE) == true then
		local luckMult = math.floor(player.Luck)
		local shootJoy = player:GetShootingJoystick()
		if shootJoy.X ~= 0 or shootJoy.Y ~= 0 then
			local pos = player.Position
			local vomitProb = 0
			if luckMult > 0 then
				vomitProb = Game():GetFrameCount()%(math.floor(300/(luckMult+1)))
			elseif luckMult == 0 then
				vomitProb = Game():GetFrameCount()%300
			else
				vomitProb = Game():GetFrameCount()%(-300*(luckMult-1))
			end
			
			for i = 1, 10, 1 do
				if vomitProb == i then
					pos = pos + shootJoy*25*i
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN , 0, pos, Vector (0,0), player)
				end
			end
		end
	end
end

function vomitCake:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		vomitCake.hasItem = false
	end
	if vomitCake.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_VOMIT_CAKE) then
		player:AddNullCostume(vomitCake.costumeID)
		vomitCake.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, vomitCake.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, vomitCake.spawnCreep)