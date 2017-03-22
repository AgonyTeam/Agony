local lilRedBook = {}

function lilRedBook:onUse()
	local entities = Isaac.GetRoomEntities()
	local totalHealth = 0
	local totalVulnEntities = 0
	for i = 1, #entities, 1 do
		if entities[i]:IsVulnerableEnemy() then
			totalHealth = totalHealth+entities[i].HitPoints
			totalVulnEntities = totalVulnEntities + 1
		end
	end
	for i = 1, #entities, 1 do
		if entities[i]:IsVulnerableEnemy() then
			entities[i].MaxHitPoints = totalHealth/totalVulnEntities
			entities[i].HitPoints = entities[i].MaxHitPoints
		end
	end
	return true
end

Agony:AddCallback(ModCallbacks.MC_USE_ITEM, lilRedBook.onUse, CollectibleType.AGONY_C_LIL_RED_BOOK)