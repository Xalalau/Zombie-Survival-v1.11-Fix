hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Remove()
	end
end)
