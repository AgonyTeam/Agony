local someonesshoe = {
	bList = {
		EntityType.ENTITY_ROUND_WORM,
		EntityType.ENTITY_NIGHT_CRAWLER,
		EntityType.ENTITY_WALL_CREEP,
		EntityType.ENTITY_RAGE_CREEP,
		EntityType.ENTITY_BLIND_CREEP,
		304, --that new red wall spider I don't like -dedChar I don't like it either - Tez
		EntityType.ENTITY_THE_HAUNT,
		EntityType.ENTITY_MEGA_SATAN,
		EntityType.ENTITY_MEGA_SATAN_2,
		EntityType.ENTITY_MOM,
		EntityType.ENTITY_GURDY,
		EntityType.ENTITY_MOMS_HEART,
		EntityType.ENTITY_EYE,
		EntityType.ENTITY_BOIL
	},
	wList = {
		302 --Stoneys, you know, that enemiy nicalis stole from us
	}
};

function someonesshoe:onUse()
	--Switch places with furthest away enemy
	local player = Isaac.GetPlayer(0);
	local targetEnt = Agony:getFurthestEnemy(player, someonesshoe.wList, someonesshoe.bList);
	if targetEnt == player then
		goto skip
	end
	local targetPos = targetEnt.Position
	local playerPos = player.Position
	
	player:AnimateTeleport(true)
	targetEnt.Position = playerPos
	targetEnt:AddHealth(-player.Damage*3)
	player.Position = targetPos
	player:SetMinDamageCooldown(120)
	player:AnimateTeleport(false)
	::skip::
end

function someonesshoe:fillCharge()
	local player = Isaac.GetPlayer(0)
	--debug_text = tostring(player:GetActiveSubCharge()) .. " " .. tostring(player:GetActiveCharge()) .. " " .. tostring(Game():GetFrameCount()) .. " " .. tostring(player:HasTimedItem())
	if player:HasCollectible(CollectibleType.AGONY_C_SOMEONES_SHOE) and player:NeedsCharge() and Game():GetFrameCount()%30 == 0 then
		player:SetActiveCharge(player:GetActiveCharge()+30)
	end
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, someonesshoe.onUse, CollectibleType.AGONY_C_SOMEONES_SHOE)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, someonesshoe.fillCharge)