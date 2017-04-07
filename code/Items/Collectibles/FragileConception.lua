
local fragileConception =  {
	stage = nil,
	dmgTot = 0,
	famSpawned = 0,
	famList = Agony.ENUMS["ItemPools"]["FragileConceptionFams"]
}

function fragileConception:onUpdate()
	--Check fi the player has taken damage this stage
	local player = Game():GetPlayer(0)
	local rng = player:GetCollectibleRNG(CollectibleType.AGONY_C_FRAGILE_CONCEPTION)
	
	if player:HasCollectible(CollectibleType.AGONY_C_FRAGILE_CONCEPTION) then
		if fragileConception.stage == nil then
			fragileConception.stage = Game():GetLevel():GetStage()
		elseif fragileConception.stage ~= Game():GetLevel():GetStage() then
			fragileConception.stage = Game():GetLevel():GetStage()
			if fragileConception.dmgTot < player:GetTotalDamageTaken() then
				fragileConception.dmgTot = player:GetTotalDamageTaken()
			else
				for i = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_FRAGILE_CONCEPTION), 1 do
					if fragileConception.famSpawned < player:GetCollectibleNum(CollectibleType.AGONY_C_FRAGILE_CONCEPTION)*4 then
						player:AddCollectible(fragileConception.famList[rng:RandomInt(#fragileConception.famList)+1], 0, false)
						fragileConception.famSpawned = fragileConception.famSpawned +1
					end
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, fragileConception.onUpdate)