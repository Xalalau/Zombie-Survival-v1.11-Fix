--[[
// I really want to redo all of this.

surface.CreateFont("frosty", 32, 200, true, false, "noxnetbig")
surface.CreateFont("akbar", 24, 500, true, false, "noxnetnormal")

local texGradient = surface.GetTextureID("gui/center_gradient")

local PANEL = {}

function PANEL:Init()
	SCOREBOARD = self
	self.Mode = 1
	self.Modes = {"Players", "Classes", "Help", "$$$"}
	self.ClassButtons = {}
	self.Buttons = {}
	self.ViewPlayer = Entity(0)
	self.HoldingPlayer = Entity(0)
	self.HoldingTime = 0
	for i=1, #self.Modes do
		self.Buttons[i] = {}
	end
end

function PANEL:Paint()
	draw.RoundedBox(16, 0, 0, self:GetWide(), self:GetTall(), color_black)

	draw.SimpleText("Zombie Survival - "..GAMEMODE.Version, "noxnetbig", self:GetWide() * 0.5, self:GetTall() * 0.01, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.Modes[self.Mode], "noxnetnormal", self:GetWide() * 0.5, self:GetTall() * 0.04, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
	surface.SetTexture(texGradient)
	surface.SetDrawColor(255, 255, 255, 50)
	surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall()) 

	if self.Mode == 1 then
		local y = self:GetTall() * 0.1
		local x = self:GetWide() * 0.1
		local x2 = x + self:GetWide() * 0.4
		local x3 = x + self:GetWide() * 0.7

		local PlayerSorted = {}
		for _, ply in ipairs(player.GetHumans()) do
			if ply:Team() == TEAM_HUMAN then
				table.insert(PlayerSorted, ply)
			end
		end

		table.sort(PlayerSorted, function (a, b) return a:Frags() > b:Frags() end)

		local PlayerSorted2 = {}
		for _, ply in ipairs(player.GetHumans()) do
			if ply:Team() == TEAM_UNDEAD then
				table.insert(PlayerSorted2, ply)
			end
		end

		table.sort(PlayerSorted2, function (a, b) return a:Frags() > b:Frags() end)

		PlayerSorted = table.Add(PlayerSorted, PlayerSorted2)

		if #PlayerSorted > 38 then
			for i=39, #PlayerSorted - 39 do
				table.remove(PlayerSorted, 39)
			end
		end

		draw.SimpleText("Name", "Default", x, y, color_white, TEXT_ALIGN_LEFT)
		draw.SimpleText("K/D", "Default", x2, y, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText("Ping", "Default", x3, y, color_white, TEXT_ALIGN_CENTER)
		local yadding = self:GetTall() * 0.02
		y = y + yadding
		surface.DrawLine(0, y, self:GetWide(), y)
		y = y + yadding
		for i, ply in ipairs(PlayerSorted) do
			local colortouse = team.GetColor(ply:Team())
			if gui.MouseX() < w * 0.4 and gui.MouseX() > w * 0.2 then
				local mousey = gui.MouseY() - h*0.032
				if mousey < y + w*0.004 and mousey > y - w*0.004 then
					local stt = "Opening profile"
					for yy=1, math.random(2, 4) do
						stt = stt.."."
					end
					draw.SimpleText(stt, "DefaultBold", gui.MouseX() - self.PosX + 24, gui.MouseY() - self.PosY, COLOR_RED, TEXT_ALIGN_LEFT)
					colortouse = color_white
					if self.HoldingPlayer ~= ply then
						self.HoldingPlayer = ply
						self.HoldingTime = 0
					end
					self.HoldingTime = self.HoldingTime + FrameTime()
					if self.HoldingTime > 1.1 then
						self.ViewPlayer = ply
						self:SetMode(714)
						surface.PlaySound("buttons/button4.wav")
						self.HoldingPlayer = Entity(0)
						self.HoldingTime = 0
					end
				end
			end
			draw.SimpleText(ply:Name(), "Default", x, y, colortouse, TEXT_ALIGN_LEFT)
			draw.SimpleText(ply:Frags().." / "..ply:Deaths(), "Default", x2, y, colortouse, TEXT_ALIGN_CENTER)
			draw.SimpleText(ply:Ping(), "Default", x3, y, colortouse, TEXT_ALIGN_CENTER)
			y = y + yadding
		end
	elseif self.Mode == 2 then
		local y = self:GetTall() * 0.1
		local x = self:GetWide() * 0.1
		local x22 = self:GetWide() * 0.15
		local x2 = x + self:GetWide() * 0.4

		draw.SimpleText("Class Name", "Default", x, y, color_white, TEXT_ALIGN_LEFT)
		draw.SimpleText("Threshold", "Default", x2, y, color_white, TEXT_ALIGN_CENTER)
		local yadding = self:GetTall() * 0.02
		y = y + yadding
		surface.DrawLine(0, y, self:GetWide(), y)
		y = y + yadding

		for i=1, #ZombieClasses do
			if not ZombieClasses[i].Hidden then
				local colortouse = Color(255, 0, 0, 255)
				local canuse = false
				if INFLICTION >= ZombieClasses[i].Threshold or ZombieClasses[i].Unlocked then
					colortouse = Color(0, 255, 0)
					canuse = true
				end
				draw.SimpleText(ZombieClasses[i].Name, "Default", x, y, colortouse, TEXT_ALIGN_LEFT)
				draw.SimpleText("%"..math.ceil(ZombieClasses[i].Threshold * 100), "DefaultSmall", x2, y, colortouse, TEXT_ALIGN_CENTER)
				local strexp = string.Explode("@", ZombieClasses[i].Description)
				for x=1, #strexp do
					draw.SimpleText(strexp[x], "DefaultSmall", x22, y + x * self:GetTall() * 0.02, colortouse, TEXT_ALIGN_LEFT)
				end
				y = y + self:GetTall() * 0.06
			end
		end
		local xysize = self:GetWide() * 0.05
		y = self:GetTall() * 0.9
		draw.RoundedBox(8, self:GetWide()*0.225, y, xysize, xysize, Color(0, 255, 0))
		draw.SimpleText("Can switch to", "DefaultSmall", self:GetWide()*0.25, y + xysize, color_white, TEXT_ALIGN_CENTER)

		draw.RoundedBox(8, self:GetWide()*0.475, y, xysize, xysize, Color(255, 0, 0))
		draw.SimpleText("Not enough infliction", "DefaultSmall", self:GetWide()*0.5, y + xysize, color_white, TEXT_ALIGN_CENTER)

		draw.RoundedBox(8, self:GetWide()*0.725, y, xysize, xysize, color_white)
		draw.SimpleText("Switch to this class", "DefaultSmall", self:GetWide()*0.75, y + xysize, color_white, TEXT_ALIGN_CENTER)
	elseif self.Mode == 3 then
		// draw.SimpleText("Help section coming soon...", "noxnetnormal", self:GetWide() * 0.5, self:GetTall() * 0.5, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		local x = self:GetWide() * 0.1
		local tall = self:GetTall()
		local y = tall * 0.12
		local touse = HELP_TEXT
		if SURVIVALMODE then
			touse = HELP_TEXT_SURVIVALMODE
		end

		for _, text in ipairs(touse) do
			if string.len(text) <= 1 then
				y = y + tall * 0.02
			else
				local pretext = string.sub(text, 1, 2)
				local colortouse = color_white
				if pretext == "^r" then
					colortouse = COLOR_RED
					text = string.sub(text, 3)
				elseif pretext == "^g" then
					colortouse = COLOR_LIMEGREEN
					text = string.sub(text, 3)
				elseif pretext == "^y" then
					colortouse = COLOR_YELLOW
					text = string.sub(text, 3)
				elseif pretext == "^b" then
					colortouse = COLOR_CYAN
					text = string.sub(text, 3)
				end
				draw.SimpleText(text, "DefaultSmall", x, y, colortouse, TEXT_ALIGN_LEFT)
				y = y + tall * 0.02
			end
		end
		draw.SimpleText("Press TAB (or your scoreboard key) to close this menu.", "DefaultBold", self:GetWide() * 0.5, y + self:GetTall()*0.05, COLOR_RED, TEXT_ALIGN_CENTER)
	elseif self.Mode == 4 then
		local x = self:GetWide() * 0.1
		local tall = self:GetTall()
		local y = tall * 0.12
		draw.SimpleText("You can donate money to the server for donation gifts.", "Default", self:GetWide() * 0.5, y, color_white, TEXT_ALIGN_CENTER)
		y = y + tall * 0.05
		draw.SimpleText("You can donate $1 for 30,000 in game Silver, $5 for Gold Member, or $17 for the elite Diamond Member package.", "DefaultSmall", x, y, color_white, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("All donations are duplicated for GMod9 and GMod10; Gold Member on GM9 is good on GM10 as well!", "DefaultSmall", x, y, color_white, TEXT_ALIGN_LEFT)
		y = y + tall * 0.04
		surface.SetDrawColor(255, 255, 255, 190)
		surface.DrawLine(0, y, self:GetWide() * 0.9, y)
		y = y + tall * 0.04
		draw.SimpleText("Gold Member, $5 for life-time ticket:", "Default", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.03
		draw.SimpleText("  - A 128(w) x 64(h) custom avatar(you make it, we display it) under your name when people move their mouse over you.", "DefaultSmall", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - 25% increase on all incoming money.", "DefaultSmall", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - 2 votes per votemap.", "DefaultSmall", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - Account suspensions (bans) can not be more than 48 hours.", "DefaultSmall", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - AFK-kicker immunity.", "DefaultSmall", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - Gold Members automatically get permanent building rights in our clique build server.", "DefaultSmall", x, y, COLOR_GOLD, TEXT_ALIGN_LEFT)
		y = y + tall * 0.04
		surface.SetDrawColor(255, 255, 255, 190)
		surface.DrawLine(0, y, self:GetWide(), y)
		y = y + tall * 0.04
		draw.SimpleText("Diamond Member, $17 for life-time ticket:", "Default", x, y, COLOR_DIAMOND, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - INCLUDES ALL GOLD MEMBER FEATURES.", "DefaultSmall", x, y, COLOR_DIAMOND, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - Reserved slots on all GM10 servers. Never wait in line again.", "DefaultSmall", x, y, COLOR_DIAMOND, TEXT_ALIGN_LEFT)
		y = y + tall * 0.02
		draw.SimpleText("  - Never-ending amount of money on GM9 servers as well as GM10 servers!! THIS IS YOUR ALL-ACCESS PASS TO NN!", "DefaultSmall", x, y, COLOR_DIAMOND, TEXT_ALIGN_LEFT)
		y = y + tall * 0.07
		surface.SetDrawColor(255, 255, 255, 190)
		surface.DrawLine(0, y, self:GetWide(), y)
		y = y + tall * 0.01
		draw.SimpleText("See our donations page at www.noxiousnet.com for more info.", "noxnetnormal", self:GetWide() * 0.5, y, Color(255, 0, 0), TEXT_ALIGN_CENTER)
	elseif self.Mode == 714 then
		local player = self.ViewPlayer
		if player:IsValid() and player:IsPlayer() then
			if player:IsSuperAdmin() then
				draw.SimpleText(player:Name(), "DefaultBold", self:GetWide() * 0.05, self:GetTall() * 0.1, COLOR_RED, TEXT_ALIGN_LEFT)
				draw.SimpleText("(The Big Cheese) ("..player.Title..")", "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.12, COLOR_RED, TEXT_ALIGN_LEFT)
				draw.SimpleText("Account #: "..player.SteamID, "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.1375, color_white, TEXT_ALIGN_LEFT)
			elseif player:IsAdmin() then
				draw.SimpleText(player:Name(), "DefaultBold", self:GetWide() * 0.05, self:GetTall() * 0.1, COLOR_LIMEGREEN, TEXT_ALIGN_LEFT)
				draw.SimpleText("(NoX Admins) ("..player.Title..")", "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.12, COLOR_LIMEGREEN, TEXT_ALIGN_LEFT)
				draw.SimpleText("Account #: "..player.SteamID, "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.1375, color_white, TEXT_ALIGN_LEFT)
			elseif player.Title ~= "None" then
				draw.SimpleText(player:Name(), "DefaultBold", self:GetWide() * 0.05, self:GetTall() * 0.1, color_white, TEXT_ALIGN_LEFT)
				draw.SimpleText("("..player.Title..")", "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.12, color_white, TEXT_ALIGN_LEFT)
				draw.SimpleText("Account #: "..player.SteamID, "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.1375, color_white, TEXT_ALIGN_LEFT)
			else
				draw.SimpleText(player:Name(), "DefaultBold", self:GetWide() * 0.05, self:GetTall() * 0.1, color_white, TEXT_ALIGN_LEFT)
				draw.SimpleText("Account #: "..player.SteamID, "DefaultSmall", self:GetWide() * 0.07, self:GetTall() * 0.1275, color_white, TEXT_ALIGN_LEFT)
			end

			draw.SimpleText("Awards", "DefaultBold", self:GetWide() * 0.5, self:GetTall() * 0.47, COLOR_GOLD, TEXT_ALIGN_CENTER)
		else
			self:SetMode(1)
		end
	else
		draw.SimpleText("Welcome to the hidden tab, lololol.", "noxnetnormal", self:GetWide() * 0.5, self:GetTall() * 0.5, Color(255, 0, 0), TEXT_ALIGN_CENTER)
	end
end

function PANEL:PerformLayout()
	self:SetSize(640, h * 0.95)
	self.PosX = (w - self:GetWide()) * 0.5
	self.PosY = (h - self:GetTall()) *0.5
	self:SetPos(self.PosX, self.PosY)
	for i=1, #self.Modes do
		local button = vgui.Create("ScoreboardTab", self)
		button.Mode = i
		button.Text = self.Modes[i]
		button:SetPos(self:GetWide() * 0.93, self:GetTall() * 0.05 + i * self:GetTall() * 0.04)
		button:SetSize(self:GetWide() * 0.07, self:GetTall() * 0.04)
	end
	self.Modes[714] = "Profile"
	self.Buttons[714] = {}
end

function PANEL:SpawnButtons()
	self:SetKeyboardInputEnabled(false)
	if self.Mode == 2 then
		local x = 1
		for i=1, #ZombieClasses do
			if not ZombieClasses[i].Hidden then
				local button = vgui.Create("ClassButton", self)
				button.Class = i
				button:SetPos(self:GetWide() * 0.02, self:GetTall() * 0.08 + self:GetTall() * x * 0.06)
				button:SetSize(self:GetWide() * 0.05, self:GetWide() * 0.05)
				table.insert(self.Buttons[self.Mode], button)
				x = x + 1
			end
		end
	elseif self.Mode == 714 then
		local player = self.ViewPlayer
		if player:IsValid() and player:IsPlayer() then
			local x = self:GetWide() * 0.02
			local y = self:GetTall() * 0.5
			if player.SteamID then
				local awardshtml = vgui.Create("HTML", self)
				awardshtml:SetPos(x, y)
				awardshtml:SetSize(self:GetWide() - self:GetWide() * 0.04, self:GetTall() * 0.48)
				awardshtml:OpenURL("http://www.noxiousnet.com/awardviewer.php?steamid="..player.SteamID)
				table.insert(self.Buttons[self.Mode], awardshtml)

				local avatarhtml = vgui.Create("HTML", self)
				avatarhtml:SetPos(self:GetWide() * 0.5 - 64, self:GetTall() * 0.1)
				avatarhtml:SetSize(256, 128)
				avatarhtml:OpenURL("http://www.noxiousnet.com/avatarviewer.php?steamid="..player.SteamID)
				table.insert(self.Buttons[self.Mode], avatarhtml)
			end
		end
	end
end

function PANEL:SetMode(mode)
	for i, button in pairs(self.Buttons[self.Mode]) do
		button:Remove()
	end
	self.Mode = mode
	self.Buttons[mode] = {}
	self:SpawnButtons()
end
vgui.Register("ScoreBoard", PANEL, "Panel")


PANEL = {}
function PANEL:DoClick()
	if self:GetParent().Mode == self.Mode then return end
	self:GetParent():SetMode(self.Mode)
	surface.PlaySound("buttons/lever8.wav")
end
function PANEL:Paint()
	local bgColor = Color(120, 120, 120, 100)
	local fgColor = color_white
	if self:GetParent().Mode == self.Mode then
		bgColor = Color(255, 0, 0, 200)
		fgColor = color_black
	elseif self.Selected then
		bgColor = Color(255, 255, 0, 200)
		fgColor = color_black
	elseif self.Armed then
		bgColor = Color(200, 100, 10, 200)
		fgColor = color_black
	end

	draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), bgColor)
	draw.SimpleText(self.Text, "Default", self:GetWide() / 2, self:GetTall() / 2, fgColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	return true
end
vgui.Register("ScoreboardTab", PANEL, "Button")


PANEL = {}
function PANEL:DoClick()
	local ply = LocalPlayer()
	if (INFLICTION < ZombieClasses[self.Class].Threshold and not ZombieClasses[self.Class].Unlocked)or ply:Team() ~= TEAM_UNDEAD then return end
	ply:ConCommand("zs_class "..ZombieClasses[self.Class].Name.."\n")
	surface.PlaySound("buttons/button1.wav")
end
function PANEL:Paint()
	local bgColor = Color(255, 0, 0, 200)
	if INFLICTION >= ZombieClasses[self.Class].Threshold or ZombieClasses[self.Class].Unlocked then
		bgColor = Color(0, 255, 0, 200)
		if self.Selected or self.Armed then
			bgColor = color_white
		end
	end
	draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), bgColor)
	return true
end
vgui.Register("ClassButton", PANEL, "Button")

PANEL = {}
function PANEL:DoClick()
	self.LastPress = self.LastPress or CurTime() - 15
	if CurTime() < self.LastPress + 15 then return end
	self.LastPress = CurTime()
	LocalPlayer():ConCommand("~~~REQUEST_BAN_LIST\n")
	surface.PlaySound("buttons/button1.wav")
end
function PANEL:Paint()
	local bgColor = color_white
	if self.Selected or self.Armed then
		bgColor = Color(255, 0, 0)
	end
	draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), bgColor)
	draw.SimpleText("Refresh", "Default", self:GetWide() / 2, self:GetTall() / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	return true
end
vgui.Register("BanListRefreshButton", PANEL, "Button")
--]]