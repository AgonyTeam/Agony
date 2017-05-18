eternalSpider = {
	hopVel = 32,
	hopAnimationLength = 22
}

function eternalSpider:ai_update(ent)
	debug_entity = ent
	if ent.State == NpcState.STATE_MOVE then
		if Game():GetRoom():GetGridCollisionAtPos(ent.Position) == GridCollisionClass.COLLISION_NONE then
			ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		end
		if 2 > ent:GetDropRNG():RandomInt(100) then
			local vel = (Isaac.GetPlayer(0).Position - ent.Position):Normalized() * eternalSpider.hopVel
			-->Do checks for empty spaces if needed here<--
			ent.Velocity = vel
			ent.State = NpcState.STATE_JUMP
			ent:GetSprite():Play("Hop")
		end
	elseif ent.State == NpcState.STATE_JUMP then
		ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		local sprite = ent:GetSprite()
		if sprite:IsFinished("Hop") then
			Isaac.DebugString("Hop Finished")
			ent.State = NpcState.STATE_IDLE
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSpider.ai_update, EntityType.ENTITY_SPIDER)