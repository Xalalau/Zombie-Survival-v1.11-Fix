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
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false

	SWEP.Slot = 3
	SWEP.SlotPos = 6
	SWEP.MaxAmmo = 0

	local col = Color(255, 80, 0, 255)
	killicon.AddFont("weapon_zs_crossbow", "HL2MPTypeDeath", "1", col)
	killicon.AddFont("projectile_arrow", "HL2MPTypeDeath", "1", col)
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = 150

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end

	if SERVER then
		local ply = self:GetOwner()
		local ent = ents.Create("projectile_arrow")
		if ent:IsValid() then
			ent:SetOwner(ply)
			ent:SetPos(ply:GetShootPos() + ply:GetAimVector() * 40)
			ent:Spawn()
		end
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end

	self:TakePrimaryAmmo(1)

	if CLIENT then
		self:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

function SWEP:SecondaryAttack()
	self.NextZoom = self.NextZoom or CurTime()
	if CurTime() < self.NextZoom then return end
	self.NextZoom = CurTime() + self.Secondary.Delay

	local zoomed = self:GetNetworkedBool("Zoomed", false)
	self:SetNetworkedBool("Zoomed", not zoomed)
	if zoomed then
		if SERVER then
			self:GetOwner():SetFOV(90, 0.5)
			self:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)
		else
			self.DrawCrosshair = true
			surface.PlaySound("weapons/sniper/sniper_zoomout.wav")
		end
	else
		if SERVER then
			self:GetOwner():SetFOV(30, 0.5)
			self:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)
		else
			self.DrawCrosshair = false
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		end
	end
end

function SWEP:Holster()
	self:SetNetworkedBool("Zoomed", false)
	return true
end

if CLIENT then
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

function SWEP:Precache()
	util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
	util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
	util.PrecacheSound("weapons/sniper/sniper_zoomin.wav")
	util.PrecacheSound("weapons/sniper/sniper_zoomout.wav")
end

if SERVER then
	function SWEP:Reload()
		if self:Clip1() == 0 and self:GetOwner():GetAmmoCount("XBowBolt") > 0 then
			self:EmitSound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav", 50, 100)
			self:DefaultReload(ACT_VM_RELOAD)
		end
	end
else
	function SWEP:Reload()
		if self:Clip1() == 0 and self:GetOwner():GetAmmoCount("XBowBolt") > 0 then
			surface.PlaySound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav")
			self:DefaultReload(ACT_VM_RELOAD)
		end
	end
end
