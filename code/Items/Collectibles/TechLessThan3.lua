
local techLessThanThree =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
techLessThanThree.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_techlessthanthree.anm2")

function techLessThanThree:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		techLessThanThree.hasItem = false
	end
	if techLessThanThree.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_TECH_LESS_THAN_3) then
		--player:AddNullCostume(techLessThanThree.costumeID)
		techLessThanThree.hasItem = true
	end
end

function techLessThanThree:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_TECH_LESS_THAN_3) then
    if player.Luck > 0 then
  		Prob = math.floor(math.random(5000)%(math.floor(200/(player.Luck+1))))
  	elseif player.Luck == 0 then
  		Prob = math.random(5000)%200
  	else
  		Prob = math.random(5000)%(-200*(player.Luck-1))
  	end
    for _,entity in pairs(ents) do
    	if entity.Type == EntityType.ENTITY_TEAR then
    		if entity.FrameCount == 1 and Prob == 1 then
    			--TODO : Change gfx to idk
    			entity.SubType = AgonyTearSubtype.TECH_LESS_THAN_3
    		end
    	end
    end
  end
end

function techLessThanThree:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
  local player = Isaac.GetPlayer(0)
  if source.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == AgonyTearSubtype.TECH_LESS_THAN_3 and hurtEntity:IsVulnerableEnemy() then
    hurtEntity:GetData().techsavvy = 600
  end 
end

function techLessThanThree:onNpcUpdate(npc)
  if npc:GetData().techsavvy ~= nil and npc:GetData().techsavvy > 0 then
    npc:GetData().techsavvy = npc:GetData().techsavvy -1
    local entList = Isaac.GetRoomEntities()
    for i = 1, #entList, 1 do
      if entList[i]:GetData().techsavvy ~= nil and entList[i]:GetData().techsavvy > 0 and entList[i].Index ~= npc.Index then
        if math.random(15) == 1 then
          l = Game():GetPlayer(0):FireTechLaser(npc.Position, 0, entList[i].Position:__sub(npc.Position), false, true)
          l:SetMaxDistance(entList[i].Position:Distance(npc.Position))
        end
      end
    end
  end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, techLessThanThree.onNpcUpdate)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, techLessThanThree.onTakeDmg);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, techLessThanThree.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, techLessThanThree.onPlayerUpdate)