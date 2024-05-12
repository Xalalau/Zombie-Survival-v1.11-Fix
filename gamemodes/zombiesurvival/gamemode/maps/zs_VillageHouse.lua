hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	for _, ent in pairs(ents.FindByClass("func_physbox")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("prop_door_rotating")) do
		ent:Remove()
	end
end)
