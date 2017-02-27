 EternalPooter = {};

--Eternal Round Worms
function EternalPooter:ai_main(entity)
	local room = Game():GetRoom();
	local sprite = entity:GetSprite();
	
	--Replace regular entity with eternal version
	if (entity.Type == EntityType.ENTITY_POOTER and math.random(10) == 1 and room:GetFrameCount() <= 10 and entity.SubType ~= 15) then
		entity.SubType = 15;
		sprite:Load("gfx/Monsters/Eternals/Pooter/animation.anm2", true);
		entity.HitPoints = 20;
		
	end
	
	if (entity.Type == EntityType.ENTITY_POOTER and entity.SubType == 15 and entity.State == NpcState.STATE_ATTACK) then
		local PlayerPos = entity:GetPlayerTarget().Position;
		
		if (sprite:IsEventTriggered("EternalShoot3") == true) then

			entity:PlaySound(318, 1.0, 0, false, 1.0)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(-10), entity);
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, Agony:calcTearVel(entity.Position, PlayerPos, 15), entity);
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(10), entity);
		elseif (sprite:IsEventTriggered("EternalShoot2") == true) then

			entity:PlaySound(318, 1.0, 0, false, 1.0)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(-5), entity);
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, entity.Position, (Agony:calcTearVel(entity.Position, PlayerPos, 14)):Rotated(5), entity);
		end
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalPooter.ai_main, EntityType.ENTITY_ROUND_WORM);