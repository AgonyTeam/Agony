EternalSquirt = {
	bList = {
		mode = "only_same_ent"
	}
};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_SQUIRT,0,"Squirt")

--Eternal Squirts
function EternalSquirt:ai_main(entity)
	local sprite = entity:GetSprite();
	local rng = entity:GetDropRNG()
	--entity.Target = nil
	--debug_text = tostring(entity.State)
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_SQUIRT and rng:RandomFloat() < Agony.ETERNAL_SPAWN_CHANCE and entity.FrameCount <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Squirt/animation.anm2", true);
		entity.HitPoints = 30;
		
	end
	
	if (entity.Type == EntityType.ENTITY_SQUIRT and entity.SubType == 15 and entity.State == NpcState.STATE_MOVE) then
		local vLength = entity.Velocity:Length()
		local player = Isaac.GetPlayer(0)
		local data = entity:GetData()
		if vLength > 5 then
			local nearestEternalSquirt = Agony:getNearestEnemy(entity, nil, EternalSquirt.bList)
			if nearestEternalSquirt.Index ~= entity.Index and entity.FrameCount > 100 and nearestEternalSquirt.FrameCount > 100 then
				entity.Target = nearestEternalSquirt
				nearestEternalSquirt.Target = entity
			else
				entity.Target = player
			end
			if data.AllowVel == true or data.AllowVel == nil then
				data.AllowVel = false
				entity.Velocity = Agony:calcTearVel(entity.Position, entity.Target.Position, vLength)
			end
		end
		
		if entity.Target ~= nil and entity.Target.Type == EntityType.ENTITY_SQUIRT and entity.Target.SubType == 15 and entity.Position:Distance(entity.Target.Position) < 20 and entity.FrameCount > 100 and entity.Target.FrameCount > 100 then --eternal dips combine into eternal squirts
			entity.Target:Remove()
			entity:Remove()
			Isaac.Spawn(EntityType.ENTITY_DINGA, 0, 15, entity.Position, Vector(0,0), nil)
		end
	end
	
	if (entity.Type == EntityType.ENTITY_SQUIRT and entity.SubType == 15 and entity.State == NpcState.STATE_IDLE) then
		local data = entity:GetData()
		data.AllowVel = true
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalSquirt.ai_main, EntityType.ENTITY_SQUIRT);