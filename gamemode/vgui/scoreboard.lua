local texGradient = surface.GetTextureID("gui/center_gradient")

local function SortFunc(a, b)
	return a:Frags() > b:Frags()
end

local colBackground = Color(40, 50, 40, 255)

local PANEL = {}

function PANEL:Init()
	SCOREBOARD = self
	self.Elements = {}
end

function PANEL:Paint()
	local tall, wide = self:GetTall(), self:GetWide()
	local posx, posy = self:GetPos()

	draw.RoundedBox(16, 0, 0, wide, tall, colBackground)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(32, 128, 256, tall - 300)
	surface.DrawRect(wide - 288, 128, 256, tall - 300)

	surface.SetDrawColor(0, 50, 255, 255)
	surface.DrawOutlinedRect(32, 128, 256, tall - 300)

	surface.SetDrawColor(0, 255, 0, 255)
	surface.DrawOutlinedRect(wide - 288, 128, 256, tall - 300)

	draw.DrawText("Zombie Survival", "HUDFontBig", wide * 0.5, 0, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
	surface.SetFont("HUDFontBig")
	local gmw, gmh = surface.GetTextSize("Zombie Survival")
	draw.DrawText("("..GAMEMODE.Version.." "..GAMEMODE.SubVersion..")", "DefaultSmall", wide * 0.5 + gmw * 0.5 + 8, gmh - 20, COLOR_GRAY, TEXT_ALIGN_LEFT)
	draw.DrawText(GetGlobalString("servername"), "HUDFont2", wide * 0.5, gmh, COLOR_GRAY, TEXT_ALIGN_CENTER)

	local colHuman = team.GetColor(ZSF.TEAM_HUMAN)
	local colUndead = team.GetColor(ZSF.TEAM_UNDEAD)

	local HumanPlayers = team.GetPlayers(ZSF.TEAM_HUMAN)
	local UndeadPlayers = team.GetPlayers(ZSF.TEAM_UNDEAD)

	table.sort(HumanPlayers, SortFunc)
	table.sort(UndeadPlayers, SortFunc)

	local y = 132
	local x = wide - 288

	draw.DrawText("Survivor", "HudDefault", 34, 116, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Kills", "HudDefault", 192, 116, color_white, TEXT_ALIGN_RIGHT)
	draw.DrawText("Ping", "HudDefault", 284, 116, color_white, TEXT_ALIGN_RIGHT)

	draw.DrawText("Zombie", "HudDefault", x + 2, 116, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Brains Eaten", "HudDefault", x + 192, 116, color_white, TEXT_ALIGN_RIGHT)
	draw.DrawText("Ping", "HudDefault", x + 254, 116, color_white, TEXT_ALIGN_RIGHT)

	surface.SetFont("HudDefault")
	local width, height = surface.GetTextSize("Q")

	for i, ply in ipairs(HumanPlayers) do
		if y >= tall - 285 then
			draw.DrawText("...", "HudDefault", 34, y, colHuman, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(ply:Name(), "HudDefault", 34, y, colHuman, TEXT_ALIGN_LEFT)
			draw.DrawText(ply:Frags(), "HudDefault", 192, y, colHuman, TEXT_ALIGN_CENTER)
			draw.DrawText(ply:Ping(), "HudDefault", 286, y, colHuman, TEXT_ALIGN_RIGHT)
			y = y + height
		end
	end

	y = 132

	for i, ply in ipairs(UndeadPlayers) do
		if y >= tall - 285 then
			draw.DrawText("...", "HudDefault", x + 2, y, colUndead, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(ply:Name(), "HudDefault", x + 2, y, colUndead, TEXT_ALIGN_LEFT)
			draw.DrawText(ply:Frags(), "HudDefault", x + 192, y, colUndead, TEXT_ALIGN_CENTER)
			draw.DrawText(ply:Ping(), "HudDefault", x + 254, y, colUndead, TEXT_ALIGN_RIGHT)
			y = y + height
		end
	end

	local y = tall - 165
	draw.DrawText("F1:  Help", "HUDFontSmallAA", 28, y, COLOR_RED, TEXT_ALIGN_LEFT)
	local tw, th = surface.GetTextSize("F1:  Help")
	y = y + th + 5
	draw.DrawText("F2: Manual redeem", "HUDFontSmallAA", 32, y, COLOR_GRAY, TEXT_ALIGN_LEFT)
	y = y + th + 5
	draw.DrawText("F3: Change Zombie class", "HUDFontSmallAA", 32, y, COLOR_GRAY, TEXT_ALIGN_LEFT)
	y = y + th + 5
	draw.DrawText("F4: Options", "HUDFontSmallAA", 32, y, COLOR_GRAY, TEXT_ALIGN_LEFT)

	return true
end

function PANEL:PerformLayout()
	self:SetSize(640, h * 0.95)

	self:SetPos((w - self:GetWide()) * 0.5, (h - self:GetTall()) * 0.5)
end
vgui.Register("ScoreBoard", PANEL, "Panel")
