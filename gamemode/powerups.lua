PowerupFunctions = {}

PowerupFunctions["_Heal"] = function(ply)
	ply:SetHealth(math.min(ply:Health() + 30, 100))
	local effectdata = EffectData()
		effectdata:SetOrigin(ply:GetPos() + Vector(0,0,48))
	util.Effect("powerup_heal", effectdata)
end

PowerupFunctions["_Shell"] = function(ply)
	ply:SetArmor(ply:Armor() + 25)
	local effectdata = EffectData()
		effectdata:SetOrigin(ply:GetPos() + Vector(0,0,48))
	util.Effect("powerup_shell", effectdata)
end

PowerupFunctions["_Regeneration"] = function(ply)
	timer.Create("regeneration"..ply:UniqueID(), 3, 0, function()
		RegenerationTimer(ply, ply:UniqueID())
	end)
	local effectdata = EffectData()
		effectdata:SetOrigin(ply:GetPos() + Vector(0,0,48))
	util.Effect("powerup_regeneration", effectdata)
end

function RegenerationTimer(ply, uid)
	if ply:IsValid() and ply:Team() == TEAM_HUMAN then
		ply:SetHealth(math.min(ply:Health() + 1, 100))
	else
		timer.Remove("regeneration"..uid)
	end
end
