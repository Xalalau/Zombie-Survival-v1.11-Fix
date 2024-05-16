hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	for _, class in ipairs(ZombieClasses) do
		class.Unlocked = true
	end

	hook.Add("PlayerInitialSpawn", "GiveAllClasses", function(ply)
		ply:SendLua("for _,class in ipairs(ZombieClasses) do class.Unlocked=true end")
	end)

	for _, ent in ipairs(ents.FindByClass("prop_physics*")) do
		ent:GetPhysicsObject():EnableMotion(true)
	end
end)
