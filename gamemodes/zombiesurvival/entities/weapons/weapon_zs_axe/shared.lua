SWEP.Author = "JetBoom"

SWEP.ViewModel = "models/weapons/v_axe/v_axe.mdl"
SWEP.WorldModel = "models/weapons/w_axe.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 29
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 205

SWEP.IsMelee = true

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("physics/wood/wood_plank_impact_hard1.wav")
	util.PrecacheSound("physics/wood/wood_plank_impact_hard2.wav")
	util.PrecacheSound("physics/wood/wood_plank_impact_hard3.wav")
	util.PrecacheSound("physics/wood/wood_plank_impact_hard4.wav")
	util.PrecacheSound("physics/wood/wood_plank_impact_hard5.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet4.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet5.wav")
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

local function StabCallback(attacker, trace, dmginfo)
	if trace.Hit and trace.HitPos:Distance(trace.StartPos) <= 65 then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
			if SERVER then
				attacker:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 80, math.random(86, 90))
			end
		else
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
			if SERVER then
				attacker:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(1,4)..".wav")
			end
		end

		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_HITCENTER)

		if trace.Entity:IsValid() then
			return {damage = true, effects = false}
		end
	else
		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_MISSCENTER)
		if SERVER then
			attacker:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 80, math.random(65, 70))
		end
	end

	return {effects = false, damage = false}
end

function SWEP:CanPrimaryAttack()
	if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end
	if self.Owner:GetNetworkedBool("IsHolding") then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		self.Owner:SetAnimation(PLAYER_ATTACK1)

		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force = 8
		bullet.Damage = self.Primary.Damage
		bullet.HullSize = 3
		bullet.Callback = StabCallback
		self.Owner:FireBullets(bullet)
	end
end
