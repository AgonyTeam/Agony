
local ludovicoTheory =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	ludoTear = nil,
	ludoTearPos = nil,
	roomID = nil
}
ludovicoTheory.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_ludovicotheory.anm2")

function ludovicoTheory:SimulateTears()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_THE_LUDOVICO_THEORY) then
		if ludovicoTheory.roomID == nil or ludovicoTheory.roomID ~= Game():GetLevel():GetCurrentRoomIndex() then 
			ludovicoTheory.ludoTear = nil
			ludovicoTheory.roomID = Game():GetLevel():GetCurrentRoomIndex()
		end
		if ludovicoTheory.ludoTear == nil then
			ludovicoTheory.ludoTear = player:FireTear(player.Position, Vector(0,0), false, true, false)
			ludovicoTheory.ludoTearPos = player.Position
			ludovicoTheory.ludoTear.Height = 50
			ludovicoTheory.ludoTear.FallingAcceleration = 0
		elseif ludovicoTheory.ludoTear.FrameCount == 60 then
			ludovicoTheory.ludoTear = player:FireTear(player.Position, Vector(0,0), false, true, false)
		end
		ludovicoTheory.ludoTearPos = ludovicoTheory.ludoTearPos:__add(player:GetShootingJoystick():__mul(5*player.ShotSpeed))
		ludovicoTheory.ludoTear.Position = ludovicoTheory.ludoTearPos
		ludovicoTheory.ludoTear.Height = 50
	end
end

function ludovicoTheory:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		ludovicoTheory.hasItem = false
	end
	if ludovicoTheory.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_THE_LUDOVICO_THEORY) then
		--player:AddNullCostume(ludovicoTheory.costumeID)
		ludovicoTheory.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, ludovicoTheory.SimulateTears)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ludovicoTheory.onPlayerUpdate)