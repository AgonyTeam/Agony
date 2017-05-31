function Agony:IsPosInRoom(pos)
	local room = Game():GetRoom()
	if room:IsLShapedRoom() then
		--TODO: Add support for L-shaped rooms
		local tl = room:GetTopLeftPos()
		local br = room:GetBottomRightPos()
		return pos.X > tl.X and pos.X < br.X and pos.Y > tl.Y and pos.Y < br.Y
	else
		local tl = room:GetTopLeftPos()
		local br = room:GetBottomRightPos()
		return pos.X > tl.X and pos.X < br.X and pos.Y > tl.Y and pos.Y < br.Y
	end
end