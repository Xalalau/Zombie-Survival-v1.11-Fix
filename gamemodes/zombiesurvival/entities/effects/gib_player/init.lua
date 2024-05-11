function EFFECT:Init(data)
	local player = data:GetEntity()

	if player and player:IsValid() then
		player:EmitSound(Sound("physics/flesh/flesh_bloody_break.wav"))

		for i=2, 4 do
			local effectdata = EffectData()
				effectdata:SetOrigin(player:GetPos() + i * Vector(0,0,10))
				effectdata:SetNormal(VectorRand())
				effectdata:SetMagnitude(math.random(700, 1300))
				effectdata:SetScale(1)
			util.Effect("bloodstream", effectdata)
		end

		for i=1, 2 do
			local effectdata = EffectData()
				effectdata:SetOrigin(player:GetPos() + Vector(0,0,32) + VectorRand() * 12)
				effectdata:SetMagnitude(i)
				effectdata:SetScale(1)
			util.Effect("gib", effectdata)
		end
		for i=1, 5 do
			local effectdata = EffectData()
				effectdata:SetOrigin(player:GetPos() + Vector(0,0,10) + VectorRand() * 12)
				effectdata:SetMagnitude(math.random(3, #HumanGibs))
				effectdata:SetScale(1)
			util.Effect("gib", effectdata)
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(player:GetPos() + Vector(0,0,10) + VectorRand() * 12)
			effectdata:SetMagnitude(math.random(1, #HumanLegs))
			effectdata:SetScale(2)
		util.Effect("gib", effectdata)

		local effectdata = EffectData()
			effectdata:SetOrigin(player:GetPos() + Vector(0,0,10) + VectorRand() * 12)
			effectdata:SetMagnitude(math.random(1, #HumanTorsos))
			effectdata:SetScale(3)
		util.Effect("gib", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
