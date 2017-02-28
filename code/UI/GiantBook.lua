local giantBook = {}

EntityType["AGONY_ETYPE_GIANT_BOOK"] = Isaac.GetEntityTypeByName("Giant Book");

function giantBook:onNpcUpdate(npc)
	local sprite = npc:GetSprite()
	if (sprite:IsEventTriggered("GiantBookEnd")) then
		npc:Remove()
	end
end

Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, ,giantBook.onNpcUpdate, EntityType.AGONY_ETYPE_GIANT_BOOK)