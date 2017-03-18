--This chest is spawned when an item is stored in the Safe Space collectible


ChestSubType["AGONY_SAFE"] = 0 --not sure how to read that one automatically either

safe = {}

function safe:onUpdate()
    local ents = Isaac.GetRoomEntities()
  local player = Isaac.GetPlayer(0)
  local sound = SFXManager()

  if Game():GetFrameCount() == 2 then
    if saveData.safeSpace.storedItem ~= nil and saveData.safeSpace.storedItem ~= 0 then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.AGONY_PICKUP_CHEST, ChestSubType.AGONY_SAFE , Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
    end
  end


  for _,entity in pairs(ents) do
    if entity.Type == EntityType.ENTITY_PICKUP 
    and entity.Variant == PickupVariant.AGONY_PICKUP_CHEST 
    and entity.SubType == ChestSubType.AGONY_SAFE then
      local entdata = entity:GetData()
      local entsprite = entity:GetSprite()
      if entdata.storedItem == nil then
        entdata.storedItem = saveData.safeSpace.storedItem
      end
      player:AddBombs(1)
      if player.Position:Distance(entity.Position) <= player.Size + entity.Size + 8
        and entdata.Opened == nil then
        player:AddKeys(1)
        entdata.Opened = true
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entsprite:Play("Open", true)
        sound:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
        --spawn item
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, entdata.storedItem , Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
        saveData.safeSpace.storedItem = 0
        Agony:SaveNow()
      end
    end
  end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, safe.onUpdate)