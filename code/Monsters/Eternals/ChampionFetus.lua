local EternalFetus = {};

--Add to Eternal List
Agony:AddEternal(EntityType.ENTITY_BABY,0,"Champion Fetus")


function EternalFetus:ai_main(entity)
	local sprite = entity:GetSprite();
	local player = Game():GetPlayer(0)
	if (entity.SubType == 15  and entity.Variant == 3) then
		entity.ProjectileDelay = -1 --prevent original shot
		if (sprite:IsEventTriggered("Convert")) then
			--entity:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 0, false, 1.0)
			player:AddCoins(1)
			local nearestEnt = Agony:getNearestEnemy(entity)
			local EternalList = Agony:getEternalList()
			for i = 1, #EternalList, 3 do
				player:AddKeys(1)
				if EternalList[i] == nearestEnt.Type and EternalList[i+1] == nearestEnt.Variant and nearestEnt.Subtype ~= 15 then
					player:AddSoulHearts(1)
					nearestEnt.SubType = 15
					nearestEnt:GetSprite():Load("gfx/Monsters/Eternals/" .. EternalList[i+2] .. "/animation.anm2", true);
					player:AddBombs(1)
				end
			end
		end
	end
end

--Callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, EternalFetus.ai_main, EntityType.ENTITY_BABY);