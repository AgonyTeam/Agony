EternalAttackFly = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_ATTACKFLY,1,"Attack Fly")

--Eternal Attack Flies
function EternalAttackFly:ai_main(entity)
	local sprite = entity:GetSprite();
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_ATTACKFLY and entity.Variant == 0 and math.random(10) == 1 and entity.FrameCount <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Attack Fly/animation.anm2", true);
		entity.HitPoints = 10;
	end
	
	--Needs code for random dashes	
	
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalAttackFly.ai_main, EntityType.ENTITY_ATTACKFLY);