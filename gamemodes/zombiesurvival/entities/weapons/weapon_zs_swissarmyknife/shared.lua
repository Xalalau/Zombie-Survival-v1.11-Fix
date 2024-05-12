SWEP.Author = "JetBoom"

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 15
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.65

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 215

SWEP.LastShootTime = 0

SWEP.IsMelee = true

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_hit1.wav")
	util.PrecacheSound("weapons/knife/knife_hit2.wav")
	util.PrecacheSound("weapons/knife/knife_hit3.wav")
	util.PrecacheSound("weapons/knife/knife_hit4.wav")
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
	util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
end

local function StabCallback(attacker, trace, dmginfo)
	if trace.Hit and trace.HitPos:Distance(trace.StartPos) <= 62 then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			if SERVER then
				attacker:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			end
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			if SERVER then
				attacker:EmitSound("weapons/knife/knife_hitwall1.wav")
			end
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end

		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_HITCENTER)

		local ent = trace.Entity
		if ent:IsValid() and trace.HitPos:Distance(trace.StartPos) <= 62 then
			return {damage = true, effects = false}
		end
	else
		if SERVER then
			attacker:EmitSound("weapons/knife/knife_slash"..math.random(1,2)..".wav")
		end
		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_MISSCENTER)
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
		bullet.Force = 2
		bullet.Damage = self.Primary.Damage
		bullet.HullSize = 1.75
		bullet.Callback = StabCallback
		self.Owner:FireBullets(bullet)
	end
end
