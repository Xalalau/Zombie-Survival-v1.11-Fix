AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
	umsg.Start("RcHCScale")
		umsg.Entity(self.Owner)
	umsg.End()
end

function SWEP:Think()
	if self.Leaping then
		if self.Owner:OnGround() then
			self.Leaping = false
			self.NextLeap = CurTime() + 1
		else
			local vStart = self.OwnerOffset + self.Owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self.OwnerAngles
			tr.filter = self.Owner
			local trace = util.TraceLine(tr)
			local ent = nil
			if trace.HitNonWorld then
				ent = trace.Entity
			end
			if ent and ent:IsValid() then
				local phys = ent:GetPhysicsObject()
				
				if ent:IsPlayer() then
			    	ent:TakeDamage(6, self.Owner)
				elseif ent:GetClass() == "func_breakable" then
					ent:Fire("addhealth", "-6", 0)
				elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
					local vel = self.Owner:EyeAngles():Forward() * 5000
					if vel.z < 800 then vel.z = 800 end
					phys:ApplyForceCenter(vel)
					ent:SetPhysicsAttacker(self.Owner)
					local bullet = {}
					bullet.Num 		= 1
					bullet.Src 		= self.Owner:GetShootPos()
					bullet.Dir 		= self.Owner:GetShootPos()
					bullet.Spread 	= Vector(0, 0, 0)
					bullet.Tracer	= 0
					bullet.Force	= 1
					bullet.Damage	= 6
					bullet.AmmoType = "Pistol"
					self.Owner:FireBullets(bullet)
				else
					local bullet = {}
					bullet.Num 		= 1
					bullet.Src 		= self.Owner:GetShootPos()
					bullet.Dir 		= self.Owner:GetAimVector()
					bullet.Spread 	= Vector(0, 0, 0)
					bullet.Tracer	= 0
					bullet.Force	= 1
					bullet.Damage	= 6
					bullet.AmmoType = "Pistol"

					self.Owner:FireBullets(bullet)
				end
				self.Leaping = false
		    	self.NextLeap = CurTime() + 1
				self.Owner:EmitSound("npc/headcrab/headbite.wav")
				self.Owner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30)))
			elseif trace.HitWorld then
				self.Owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
		    	self.Leaping = false
		    	self.NextLeap = CurTime() + 1
			end
		end
	end
end

function SWEP:PrimaryAttack()
	self:SecondaryAttack()
end

SWEP.NextLeap = 0
function SWEP:SecondaryAttack()
	if self.Leaping then return end
	self.Owner:Fire("IgnoreFallDamage", "", 0)
	local onground = self.Owner:OnGround()
	if CurTime() < self.NextLeap then return end
	if not onground then return end
	local vel = self.Owner:GetAngles():Forward() * 400
	if vel.z < 200 then vel.z = 200 end
	local eyeangles = self.Owner:GetAngles():Forward()
	eyeangles.pitch = -0.15
	eyeangles.z = -0.1
	local ang = self.Owner:GetAimVector() ang.z = 0
	self.OwnerAngles = ang * 45
	self.OwnerOffset = Vector(0,0,4)
	self.Owner:SetLocalVelocity(vel)
	self.Leaping = true
	self.Owner:EmitSound("npc/headcrab/attack"..math.random(1,3)..".wav")
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Reload()
	return false
end
