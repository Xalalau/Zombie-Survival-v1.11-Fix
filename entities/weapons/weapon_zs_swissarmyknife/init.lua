AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	if self.WalkSpeed < self:GetOwner().WalkSpeed then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(), self.WalkSpeed)
	elseif self.WalkSpeed > self:GetOwner().WalkSpeed then
		local timername = tostring(self:GetOwner()).."speedchange"
		timer.Remove(timername)
		timer.Create(timername, 1, 1, function()
			if IsValid(self) and IsValid(self:GetOwner()) then
				GAMEMODE:SetPlayerSpeed(self:GetOwner(), self.WalkSpeed)
			end
		end)
	end

	return true
end

function SWEP:Think()
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	local trace = self:GetOwner():TraceLine(62)
	local ent

	if trace.HitNonWorld then
		ent = trace.Entity
	end

	if trace.Hit then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			self:GetOwner():EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			self:GetOwner():EmitSound("weapons/knife/knife_hitwall1.wav")
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end
	end

	if self.Alternate then
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
	else
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	end
	self.Alternate = not self.Alternate

	self:GetOwner():EmitSound("weapons/knife/knife_slash"..math.random(1,2)..".wav")
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			ent:TakeDamage(self.Primary.Damage, self:GetOwner())
		end
	end
end

function SWEP:SecondaryAttack()
end
