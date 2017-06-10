eternalSpirit = {}

function eternalSpirit:ai_main(ent)
	local sprite = ent:GetSprite()
	local data = ent:GetData()
	if ent.State == NpcState.STATE_INIT then
		ent.State = NpcState.STATE_IDLE
		sprite:Play("Idle",true)
	elseif ent.State == NpcState.STATE_IDLE then
		if not sprite:IsPlaying("Idle") or sprite:IsFinished("Idle") then
			sprite:Play("Idle",true)
		end
		ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		--Ensure target is still valid
		if data.target ~= nil and data.target:Exists() and not Agony:IsEntityEternal(data.target) and Agony:HasEternalSubtype(data.target.Type,data.target.Variant) then
			--Follow Target
			local t = data.target
			--Fly towards target
			ent.Velocity = Agony:calcEntVel(ent, t, 5)
			if ent.Position:Distance(t.Position) <= 45 then
				ent.State = NpcState.STATE_ATTACK
				sprite:Play("Enter",true)
			end
		else
			
			ent.Velocity = Agony:calcEntVel(ent, Isaac.GetPlayer(0), 4)
			--Find Target
			local possibleTargets = {}
			local ents = Isaac.GetRoomEntities()
			for _,v in pairs(ents) do
				if v ~= ent and v:ToNPC() ~= nil and not Agony:IsEntityEternal(v) and Agony:HasEternalSubtype(v.Type, v.Variant) then
					table.insert(possibleTargets, v:ToNPC())
				end
			end
			
			local dist = 0
			local currDist = 999999
			local currTarget = nil
			for _,v in pairs(possibleTargets) do
				dist = ent.Position:Distance(v.Position)
				if dist < currDist then
					currDist = dist
					currTarget = v
				end
			end
			
			ent:GetData().target = currTarget
			
		end
		
	elseif ent.State == NpcState.STATE_ATTACK then
		ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		--Ensure target is still valid
		if data.target ~= nil and data.target:Exists() and not Agony:IsEntityEternal(data.target) and Agony:HasEternalSubtype(data.target.Type,data.target.Variant) then
			local t = data.target
			ent.Velocity = Vector(0,0)
			ent.Position = (ent.Position - t.Position) * 0.75 + t.Position
			if sprite:IsFinished("Enter") then
				--Morph and scale hp
				local hpMult = t.HitPoints / t.MaxHitPoints
				t:Morph(t.Type,t.Variant,15,-1)
				t.HitPoints = t.HitPoints * hpMult
				t:GetData().isPossessedEternal = true
				t:GetData().spiritHP = ent.HitPoints
				ent:Remove()
			end
		else
			ent.State = NpcState.STATE_IDLE
			sprite:Play("Idle",true)
		end
	elseif ent.State == NpcState.STATE_APPEAR_CUSTOM then
		if sprite:IsFinished("Leave") then
			ent.State = NpcState.STATE_IDLE
		end
	end
end

function eternalSpirit:respawnSpirit(ent, dmg, flags, src, countdown)
	if dmg >= ent.HitPoints and ent:GetData().isPossessedEternal then
		--Respawn Spirit
		local spirit = Isaac.Spawn(EntityType.AGONY_ETYPE_ETERNAL_SPIRIT,0,0,ent.Position,ent.Velocity,nil):ToNPC()
		spirit:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		spirit.HitPoints = ent:GetData().spiritHP or spirit.HitPoints
		spirit:GetSprite():Play("Leave",true)
		spirit.State = NpcState.STATE_APPEAR_CUSTOM
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, eternalSpirit.ai_main, EntityType.AGONY_ETYPE_ETERNAL_SPIRIT)
Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, eternalSpirit.respawnSpirit)