
local rigidMind =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
rigidMind.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_rigidmind.anm2")

function rigidMind:FireRightAngledTears()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_RIGID_MIND) then
		local entList = Isaac.GetRoomEntities()
		for i = 1, #entList, 1 do
			if entList[i].Type == EntityType.ENTITY_TEAR and entList[i]:GetData().RigidMind ~= 0 and (entList[i].Parent.Type == EntityType.ENTITY_PLAYER or (entList[i].Parent.Type == 3 and entList[i].Parent.SubType == 80)) and entList[i].FrameCount == 1 then
				--scales with nbr of copies
				for j = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_RIGID_MIND), 1 do				
					local t = player:FireTear(player.Position:__add(Vector(-1+math.random()*2,-1+math.random()*2):__mul(10)), entList[i].Velocity:Rotated(90*j), false, false, true)
					--Copy the data to avoid proccing other items like speical one
					entList[i]:GetData().RigidMind = 0 
					Agony:dataCopy(entList[i]:GetData(),t:GetData())
				end
			end
		end
	end
end

function rigidMind:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		rigidMind.hasItem = false
	end
	if rigidMind.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_RIGID_MIND) then
		--player:AddNullCostume(rigidMind.costumeID)
		rigidMind.hasItem = true
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, rigidMind.FireRightAngledTears)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, rigidMind.onPlayerUpdate)