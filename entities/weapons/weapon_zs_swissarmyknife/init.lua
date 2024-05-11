AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	if self.WalkSpeed < self.Owner.WalkSpeed then
		GAMEMODE:SetPlayerSpeed(self.Owner, self.WalkSpeed)
	elseif self.WalkSpeed > self.Owner.WalkSpeed then
		local timername = tostring(self.Owner).."speedchange"
		timer.Destroy(timername)
		timer.Create(timername, 1, 1, GAMEMODE.SetPlayerSpeed, GAMEMODE, self.Owner, self.WalkSpeed)
	end

	return true
end

function SWEP:Think()
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self.Weapon:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	local trace = self.Owner:TraceLine(62)
	local ent

	if trace.HitNonWorld then
		ent = trace.Entity
	end

	if trace.Hit then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			self.Owner:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			self.Owner:EmitSound("weapons/knife/knife_hitwall1.wav")
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end
	end

	if self.Alternate then
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	end
	self.Alternate = not self.Alternate

	self.Owner:EmitSound("weapons/knife/knife_slash"..math.random(1,2)..".wav")
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			ent:TakeDamage(self.Primary.Damage, self.Owner)
		end
	end
end

function SWEP:SecondaryAttack()
end
