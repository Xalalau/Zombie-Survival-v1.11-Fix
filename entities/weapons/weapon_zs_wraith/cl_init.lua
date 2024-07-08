include("shared.lua")

SWEP.PrintName = "Wraith"
SWEP.ViewModelFOV = 40

function SWEP:Holster()
	local vm = LocalPlayer():GetViewModel()

	timer.Simple(0.1, function() -- This avoids the last Think() overriding reder mode and colors here
		if vm and vm:IsValid() then
			vm:SetRenderMode(RENDERMODE_NORMAL)
			vm:SetColor(Color(255, 255, 255, 255))
		end		
	end)
end

function SWEP:Think()
	local ply = LocalPlayer()
	local vm = ply:GetViewModel()
	if vm and vm:IsValid() and ply:Health() > 0 then
		if vm:GetRenderMode() == RENDERMODE_NORMAL then
			vm:SetRenderMode(RENDERMODE_TRANSCOLOR) -- Hacky solution to keep the rendermode 1. Idk why it keeps resting - Xala
		end
		vm:SetColor(Color(20, 20, 20, math.max(15, math.min(ply:GetVelocity():Length(), 200))))
	end
end
