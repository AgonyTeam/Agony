CoinSubType["AGONY_COIN_PYRITE"] = 51 --not sure how to read that one automatically

pyritecoin = {}

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

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, pyritecoin.onPickup)