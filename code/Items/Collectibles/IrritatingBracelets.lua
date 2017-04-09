local irritatingBracelets =  {}

function irritatingBracelets:onUse()
	local player = Game():GetPlayer(0)
	--Reflects enemy tears
	local entities = Isaac.GetRoomEntities()
	for i = 1, #entities do
		if (entities[i].Type == EntityType.ENTITY_PROJECTILE) and entities[i].Position:Distance(player.Position) < 50 then
			player:FireTear(entities[i].Position, entities[i].Velocity:__mul(-1), false, true, false)
			--POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(entities[i].Position, EffectVariant.POOF01, 1, 1, col, 0)
			entities[i]:Remove()
		end
	end
	return true
end

function irritatingBracelets:onUpdate()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_IRRITATING_BRACELETS) and player:NeedsCharge() and Game():GetFrameCount()%60 == 0 then
		player:SetActiveCharge(player:GetActiveCharge()+1)
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, irritatingBracelets.onUpdate)
Agony:AddCallback(ModCallbacks.MC_USE_ITEM, irritatingBracelets.onUse, CollectibleType.AGONY_C_IRRITATING_BRACELETS)