EternalWalkingSack = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_WALKINGBOIL,2,"Walking Boil")

function EternalWalkingSack:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	
	--Replace regular entity with eternal version
	if (entity.Variant == 2 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
	if entity.Variant == 2 and entity.SubType == 15 then
		if entity:GetSprite():IsEventTriggered("SecondShot") then
			SFXManager():Play(SoundEffect.SOUND_BLOODSHOOT,1.2,0,false,0.85)
			EntityNPC.ThrowSpider(entity.Position,entity,Isaac.GetFreeNearPosition(entity.Position,1.0),false,0.0)
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_WHITE, 1, entity.Position, Vector(0,0), entity)
			creep:Update()
		end
		
		--Lower chance to spit Spiders based on distance
		if entity.State == 8 then
			if entity.I2 == 0 and entity.Position:Distance(Isaac.GetPlayer(0).Position) < math.random(225,750) then
				entity.State = NpcState.STATE_IDLE
			else
				entity.I2 = 1
			end
		else
			entity.I2 = 0
		end
	end
	
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalWalkingSack.ai_main, EntityType.ENTITY_WALKINGBOIL);