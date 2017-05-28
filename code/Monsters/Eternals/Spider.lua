eternalSpider = {
	hopVel = 15,
	hopAnimationLength = 22,
	minDist = 120,
	walkVelMult = 0.75
}

function eternalSpider:ai_update(ent)
	debug_entity = ent
	if ent.Variant == 0 and ent.SubType ~= 15 and ent.FrameCount <= 1 then
		ent:Morph(ent.Type, ent.Variant, 15, -1)
		ent.HitPoints = ent.MaxHitPoints
	end
	
	if ent.Variant == 0 and ent.SubType == 15 and ent.State == NpcState.STATE_MOVE then
		if Game():GetRoom():GetGridCollisionAtPos(ent.Position) == GridCollisionClass.COLLISION_NONE then
			ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			ent.Velocity = ent.Velocity * eternalSpider.walkVelMult
		end
		
		if 2 > ent:GetDropRNG():RandomInt(100) and ent.Position:Distance(Isaac.GetPlayer(0).Position) >= eternalSpider.minDist then
			local vel = (Isaac.GetPlayer(0).Position - ent.Position):Normalized() * eternalSpider.hopVel
			-->Do checks for empty spaces if needed here<--
			ent.Velocity = vel
			ent.State = NpcState.STATE_JUMP
			ent.StateFrame = 0
			ent:Morph(EntityType.AGONY_ETYPE_ETERNAL_SPIDER_JUMPING,0,0,-1)
		end
	end
	
end

function eternalSpider:ai_jump(ent)
	if ent.StateFrame == 0 then
		ent:GetSprite():Play("Hop")
	end
	ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	local sprite = ent:GetSprite()
	if ent.StateFrame >= 22 then
		ent.State = 4
		ent:Morph(EntityType.ENTITY_SPIDER, 0, 15, -1)
		ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	end
	ent.StateFrame = ent.StateFrame + 1
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSpider.ai_update, EntityType.ENTITY_SPIDER)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSpider.ai_jump, EntityType.AGONY_ETYPE_ETERNAL_SPIDER_JUMPING)