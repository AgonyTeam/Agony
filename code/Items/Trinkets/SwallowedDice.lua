
local swallowedDice = {}

function swallowedDice:onTakeDmg()
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(TrinketType.AGONY_T_SWALLOWED_DICE) then
		local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_D3)
	
		if player:GetCollectibleCount() >= 1 then --If the player has collectibles
		    local colletibles = {}
	        for name, id in pairs(CollectibleType) do --Iterate over all collectibles to see if the player has it, as far as I know you can't get the current collectible list
	            if (name ~= "NUM_COLLECTIBLES" and player:HasCollectible(id)) then --If they have it add it to the table
	                table.insert(colletibles, id)
	            end
	        end
	        player:RemoveCollectible(colletibles[rng:RandomInt(#colletibles)+1])
	        player:AddCollectible(rng:RandomInt(CollectibleType.NUM_COLLECTIBLES)+1, 0, true)
	        --POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(player.Position, EffectVariant.POOF01, 1, 1, col, 0)
	    end
	end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, swallowedDice.onTakeDmg, EntityType.ENTITY_PLAYER)