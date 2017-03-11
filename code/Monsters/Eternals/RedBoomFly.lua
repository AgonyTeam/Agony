EternalRedBoomFly = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_BOOMFLY,1,"RedBoomFly")

--Eternal RedBoomFlies
function EternalRedBoomFly:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()

	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_BOOMFLY and entity.Variant == 1 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Red Boom Fly/animation.anm2", true);
		entity.HitPoints = 40;
		
	end
end

function EternalRedBoomFly:ai_take_damage(entity,damage,_,_,_)
	if entity.Variant == 1 and entity.SubType == 15 and damage >= entity.HitPoints then
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Vector(math.cos(math.pi/3)*13,math.sin(math.pi/3)*13), entity);
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Vector(math.cos(2*math.pi/3)*13,math.sin(2*math.pi/3)*13), entity);
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Vector(math.cos(math.pi)*13,math.sin(math.pi)*13), entity);
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Vector(math.cos(4*math.pi/3)*13,math.sin(4*math.pi/3)*13), entity);
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Vector(math.cos(5*math.pi/3)*13,math.sin(5*math.pi/3)*13), entity);
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Vector(math.cos(2*math.pi)*13,math.sin(2*math.pi)*13), entity);
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalRedBoomFly.ai_main, EntityType.ENTITY_BOOMFLY);
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EternalRedBoomFly.ai_take_damage, EntityType.ENTITY_BOOMFLY);