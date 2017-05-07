
pyritecoin = {}

--[[
function pyritecoin:onPickup()
	local ents = Isaac.GetRoomEntities()
	local player = Isaac.GetPlayer(0)
	local sound = SFXManager()
	
	for _,entity in pairs(ents) do
		if entity.Type == EntityType.ENTITY_PICKUP 
		  and entity.Variant == PickupVariant.AGONY_PICKUP_COIN 
		  and entity.SubType == CoinSubType.AGONY_COIN_PYRITE then 
			local entdata = entity:GetData()
			local entsprite = entity:GetSprite()
			
		    if player.Position:Distance(entity.Position) <= player.Size + entity.Size + 8
		      and entdata.Picked == nil then
			    entdata.Picked = true
			    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			    entsprite:Play("Collect", true)
			    sound:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
			elseif entdata.Picked and entsprite:GetFrame() == 6 then
				entity:Remove()
			end
		end	
	end
end
]]--

function pyritecoin:onPick(player, sound, data, sprite, ent)
	sound:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
end

Agony:addPickup(EntityType.ENTITY_PICKUP, PickupVariant.AGONY_PICKUP_COIN, CoinSubType.AGONY_COIN_PYRITE, pyritecoin.onPick, nil, nil)