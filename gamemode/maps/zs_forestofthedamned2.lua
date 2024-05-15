hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(225, 305, -69))
		ent2:SetAngles(Angle(0, 0, 90))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_c17/FurnitureCouch001a.mdl"))
		ent2:Spawn()
	end
end)
