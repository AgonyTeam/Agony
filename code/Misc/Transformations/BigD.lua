local bigD =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	requireditems = Agony.ENUMS["ItemPools"]["Ds"],
	Items = saveData.bigD.Items or {} --Keeps track of what Items the player has had
}
bigD.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/trans_bigd.anm2")

function bigD:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		bigD.hasItem = false
		bigD.Items = {}
	end
	for i = 1, #bigD.requireditems do
		if player:HasCollectible(bigD.requireditems[i]) then
			local isNew = true
			for j = 1, #bigD.Items do
				if bigD.Items[j] == bigD.requireditems[i] then
					isNew = false 
				end
			end
			if isNew then
				table.insert(bigD.Items, bigD.requireditems[i])
				saveData.bigD.Items = bigD.Items
				Agony:SaveNow()
			end
		end
	end
	if #bigD.Items > 2 then
		if bigD.hasItem == false then
			player:AddNullCostume(bigD.costumeID)
			bigD.hasItem = true
			--POOF!
			local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
			col:Reset()
			Game():SpawnParticles(player.Position, EffectVariant.POOF01, 1, 1, col, 0)
		end
	end
end


function bigD:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if bigD.hasItem then
    if player.Luck > 0 then
  		Prob = math.floor(math.random(5000)%(math.floor(300/(player.Luck+1))))
  	elseif player.Luck == 0 then
  		Prob = math.random(5000)%300
  	else
  		Prob = math.random(5000)%(-300*(player.Luck-1))
  	end
    for _,entity in pairs(ents) do
    	if entity.Type == EntityType.ENTITY_TEAR then
    		if entity.FrameCount == 1 and Prob == 1 then
    			--TODO : Change gfx to D
    			entity:GetSprite():ReplaceSpritesheet(0, "gfx/effect/tear_bigd.png")
          		entity:GetSprite():LoadGraphics()
    			entity.SubType = AgonyTearSubtype.BIG_D
    		end
    	end
    end
  end
end

function bigD:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    if source.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == AgonyTearSubtype.BIG_D and not hurtEntity:IsBoss() and hurtEntity:IsVulnerableEnemy() then
    	local col = Color(255,255,255,255,0,0,0) -- Used to set the poof color
		col:Reset()
		Game():SpawnParticles(hurtEntity.Position, EffectVariant.POOF01, 1, 1, col, 0)
		if math.random(100) == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NULL, hurtEntity.Position, Vector(0, 0), player)
		elseif math.random(20) == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, ChestSubType.CHEST_CLOSED, hurtEntity.Position, Vector(0, 0), player)
		elseif math.random(4) == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, hurtEntity.Position, Vector(0, 0), player)
		elseif math.random(3) == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, hurtEntity.Position, Vector(0, 0), player)
		elseif math.random(2) == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, hurtEntity.Position, Vector(0, 0), player)
		else
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, hurtEntity.Position, Vector(0, 0), player)
		end
		hurtEntity:Remove()
    end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, bigD.onUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, bigD.onTakeDmg)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, bigD.onPlayerUpdate)