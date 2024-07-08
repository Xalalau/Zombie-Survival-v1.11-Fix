// GET RID OF THE FUCKING CAMPTASTIC DOOR UPSTAIRS!

hook.Add("InitPostEntity", "DestroyDoor", function()
	hook.Remove("InitPostEntity", "DestroyDoor")
	RunConsoleCommand("zs_destroy_doors", false)
	RunConsoleCommand("zs_destroy_prop_doors", false)
	local doors = ents.FindByClass("prop_door_rotating")
	if doors[2] then
		doors[2]:Remove()
	end

	for _, ent in ipairs(ents.FindByClass("gmod_player_start")) do
		if ent:GetPos().z > -440 then
			ent:Remove()
		end
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(2946.4270, -2783.7803, -439.9688))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_wasteland/kitchen_shelf001a.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(2946.7278, -2781.4426, -407.3824 + 6))
		ent2:SetAngles(Angle(0, 50, 90))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_junk/CinderBlock01a.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(2946.5017, -2783.1523, -343.4822 + 6))
		ent2:SetAngles(Angle(0, 90, 90))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_junk/CinderBlock01a.mdl"))
		ent2:Spawn()
	end
end)
