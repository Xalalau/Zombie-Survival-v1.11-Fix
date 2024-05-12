ENT.Type = "anim"

function ENT:SetRadius(fRadius)
	self:SetNetworkedFloat("radius", fRadius)
end

function ENT:GetRadius()
	return self:GetNetworkedFloat("radius", 250)
end
