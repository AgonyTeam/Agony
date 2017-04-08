
local smokersLung =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	lastAction = nil
}
smokersLung.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_smokerslung.anm2")

function smokersLung:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		smokersLung.hasItem = false
	end
	if smokersLung.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_SMOKERS_LUNG) then
		--player:AddNullCostume(smokersLung.costumeID)
		smokersLung.hasItem = true
	end
	if player:GetData().smokersLungCooldown == nil then
		player:GetData().smokersLungCooldown = 0 
	end
	if player:GetData().smokersLungFrame == nil then
		player:GetData().smokersLungFrame = 0
	end
	if player:HasCollectible(CollectibleType.AGONY_C_SMOKERS_LUNG) then
		player.FireDelay = 1337;

		if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex)
		or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex)
		or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)
		or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex)
		and player:GetData().smokersLungCooldown == 0 then
			if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then 
				smokersLung.lastAction = ButtonAction.ACTION_SHOOTLEFT
			elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then 
				smokersLung.lastAction = ButtonAction.ACTION_SHOOTRIGHT
			elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then 
				smokersLung.lastAction = ButtonAction.ACTION_SHOOTUP
			elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then 
				smokersLung.lastAction = ButtonAction.ACTION_SHOOTDOWN
			end
			player:GetData().smokersLungFrame = math.min(player.MaxFireDelay*2, player:GetData().smokersLungFrame+1)
			BOff = math.ceil(255*player:GetData().smokersLungFrame/(player.MaxFireDelay*2))
			player:SetColor(Color(BOff, 1, 1, 1, 0, 0, 0), 1, 0, false, false)
		elseif Game():GetRoom():GetFrameCount() > 1 then
			if player:GetData().smokersLungFrame == player.MaxFireDelay*2 then
				--fire smoke
				local lastShootingDir = Vector (0,0)
				if smokersLung.lastAction == ButtonAction.ACTION_SHOOTLEFT then lastShootingDir.X = -1
				elseif smokersLung.lastAction == ButtonAction.ACTION_SHOOTRIGHT then lastShootingDir.X = 1
				elseif smokersLung.lastAction == ButtonAction.ACTION_SHOOTDOWN then lastShootingDir.Y = 1
				elseif smokersLung.lastAction == ButtonAction.ACTION_SHOOTUP then lastShootingDir.Y = -1 end
				
				for i = 1, 5+math.random(5) do
					t = player:FireTear(player.Position, lastShootingDir:__mul(player.ShotSpeed*5):__add(player.Velocity):Rotated(math.random(20)-10):__mul(1 +((math.random(20)-10)/100)), false, true, false)
					t.TearFlags = t.TearFlags | TearFlags.TEAR_PIERCING
					t.TearFlags = t.TearFlags | TearFlags.TEAR_SPECTRAL
					t:GetSprite():ReplaceSpritesheet(0, "gfx/effect/tear_smokerslung.png")
					t:GetSprite():LoadGraphics()
					player:GetData().smokersLungCooldown = 15
				end
			end
			player:GetData().smokersLungFrame = 0
		end
		player:GetData().smokersLungCooldown = math.max(0,player:GetData().smokersLungCooldown-1)
	end
end

function smokersLung:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SMOKERS_LUNG)) then
		if cacheFlag == CacheFlag.CACHE_RANGE then
			--player.TearHeight = 25
			player.TearFallingAcceleration = 0
		end
	end
end

function smokersLung:onUpdate()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(CollectibleType.AGONY_C_SMOKERS_LUNG) then
		local ents = Isaac.GetRoomEntities()
		for i=1,#ents do
			if ents[i].Type == EntityType.ENTITY_TEAR then
				ents[i]:ToTear().Height = player.TearHeight
				ents[i]:ToTear().FallingAcceleration = 0
				ents[i]:ToTear().FallingSpeed = 0
				ents[i].Velocity = ents[i].Velocity:__mul(0.97)
				if ents[i].FrameCount == 169 then
					ents[i]:Remove()
				end
			end
		end
	end
end

function smokersLung:onInput(entity,hook,action)
	if entity ~= nil then
		local player = entity:ToPlayer()

		if player and player:HasCollectible(CollectibleType.AGONY_C_SMOKERS_LUNG) then
			if action == ButtonAction.ACTION_SHOOTUP
			or action == ButtonAction.ACTION_SHOOTDOWN
			or action == ButtonAction.ACTION_SHOOTLEFT
			or action == ButtonAction.ACTION_SHOOTRIGHT
			then
				if hook == InputHook.GET_ACTION_VALUE then
					return 0
				else
					return false
				end
			end
		end
	end
end

Agony:AddCallback(ModCallbacks.MC_INPUT_ACTION, smokersLung.onInput)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, smokersLung.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, smokersLung.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, smokersLung.onPlayerUpdate)