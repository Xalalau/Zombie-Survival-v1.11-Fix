util.PrecacheSound("physics/flesh/flesh_bloody_break.wav")

local NextEffect = 0

function EFFECT:Init(data)
	if CurTime() < NextEffect then return end -- This is to stop crashing when lots of people get gibbed at once.
	NextEffect = CurTime() + 0.5

	local ply = data:GetEntity()

	if ply and ply:IsValid() then
		local pos = ply:GetPos()
		ply:EmitSound("physics/flesh/flesh_bloody_break.wav")

		local effectdata = EffectData()
			effectdata:SetOrigin(pos + Vector(0,0,25))
			effectdata:SetMagnitude(math.random(28, 34))
		util.Effect("bloodstream", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
