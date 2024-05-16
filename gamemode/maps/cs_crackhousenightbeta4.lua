hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	for _, ent in ipairs(ents.FindByClass("prop_physics*")) do
		ent:GetPhysicsObject():EnableMotion(true)
	end
end)
