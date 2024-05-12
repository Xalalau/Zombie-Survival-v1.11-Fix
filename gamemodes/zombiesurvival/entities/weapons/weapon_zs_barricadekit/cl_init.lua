include("shared.lua")

SWEP.PrintName = "'Aegis' Barricade Kit"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 4
SWEP.SlotPos = 5

CreateClientConVar("zs_barricadekityaw", 0, false, true)

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
end

function SWEP:GetViewModelPosition(pos, ang)
	if self.Owner:GetNetworkedBool("IsHolding") then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
	RunConsoleCommand("zs_barricadekityaw", math.NormalizeAngle(GetConVarNumber("zs_barricadekityaw") + 10))
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Think()
	if 0 < self:Clip1() then
		local owner = self.Owner
		local effectdata = EffectData()
			effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
			effectdata:SetNormal(owner:GetAimVector())
		util.Effect("barricadeghost", effectdata, true, true)
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide*0.5, y + tall*0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide*0.5, YNameBlur + y + tall*0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide*0.5, YNameBlur + y + tall*0.5, color_blu1, TEXT_ALIGN_CENTER)
end
