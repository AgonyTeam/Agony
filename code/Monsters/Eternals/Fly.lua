EternalFly = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_FLY,1,"Fly")

--Eternal Flies
function EternalFly:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Fly/animation.anm2", true);
		--entity.MaxHitPoints = 0;
		--entity.CollisionDamage = 1;
		--entity.CanShutDoors = false;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalFly.ai_main, EntityType.ENTITY_FLY);