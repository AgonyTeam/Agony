local stinkEye =  {}

function stinkEye:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_STINK_EYE) then
    if player.Luck > 0 then
  		Prob = math.floor(math.random(5000)%(math.floor(300/(player.Luck+1))))
  	elseif player.Luck == 0 then
  		Prob = math.random(5000)%300
  	else
  		Prob = math.random(5000)%(-300*(player.Luck-1))
  	end
    for _,entity in pairs(ents) do
    	if entity.Type == EntityType.ENTITY_TEAR then
    		if entity.FrameCount == 1 and Prob == 0 then
				entity:GetSprite():ReplaceSpritesheet(0, "gfx/effect/tear_stinkeye.png")
				entity:GetSprite():LoadGraphics()
    			entity.SubType = Agony.TearSubTypes.STINK_EYE
    		end
    	end
    end
  end
end

function stinkEye:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
  local player = Isaac.GetPlayer(0)
  if source.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == Agony.TearSubTypes.STINK_EYE and hurtEntity:IsVulnerableEnemy() then
    hurtEntity:GetData().status_stinks = 120
    hurtEntity:SetColor(Color(0.5, 0.2, 0, 1, 1, 1, 1), 120, 1, false, false)
    if hurtEntity.HitPoints < dmgAmount then
        --not sure why this doesnt work
       Game():GetRoom():SpawnGridEntity(Game():GetRoom():GetGridIndex(hurtEntity.Position), GridEntityType.GRID_POOP, 0, RNG():GetSeed(), 1)
    end
  end 
end

function stinkEye:onNpcUpdate(npc)
  if npc:GetData().status_stinks ~= nil and npc:GetData().status_stinks > 0 then
    local ents = Isaac.GetRoomEntities()
    for i=1,#ents do
      if ents[i].Position:Distance(npc.Position) < 100 and ents[i]:IsEnemy() and ents[i].Index ~= npc.Index then
        ents[i]:AddPoison(EntityRef(npc), 15, 3)
        ents[i]:AddFear(EntityRef(npc), 15)
      end
    end
	npc:GetData().status_stinks = npc:GetData().status_stinks -1
  end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, stinkEye.onNpcUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, stinkEye.onTakeDmg);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, stinkEye.onUpdate)