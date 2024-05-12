function GM:HUDWeaponPickedUp(wep)
	if MySelf:Team() == TEAM_HUMAN then
		rW(wep)
	end
end

function GM:HUDItemPickedUp(itemname)
end

function GM:HUDAmmoPickedUp(itemname, amount)
end
