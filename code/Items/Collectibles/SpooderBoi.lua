local spooderBoi =  {
	spooderList = Agony.ENUMS["EnemyLists"]["Spooders"]
}

function spooderBoi:onPlayerUpdate(player)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_SPOODER_BOI)
	if player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI) then
		if math.random(300) == 1 then
			local r = (rng:RandomInt(#spooderBoi.spooderList))+1
			local spooder = Isaac.Spawn(spooderBoi.spooderList[r][1], spooderBoi.spooderList[r][2], 0, player.Position, Vector (0,0), player)
			spooder:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM);
		end
	end
end

function spooderBoi:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SPOODER_BOI)) then
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
		player.MoveSpeed = player.MoveSpeed + 0.3;
		end
	end
end


Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, spooderBoi.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, spooderBoi.cacheUpdate)