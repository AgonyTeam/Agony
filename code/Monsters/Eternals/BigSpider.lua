eternalBigSpider = {
	hopVel = 15,
	hopAnimationLength = 22,
	minDist = 120,
	walkVelMult = 0.75
}

function eternalBigSpider:ai_update(ent)
	debug_entity = ent
	if ent.Variant == 0 and ent.SubType ~= 15 and ent.FrameCount <= 1 then
		ent:Morph(ent.Type, ent.Variant, 15, -1)
		ent.HitPoints = ent.MaxHitPoints
	end
	
	if ent.Variant == 0 and ent.SubType == 15 and ent.State == NpcState.STATE_MOVE then
		if Game():GetRoom():GetGridCollisionAtPos(ent.Position) == GridCollisionClass.COLLISION_NONE then
			ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			ent.Velocity = ent.Velocity * eternalBigSpider.walkVelMult
		end
		
		if 2 > ent:GetDropRNG():RandomInt(100) and ent.Position:Distance(Isaac.GetPlayer(0).Position) >= eternalBigSpider.minDist then
			local vel = (Isaac.GetPlayer(0).Position - ent.Position):Normalized() * eternalBigSpider.hopVel
			-->Do checks for empty spaces if needed here<--
			ent.Velocity = vel
			ent.State = NpcState.STATE_JUMP
			ent.StateFrame = 0
			ent:Morph(EntityType.AGONY_ETYPE_ETERNALS_JUMPING,Agony.JumpVariant.ETERNAL_BIG_SPIDER,0,-1)
		end
	end
	
end

function eternalBigSpider:ai_jump(ent)
	if ent.Variant == Agony.JumpVariant.ETERNAL_BIG_SPIDER then
		if ent.StateFrame == 0 then
			ent:GetSprite():Play("Hop")
		end
		ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		local sprite = ent:GetSprite()
		if not sprite:IsPlaying("Hop") then
			sprite:Play("Hop")
		end
		if ent.StateFrame >= 22 then
			ent.State = 4
			ent:Morph(EntityType.ENTITY_BIGSPIDER, 0, 15, -1)
			ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		end
		ent.StateFrame = ent.StateFrame + 1
	end
end

function eternalBigSpider:ai_dmg(ent, dmg, flags, src, countdown)
	if ent.Variant == 0 and ent.SubType == 15 and dmg >= ent.HitPoints then
		Agony:addDelayedFunction(Agony:getCurrTime()+3, function (data)
			
			local pos = data.pos
			local ent = data.ent
			--Try to Morph spiders to eternal spiders
			local roomEnts = Isaac.GetRoomEntities()
			for _, rEnt in pairs(roomEnts) do
				if rEnt.Type == EntityType.ENTITY_SPIDER and rEnt.Position:Distance(pos) <= 80 and rEnt.FrameCount <= 5 then
					rEnt:ToNPC():Morph(EntityType.ENTITY_SPIDER, 0, 15, -1)
				end
			end
		
		end, {pos=ent.Position,ent=ent}, true)
	end
end

function eternalBigSpider:ai_dmg_jumping(ent, dmg, flags, src, countdown)
	if ent.Variant == Agony.JumpVariant.ETERNAL_BIG_SPIDER and dmg >= ent.HitPoints then
		Isaac.Spawn(EntityType.ENTITY_SPIDER,0,15,ent.Position,Vector(0,0),ent)
		Isaac.Spawn(EntityType.ENTITY_SPIDER,0,15,ent.Position,Vector(0,0),ent)
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalBigSpider.ai_update, EntityType.ENTITY_BIGSPIDER)
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalBigSpider.ai_jump, EntityType.AGONY_ETYPE_ETERNALS_JUMPING)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalBigSpider.ai_dmg, EntityType.ENTITY_BIGSPIDER)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalBigSpider.ai_dmg_jumping, EntityType.AGONY_ETYPE_ETERNALS_JUMPING)