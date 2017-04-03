local bClotty = {}

function bClotty:ai_main(ent)
	if ent.SubType == 20 then
		local rng = ent:GetDropRNG()
		local eData = ent:GetData()
		--local eSprite = ent:GetSprite()
		--debug_text = tostring(EffectVariant.HOT_BOMB_FIRE)
		if ent.State == NpcState.STATE_ATTACK then
			local r = rng:RandomInt(15)+1
			if rng:RandomInt(2) == 0 then
				r = -r
			end
			local roomEnts = Isaac.GetRoomEntities()
			for _, rEnt in pairs(roomEnts) do
				if rEnt.Type == EntityType.ENTITY_PROJECTILE and rEnt.Position:Distance(ent.Position) <= 2 and rEnt.FrameCount <= 1 then
					if rng:RandomInt(10) == 0 then
						fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 1, rEnt.Position, rEnt.Velocity:Rotated(r), ent)
						fire.SpawnerEntity = ent
						rEnt:Remove()
					else
						rEnt.Velocity = rEnt.Velocity:Rotated(r)
					end
				end
			end
		--[[elseif ent.State == NpcState.STATE_MOVE then
			debug_text = tostring(eSprite:GetFrame())
			if ent.Velocity:Length() > 0 then
				local dirVector = ent.Velocity:Normalized()
				ent.Velocity = dirVector:__mul(math.abs(2*(-0.1*(((eSprite:GetFrame()-6.4)^2)-1)+4)))
			end]]
		end
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, bClotty.ai_main, EntityType.ENTITY_CLOTTY)