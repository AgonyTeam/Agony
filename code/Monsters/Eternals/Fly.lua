--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_FLY,1,"Fly")

--Eternal Flies
function EternalFly:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_FLY and math.random(10) == 1 and room:GetFrameCount() <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Fly/animation.anm2", true);
		entity.MaxHitPoints = 0;
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalFly.ai_main, EntityType.ENTITY_FLY);