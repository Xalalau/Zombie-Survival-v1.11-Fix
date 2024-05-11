hook.Add("InitPostEntity", "AddBlocker", function()
	hook.Remove("InitPostEntity", "AddBlocker")
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(96, -376, 280))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_c17/FurnitureCouch001a.mdl"))
		ent:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(139, -379, 280.0313))
		ent2:SetAngle(Angle(270, 0, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
		ent2:SetColor(0, 0, 0, 0)
	end
end)
