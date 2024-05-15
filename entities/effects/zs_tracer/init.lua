local matBeam = Material("Effects/laser1.vmt")
local TracerTime = 0.2

function EFFECT:Init(data)

	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
	self.DieTime = RealTime() + TracerTime
end

function EFFECT:Think()
	return RealTime() < self.DieTime
end

function EFFECT:Render()
	render.DrawBeam(self.StartPos, self.EndPos, 3, 3, 0, color_white)
end
