local toyHammer =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
toyHammer.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_toyhammer.anm2")

function toyHammer:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		toyHammer.hasItem = false
	end
	if toyHammer.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_THE_TOY_HAMMER) then
		--player:AddNullCostume(toyHammer.costumeID)
		toyHammer.hasItem = true
	end
end

function toyHammer:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_THE_TOY_HAMMER) then
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
    			--TODO : Change gfx to hammer shit idc
    			entity.SubType = AgonyTearSubtype.TOY_HAMMER
    		end
    	end
    end
  end
end

function toyHammer:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
  local player = Isaac.GetPlayer(0)
  if source.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == AgonyTearSubtype.TOY_HAMMER and hurtEntity:IsVulnerableEnemy() then
    hurtEntity:GetData().slagged = 120
    hurtEntity:SetColor(Color(0.5, 0, 0.5, 1, 1, 1, 1), 120, 1, false, false)     	
  end
  if hurtEntity:GetData().slagged ~= nil and hurtEntity:GetData().slagged > 0 then
    hurtEntity:AddHealth(-dmgAmount)
  end  
end

function toyHammer:onNpcUpdate(npc)
  if npc:GetData().slagged ~= nil and npc:GetData().slagged > 0 then
    npc:GetData().slagged = npc:GetData().slagged -1
  end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, toyHammer.onNpcUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, toyHammer.onTakeDmg);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, toyHammer.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, toyHammer.onPlayerUpdate)