local SKIN = {}

function SKIN:PaintFrame(panel)
	self:DrawGenericBackground(0, 0, panel:GetWide(), panel:GetTall(), color_black)

	surface.SetDrawColor(0, 150, 0, 255)
	surface.DrawRect(0, 22, panel:GetWide(), 1)
	surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
end

derma.DefineSkin("ZS", "Derma skin for Zombie Survival", SKIN, "Default")

RunConsoleCommand("derma_skin", "ZS")
