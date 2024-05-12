-- NoXiousNet mini-mapeditor

concommand.Add("mapeditor_add", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	if not arguments[1] then return end

	local tr = sender:TraceLine(3000)
	if tr.Hit then
		local ent = ents.Create(string.lower(arguments[1]))
		if ent:IsValid() then
			ent:SetPos(tr.HitPos)
			ent:Spawn()
			table.insert(GAMEMODE.MapEditorEntities, ent)
			GAMEMODE:SaveMapEditorFile()
		end
	end
end)

concommand.Add("mapeditor_addonme", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	if not arguments[1] then return end

	local ent = ents.Create(string.lower(arguments[1]))
	if ent:IsValid() then
		ent:SetPos(sender:EyePos())
		ent:Spawn()
		table.insert(GAMEMODE.MapEditorEntities, ent)
		GAMEMODE:SaveMapEditorFile()
	end
end)

concommand.Add("mapeditor_remove", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				table.remove(GAMEMODE.MapEditorEntities, i)
				ent:Remove()
			end
		end
		GAMEMODE:SaveMapEditorFile()
	end
end)

local function ME_Pickup(pl, ent, uid)
	if pl:IsValid() and ent:IsValid() then
		ent:SetPos(util.TraceLine({start=pl:GetShootPos(),endpos=pl:GetShootPos() + pl:GetAimVector() * 3000, filter={pl, ent}}).HitPos)
		return
	end
	timer.Destroy(uid.."mapeditorpickup")
	GAMEMODE:SaveMapEditorFile()
end

concommand.Add("mapeditor_pickup", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				timer.Create(sender:UniqueID().."mapeditorpickup", 0.25, 0, ME_Pickup, sender, ent, sender:UniqueID())
			end
		end
	end
end)

concommand.Add("mapeditor_nudgeup", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				local amount = tonumber(arguments[1]) or 1
				ent:SetPos(ent:GetPos() + Vector(0,0,amount))
				GAMEMODE:SaveMapEditorFile()
				return true
			end
		end
	end
end)

concommand.Add("mapeditor_nudgeforward", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				local amount = tonumber(arguments[1]) or 1
				ent:SetPos(ent:GetPos() + ent:GetForward() * amount)
				GAMEMODE:SaveMapEditorFile()
				return true
			end
		end
	end
end)

concommand.Add("mapeditor_nudgeright", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				local amount = tonumber(arguments[1]) or 1
				ent:SetPos(ent:GetPos() + ent:GetRight() * amount)
				GAMEMODE:SaveMapEditorFile()
				return true
			end
		end
	end
end)

concommand.Add("mapeditor_rotateup", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				local amount = tonumber(arguments[1]) or 1
				local ang = ent:GetAngles()
				ang:RotateAroundAxis(ang:Up(), amount)
				ent:SetAngles(ang)
				GAMEMODE:SaveMapEditorFile()
				return true
			end
		end
	end
end)

concommand.Add("mapeditor_rotateforward", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				local amount = tonumber(arguments[1]) or 1
				local ang = ent:GetAngles()
				ang:RotateAroundAxis(ang:Forward(), amount)
				ent:SetAngles(ang)
				GAMEMODE:SaveMapEditorFile()
				return true
			end
		end
	end
end)

concommand.Add("mapeditor_rotateright", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	local tr = sender:TraceLine(3000)
	if tr.Entity and tr.Entity:IsValid() then
		for i, ent in ipairs(GAMEMODE.MapEditorEntities) do
			if ent == tr.Entity then
				local amount = tonumber(arguments[1]) or 1
				local ang = ent:GetAngles()
				ang:RotateAroundAxis(ang:Right(), amount)
				ent:SetAngles(ang)
				GAMEMODE:SaveMapEditorFile()
				return true
			end
		end
	end
end)

concommand.Add("mapeditor_drop", function(sender, command, arguments)
	if not sender:IsSuperAdmin() then return end

	timer.Destroy(sender:UniqueID().."mapeditorpickup")
	GAMEMODE:SaveMapEditorFile()
end)

function GM:SaveMapEditorFile()
	local sav = {}
	for _, ent in pairs(GAMEMODE.MapEditorEntities) do
		if ent:IsValid() then
			local ppos = ent:GetPos()
			ppos.x = math.ceil(ppos.x)
			ppos.y = math.ceil(ppos.y)
			ppos.z = math.ceil(ppos.z)
			table.insert(sav, ent:GetClass().." "..tostring(ppos))
		end
	end
	file.Write("zsmaps/"..game.GetMap()..".txt", table.concat(sav, ","))
end
