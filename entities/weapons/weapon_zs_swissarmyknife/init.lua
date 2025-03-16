AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	local owner = self:GetOwner()
	if self.WalkSpeed < owner.WalkSpeed then
		GAMEMODE:SetPlayerSpeed(owner, self.WalkSpeed)
	elseif self.WalkSpeed > owner.WalkSpeed then
		local timername = tostring(owner).."speedchange"
		timer.Remove(timername)
		timer.Create(timername, 1, 1, function()
			if IsValid(self) and IsValid(owner) then
				GAMEMODE:SetPlayerSpeed(owner, self.WalkSpeed)
			end
		end)
	end

	return true
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	local owner = self:GetOwner()
	local trace, ent = owner:CalcMeleeHit(self.MeleeHitDetection)

	if trace.Hit then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			owner:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			owner:EmitSound("weapons/knife/knife_hitwall1.wav")
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end
	elseif ent:IsValid() then
		owner:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
		util.Decal("Blood", ent:GetPos() + ent:GetAngles():Forward() * 8, ent:GetPos() - ent:GetAngles():Forward() * 8)
	end

	if self.Alternate then
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
	else
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	end
	self.Alternate = not self.Alternate

	owner:EmitSound("weapons/knife/knife_slash"..math.random(1,2)..".wav")
	owner:SetAnimation(PLAYER_ATTACK1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			ent:TakeDamage(self.Primary.Damage, owner)
		end
	end
end

function SWEP:SecondaryAttack()
end
