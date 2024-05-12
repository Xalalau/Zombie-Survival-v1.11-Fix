util.PrecacheSound("physics/flesh/flesh_bloody_break.wav")

local NextEffect = 0

function EFFECT:Init(data)
	local ent = data:GetEntity()
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local scale = math.Round(data:GetScale())

	if CurTime() < NextEffect then return end -- This is to stop crashing when lots of people get gibbed at once.
	NextEffect = CurTime() + 0.2

	if ent:IsValid() then
		ent:EmitSound("physics/flesh/flesh_bloody_break.wav")

		local effectdata = EffectData()
			effectdata:SetOrigin(ent:GetPos() + Vector(0,0,25))
			effectdata:SetEntity(ent)
			effectdata:SetMagnitude(math.random(20, 26))
			effectdata:SetScale(scale)
		util.Effect("bloodstream", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
