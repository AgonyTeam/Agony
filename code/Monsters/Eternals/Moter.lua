EternalMoter = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_MOTER,1,"Moter")

--Eternal Moters
function EternalMoter:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_MOTER and rng:RandomInt(10) == 1 and entity.FrameCount <= 10 and entity.SubType ~= 15) then
		Isaac.Spawn(18, 1, 15, entity.Position, Vector(0,0), entity);
		entity:Remove();
	end
end

--Spawn Eternal Flies on death
function EternalMoter:ai_take_damage(entity,damage,_,player,_)
	if entity.Variant == 1 and entity.SubType == 15 and damage >= entity.HitPoints then --NOTE: Eternal Attack Flies not implemented yet,  for now spawns normal Attack Flies
		Isaac.Spawn(18, 0, 15, entity.Position, Vector(0,0), entity)
		Isaac.Spawn(18, 0, 15, entity.Position, Vector(0,0), entity)
		Isaac.Spawn(18, 0, 15, entity.Position, Vector(0,0), entity)
		Isaac.Spawn(18, 0, 15, entity.Position, Vector(0,0), entity)
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalMoter.ai_main, EntityType.ENTITY_ATTACKFLY);
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EternalMoter.ai_take_damage, EntityType.ENTITY_ATTACKFLY);