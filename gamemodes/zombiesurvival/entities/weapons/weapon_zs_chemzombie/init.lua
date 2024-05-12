AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.ZombieOnly = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	local owner = self.Owner
	owner:DrawViewModel(false)
	owner:DrawWorldModel(false)

	for _, ent in pairs(ents.FindByClass("status_chemzombieambience")) do
		if ent:GetOwner() == owner then return end
	end

	local ent = ents.Create("status_chemzombieambience")
	if ent:IsValid() then
		ent:SetPos(owner:GetPos() + Vector(0,0,16))
		owner["status_chemzombieambience"] = ent
		ent:SetOwner(owner)
		ent:SetParent(owner)
		ent:Spawn()
	end
end

SWEP.NextAura = 0

function SWEP:Think()
	if self.NextAura <= CurTime() then
		self.NextAura = CurTime() + 2
		local origin = self.Owner:GetPos() + Vector(0,0,32)
		for _, ent in pairs(ents.FindInSphere(origin, 40)) do
			if ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD and ent:Alive() and TrueVisible(origin, ent:NearestPoint(origin)) then
				ent:TakeDamage(1, self.Owner, self)
			end
		end
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end
