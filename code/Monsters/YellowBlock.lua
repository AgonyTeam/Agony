--StartDebug()

--Yellow Block
yellowblock = {};
--yb_entitytype = Isaac.GetEntityTypeByName("Yellow Block");
EntityType["AGONY_ETYPE_YELLOW_BLOCK"] = Isaac.GetEntityTypeByName("Yellow Block");
--debug_text = "";

-- Movement
function yellowblock:ai_main(npc)
	local room = Game():GetRoom();
	--local getcol = room.GetGridCollisionAtPos(room, Vector(Isaac.GetPlayer(0).Position.X, Isaac.GetPlayer(0).Position.Y - 15));
	--debug_text = npc.Velocity.Y;
	--debug_text = npc.EntityGridCollisionClass;
	--debug_text = npc.StateFrame;
	--debug_text = "X: " .. npc.Position.X .. " || Y: " .. npc.Position.Y;
	--debug_text = npc.Velocity.X .. " | " .. npc.Velocity.Y;
	
	if (npc.State == NpcState.STATE_INIT) then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
		npc.CanShutDoors = false;
		npc.CollisionDamage = 0.0;
    
		npc:SetSpriteFrame("No-Spikes", 10);
		if ((npc.Variant == 1 and npc.SubType == 0) or (npc.Variant == 0 and npc.SubType == 0)) then
			npc.V1 = Vector(3,3);
		elseif ((npc.Variant == 2 and npc.SubType == 0) or (npc.Variant == 0 and npc.SubType == 1)) then
			npc.V1 = Vector(-3,3);
		elseif ((npc.Variant == 3 and npc.SubType == 0) or (npc.Variant == 0 and npc.SubType == 2)) then
			npc.V1 = Vector(3,-3);
		elseif ((npc.Variant == 4 and npc.SubType == 0) or (npc.Variant == 0 and npc.SubType == 3)) then
			npc.V1 = Vector(-3,-3);
		else
			npc.V1 = Vector(3,3);
		end
		npc.State = NpcState.STATE_MOVE;
	end
	
	if (npc.State == NpcState.STATE_MOVE) then
		npc.Velocity = npc.V1;
	end
	
	if (npc.StateFrame == 30 and npc.State ~= NpcState.STATE_IDLE) then
		npc:PlaySound(237, 1.0, 0, false, 1.0)
		npc.SetSpriteFrame(npc ,"Spikes", 0);
		npc.CollisionDamage = 1.0;
	end
	
	if (room:IsClear() == true and npc.Variant == 0) then
		npc.State = NpcState.STATE_IDLE;
	end
	
	if (npc.State == NpcState.STATE_IDLE) then
		npc:SetSpriteFrame("No-Spikes", 10);
		--npc.Velocity = Vector(0,0);
		npc.CollisionDamage = 0.0;
		npc.Friction = 0.5;
		npc.CollisionDamage = 0.0;
	end
	
	
	npc.StateFrame = npc.StateFrame + 1;
	
end

--Wall Bounce
function yellowblock:ai_turn(entity);
	local room = Game():GetRoom();
  
	local col_up = room.GetGridCollisionAtPos(room, Vector(entity.Position.X, entity.Position.Y - 20));
	local col_down = room.GetGridCollisionAtPos(room, Vector(entity.Position.X, entity.Position.Y + 20));
	local col_left = room.GetGridCollisionAtPos(room, Vector(entity.Position.X - 20, entity.Position.Y));
	local col_right = room.GetGridCollisionAtPos(room, Vector(entity.Position.X + 20, entity.Position.Y));
	
	--debug_text = entity.V1.X .. " | " .. entity.V1.Y .. " isfirstvisit(): " .. tostring(room:IsFirstVisit());
	
		if(col_up == 1 or 
		   col_up == 3 or 
		   col_up == 4) then
		   
		   --debug_text = debug_text .. "u";

		  entity.V1 = Vector(entity.V1.X, 3);
		end  
		
		if(col_down == 1 or 
		   col_down == 3 or 
		   col_down == 4) then
		   
		   --debug_text = debug_text .. "d";

		   entity.V1 = Vector(entity.V1.X, -3);
		end

		if(col_left == 1 or
		   col_left == 3 or 
		   col_left == 4) then
		   
		   --debug_text = debug_text .. "l";

		   entity.V1 = Vector(3, entity.V1.Y);
		end  
		
		if(col_right == 1 or
		   col_right == 3 or 
		   col_right == 4) then
		   
		   --debug_text = debug_text .. "r";

		   entity.V1 = Vector(-3, entity.V1.Y);
		end  	
end


-- Register the callbacks
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, yellowblock.ai_main, EntityType.AGONY_ETYPE_YELLOW_BLOCK);
Agony:AddCallback(ModCallbacks.MC_NPC_UPDATE, yellowblock.ai_turn, EntityType.AGONY_ETYPE_YELLOW_BLOCK);