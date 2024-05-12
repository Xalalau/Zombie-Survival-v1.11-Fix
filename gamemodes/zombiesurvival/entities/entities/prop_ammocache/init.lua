AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():EnableMotion(false)

	self:SetUseType(SIMPLE_USE)

	self.Think = nil
end

function ENT:Use(activator, caller, usetype, unknown)
	if activator:IsPlayer() and activator:Alive() and activator:Team() == TEAM_HUMAN then
		local wep = activator:GetActiveWeapon()

		if wep.Primary.Ammo and wep.Primary.Ammo ~= "none" then
			local maxammo = GAMEMODE.AmmoCache[string.lower(wep.Primary.Ammo)]
			if maxammo then
				local currentammo = activator:GetAmmoCount(wep.Primary.Ammo)
				if currentammo < maxammo then
					activator:StripAmmo(wep.Primary.Ammo)
					activator:GiveAmmo(maxammo, wep.Primary.Ammo)
					activator:SendLua("GAMEMODE:SplitMessage(h*0.6,\"<color=yellow><font=HUDFontSmallAA>Ammo Replenished\")")
				end
			end
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
