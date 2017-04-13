
local nutMilk =  {}

function nutMilk:onUpdate()
	local ents = Isaac.GetRoomEntities()
	local player = Game():GetPlayer(0)
  if player:HasCollectible(CollectibleType.AGONY_C_NUT_MILK) then
    local entList = Isaac.GetRoomEntities()
    for i = 1, #entList, 1 do
      if entList[i].Type == EntityType.ENTITY_TEAR and entList[i]:GetData().NutMilk ~= 0 and (entList[i].Parent.Type == EntityType.ENTITY_PLAYER or (entList[i].Parent.Type == 3 and entList[i].Parent.SubType == 80)) then
        for j = 2, 6, 2 do
          if entList[i].FrameCount == j then
            nutMilk:fireSmallTears(entList[i])
          end
        end
      end
    end
  end
end

function nutMilk:fireSmallTears(ent)
  local player = Game():GetPlayer(0)
  local t = player:FireTear(player.Position,ent.Velocity, false, true, false)
  --Copy the data to avoid proccing other items like speical one
  Agony:dataCopy(ent:GetData(),t:GetData())
  t:GetData().NutMilk = 0 
  t.Scale = t.Scale/3
  t.CollisionDamage = t.CollisionDamage/3
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, nutMilk.onUpdate) 