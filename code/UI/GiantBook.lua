local giantBook = {}

function giantBook:onNpcUpdate(npc)
	local sprite = npc:GetSprite()
	if (sprite:IsEventTriggered("GiantBookEnd")) then
		npc:Remove()
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, ,giantBook.onNpcUpdate, EntityType.ENTITY_FLY)