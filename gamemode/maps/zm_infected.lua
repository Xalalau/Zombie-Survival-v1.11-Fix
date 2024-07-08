RunConsoleCommand("zs_roundtime", 1500)

hook.Add("PlayerInitialSpawn", "SendAlteredTime", function(ply)+
	ply:SendLua("RunConsoleCommand('zs_roundtime', 1500)")
end)
