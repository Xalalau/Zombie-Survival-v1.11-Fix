if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = true
	SWEP.CSMuzzleFlashes = true
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5

	surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
	surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

util.PrecacheSound("Weapon_AK47.Single")
SWEP.PrimarySound = "Weapon_AK47.Single"
SWEP.PrimaryRecoil = 1.5
SWEP.PrimaryDamage = 40
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.15
SWEP.Cone = 0.02
SWEP.ConeMoving = 0.03
SWEP.ConeCrouching = 0.013
SWEP.ConeIron = 0.018
SWEP.ConeIronCrouching = 0.01

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = 200

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.IronSightsPos = Vector(0,0,0)

function SWEP:SetIronsights(b)
	self:SetNetworkedBool("Ironsights", b)

	GAMEMODE:WeaponDeployed(self.Owner, self, b)
end

function SWEP:GetViewModelPosition(pos, ang)
	if self.Owner:GetNetworkedBool("IsHolding") then
		return pos + ang:Forward() * -256, ang
	end

	local bIron = self:GetNetworkedBool("Ironsights")

	if bIron ~= self.bLastIron then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

		if bIron then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 2.0
			self.BobScale 	= 1.5
		end
	end

	local fIronTime = self.fIronTime or 0

	if not bIron and fIronTime < CurTime() - 0.25 then 
		return pos, ang 
	end

	local Mul = 1.0

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) / 0.25, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	local Offset = self.IronSightsPos
	
	if self.IronSightsAng then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
	end

	pos = pos + Offset.x * ang:Right() * Mul
	pos = pos + Offset.y * ang:Forward() * Mul
	pos = pos + Offset.z * ang:Up() * Mul

	return pos, ang
end

if SERVER then
	local ActIndex = {}
	ActIndex["pistol"] = ACT_HL2MP_IDLE_PISTOL
	ActIndex["smg"] = ACT_HL2MP_IDLE_SMG1
	ActIndex["grenade"] = ACT_HL2MP_IDLE_GRENADE
	ActIndex["ar2"] = ACT_HL2MP_IDLE_AR2
	ActIndex["shotgun"] = ACT_HL2MP_IDLE_SHOTGUN
	ActIndex["rpg"] = ACT_HL2MP_IDLE_RPG
	ActIndex["physgun"] = ACT_HL2MP_IDLE_PHYSGUN
	ActIndex["crossbow"] = ACT_HL2MP_IDLE_CROSSBOW
	ActIndex["melee"] = ACT_HL2MP_IDLE_MELEE
	ActIndex["melee2"] = ACT_HL2MP_IDLE_MELEE2
	ActIndex["slam"] = ACT_HL2MP_IDLE_SLAM
	ActIndex["fist"] = ACT_HL2MP_IDLE_FIST
	ActIndex["passive"] = ACT_HL2MP_IDLE_PASSIVE
	ActIndex["knife"] = ACT_HL2MP_IDLE_KNIFE
	ActIndex["normal"] = ACT_HL2MP_IDLE

	function SWEP:SetWeaponHoldType(t, i)
		t = t or i or "normal"
		local index = ActIndex[t]
		if i then
			local ironindex = ActIndex[i]
			if ironindex then
				self.ActivityTranslateIronSights = {}
				self.ActivityTranslateIronSights[ACT_HL2MP_IDLE] = ironindex
				self.ActivityTranslateIronSights[ACT_HL2MP_WALK] = ironindex+1
				self.ActivityTranslateIronSights[ACT_HL2MP_RUN] = ironindex+1
				self.ActivityTranslateIronSights[ACT_HL2MP_IDLE_CROUCH] = ironindex+3
				self.ActivityTranslateIronSights[ACT_HL2MP_WALK_CROUCH] = ironindex+4
				self.ActivityTranslateIronSights[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ironindex+5
				self.ActivityTranslateIronSights[ACT_HL2MP_GESTURE_RELOAD] = index+6
				self.ActivityTranslateIronSights[ACT_HL2MP_JUMP] = ironindex+7
				self.ActivityTranslateIronSights[ACT_RANGE_ATTACK1] = ironindex+8
			end
		end

		
		if index then
			self.ActivityTranslate = {}
			self.ActivityTranslate[ACT_HL2MP_IDLE] = index
			self.ActivityTranslate[ACT_HL2MP_WALK] = index+1
			self.ActivityTranslate[ACT_HL2MP_RUN] = index+2
			self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = index+3
			self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = index+4
			self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = index+5
			self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = index+6
			self.ActivityTranslate[ACT_HL2MP_JUMP] = index+7
			self.ActivityTranslate[ACT_RANGE_ATTACK1] = index+8
		else
			Msg("SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n")
		end
	end

	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
			self:EmitSound(self.PrimarySound)

			self:TakePrimaryAmmo(1)
			--self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.PrimaryRecoil, math.Rand(-0.1,0.1) * self.PrimaryRecoil, 0))

			if self:GetNetworkedBool("Ironsights", false) then
				if self.Owner:Crouching() then
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeIronCrouching)
				else
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeIron)
				end
			elseif 25 < self.Owner:GetVelocity():Length() then
				self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeMoving)
			else
				if self.Owner:Crouching() then
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeCrouching)
				else
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.Cone)
				end
			end
		end
	end

	function SWEP:Initialize()
		self:SetWeaponHoldType(self.HoldType, self.IronSightsHoldType)
		self:SetDeploySpeed(1.1)
	end
end

function SWEP:Deploy()
	self:SetNextReload(0)
	GAMEMODE:WeaponDeployed(self.Owner, self)
	self:SetIronsights(false)

	if self.PreHolsterClip1 then
		local diff = self:Clip1() - self.PreHolsterClip1
		self:SetClip1(self.PreHolsterClip1)
		if SERVER then
			self.Owner:GiveAmmo(diff, self.Primary.Ammo, true)
		end
		self.PreHolsterClip1 = nil
	end
	if self.PreHolsterClip2 then
		local diff = self:Clip2() - self.PreHolsterClip2
		self:SetClip2(self.PreHolsterClip2)
		if SERVER then
			self.Owner:GiveAmmo(diff, self.Secondary.Ammo, true)
		end
		self.PreHolsterClip2 = nil
	end

	return true
end

function SWEP:Holster()
	if self.Primary.Ammo ~= "none" then
		self.PreHolsterClip1 = self:Clip1()
	end
	if self.Secondary.Ammo ~= "none" then
		self.PreHolsterClip2 = self:Clip2()
	end
	return true
end

function SWEP:TranslateActivity(act)
	if self:GetNetworkedBool("Ironsights") and self.ActivityTranslateIronSights then
		return self.ActivityTranslateIronSights[act] or -1
	end
	return self.ActivityTranslate[act] or -1
end

function SWEP:Reload()
	if self:GetNetworkedBool("Ironsights") then
		self:SetIronsights(false)
	end

	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_RELOAD) then
		self:SetNextReload(CurTime() + self:SequenceDuration())
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end
	end
end

function SWEP:Think()
end

function SWEP:ZSShootBullet(dmg, numbul, cone)
	local owner = self.Owner
	owner:FireBullets({Num = numbul, Src = owner:GetShootPos(), Dir = owner:GetAimVector(), Spread = Vector(cone, cone, 0), Tracer = 1, Force = 2, Damage = dmg})
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:SetAnimation(PLAYER_ATTACK1)
end

if CLIENT then
	function SWEP:Initialize()
		self:SetNetworkedBool("Ironsights", false)
	end

	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
			self:EmitSound(self.PrimarySound)

			self:TakePrimaryAmmo(1)
			--self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.PrimaryRecoil, math.Rand(-0.1, 0.1) * self.PrimaryRecoil, 0))

			self:SetNetworkedFloat("LastShootTime", CurTime())

			if self.Weapon:GetNetworkedBool("Ironsights", false) then
				if self.Owner:Crouching() then
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeIronCrouching)
				else
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeIron)
				end
			elseif 25 < self.Owner:GetVelocity():Length() then
				self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeMoving)
			else
				if self.Owner:Crouching() then
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeCrouching)
				else
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.Cone)
				end
			end
		end
	end

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
	end

	local oldcrosshair = CreateClientConVar("zs_oldcrosshair", 0, true, false)
	SWEP.CrossHairScale = 1
	function SWEP:DrawHUD()
		local x = w * 0.5
		local y = h * 0.5

		if self:GetNetworkedBool("Ironsights") then
			--surface.SetDrawColor(255, 0, 0, 255)
			--surface.DrawRect(x - 2, y - 2, 4, 4)
			return
		end

		local scalebyheight = (h / 768) * 18

		local scale

		if not MySelf:IsValid() then return end

		if MySelf:GetVelocity():Length() > 25 then
			scale = scalebyheight * self.ConeMoving
		else
			if MySelf:Crouching() then
				scale = scalebyheight * self.ConeCrouching
			else
				scale = scalebyheight * self.Cone
			end
		end

		surface.SetDrawColor(0, 190, 0, 230)

		self.CrossHairScale = math.Approach(self.CrossHairScale, scale, FrameTime() * 3 + math.abs(self.CrossHairScale - scale) * 0.012)

		local dispscale = self.CrossHairScale

		if oldcrosshair:GetBool() then
			local gap = 40 * dispscale
			local length = gap + 15 * dispscale
			surface.DrawLine(x - length, y, x - gap, y)
			surface.DrawLine(x + length, y, x + gap, y)
			surface.DrawLine(x, y - length, x, y - gap)
			surface.DrawLine(x, y + length, x, y + gap)

			surface.SetDrawColor(200, 0, 0, 230)
			surface.DrawRect(x - 2, y - 2, 4, 4)
		else
			local gap = math.min(20, 40 * dispscale)
			local length = gap + 15 * dispscale
			surface.DrawLine(x - length, y - length, x - length, gap + y - length)
			surface.DrawLine(x - length, y - length, x - length + gap, y - length)

			surface.DrawLine(x + length, y - length, x + length - gap, y - length)
			surface.DrawLine(x + length, y - length, x + length, gap + y - length)

			surface.DrawLine(x + length, y + length, x + length - gap, y + length)
			surface.DrawLine(x + length, y + length, x + length, y + length - gap)

			surface.DrawLine(x - length, y + length, x - length, y + length - gap)
			surface.DrawLine(x - length, y + length, x - length + gap, y + length)

			surface.SetDrawColor(200, 0, 0, 230)
			surface.DrawRect(x - 2, y - 2, 4, 4)
		end
	end
end

function SWEP:CanPrimaryAttack()
	local owner = self.Owner
	if owner:Team() == TEAM_UNDEAD then owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") owner:Kill() return false end -- Stops an exploit that allows people to put their modem on standby to avert StripWeapons(). VALVe engine bug.
	if owner:GetNetworkedBool("IsHolding") then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self.Owner:GetNetworkedBool("IsHolding") then
		local newsights = not self:GetNetworkedBool("Ironsights", false)
		self:SetIronsights(newsights)

		self:SetNextSecondaryFire(CurTime() + 0.5)
	end
end

function SWEP:OnRestore()
	self:SetIronsights(false)
end
