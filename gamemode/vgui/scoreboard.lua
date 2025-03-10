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

local function TruncateText(text, maxLength)
    if string.len(text) > maxLength then
        return string.sub(text, 1, maxLength - 3) .. "..."
    else
        return text
    end
end

function PANEL:Paint()
	local UIScalingW, UIScalingH, smoothingFactor = GetUIScale()

	local tall, wide = self:GetTall(), self:GetWide()
	local posx, posy = self:GetPos()

	draw.RoundedBox(16, 0, 0, wide, tall, colBackground)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(32 * UIScalingW, 138 * UIScalingH, 256 * UIScalingW, tall - 300 * UIScalingH)
	surface.DrawRect(wide - 288 * UIScalingW, 138 * UIScalingH, 256 * UIScalingW, tall - 300 * UIScalingH)

	surface.SetDrawColor(0, 50, 255, 255)
	surface.DrawOutlinedRect(32 * UIScalingW, 138 * UIScalingH, 256 * UIScalingW, tall - 300 * UIScalingH)

	surface.SetDrawColor(0, 255, 0, 255)
	surface.DrawOutlinedRect(wide - 288 * UIScalingW, 138 * UIScalingH, 256 * UIScalingW, tall - 300 * UIScalingH)

	draw.DrawText("Zombie Survival", "HUDFontBig", wide * 0.5, 0, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
	surface.SetFont("HUDFontBig")
	local gmw, gmh = surface.GetTextSize("Zombie Survival")
	draw.DrawText("("..GAMEMODE.Version.." "..GAMEMODE.SubVersion..")", "DefaultSmallScaled", gmw, gmh - 10 * UIScalingH, COLOR_GRAY, TEXT_ALIGN_LEFT)
	draw.DrawText(TruncateText(GetGlobalString("servername"), 36), "HUDFont2", wide * 0.5, gmh + 10 * UIScalingH, COLOR_GRAY, TEXT_ALIGN_CENTER)

	local colHuman = team.GetColor(TEAM_HUMAN)
	local colUndead = team.GetColor(TEAM_UNDEAD)

	local HumanPlayers = team.GetPlayers(TEAM_HUMAN)
	local UndeadPlayers = team.GetPlayers(TEAM_UNDEAD)

	table.sort(HumanPlayers, SortFunc)
	table.sort(UndeadPlayers, SortFunc)

	local y = 142 * UIScalingH
	local x = wide - 288 * UIScalingW

	draw.DrawText("Survivor", "DefaultScaled", 34 * UIScalingW, 126 * UIScalingH, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Kills", "DefaultScaled", 192 * UIScalingW, 126 * UIScalingH, color_white, TEXT_ALIGN_RIGHT)
	draw.DrawText("Ping", "DefaultScaled", 284 * UIScalingW, 126 * UIScalingH, color_white, TEXT_ALIGN_RIGHT)

	draw.DrawText("Zombie", "DefaultScaled", x + 2 * UIScalingW, 126 * UIScalingH, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Brains Eaten", "DefaultScaled", x + 192 * UIScalingW, 126 * UIScalingH, color_white, TEXT_ALIGN_RIGHT)
	draw.DrawText("Ping", "DefaultScaled", x + 254 * UIScalingW, 126 * UIScalingH, color_white, TEXT_ALIGN_RIGHT)

	surface.SetFont("DefaultScaled")
	local width, height = surface.GetTextSize("Q")

	for i, ply in ipairs(HumanPlayers) do
		if y >= tall - 285 * UIScalingH then
			draw.DrawText("...", "DefaultScaled", 34 * UIScalingW, y, colHuman, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(ply:Name(), "DefaultScaled", 34 * UIScalingW, y, colHuman, TEXT_ALIGN_LEFT)
			draw.DrawText(ply:Frags(), "DefaultScaled", 192 * UIScalingW, y, colHuman, TEXT_ALIGN_CENTER)
			draw.DrawText(ply:Ping(), "DefaultScaled", 286 * UIScalingW, y, colHuman, TEXT_ALIGN_RIGHT)
			y = y + height
		end
	end

	y = 142 * UIScalingH

	for i, ply in ipairs(UndeadPlayers) do
		if y >= tall - 285 * UIScalingH then
			draw.DrawText("...", "DefaultScaled", x + 2 * UIScalingW, y, colUndead, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(ply:Name(), "DefaultScaled", x + 2 * UIScalingW, y, colUndead, TEXT_ALIGN_LEFT)
			draw.DrawText(ply:Frags(), "DefaultScaled", x + 192 * UIScalingW, y, colUndead, TEXT_ALIGN_CENTER)
			draw.DrawText(ply:Ping(), "DefaultScaled", x + 254 * UIScalingW, y, colUndead, TEXT_ALIGN_RIGHT)
			y = y + height
		end
	end

	local y = tall - 155 * UIScalingH
	draw.DrawText("F1:  Help", "HUDFontSmallAA", 28 * UIScalingW, y, COLOR_RED, TEXT_ALIGN_LEFT)
	local tw, th = surface.GetTextSize("F1:  Help")
	y = y + th + 5 * UIScalingH
	draw.DrawText("F2: Manual redeem", "HUDFontSmallAA", 32 * UIScalingW, y, COLOR_GRAY, TEXT_ALIGN_LEFT)
	y = y + th + 5 * UIScalingH
	draw.DrawText("F3: Change Zombie class", "HUDFontSmallAA", 32 * UIScalingW, y, COLOR_GRAY, TEXT_ALIGN_LEFT)
	y = y + th + 5 * UIScalingH
	draw.DrawText("F4: Options", "HUDFontSmallAA", 32 * UIScalingW, y, COLOR_GRAY, TEXT_ALIGN_LEFT)

	return true
end

function PANEL:PerformLayout()
	local UIScalingW, UIScalingH, smoothingFactor = GetUIScale()
	
	self:SetSize(640 * UIScalingW, h * 0.95 * smoothingFactor)

	self:SetPos((w - self:GetWide()) * 0.5, (h - self:GetTall()) * 0.5)
end
vgui.Register("ScoreBoard", PANEL, "Panel")
