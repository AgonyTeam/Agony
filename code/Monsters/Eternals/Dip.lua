EternalDip = {
	bList = {
		mode = "only_same_ent"
	}
};

--Add the id, variant and name to the EternalsList
table.insert(EternalsList, EntityType.ENTITY_DIP);
table.insert(EternalsList, 0);
table.insert(EternalsList, "Dip");

--Eternal Dips
function EternalDip:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();
	entity.Target = nil

	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_DIP and math.random(10) == 1 and room:GetFrameCount() <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Dip/animation.anm2", true);
		entity.HitPoints = 6;
		
	end
	
	if (entity.Type == EntityType.ENTITY_DIP and entity.SubType == 15 and entity.State == NpcState.STATE_MOVE) then
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