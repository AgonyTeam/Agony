EternalRedBoomFly = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_BOOMFLY,1,"Red Boom Fly",30)

--Eternal RedBoomFlies
function EternalRedBoomFly:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()

	--Replace regular entity with eternal version
	if (false and entity.Variant == 1 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Red Boom Fly/animation.anm2", true);
		--entity.HitPoints = 40;
		--entity.MaxHitPoints = 40;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
end

function EternalRedBoomFly:ai_take_damage(entity,damage,_,_,_)
	if entity.Variant == 1 and entity.SubType == 15 and damage >= entity.HitPoints then
		local tearConf = Agony:TearConf()
		tearConf.SpawnerEntity = entity
		
		Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, Vector(math.cos(math.pi/3)*11,math.sin(math.pi/3)*11), tearConf)
		Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, Vector(math.cos(2*math.pi/3)*11,math.sin(2*math.pi/3)*11), tearConf)
		Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, Vector(math.cos(3*math.pi/3)*11,math.sin(3*math.pi/3)*11), tearConf)
		Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, Vector(math.cos(4*math.pi/3)*11,math.sin(4*math.pi/3)*11), tearConf)
		Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, Vector(math.cos(5*math.pi/3)*11,math.sin(5*math.pi/3)*11), tearConf)
		Agony:fireTearProj(0, Agony.TearSubTypes.ETERNAL, entity.Position, Vector(math.cos(6*math.pi/3)*11,math.sin(6*math.pi/3)*11), tearConf)
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalRedBoomFly.ai_main, EntityType.ENTITY_BOOMFLY);
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EternalRedBoomFly.ai_take_damage, EntityType.ENTITY_BOOMFLY);