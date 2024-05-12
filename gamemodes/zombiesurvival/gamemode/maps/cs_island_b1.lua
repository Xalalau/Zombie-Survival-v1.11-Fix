hook.Add("InitPostEntity", "Adding", function()
	hook.Remove("InitPostEntity", "Adding")

	for _, class in pairs(GAMEMODE.ZombieClasses) do
		class.Unlocked = true
	end

	hook.Add("PlayerInitialSpawn", "GiveAllClasses", function(pl)
		pl:SendLua("for _,class in pairs(GAMEMODE.ZombieClasses) do class.Unlocked=true end")
	end)
end)
