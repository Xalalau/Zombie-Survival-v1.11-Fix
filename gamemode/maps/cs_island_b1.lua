hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	for _, class in ipairs(ZombieClasses) do
		class.Unlocked = true
	end

	hook.Add("PlayerInitialSpawn", "GiveAllClasses", function(ply)
		ply:SendLua("for _,class in ipairs(ZombieClasses) do class.Unlocked=true end")
	end)
end)
