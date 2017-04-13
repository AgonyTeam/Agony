local misterBean =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	requireditems = Agony.ENUMS["ItemPools"]["Beans"],
	Items = saveData.misterBean.Items or {} --Keeps track of what Items the player has had
}
misterBean.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/trans_misterbean.anm2")

function misterBean:onPlayerUpdate(player)
		Agony:TransformationUpdate(player, misterBean ,saveData.misterBean, true)
end


function misterBean:onTakeDmg(hurtEntity, dmgAmount, dmgFlags, source, countdown)
    local player = Isaac.GetPlayer(0)
    if source.Type == EntityType.ENTITY_TEAR and misterBean.hasItem then
    	--Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS , 0, source.Position, Vector(0,0), player)
    	if math.random(5) == 1 then
    		Game():Fart(source.Position, 25, player, 1, 0)
    	elseif math.random(10) == 1 then
    		game():ButterBeanFart(source.Position, 25, player, true)
    	end
    end
end

Agony:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, misterBean.onTakeDmg)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, misterBean.onPlayerUpdate)