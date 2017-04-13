local god =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	requireditems = Agony.ENUMS["ItemPools"]["GodItemsIdk"],
 	Items = saveData.god.Items or {} --Keeps track of what Items the player has had}
}
god.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_god.anm2")

function god:onPlayerUpdate(player)
		Agony:TransformationUpdate(player, god ,saveData.god, false)

		if god.hasItem and math.random(690) == 69 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_CRACK_THE_SKY, false,true, true, false)
		end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, god.onPlayerUpdate)