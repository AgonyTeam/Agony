local suicideGod =  {}

function suicideGod:checkIfPlayerDying()
	local player = Game():GetPlayer(0)
	if player:HasTrinket(TrinketType.AGONY_T_SUICIDE_GOD) then
		local sprite = player:GetSprite()
		
		if sprite:IsPlaying("Death") and sprite:GetFrame() == 1 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
			--for j = 1, 5*player:GetCollectibleNum(CollectibleType.AGONY_C_SUICIDE_GOD), 1 do Not really sure what the purpose of this line is.
			for j = 1, 5 * player:GetCollectibleCount(), 1 do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_NULL, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, suicideGod.checkIfPlayerDying)