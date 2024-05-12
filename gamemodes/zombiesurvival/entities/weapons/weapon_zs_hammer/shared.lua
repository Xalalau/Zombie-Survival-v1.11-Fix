SWEP.Author = "JetBoom"

SWEP.ViewModel = "models/weapons/v_hammer/v_hammer.mdl"
SWEP.WorldModel = "models/weapons/w_hammer.mdl"

SWEP.Primary.ClipSize = 9999
SWEP.Primary.Damage = 18
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Gravity"
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = 215

SWEP.LastShootTime = 0

SWEP.IsMelee = true

function SWEP:CanPrimaryAttack()
	if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end
	if self.Owner:GetNetworkedBool("IsHolding") then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-1.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-2.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-3.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-4.wav")
end


