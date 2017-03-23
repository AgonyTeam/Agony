
local milkman =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
milkman.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_milkman.anm2")

function milkman:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		milkman.hasItem = false
	end
	if milkman.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_MILKMAN) then
		--player:AddNullCostume(milkman.costumeID)
		milkman.hasItem = true
	end
end

function milkman:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_MILKMAN) then
    if player.Luck > 0 then
  		milkProb = math.random(5000)%(math.floor(300/(player.Luck+1)))
  	elseif player.Luck == 0 then
  		milkProb = math.random(5000)%300
  	else
  		milkProb = math.random(5000)%(-300*(player.Luck-1))
  	end
    for _,entity in pairs(ents) do
    	if entity.Type == EntityType.ENTITY_TEAR then
    		if entity.FrameCount == 1 and milkProb == 1 then
    			--TODO : Change gfx to milk
    			entity.SubType = AgonyTearSubtype.MILKMAN
    		end
    	end
    end
  end
end

function milkman:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    if source.Type == EntityType.ENTITY_TEAR and source.Entity.SubType == AgonyTearSubtype.MILKMAN then
    	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE , 0, source.Position, Vector(0,0), player)
    	for i = 1, 15, 1 do
    		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE , 0, Vector(source.Position.X+math.random(100)-50,source.Position.Y+math.random(100)-50), Vector(0,0), player)
    	end
        r = 3 + math.random(4)
        for i = 1, r, 1 do
        	local pos = Vector(source.Position.X+(math.random(100)-50),source.Position.Y+(math.random(100)-50))
        	Isaac.Spawn(1000, 52, 1, pos, Vector(0,0), player)
        end
    end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, milkman.onTakeDmg);
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, milkman.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, milkman.onPlayerUpdate)