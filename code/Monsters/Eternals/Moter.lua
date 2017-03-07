EternalMoter = {
	bList = {
		mode = "only_same_ent"
	}
};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_MOTER,1,"Moter")

--Eternal Moters
function EternalMoter:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();
	--entity.Target = nil
	--debug_text = tostring(entity.State)
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_MOTER and math.random(10) == 1 and room:GetFrameCount() <= 10 and entity.SubType ~= 15) then
		entity.Type = 18;
		entity.Variant = 1;
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Moter/animation.anm2", true);
		entity.HitPoints = 20;
	end
end

--Spawn Eternal Flies on death
function EternalMoter:ai_main(entity,damage,_,player,_)
	if entity.Variant == 1 and entity.SubType == 15 and damage >= entity.HitPoints then --NOTE: Eternal Attack Flies not implemented yet,  for now spawns normal Attack Flies
		Isaac.Spawn(18, 0, 0, entity.Position, Vector(0,0), entity)
		Isaac.Spawn(18, 0, 0, entity.Position, Vector(0,0), entity)
		Isaac.Spawn(18, 0, 0, entity.Position, Vector(0,0), entity)
		Isaac.Spawn(18, 0, 0, entity.Position, Vector(0,0), entity)
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EternalMoter.ai_main, EntityType.ENTITY_ATTACKFLY);