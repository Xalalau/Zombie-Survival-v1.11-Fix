AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	local timername = tostring(self:GetOwner()).."speedchange"
	timer.Remove(timername)
	if self.WalkSpeed < self:GetOwner().WalkSpeed then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(), self.WalkSpeed)
	elseif self.WalkSpeed > self:GetOwner().WalkSpeed then
		timer.Create(timername, 1, 1, function()
			GAMEMODE:SetPlayerSpeed(self:GetOwner(), self.WalkSpeed)
		end)
	end
	return true
end

function SWEP:Think()
end

function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	local hurt = self:GetOwner():TraceHullAttack(self:GetOwner():EyePos(), self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * 70, 
		Vector(-16,-16,-16), Vector(36, 36, 36), 1, DMG_CLUB, 45)

	local trace = self:GetOwner():TraceLine(70)

	if hurt and hurt:IsValid() then
		trace.Hit = true
		trace.HitWorld = false
		trace.HitNonWorld = true
		trace.Entity = hurt
		trace.MatType = 1337
	end

	if trace.Hit then
		local mat = trace.MatType

		local decal = nil
		local soundname = nil
		if mat == MAT_FLESH then
			decal = "Impact.Flesh"
			soundname = "physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav"
			local effectdata = EffectData()
				effectdata:SetOrigin(trace.HitPos)
				effectdata:SetStart(trace.HitPos + trace.HitNormal * 8)
			util.Effect("BloodImpact", effectdata)
		elseif mat == MAT_ANTLION then
			decal = "Impact.Antlion"
			soundname = "npc/antlion/shell_impact"..math.random(1,4)..".wav"
		elseif mat == MAT_BLOODYFLESH then
			decal = "Impact.BloodyFlesh"
			soundname = "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav"
			local effectdata = EffectData()
				effectdata:SetOrigin(trace.HitPos)
				effectdata:SetStart(trace.HitPos + trace.HitNormal * 8)
			util.Effect("BloodImpact", effectdata)
		elseif mat == MAT_SLOSH then
			decal = "Impact.BloodyFlesh"
			soundname = "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav"
		elseif mat == MAT_ALIENFLESH then
			decal = "Impact.AlienFlesh"
			soundname = "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav"
		elseif mat == MAT_WOOD then
			decal = "Impact.Concrete"
			soundname = "physics/wood/wood_solid_impact_bullet"..math.random(1,5)..".wav"
		elseif mat == MAT_CONCRETE then
			decal = "Impact.Concrete"
			soundname = "physics/concrete/concrete_impact_bullet"..math.random(1,4)..".wav"
		elseif mat == MAT_METAL then
			decal = "Impact.Concrete"
			soundname = "physics/metal/metal_solid_impact_bullet"..math.random(1,4)..".wav"
		elseif mat == MAT_SAND or mat == MAT_DIRT or mat == MAT_FOLIAGE then
			decal = "Impact.Concrete"
			soundname = "physics/surfaces/sand_impact_bullet"..math.random(1,4)..".wav"
		elseif mat == MAT_GLASS then
			decal = "Impact.Glass"
			soundname = "physics/glass/glass_impact_bullet"..math.random(1,4)..".wav"
		elseif mat == MAT_VENT or mat == MAT_GRATE then
			decal = "Impact.Metal"
			soundname = "physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav"
		elseif mat == MAT_PLASTIC then
			decal = "Impact.Metal"
			soundname = "physics/plastic/plastic_box_impact_bullet"..math.random(1,5)..".wav"
		elseif mat == MAT_COMPUTER then
			decal = "Impact.Metal"
			soundname = "physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav"
		elseif mat == MAT_TILE then
			decal = "Impact.Concrete"
			soundname = "physics/surfaces/tile_impact_bullet"..math.random(1,4)..".wav"
		end

		if soundname then
			self:GetOwner():EmitSound(soundname)
		end

		if decal then
			util.Decal(decal, trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end

		/*local ent = trace.Entity
		if ent and ent:IsValid() then
			ent:TakeDamage(45, self:GetOwner())
		end*/
	else
		self:GetOwner():EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end

	if self.Alternate then
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
	else
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	end
	self.Alternate = not self.Alternate

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
end
