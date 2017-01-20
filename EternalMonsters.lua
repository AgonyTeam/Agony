eternalM = {
	RoundWorm = {};
};
entity_roundworm = Isaac.GetEntityTypeByName("Round Worm");

--Eternal Round Worms
function eternalM.RoundWorm:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();
	
	--Replace regular entity with eternal version
	--TODO: put in a function, unless we decide to split up Eternals into multiple files
	if (entity.Type == entity_roundworm and math.random(10) == 1 and room:GetFrameCount() <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("/gfx/Eternals/Monsters/Round Worm/animation.anm2", true);
		entity.HitPoints = 20;
		
	end
	
	if (entity.Type == entity_roundworm and entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK) then
		local PlayerPos = entity:GetPlayerTarget().Position;
		
		if (sprite:IsEventTriggered("EternalShoot3") == true) then
			--Host-like triple shot
			entity:PlaySound(318, 1.0, 0, false, 1.0)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(-10), entity);
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Agony:calcTearVel(entity.Position, PlayerPos, 15), entity);
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(10), entity);
		elseif (sprite:IsEventTriggered("EternalShoot2") == true) then
			--V-shape double shot like Shroomers from EtG
			entity:PlaySound(318, 1.0, 0, false, 1.0)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(-5), entity);
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(5), entity);
		end
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalM.RoundWorm.ai_main, entity_roundworm);