eternalHorf = {}

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_HORF,0,"HORF", 22)

function eternalHorf:ai_main(ent)
	if ent.Variant == 0 and ent.SubType == 15 then
		local ents = Isaac.GetRoomEntities()
		--Remove original Shot
		for _,v in pairs(ents) do
			if v.Type	== EntityType.ENTITY_PROJECTILE and v.FrameCount <= 3 and v.SpawnerType and EntityType.ENTITY_HORF then
				v:Remove()
			end
		end
		if ent:GetSprite():IsEventTriggered("Shoot") then
			Agony:fireMinistroTearProj(0, Agony.TearSubTypes.ETERNAL, ent.Position, Agony:calcTearVel(ent.Position, ent:GetPlayerTarget().Position, 6), {}, 5, ent:GetDropRNG(), {})
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalHorf.ai_main, EntityType.ENTITY_HORF)