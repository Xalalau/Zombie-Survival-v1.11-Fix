local texGradient = surface.GetTextureID("gui/center_gradient")

local function SortFunc(a, b)
	return a:Frags() > b:Frags()
end

local PANEL = {}
function PANEL:Paint()
	local pl = self.Player
	if pl:IsValid() then
		local col
		if self.Selected then col = color_white else col = team.GetColor(pl:Team()) end
		draw.DrawText(pl:Name(), "Default", 0, 0, col, TEXT_ALIGN_LEFT)
		draw.DrawText(pl:Frags(), "Default", 158, 0, col, TEXT_ALIGN_CENTER)
		draw.DrawText(pl:Ping(), "Default", 252, 0, col, TEXT_ALIGN_RIGHT)
	else
		self:Remove()
	end

	return true
end

function PANEL:DoClick()
	local player = self.Player
	if player:IsValid() then
		--[[GAMEMODE:ScoreboardHide()
		surface.PlaySound("buttons/button14.wav")
		MySelf:ConCommand("-showscores")
		NDB.CreateProfile(player)]]
		NDB.GeneralPlayerMenu(player, true)
	end
end
vgui.Register("PlayerPanel", PANEL, "Button")

local PANEL = {}

function PANEL:Init()
	self.Elements = {}
	SCOREBOARD = self
	self.NextRefresh = CurTime() + 0.25
end

function PANEL:ElementRefresh()
	for _, element in pairs(self.Elements) do element:Remove() end
	self.Elements = {}

	local tall, wide = self:GetTall(), self:GetWide()

	local HumanPlayers = team.GetPlayers(TEAM_HUMAN)
	local UndeadPlayers = team.GetPlayers(TEAM_UNDEAD)

	table.sort(HumanPlayers, SortFunc)
	table.sort(UndeadPlayers, SortFunc)

	local y = 132

	surface.SetFont("Default")
	local width, height = surface.GetTextSize("Q")

	for i, pl in ipairs(HumanPlayers) do
		if y >= tall - 285 then
			break
		else
			local pan = vgui.Create("PlayerPanel", self)
			pan:SetSize(252, height)
			pan:SetPos(34, y)
			pan.Player = pl
			table.insert(self.Elements, pan)

			y = y + height
		end
	end

	y = 132
	local x = wide - 286

	for i, pl in ipairs(UndeadPlayers) do
		if y >= tall - 285 then
			break
		else
			local pan = vgui.Create("PlayerPanel", self)
			pan:SetSize(252, height)
			pan:SetPos(x, y)
			pan.Player = pl
			table.insert(self.Elements, pan)

			y = y + height
		end
	end
end

local colBackground = Color(40, 50, 40, 255)
function PANEL:Paint()
	if self.NextRefresh and self.NextRefresh < CurTime() then
		self.NextRefresh = nil
		self:ElementRefresh()
	end

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
	draw.DrawText("(v"..string.format("%.2f", GAMEMODE.Version).." "..GAMEMODE.SubVersion..")", "DefaultSmall", wide * 0.5 + gmw * 0.5 + 8, gmh - 20, COLOR_GRAY, TEXT_ALIGN_LEFT)
	draw.DrawText(GetGlobalString("servername"), "HUDFont2", wide * 0.5, gmh, COLOR_GRAY, TEXT_ALIGN_CENTER)

	local y = 132
	local x = wide - 288

	draw.DrawText("Survivor", "Default", 34, 116, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Kills", "Default", 192, 116, color_white, TEXT_ALIGN_RIGHT)
	draw.DrawText("Ping", "Default", 284, 116, color_white, TEXT_ALIGN_RIGHT)

	draw.DrawText("Zombie", "Default", x + 2, 116, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Brains Eaten", "Default", x + 192, 116, color_white, TEXT_ALIGN_RIGHT)
	draw.DrawText("Ping", "Default", x + 254, 116, color_white, TEXT_ALIGN_RIGHT)

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
