eternalCorn = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_DIP,1,"Corn")

--Eternal Attack Flies
function eternalCorn:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Variant == 1 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end

	--Leave slippery creep
	if (entity.Variant == 1 and entity.SubType == 15 and entity.FrameCount % 4 == 0) then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 1, entity.Position, Vector(0,0), entity)
	end

end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalCorn.ai_main, EntityType.ENTITY_DIP);