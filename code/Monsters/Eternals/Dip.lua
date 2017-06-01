EternalDip = {
	bList = {
		mode = "only_same_ent"
	}
};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_DIP,0,"Dip",9)

--Eternal Dips
function EternalDip:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	entity.Target = nil

	
	--Replace regular entity with eternal version
	if (false and entity.Variant == 0 and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 1 and entity.SubType ~= 15) then
		--entity.SubType = 15;
		--sprite:Load("gfx/Monsters/Eternals/Dip/animation.anm2", true);
		--entity.HitPoints = 6;
		--entity.MaxHitPoints = 6;
		entity:Morph(entity.Type, entity.Variant, 15, -1)
		entity.HitPoints = entity.MaxHitPoints
	end
	
	if (entity.Variant == 0 and entity.SubType == 15 and entity.State == NpcState.STATE_MOVE) then
		local vLength = entity.Velocity:Length()
		local player = Isaac.GetPlayer(0)
		if vLength > 5 then
			local nearestEternalDip = Agony:getNearestEnemy(entity, nil, EternalDip.bList)
			if nearestEternalDip.Index ~= entity.Index and entity.FrameCount > 100 and nearestEternalDip.FrameCount > 100 then
				entity.Target = nearestEternalDip
				nearestEternalDip.Target = entity
			else
				entity.Target = player
			end
			entity.Velocity = Agony:calcTearVel(entity.Position, entity.Target.Position, vLength)
		end
		
		if entity.Target ~= nil and entity.Target.Type == EntityType.ENTITY_DIP and entity.Target.SubType == 15 and entity.Position:Distance(entity.Target.Position) < 20 and entity.FrameCount > 100 and entity.Target.FrameCount > 100 then --eternal dips combine into eternal squirts
			entity.Target:Remove()
			entity:Remove()
			Isaac.Spawn(EntityType.ENTITY_SQUIRT, 0, 15, entity.Position, Vector(0,0), nil)
		end
	end
	
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalDip.ai_main, EntityType.ENTITY_DIP);