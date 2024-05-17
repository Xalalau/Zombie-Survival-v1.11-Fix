ROUNDTIME = 1500

hook.Add("PlayerInitialSpawn", "SendAlteredTime", function(ply)
	ply:SendLua("ROUNDTIME=1500")
end)
