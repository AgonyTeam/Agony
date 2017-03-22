local irritatingBracelets =  {}

function irritatingBracelets:onUse()
	local player = Game():GetPlayer(0)
	--Reflects enemy tears
	local entities = Isaac.GetRoomEntities()
	for i = 1, #entities do
		if (entities[i].Type == EntityType.ENTITY_PROJECTILE) and entities[i].Position:Distance(player.Position) < 50 then
			player:FireTear(entities[i].Position, entities[i].Velocity:__mul(-1), false, true, false)
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