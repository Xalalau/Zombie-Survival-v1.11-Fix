MySelf = NULL
hook.Add("Think", "GetLocal", function()
	MySelf = LocalPlayer()
	if MySelf:IsValid() then
		MYSELFVALID = true
		MySelf.Money = MySelf.Money or 0
		RunConsoleCommand("PostPlayerInitialSpawn")
		hook.Remove("Think", "GetLocal")
	end
end)

GM.RewardIcons = {}

include("shared.lua")
include("cl_scoreboard.lua")
include("cl_targetid.lua")
include("cl_hudpickup.lua")
include("cl_spawnmenu.lua")
include("cl_postprocess.lua")
include("cl_beats.lua")
include("cl_splitmessage.lua")
include("vgui/poptions.lua")
include("vgui/phelp.lua")
include("vgui/pclasses.lua")
include("vgui/pweapons.lua")
include("cl_dermaskin.lua")

for i, filename in ipairs(file.FindInLua("zombieclasses")) do
	include("zombieclasses/"..filename)
end

if not killicon.GetFont then -- Need this for the rewards message.
	local kiaf = killicon.AddFont
	local storedfonts = {}
	function killicon.AddFont(sClass, sFont, sLetter, cColor)
		storedfonts[sClass] = {font=sFont, letter=sLetter}
		kiaf(sClass, sFont, sLetter, cColor)
	end

	function killicon.GetFont(sClass)
		return storedfonts[sClass]
	end
end

include("cl_deathnotice.lua")

util.PrecacheSound(LASTHUMANSOUND)
util.PrecacheSound(UNLIFESOUND)

-- A bunch of colors we'll need.
color_white = Color(255, 255, 255, 220)
color_black = Color(50, 50, 50, 255)
color_black_alpha180 = Color(0, 0, 0, 180)
color_black_alpha90 = Color(0, 0, 0, 90)
color_white_alpha200 = Color(255, 255, 255, 200)
color_white_alpha180 = Color(255, 255, 255, 180)
color_white_alpha90 = Color(255, 255, 255, 90)
COLOR_INFLICTION = Color(235, 185, 0, 165)
COLOR_DARKBLUE = Color(5, 75, 150, 255)
COLOR_DARKGREEN = Color(0, 150, 0, 255)
COLOR_DARKRED = Color(185, 0, 0, 255)
COLOR_DARKRED_HUD = Color(185, 0, 0, 180)
COLOR_DARKCYAN = Color(0, 155, 155, 255)
COLOR_DARKCYAN_HUD = Color(0, 155, 155, 180)
COLOR_GRAY = Color(190, 190, 190, 255)
COLOR_GRAY_HUD = Color(190, 190, 190, 180)
COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255)
COLOR_BLACK = Color(0, 0, 0)

local LastMoney = 0
local LastMoneyDraw = 0
local LastMoneyEnd = 0
function DrawNoXNetBox()
	if not MYSELFVALID then return end

	draw.RoundedBox(8, 2, NOXNETBOX_START, NOXNETBOX_WIDTH, NOXNETBOX_HEIGHT, color_black_alpha90)
	draw.DrawText("NN Account", "noxnet", NOXNETBOX_WIDTH * 0.5, NOXNETBOX_LINE1, COLOR_DARKGREEN, TEXT_ALIGN_CENTER)
	draw.DrawText("Silver: "..MySelf.Money, "HUDFontTinyAA", 8, NOXNETBOX_LINE2, COLOR_GRAY, TEXT_ALIGN_LEFT)
	local jetanium = MySelf:GetJetanium()
	if 0 < jetanium then
		draw.DrawText("Jetanium: "..jetanium, "HUDFontTinyAA", 8, NOXNETBOX_LINE3, COLOR_GRAY, TEXT_ALIGN_LEFT)
	end

	local ct = CurTime()
	if MySelf.Money ~= LastMoney then
		if ct < LastMoneyEnd then
			LastMoneyDraw = LastMoneyDraw + (MySelf.Money - LastMoney)
		else
			LastMoneyDraw = MySelf.Money - LastMoney
		end

		LastMoney = MySelf.Money
		LastMoneyEnd = ct + 5
	end

	if CurTime() < LastMoneyEnd and LastMoneyDraw ~= 0 then
		if 0 < LastMoneyDraw then
			surface.SetFont("noxnet")
			surface.SetTextPos(48, NOXNETBOX_LINE4)
			surface.SetTextColor(20, 255, 20, math.min(255, (LastMoneyEnd - ct) * 200))
			surface.DrawText(" + " .. LastMoneyDraw)
		else
			surface.SetFont("noxnet")
			surface.SetTextPos(48, NOXNETBOX_LINE4)
			surface.SetTextColor(255, 20, 20, math.min(255, (LastMoneyEnd - ct) * 200))
			surface.DrawText(" - " .. LastMoneyDraw * -1)
		end
	end
end

function CheckDiamondGold()
	if MySelf.DiamondMember then
		function DrawNoXNetBox()
			if not MYSELFVALID then return end
			draw.RoundedBox(8, 2, NOXNETBOX_START, NOXNETBOX_WIDTH, NOXNETBOX_HEIGHT, color_black_alpha90)
			draw.DrawText("NN Account", "noxnet", NOXNETBOX_WIDTH * 0.5, NOXNETBOX_LINE1, COLOR_DARKGREEN, TEXT_ALIGN_CENTER)
			draw.DrawText("Infinite Silver", "HUDFontTinyAA", 8, NOXNETBOX_LINE2, COLOR_GRAY, TEXT_ALIGN_LEFT)
			local jetanium = MySelf:GetJetanium()
			if 0 < jetanium then
				draw.DrawText("Jetanium: "..jetanium, "HUDFontTinyAA", 8, NOXNETBOX_LINE3, COLOR_GRAY, TEXT_ALIGN_LEFT)
			end
			draw.DrawText("[D]", "HUDFontTinyAA", 2, NOXNETBOX_LINE4, COLOR_GRAY, TEXT_ALIGN_LEFT)
		end
	elseif MySelf.SubDiamondMember then
		function DrawNoXNetBox()
			if not MYSELFVALID then return end
			draw.RoundedBox(8, 2, NOXNETBOX_START, NOXNETBOX_WIDTH, NOXNETBOX_HEIGHT, color_black_alpha90)
			draw.DrawText("NN Account", "noxnet", NOXNETBOX_WIDTH * 0.5, NOXNETBOX_LINE1, COLOR_DARKGREEN, TEXT_ALIGN_CENTER)
			draw.DrawText("Silver: "..MySelf.Money, "HUDFontTinyAA", 8, NOXNETBOX_LINE2, COLOR_GRAY, TEXT_ALIGN_LEFT)
			local jetanium = MySelf:GetJetanium()
			if 0 < jetanium then
				draw.DrawText("Jetanium: "..jetanium, "HUDFontTinyAA", 8, NOXNETBOX_LINE3, COLOR_GRAY, TEXT_ALIGN_LEFT)
			end
			draw.DrawText("[D]", "DefaultSmall", 2, NOXNETBOX_LINE4, COLOR_GRAY, TEXT_ALIGN_LEFT)

			local ct = CurTime()
			if MySelf.Money ~= LastMoney then
				if ct < LastMoneyEnd then
					LastMoneyDraw = LastMoneyDraw + (MySelf.Money - LastMoney)
				else
					LastMoneyDraw = MySelf.Money - LastMoney
				end

				LastMoney = MySelf.Money
				LastMoneyEnd = ct + 5
			end

			if CurTime() < LastMoneyEnd and LastMoneyDraw ~= 0 then
				if 0 < LastMoneyDraw then
					surface.SetFont("noxnet")
					surface.SetTextPos(48, NOXNETBOX_LINE4)
					surface.SetTextColor(20, 255, 20, math.min(255, (LastMoneyEnd - ct) * 200))
					surface.DrawText(" + " .. LastMoneyDraw)
				else
					surface.SetFont("noxnet")
					surface.SetTextPos(48, NOXNETBOX_LINE4)
					surface.SetTextColor(255, 20, 20, math.min(255, (LastMoneyEnd - ct) * 200))
					surface.DrawText(" - " .. LastMoneyDraw * -1)
				end
			end
		end
	elseif MySelf.GoldMember then
		function DrawNoXNetBox()
			if not MYSELFVALID then return end
			draw.RoundedBox(8, 2, NOXNETBOX_START, NOXNETBOX_WIDTH, NOXNETBOX_HEIGHT, color_black_alpha90)
			draw.DrawText("NN Account", "noxnet", NOXNETBOX_WIDTH * 0.5, NOXNETBOX_LINE1, COLOR_DARKGREEN, TEXT_ALIGN_CENTER)
			draw.DrawText("Silver: "..MySelf.Money, "HUDFontTinyAA", 8, NOXNETBOX_LINE2, COLOR_GRAY, TEXT_ALIGN_LEFT)
			local jetanium = MySelf:GetJetanium()
			if 0 < jetanium then
				draw.DrawText("Jetanium: "..jetanium, "HUDFontTinyAA", 8, NOXNETBOX_LINE3, COLOR_GRAY, TEXT_ALIGN_LEFT)
			end
			draw.DrawText("[G]", "DefaultSmall", 2, NOXNETBOX_LINE4, COLOR_YELLOW, TEXT_ALIGN_LEFT)

			local ct = CurTime()
			if MySelf.Money ~= LastMoney then
				if ct < LastMoneyEnd then
					LastMoneyDraw = LastMoneyDraw + (MySelf.Money - LastMoney)
				else
					LastMoneyDraw = MySelf.Money - LastMoney
				end

				LastMoney = MySelf.Money
				LastMoneyEnd = ct + 5
			end

			if CurTime() < LastMoneyEnd and LastMoneyDraw ~= 0 then
				if 0 < LastMoneyDraw then
					surface.SetFont("noxnet")
					surface.SetTextPos(48, NOXNETBOX_LINE4)
					surface.SetTextColor(20, 255, 20, math.min(255, (LastMoneyEnd - ct) * 200))
					surface.DrawText(" + " .. LastMoneyDraw)
				else
					surface.SetFont("noxnet")
					surface.SetTextPos(48, NOXNETBOX_LINE4)
					surface.SetTextColor(255, 20, 20, math.min(255, (LastMoneyEnd - ct) * 200))
					surface.DrawText(" - " .. LastMoneyDraw * -1)
				end
			end
		end
	end
end

ENDTIME = 0

NearZombies = 0
ActualNearZombies = 0

local Top = {}
local TopZ = {}
local TopZD = {}
local TopHD = {}

w, h = ScrW(), ScrH()

local matHumanHeadID = surface.GetTextureID("humanhead")
local matZomboHeadID = surface.GetTextureID("zombohead")

function GetZombieFocus2(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, pl in pairs(player.GetAll()) do
		if pl ~= MySelf and pl:Team() == TEAM_UNDEAD and pl:Alive() then
			local dist = pl:GetPos():Distance(mypos)
			if dist < range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	return math.min(zombies, 1)
end

function GM:Initialize()
	self.ShowScoreboard = false

	surface.CreateFont("coolvetica", 48, 500, true, false, "ScoreboardHead")
	surface.CreateFont("coolvetica", 24, 500, true, false, "ScoreboardSub")
	surface.CreateFont("Tahoma", 16, 1000, true, false, "ScoreboardText")

	surface.CreateFont("csd", 42, 500, true, true, "Signs")
	surface.CreateFont("csd", ScreenScale(30), 200, true, true, "HUDIcons")

	surface.CreateFont("anthem", 16, 250, false, true, "HUDFontTiny")
	surface.CreateFont("anthem", 28, 400, false, true, "HUDFontSmall")
	surface.CreateFont("anthem", 42, 400, false, true, "HUDFont")
	surface.CreateFont("anthem", 72, 400, false, true, "HUDFontBig")
	surface.CreateFont("anthem", 16, 250, true, true, "HUDFontTinyAA")
	surface.CreateFont("anthem", 28, 400, true, true, "HUDFontSmallAA")
	surface.CreateFont("anthem", 42, 400, true, true, "HUDFontAA")
	surface.CreateFont("anthem", 72, 400, true, true, "HUDFontBigAA")

	surface.CreateFont("akbar", 16, 250, true, true, "HUDFontTiny2")
	surface.CreateFont("akbar", 28, 500, true, true, "HUDFontSmall2")
	surface.CreateFont("akbar", 42, 500, true, true, "HUDFont2")
	surface.CreateFont("akbar", 72, 500, true, true, "HUDFontBig2")

	surface.CreateFont("frosty", 32, 200, false, true, "noxnetbig")
	surface.CreateFont("akbar", 24, 500, true, false, "noxnetnormal")

	RunConsoleCommand("r_decals", 200)

	self:SplitMessage(h * 0.6, "<color=ltred><font=HUDFontAA>Zombie Survival</font></color>")
end

function GM:GetLivingZombies()
	local tab = {}

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD and 0.500001 <= pl:Health() then
			table.insert(tab, pl)
		end
	end

	self.LivingZombies = #tab
	return tab
end

function GM:NumLivingZombies()
	return #self:GetLivingZombies()
end

function GM:PlayerDeath(pl, attacker)
end

usermessage.Hook("recranfirstzom", function(um)
	GAMEMODE:SplitMessage(h * 0.7, "<color=red><font=HUDFontAA>You have been randomly chosen to lead the Undead army!</font></color>")
end)

usermessage.Hook("recvolfirstzom", function(um)
	GAMEMODE:SplitMessage(h * 0.7, "<color=red><font=HUDFontAA>You have volunteered to lead the Undead army!</font></color>")
end)

local cv_ShouldPlayMusic = CreateClientConVar("zs_playmusic", 1, true, false)
local function LoopLastHuman()
	if not ENDROUND then
		if cv_ShouldPlayMusic:GetBool() then
			surface.PlaySound(LASTHUMANSOUND)
		end
		timer.Simple(LASTHUMANSOUNDLENGTH, LoopLastHuman)
	end
end

local function DelayedLH()
	local MySelf = LocalPlayer()

	if not ENDROUND then
		if MySelf:Team() == TEAM_UNDEAD or not MySelf:Alive() then
			GAMEMODE:SplitMessage(h * 0.7, "<color=red><font=HUDFontAA>Kill the Last Human!</font></color>")
		else
			GAMEMODE:SplitMessage(h * 0.7, "<color=ltred><font=HUDFontAA>You are the Last Human!</font></color>", "<color=red><font=HUDFontAA>RUN!</font></color>")
		end
	end
end

function GM:LastHuman()
	if LASTHUMAN then return end

	LASTHUMAN = true
	RunConsoleCommand("stopsounds")
	timer.Simple(0.5, LoopLastHuman)
	DrawingDanger = 1
	timer.Simple(0.5, DelayedLH)
	GAMEMODE:SetLastHumanText()
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.Alive then
		return pl:Team() ~= attacker:Team() or pl == attacker
	end
	return true
end

function GM:HUDShouldDraw(name)
	if MYSELFVALID then
		local wep = MySelf:GetActiveWeapon()
		if wep.HUDShouldDraw then return wep:HUDShouldDraw(name) end
	end

	return name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudSecondaryAmmo"
end

usermessage.Hook("RcTopTimes", function(um)
	local index = um:ReadShort()
	Top[index] = um:ReadString()
	if Top[index] == "Downloading" or Top[index] == "[STRING NOT POOLED]" then
		Top[index] = nil
	else
		Top[index] = index..". "..Top[index]
	end
end)

usermessage.Hook("RcTopZombies", function(um)
	local index = um:ReadShort()
	TopZ[index] = um:ReadString()
	if TopZ[index] == "Downloading" or TopZ[index] == "[STRING NOT POOLED]" then
		TopZ[index] = nil
	else
		TopZ[index] = index..". "..TopZ[index]
	end
end)

usermessage.Hook("RcTopHumanDamages", function(um)
	local index = um:ReadShort()
	TopHD[index] = um:ReadString()
	if TopHD[index] == "Downloading" or TopHD[index] == "[STRING NOT POOLED]" then
		TopHD[index] = nil
	else
		TopHD[index] = index..". "..TopHD[index]
	end
end)

usermessage.Hook("RcTopZombieDamages", function(um)
	local index = um:ReadShort()
	TopZD[index] = um:ReadString()
	if TopZD[index] == "Downloading" or TopZD[index] == "[STRING NOT POOLED]" then
		TopZD[index] = nil
	else
		TopZD[index] = index..". "..TopZD[index]
	end
end)

usermessage.Hook("recwavestart", function(um)
	local wave = um:ReadShort()

	GAMEMODE:SetWave(wave)
	GAMEMODE:SetWaveEnd(um:ReadFloat())

	local UnlockedClass
	local amount = 0
	for i, tab in ipairs(GAMEMODE.ZombieClasses) do
		if tab.Wave <= wave and not tab.Unlocked then
			tab.Unlocked = true
			UnlockedClass = tab.Name
			amount = amount + 1
		end
	end

	local msg = "<color=ltred><font=HUDFontAA>Wave "..wave.." has begun!"
	if wave == NUM_WAVES then
		msg = "<color=ltred><font=HUDFontAA>THE FINAL WAVE HAS BEGUN!"
	end

	local secmsg = ""
	if amount == 1 then
		secmsg = "<color=green><font=HUDFontSmallAA>"..UnlockedClass.." unlocked!"
	elseif 1 < amount then
		secmsg = "<color=green><font=HUDFontSmallAA>"..amount.." new zombies unlocked!"
	end

	GAMEMODE:SplitMessage(h * 0.6, msg, secmsg)

	surface.PlaySound("ambient/creatures/town_zombie_call1.wav")
end)

usermessage.Hook("recwaveend", function(um)
	local wave = um:ReadShort()
	GAMEMODE:SetWaveStart(um:ReadFloat())

	if wave < NUM_WAVES then
		GAMEMODE:SplitMessage(h * 0.7, "<color=ltred><font=HUDFontAA>Wave "..wave.." is over!", "<color=white><font=HUDFontSmallAA>The Undead have stopped rising... for now")

		surface.PlaySound("ambient/atmosphere/cave_hit1.wav")
	end
end)

function GM:HUDPaintBackground()
	if pHelp and pHelp:Valid() and pHelp:IsVisible() then -- Time to draw lots of shit.
		surface.SetDrawColor(20, 255, 20, 255)
		surface.DrawLine(64, 32, 128, 200)
		draw.DrawTextShadow("How many Undead players are in the game.", "DefaultBold", 128, 200, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(20, 255, 20, 255)
		surface.DrawLine(64, 64, 128, 230)
		draw.DrawTextShadow("How many living players are in the game.", "DefaultBold", 128, 230, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(20, 255, 20, 255)
		surface.DrawLine(100, h - 48, 100, h - 120)
		draw.DrawTextShadow("Your health.", "DefaultBold", 100, h - 120, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(20, 255, 20, 255)
		surface.DrawLine(256, h - 32, 300, h - 80)
		draw.DrawTextShadow("Horde meter. The higher the bar, the more zombies are near you and the less damage your attacks do.", "DefaultBold", 300, h - 80, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)

		if MySelf:Team() == TEAM_HUMAN then
			surface.SetDrawColor(20, 255, 20, 255)
			surface.DrawLine(64, h - 95, 48, h - 150)
			draw.DrawTextShadow("Time until the next ammo regeneration for your team.", "DefaultBold", 48, h - 150, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		end

		surface.SetFont("HUDFontSmall")
		local tw, th = surface.GetTextSize("Wave 00 out of 00")

		local linx = w * 0.09 + tw + 32

		if 0 < self:GetWave() then
			surface.SetDrawColor(20, 255, 20, 255)
			surface.DrawLine(w * 0.09 + tw, 6, linx, th * 4)
			draw.DrawTextShadow("The current wave. Humans must survive "..NUM_WAVES.." waves to win!", "DefaultBold", linx, th * 4, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		end

		surface.SetDrawColor(20, 255, 20, 255)
		surface.DrawLine(w * 0.09 + tw, th + 6, linx, th * 5)
		if self:GetWave() <= 0 then
			draw.DrawTextShadow("Time until the first wave of zombies.", "DefaultBold", linx, th * 5, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		elseif self:GetFighting() then
			if self:GetWaveEnd() <= CurTime() then
				draw.DrawTextShadow("Zombies that must be killed before the wave is finally over.", "DefaultBold", linx, th * 5, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
			else
				draw.DrawTextShadow("Time remaining until the wave ends and no new zombies can spawn.", "DefaultBold", linx, th * 5, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
			end
		else
			draw.DrawTextShadow("Time until the next wave starts.", "DefaultBold", linx, th * 5, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		end

		surface.SetDrawColor(20, 255, 20, 255)
		surface.DrawLine(w * 0.09 + tw, th * 2 + 6, linx, th * 6)
		if MySelf:Team() == TEAM_HUMAN then
			draw.DrawTextShadow("Amount of zombies you've killed and how many are needed for your next arsenal upgrade.", "DefaultBold", linx, th * 6, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		elseif REDEEM then
			draw.DrawTextShadow("Amount of brains you've eaten and how many are needed to redeem.", "DefaultBold", linx, th * 6, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		else
			draw.DrawTextShadow("Amount of brains you've eaten.", "DefaultBold", linx, th * 6, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		end

		if NDB then
			draw.RoundedBox(8, 2, NOXNETBOX_START, NOXNETBOX_WIDTH, NOXNETBOX_HEIGHT, color_black_alpha90)
			surface.SetDrawColor(20, 255, 20, 255)
			surface.DrawLine(16, NOXNETBOX_START + NOXNETBOX_HEIGHT, 16, NOXNETBOX_START + NOXNETBOX_HEIGHT + 128)
			draw.DrawTextShadow("NoXiousNet account information for all servers.", "DefaultBold", 16, NOXNETBOX_START + NOXNETBOX_HEIGHT + 128, COLOR_LIMEGREEN, color_black, TEXT_ALIGN_LEFT)
		end
	end
end

local nobaby = CreateClientConVar("zs_nobaby", 0, true, false)
local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")
local matUIBottomLeft = surface.GetTextureID("zombiesurvival/zs_ui_bottomleft")
function GM:HUDPaint()
	if not MYSELFVALID then return end

	-- Width, height
	h = ScrH()
	w = ScrW()

	surface.SetDrawColor(170, 170, 170, 255)
	surface.SetTexture(matUIBottomLeft)
	surface.DrawTexturedRect(0, h - 72, 256, 64)

	local myteam = MySelf:Team()

	-- TargetID
	self:HUDDrawTargetID(MySelf, myteam)

	-- Death Notice
	self:DrawDeathNotice(0.8, 0.04)

	-- Team Count
	local zombies = 0
	local humans = 0
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_ZOMBIE then
			zombies = zombies + 1
		else
			humans = humans + 1
		end
	end

	surface.SetFont("HUDFontAA")
	local texw, texh = surface.GetTextSize("64")
	local startx = texw + 64

	surface.SetFont("HUDFontSmallAA")
	local texw2, texh2 = surface.GetTextSize("Prepare your strongholds....")
	draw.RoundedBox(16, 0, 0, 64 + texw + texw2, 102, color_black_alpha90)

	local w05 = w * 0.05
	local h05 = h * 0.05
	surface.SetDrawColor(190, 200, 190, 255)
	surface.SetTexture(matZomboHeadID)
	surface.DrawTexturedRect(0, 0, 48, 48)
	surface.SetTexture(matHumanHeadID)
	surface.DrawTexturedRect(0, 52, 48, 48)
	draw.DrawText(zombies, "HUDFontAA", 52, 0, COLOR_DARKGREEN, TEXT_ALIGN_LEFT)
	draw.DrawText(zombies, "HUDFontAA", 52, 0, COLOR_DARKGREEN, TEXT_ALIGN_LEFT)
	draw.DrawText(humans, "HUDFontAA", 52, 52, COLOR_DARKBLUE, TEXT_ALIGN_LEFT)
	draw.DrawText(humans, "HUDFontAA", 52, 52, COLOR_DARKBLUE, TEXT_ALIGN_LEFT)

	local curwav = self:GetWave()
	if curwav <= 0 then
		draw.DrawText("Prepare your strongholds...", "HUDFontSmallAA", startx, 0, COLOR_GRAY, TEXT_ALIGN_LEFT)
	else
		draw.DrawText("Wave ".. curwav .. " out of ".. NUM_WAVES, "HUDFontSmallAA", startx, 0, COLOR_GRAY, TEXT_ALIGN_LEFT)
	end
	local tw, th = surface.GetTextSize("00:00")
	if curwav <= 0 then
		local timleft = math.max(0, WAVEZERO_LENGTH - CurTime())
		if timleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			draw.DrawText("Zombie invasion in: "..string.ToMinutesSeconds(timleft), "HUDFontSmallAA", startx, th, Color(255, glow, glow), TEXT_ALIGN_LEFT)
			if lastwarntim ~= math.ceil(timleft) then
				lastwarntim = math.ceil(timleft)
				if 0 < lastwarntim and not nobaby:GetBool() then
					surface.PlaySound("ambient/creatures/teddy.wav")
				end
				--surface.PlaySound("ambient/creatures/town_moan1.wav")
			end
		else
			draw.DrawText("Zombie invasion in: "..string.ToMinutesSeconds(timleft), "HUDFontSmallAA", startx, th, COLOR_GRAY, TEXT_ALIGN_LEFT)
		end
	elseif self:GetFighting() then
		local timleft = math.max(0, self:GetWaveEnd() - CurTime())
		if timleft <= 0 then
			draw.DrawText(self:NumLivingZombies().." Zombies remaining", "HUDFontSmallAA", startx, th, COLOR_RED, TEXT_ALIGN_LEFT)
		else
			if 10 < timleft then
				draw.DrawText("Wave ends: "..string.ToMinutesSeconds(timleft), "HUDFontSmallAA", startx, th, COLOR_GRAY, TEXT_ALIGN_LEFT)
			else
				local glow = math.sin(RealTime() * 8) * 200 + 255
				draw.DrawText("Wave ends: "..string.ToMinutesSeconds(timleft), "HUDFontSmallAA", startx, th, Color(255, glow, glow), TEXT_ALIGN_LEFT)
				if lastwarntim ~= math.ceil(timleft) then
					lastwarntim = math.ceil(timleft)

					if 0 < lastwarntim and not nobaby:GetBool() then
						surface.PlaySound("ambient/creatures/teddy.wav")
					end
				end
			end
		end
	else
		local timleft = math.max(0, self:GetWaveStart() - CurTime())
		if timleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			draw.DrawText("Next wave in: "..string.ToMinutesSeconds(timleft), "HUDFontSmallAA", startx, th, Color(255, glow, glow), TEXT_ALIGN_LEFT)
			if lastwarntim ~= math.ceil(timleft) then
				lastwarntim = math.ceil(timleft)
					if 0 < lastwarntim and not nobaby:GetBool() then
					surface.PlaySound("ambient/creatures/teddy.wav")
				end
			end
		else
			draw.DrawText("Next wave in: "..string.ToMinutesSeconds(timleft), "HUDFontSmallAA", startx, th, COLOR_GRAY, TEXT_ALIGN_LEFT)
		end
	end

	if myteam == TEAM_UNDEAD then
		self:ZombieHUD(MySelf, startx, th)
	else
		self:HumanHUD(MySelf, startx, th)
	end
end

function GM:HumanMenu()
	local menu = DermaMenu()
	menu:SetPos(w * 0.5, h * 0.6)

	--menu:AddOption("Drop ammo", function() RunConsoleCommand("zsdropammo") end)
	menu:AddOption("Drop weapon", function() RunConsoleCommand("zsdropweapon") end)
	menu:AddOption("Empty weapon clip", function() RunConsoleCommand("zsemptyclip") end)
	menu:AddSpacer()
	menu:AddOption("Close")

	menu:MakePopup()

	timer.Simple(0, gui.SetMousePos, w * 0.5 - 1, h * 0.6 - 1)
end

util.PrecacheSound("npc/stalker/breathing3.wav")
util.PrecacheSound("npc/zombie/zombie_pain6.wav")
function GM:PlayerBindPress(pl, bind)
	if bind == "+walk" then
		RunConsoleCommand("zsdropweapon")
		return true
	elseif bind == "+speed" and pl:Alive() then
		if pl:Team() == TEAM_UNDEAD then
			if DLV then
				pl:EmitSound("npc/zombie/zombie_pain6.wav", 100, 110)
				DoZomC()
			elseif DISABLE_PP or not COLOR_MOD then
				pl:ChatPrint("Dark to Light vision can not be used with post processing or color mod turned off (Check F4 options).")
			else
				pl:EmitSound("npc/stalker/breathing3.wav", 100, 230)
				DLVC()
			end
		else
			self:HumanMenu()
		end
	end
end

local SkullCam = NULL
usermessage.Hook("SkullCam", function(um)
	local ent = um:ReadEntity()
	if ent and ent:IsValid() then
		SkullCam = ent
	end
end)

local fovlerp = GetConVarNumber("fov_desired")
local maxfov = fovlerp
local minfov = fovlerp * 0.6
function GM:CalcView(pl, pos, ang, _fov)
	if MYSELFVALID then
		if not pl:Alive() and pl:GetMoveType() ~= MOVETYPE_OBSERVER then
			if SkullCam:IsValid() then
				SkullCam:SetColor(255, 255, 255, 1)
				pos = SkullCam:GetPos() + SkullCam:GetForward()
				ang = SkullCam:GetAngles()
			elseif pl:GetRagdollEntity() then
				local rpos, rang = self:GetRagdollEyes(pl)
				if rpos then
					pos = rpos
					ang = rang
				end
				--[[local phys = pl:GetRagdollEntity():GetPhysicsObjectNum(12)
				local ragdoll = pl:GetRagdollEntity()
				if ragdoll then
					local lookup = pl:LookupAttachment("eyes")
					if lookup then
						local attach = ragdoll:GetAttachment(lookup)
						if attach then
							return {origin=attach.Pos + attach.Ang:Forward() * -5, angles=attach.Ang}
						end
					end
				end]]
			end
		elseif 2 < pl:WaterLevel() then --or pl:Team() == TEAM_HUMAN and pl:Health() <= 30 then
			ang.roll = ang.roll + math.sin(RealTime()) * 7
		elseif pl:Team() == TEAM_UNDEAD then
			local cl = pl.Class or 1
			if cl and self.ZombieClasses[cl].ViewOffset and not pl:Crouching() then
				pos = pos + self.ZombieClasses[cl].ViewOffset
			end
		end

		local wep = pl:GetActiveWeapon()
		if wep:GetNetworkedBool("Ironsights") then
			fovlerp = math.max(minfov, fovlerp - FrameTime() * 70)
			_fov = fovlerp
		elseif fovlerp < maxfov then
			fovlerp = math.min(maxfov, fovlerp + FrameTime() * 140)
			_fov = fovlerp
		end
	end

	return self.BaseClass:CalcView(pl, pos, ang, _fov)
end

local staggerdir = VectorRand():Normalize()
function GM:CreateMove(cmd)
	if MYSELFVALID and MySelf:Team() == TEAM_HUMAN and MySelf:Alive() and MySelf:Health() <= 30 then
		local ang = cmd:GetViewAngles()
		local ft = FrameTime()
		ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * ft * 2)
		ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * ft * 2)
		staggerdir = (staggerdir + ft * 8 * VectorRand()):Normalize()

		cmd:SetViewAngles(ang)	
	end
end

function GM:ShutDown()
end

function GM:GetTeamColor(ent)
	if ent and ent:IsValid() and ent:IsPlayer() then
		local teamnum = ent:Team() or TEAM_UNASSIGNED
		return team.GetColor(teamnum) or color_white
	end
	return color_white
end

function GM:GetTeamNumColor(num)
	return team.GetColor(num) or color_white
end

function GM:OnChatTab(str)
	local LastWord
	for word in string.gmatch(str, "%a+") do
	     LastWord = word
	end
	if LastWord == nil then return str end
	playerlist = player.GetAll()
	for k, v in pairs(playerlist) do
		local nickname = v:Nick()
		if string.len(LastWord) < string.len(nickname) and string.find(string.lower(nickname), string.lower(LastWord)) == 1 then
			str = string.sub(str, 1, (string.len(LastWord) * -1)-1)
			str = str .. nickname
			return str
		end
	end
	return str
end

function GM:GetSWEPMenu()
	return {}
end

function GM:GetSENTMenu()
	return {}
end

function GM:PostProcessPermitted(str)
	return false
end

function GM:PostRenderVGUI()
end

function GM:RenderScene()
end

function GM:UpdateAnimation(pl)
	if pl:Team() == TEAM_HUMAN then
		pl:SetPoseParameter("breathing", 2 - pl:Health() * 0.01)
	end
end

function draw.DrawTextShadow(text, font, x, y, color, shadowcolor, xalign)
	local tw, th = 0, 0
	surface.SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		x = x - tw * 0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		tw, th = surface.GetTextSize(text)
		x = x - tw
	end

	surface.SetTextColor(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a or 255)
	surface.SetTextPos(x+1, y+1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x+1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y+1)
	surface.DrawText(text)

	if color then
		surface.SetTextColor(color.r, color.g, color.b, color.a or 255)
	end

	surface.SetTextPos(x, y)
	surface.DrawText(text)

	return tw, th
end

function draw.SimpleTextShadow(text, font, x, y, color, shadowcolor, xalign, yalign)
	font 	= font 		or "Default"
	x 		= x 		or 0
	y 		= y 		or 0
	xalign 	= xalign 	or TEXT_ALIGN_LEFT
	yalign 	= yalign 	or TEXT_ALIGN_TOP
	local tw, th = 0, 0
	surface.SetFont(font)
	
	if xalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		x = x - tw*0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		tw, th = surface.GetTextSize(text)
		x = x - tw
	end
	
	if yalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		y = y - th*0.5
	end

	surface.SetTextColor(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a or 255)
	surface.SetTextPos(x+1, y+1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x+1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y+1)
	surface.DrawText(text)

	if color then
		surface.SetTextColor(color.r, color.g, color.b, color.a or 255)
	else
		surface.SetTextColor(255, 255, 255, 255)
	end

	surface.SetTextPos(x, y)
	surface.DrawText(text)

	return tw, th
end

function Intermission(nextmap, winner)
	ENDROUND = true
	hook.Remove("RenderScreenspaceEffects", "PostProcess")
	ENDTIME = CurTime()
	DrawingDanger = 0
	NearZombies = 0
	NextThump = 999999
	RunConsoleCommand("stopsounds")
	DoHumC()

	function GAMEMODE:HUDPaint() end
	function GAMEMODE:HUDPaintBackground()
		surface.SetFont("HUDFontSmall")
		local texw, texh = surface.GetTextSize("ABCDEFGHABCDEFGHABCDEFGH")
		surface.SetFont("HUDFont")
		local bigtexw, bigtexh = surface.GetTextSize("Damage to Undead")
		local midw, midh = w*0.5, h*0.5
		local boxw = bigtexw * 3
		draw.RoundedBox(16, midw - boxw * 0.5, 92, boxw, texh * 10 + bigtexh * 2 + 128, color_black_alpha180)

		local x = midw - boxw * 0.25
		if #Top > 0 then
			local y = 128
			draw.DrawText("Survival Times", "HUDFont", x, y, COLOR_CYAN, TEXT_ALIGN_CENTER)
			y = y + bigtexh + 4
			for i=1, 5 do
				if Top[i] and ENDTIME + i * 0.7 < CurTime() then
					draw.DrawText(Top[i], "HUDFontSmall", x, y, Color(285 - i * 30, 0, i * 65 - 65, 255), TEXT_ALIGN_CENTER)
					y = y + texh + 2
				end
			end
		end
		if #TopHD > 0 then
			local y = 144 + bigtexh + (texh + 2) * 5
			draw.DrawText("Damage to undead", "HUDFont", x, y, COLOR_CYAN, TEXT_ALIGN_CENTER)
			y = y + bigtexh + 4
			for i=1, 5 do
				if TopHD[i] and ENDTIME + i * 0.7 < CurTime() then
					draw.DrawText(TopHD[i], "HUDFontSmall", x, y, Color(285 - i * 30, 0, i * 65 - 65, 255), TEXT_ALIGN_CENTER)
					y = y + texh + 2
				end
			end
		end

		x = midw + boxw * 0.25
		if #TopZ > 0 then
			local y = 128
			draw.DrawText("Brains Eaten", "HUDFont", x, y, COLOR_GREEN, TEXT_ALIGN_CENTER)
			y = y + bigtexh + 4
			for i=1, 5 do
				if TopZ[i] and ENDTIME + i * 0.7 < CurTime() then
					draw.DrawText(TopZ[i], "HUDFontSmall", x, y, Color(285 - i * 30, 0, i * 65 - 65, 255), TEXT_ALIGN_CENTER)
					y = y + texh + 2
				end
			end
		end
		if #TopZD > 0 then
			local y = 144 + bigtexh + (texh + 2) * 5
			draw.DrawText("Damage to humans", "HUDFont", x, y, COLOR_GREEN, TEXT_ALIGN_CENTER)
			y = y + bigtexh + 4
			for i=1, 5 do
				if TopZD[i] and ENDTIME + i * 0.7 < CurTime() then
					draw.DrawText(TopZD[i], "HUDFontSmall", x, y, Color(285 - i * 30, 0, i * 65 - 65, 255), TEXT_ALIGN_CENTER)
					y = y + texh + 2
				end
			end
		end

		local timleft = math.max(0, ENDTIME + INTERMISSION_TIME - CurTime())
		if timleft <= 0 then
			draw.DrawText("Loading next level...", "HUDFontSmall", midw, 92 + texh * 18, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.DrawText("Next: "..string.ToMinutesSeconds(timleft), "HUDFontSmall", midw, 92 + texh * 18, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		self:DrawDeathNotice(0.8, 0.04)
	end

	if winner == TEAM_UNDEAD then
		hook.Add("HUDPaint", "DrawLose", DrawLose)
		timer.Simple(0.5, surface.PlaySound, ALLLOSESOUND)
	else
		if TEAM_HUMAN == MySelf:Team() then
			hook.Add("HUDPaint", "DrawWin", DrawWin)
		else
			hook.Add("HUDPaint", "DrawLose", DrawLose)
		end
		timer.Simple(0.5, surface.PlaySound, HUMANWINSOUND)
	end
end

--[[GM.NextUnlife = 0
local function LoopUnlife()
	if UNLIFE and not ENDROUND and not LASTHUMAN and GAMEMODE.NextUnlife < CurTime() then
		surface.PlaySound(UNLIFESOUND)
		timer.Simple(UNLIFESOUNDLENGTH, LoopUnlife)
		GAMEMODE.NextUnlife = UNLIFESOUNDLENGTH - 5 -- Get rid of some double-play issues when joining late.
	end
end]]

usermessage.Hook("SetInf", function(um)
	INFLICTION = um:ReadFloat()

	if not LASTHUMAN then
		if 0.75 <= INFLICTION and not UNLIFE then
			UNLIFE = true
			HALFLIFE = true
			GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Un-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 75%</font></color>")
			GAMEMODE:SetUnlifeText()
		elseif INFLICTION >= 0.5 and not HALFLIFE then
			HALFLIFE = true
			GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Half-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 50%</font></color>")
			GAMEMODE:SetHalflifeText()
		end
	end
end)

function GM:WeaponDeployed(pl, wep, ironsights)
end

usermessage.Hook("reczsgamestate", function(um)
	--GAMEMODE:SetZombieLives(um:ReadShort())
	GAMEMODE:SetWave(um:ReadShort())
	GAMEMODE:SetWaveStart(um:ReadFloat())
	GAMEMODE:SetWaveEnd(um:ReadFloat())
end)

usermessage.Hook("SetInfInit", function(um)
	INFLICTION = um:ReadFloat()
	local wave = um:ReadShort()
	GAMEMODE:SetWave(wave)

	for i, tab in ipairs(GAMEMODE.ZombieClasses) do
		if tab.Wave <= wave then
			tab.Unlocked = true
		end
	end

	if INFLICTION >= 0.75 then
		UNLIFE = true
		HALFLIFE = true
		--LoopUnlife()
	elseif INFLICTION >= 0.5 then
		HALFLIFE = true
	end
end)

function Died()
	LASTDEATH = RealTime()
	surface.PlaySound(DEATHSOUND)
	GAMEMODE:SplitMessage(h * 0.5, "<color=red><font=HUDFontBigAA>You are dead.</font></color>")
end

function GM:KeyPress(pl, key)
	--[[if key == IN_USE and MySelf:Team() == TEAM_HUMAN then
		local ent = util.TraceLine({start = MySelf:EyePos(), endpos = MySelf:EyePos() + MySelf:GetAimVector() * 50, filter = MySelf}).Entity
		if ent and ent:IsValid() and ent:IsPlayer() then
			RunConsoleCommand("shove", ent:EntIndex())
		end]]
	--[[elseif key == IN_ATTACK and MySelf:Team() == TEAM_UNDEAD and MySelf:GetMoveType() == MOVETYPE_OBSERVER and not self:GetFighting() then
		RunConsoleCommand("setbury")]]
	--end
end

function DrawLose()
	DrawLoseY = DrawLoseY or 0
	if DrawLoseY > h*0.8 then
		DrawLoseHoldTime = true
	else
		for i=1, 5 do
			draw.DrawText("You have lost.", "HUDFontBig", w*0.5, DrawLoseY - i*h*0.02, Color(255, 0, 0, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawLoseY = DrawLoseY + h * 0.495 * FrameTime()
	end
	if DrawLoseHoldTime then
		if not DrawLoseSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawLoseSound = true
		end
		if not DISABLE_PP and 90 <= render.GetDXLevel() then
			ColorModify["$pp_colour_contrast"] = math.Approach(ColorModify["$pp_colour_contrast"], 0.4, FrameTime()*0.5)
		end
		draw.DrawText("You have lost.", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawLoseY, color_blur1, TEXT_ALIGN_CENTER)
		draw.DrawText("You have lost.", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawLoseY, color_blur1, TEXT_ALIGN_CENTER)
		draw.DrawText("You have lost.", "HUDFontBig", w*0.5, DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("You have lost.", "HUDFontBig", w*0.5, DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
	end
end

function DrawWin()
	DrawWinY = DrawWinY or 0

	if DrawWinY > h*0.8 then
		DrawWinHoldTime = true
	else
		for i=1, 5 do
			draw.DrawText("You have survived!", "HUDFontBig", w*0.5, DrawWinY - i*h*0.02, Color(0, 0, 255, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawWinY = DrawWinY + h * 0.495 * FrameTime() 
	end

	if DrawWinHoldTime then
		if not DrawWinSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawWinSound = true
		end

		if not DISABLE_PP then
			ColorModify["$pp_colour_contrast"] = math.Approach(ColorModify["$pp_colour_contrast"], 2, FrameTime() * 0.5)
		end

		draw.DrawText("You have survived!", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawWinY, Color(0, 0, 255, 90), TEXT_ALIGN_CENTER)
		draw.DrawText("You have survived!", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawWinY, Color(0, 0, 255, 180), TEXT_ALIGN_CENTER)
		draw.DrawText("You have survived!", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("You have survived!", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	end
end

function Rewarded(wep)
	surface.PlaySound("weapons/physcannon/physcannon_charge.wav")
	if wep and wep.PrintName then
		local font = "HL2MPTypeDeath"
		local letter = "0"
		local stuff = killicon.GetFont(wep:GetClass())
		if stuff then
			font = stuff.font
			letter = stuff.letter
		end
		GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontSmallAA>Arsenal Upgraded</font></color>", "<color=ltred><font="..font..">"..letter.."</font>  <font=HUDFontSmallAA>"..wep.PrintName.."</font>  <font="..font..">"..letter.."</font></color>")
	else
		GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontSmallAA>Arsenal Upgraded</font></color>", "<color=ltred><font=HL2MPTypeDeath>0</font></color>")
	end
end
rW = Rewarded

util.PrecacheSound("npc/zombie/foot1.wav")
util.PrecacheSound("npc/zombie/foot2.wav")
util.PrecacheSound("npc/zombie/foot3.wav")
util.PrecacheSound("npc/zombie/foot_slide1.wav")
util.PrecacheSound("npc/zombie/foot_slide2.wav")
util.PrecacheSound("npc/zombie/foot_slide3.wav")
util.PrecacheSound("npc/fast_zombie/foot1.wav")
util.PrecacheSound("npc/fast_zombie/foot2.wav")
util.PrecacheSound("npc/fast_zombie/foot3.wav")
util.PrecacheSound("npc/fast_zombie/foot4.wav")
util.PrecacheSound("npc/zombie_poison/pz_left_foot1.wav")
util.PrecacheSound("npc/zombie_poison/pz_right_foot1.wav")
util.PrecacheSound("npc/headcrab_poison/ph_step1.wav")
util.PrecacheSound("npc/headcrab_poison/ph_step2.wav")
util.PrecacheSound("npc/headcrab_poison/ph_step3.wav")
util.PrecacheSound("npc/headcrab_poison/ph_step4.wav")

local FootModelsTime = {}
FootModelsTime["models/zombie/classic.mdl"] = function(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 625 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 600
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 750
	end

	return 450
end

local FootModelsTime = {}
FootModelsTime["models/zombie/fast.mdl"] = function(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 450 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 400
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 550
	end

	return 250
end

FootModelsTime["models/zombie/poison.mdl"] = function(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 350 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 300
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 450
	end

	return 150
end

FootModelsTime["models/headcrabblack.mdl"] = function(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 240 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 180
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 250
	end

	return 160
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	local cb = FootModelsTime[pl:GetModel()]
	if cb then
		return cb(pl, iType, bWalking)
	elseif iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 520 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 500
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 650
	end

	return 350
end

local FootModels = {}

FootModels["models/zombie/classic.mdl"] = function(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and math.random(1, 3) < 2 then
		pl:EmitSound("npc/zombie/foot_slide"..math.random(1,3)..".wav", 70, math.Rand(97, 103))
	else
		pl:EmitSound("npc/zombie/foot"..math.random(1,3)..".wav", 70, math.Rand(97, 103))
	end

	return true
end

FootModels["models/zombie/fast.mdl"] = function(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound("npc/fast_zombie/foot"..math.random(1,2)..".wav", 68, math.Rand(115, 120))
	else
		pl:EmitSound("npc/fast_zombie/foot"..math.random(3,4)..".wav", 68, math.Rand(115, 120))
	end

	return true
end

FootModels["models/zombie/poison.mdl"] = function(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and math.random(1,3) < 3 then
		pl:EmitSound("npc/zombie_poison/pz_right_foot1.wav", 69, math.Rand(98, 102))
	else
		pl:EmitSound("npc/zombie_poison/pz_left_foot1.wav", 69, math.Rand(98, 102))
	end

	return true
end

FootModels["models/headcrabclassic.mdl"] = function() return true end
FootModels["models/stalker.mdl"] = function() return true end
FootModels["models/headcrab.mdl"] = function() return true end

FootModels["models/headcrabblack.mdl"] = function(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound("npc/headcrab_poison/ph_step"..math.random(1,4)..".wav", 50, math.Rand(98, 102))

	return true
end

function GM:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume)
	local cb = FootModels[string.lower(pl:GetModel())]
	if cb then
		return cb(pl, vFootPos, iFoot, strSoundName, fVolume)
	end
end
