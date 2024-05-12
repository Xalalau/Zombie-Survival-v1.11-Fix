SWEP.Author = "JetBoom"

SWEP.ViewModel = "models/weapons/v_sledgehammer/v_sledgehammer.mdl"
SWEP.WorldModel = "models/weapons/w_sledgehammer.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 45
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 180

SWEP.LastShootTime = 0

SWEP.IsMelee = true

function SWEP:Reload()
	return false
end

function SWEP:Precache()
end

local function StabCallback(attacker, trace, dmginfo)
	if trace.Hit and trace.HitPos:Distance(trace.StartPos) <= 70 then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
			if SERVER then
				attacker:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 80, math.random(86, 90))
			end
		else
			if SERVER then
				attacker:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav", 80, math.random(86, 90))
			end
			util.Decal("Impact.Concrete", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end

		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_HITCENTER)

		if trace.Entity:IsValid() then
			return {damage = true, effects = false}
		end
	else
		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_MISSCENTER)
	end

	if SERVER then
		attacker:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 77, math.random(35, 45))
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
		bullet.Force = 12
		bullet.Damage = self.Primary.Damage
		bullet.HullSize = 3.25
		bullet.Callback = StabCallback
		self.Owner:FireBullets(bullet)
	end
end
