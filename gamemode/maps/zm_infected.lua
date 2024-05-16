ZSF.ROUNDTIME = 1500

hook.Add("PlayerInitialSpawn", "SendAlteredTime", function(ply)
	ply:SendLua("ZSF.ROUNDTIME=1500")
end)
