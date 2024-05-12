ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.AutomaticFrameAdvance = true

util.PrecacheSound("npc/fast_zombie/fz_alert_close1.wav")
util.PrecacheSound("npc/fast_zombie/leap1.wav")
util.PrecacheSound("npc/fast_zombie/wake1.wav")
util.PrecacheSound("npc/fast_zombie/fz_alert_far1.wav")
util.PrecacheSound("npc/zombie/claw_miss1.wav")
util.PrecacheSound("npc/zombie/claw_miss2.wav")
util.PrecacheSound("npc/zombie/claw_strike1.wav")
util.PrecacheSound("npc/zombie/claw_strike2.wav")
util.PrecacheSound("npc/zombie/claw_strike3.wav")

function ENT:OnRemove()
end

function ENT:PhysicsCollide(data, physobj)
end

function ENT:PhysicsUpdate(physobj)
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:TrueEyePos()
	return self:GetPos() + Vector(0,0,47)
end

function ENT:GetShootPos()
	return self:TrueEyePos()
end

function ENT:InVehicle()
	return false
end

ENT.CleanClassName = "npc_summonedzombie"
