if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "crossbow"
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'Impaler' Crossbow"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false

	SWEP.Slot = 3
	SWEP.SlotPos = 3
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.PrimaryDelay = 2.0

SWEP.SecondaryDelay = 0.5

SWEP.WalkSpeed = 150

SWEP.NextZoom = 0

if SERVER then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)

			local ent = ents.Create("projectile_arrow")
			if ent:IsValid() then
				local pl = self.Owner
				ent:SetOwner(pl)
				ent:SetPos(pl:GetShootPos() + pl:GetAimVector() * 40)
				ent:Spawn()
			end
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			self:TakePrimaryAmmo(1)
		end
	end

	function SWEP:Reload()
		if self:GetNextReload() <= CurTime() and self:Clip1() == 0 and 0 < self.Owner:GetAmmoCount("XBowBolt") then
			self:EmitSound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav", 50, 100)
			self:DefaultReload(ACT_VM_RELOAD)
			self:SetNextReload(CurTime() + self:SequenceDuration())
		end
	end

	function SWEP:SecondaryAttack()
		if CurTime() < self.NextZoom then return end
		self.NextZoom = CurTime() + self.SecondaryDelay

		local zoomed = self:GetNetworkedBool("Zoomed", false)
		self:SetNetworkedBool("Zoomed", not zoomed)
		if zoomed then
			self.Owner:SetFOV(75, 0.5)
			self:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)
		else
			self.Owner:SetFOV(30, 0.5)
			self:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)
		end
	end
end

if CLIENT then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
			self:TakePrimaryAmmo(1)
		end
	end

	function SWEP:SecondaryAttack()
		if CurTime() < self.NextZoom then return end
		self.NextZoom = CurTime() + self.SecondaryDelay

		local zoomed = self:GetNetworkedBool("Zoomed", false)
		self:SetNetworkedBool("Zoomed", not zoomed)
		if zoomed then
			--self.DrawCrosshair = true
			surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
		else
			--self.DrawCrosshair = false
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		end
	end

	function SWEP:Reload()
		if self:GetNextReload() <= CurTime() and self:Clip1() == 0 and 0 < self.Owner:GetAmmoCount("XBowBolt") then
			surface.PlaySound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav")
			self:DefaultReload(ACT_VM_RELOAD)
			self:SetNextReload(CurTime() + self:SequenceDuration())
		end
	end

	function SWEP:DrawHUD()
		if self:GetNetworkedBool("Zoomed", false) then
			local hw = w * 0.5
			local hh = h * 0.5

			surface.SetDrawColor(255, 0, 0, 180)
			surface.DrawLine(0, hh, w, hh)
			surface.DrawLine(hw, 0, hw, h)
			for i=1, 10 do
				surface.DrawLine(hw, hh + i * 7, hw + (50 - i * 5), hh + i * 7)
			end

			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, w*0.15, h)
			surface.DrawRect(0, 0, w, h*0.15)
			surface.DrawRect(0, h*0.85, w, h*0.15)
			surface.DrawRect(w*0.85, 0, w*0.15, h)
		end
	end
end

function SWEP:Holster()
	self:SetNetworkedBool("Zoomed", false)
	return true
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomin.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomout.wav")
