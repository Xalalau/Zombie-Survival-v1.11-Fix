hook.Add("Think", "GetLocal", function()
	if LocalPlayer():IsValid() then
		RunConsoleCommand("PostPlayerInitialSpawn")
		hook.Remove("Think", "GetLocal")
	end
end)

include("shared.lua")
include("cl_scoreboard.lua")
include("cl_targetid.lua")
include("cl_hudpickup.lua")
include("cl_spawnmenu.lua")
include("cl_postprocess.lua")
include("cl_deathnotice.lua")
include("cl_beats.lua")
include("cl_splitmessage.lua")
include("vgui/poptions.lua")
include("vgui/phelp.lua")
include("vgui/pclasses.lua")
include("cl_dermaskin.lua")

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
COLOR_READABLERED = Color(255, 133, 133)
COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255)
COLOR_BLACK = Color(0, 0, 0)

ENDTIME = 0

NearZombies = 0
ActualNearZombies = 0

local cvar_zs_roundtime = GetConVar("zs_roundtime")
local cvar_zs_intermission_time = GetConVar("zs_intermission_time")

local Top = {}
local TopZ = {}
local TopZD = {}
local TopHD = {}

w, h = ScrW(), ScrH()

local matHumanHeadID = surface.GetTextureID("humanhead")
local matZomboHeadID = surface.GetTextureID("zombohead")

function GetZombieFocus2(mypos, range, multiplier, maxper)
	local zombies = 0

	for _, curPly in ipairs(player.GetAll()) do
		if curPly ~= LocalPlayer() and curPly:Team() == TEAM_UNDEAD and curPly:Alive() then
			local dist = curPly:GetPos():Distance(mypos)
			if dist < range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	return math.min(zombies, 1)
end

function GetUIScale()
	local UIScalingW = 1
	local UIScalingH = 1
	local smoothinFactor = 1

	if w > 1366 and h > 768 then
		local baseWidth = 1366
		local baseHeight = 768

		smoothinFactor = 0.9
		UIScalingW = (w / baseWidth) * smoothinFactor
		UIScalingH = (h / baseHeight) * smoothinFactor
	end

	return UIScalingW, UIScalingH, smoothinFactor
end

function GM:Initialize()
	self.ShowScoreboard = false

	local UIScalingW, UIScalingH = GetUIScale()

	surface.CreateFont("ScoreboardHead", { 
		font = "Coolvetica",
		size = 48 * UIScalingH,
		weight = 500,
		shadow = true
	})
	surface.CreateFont("ScoreboardSub", { 
		font = "Coolvetica",
		size = 24 * UIScalingH,
		weight = 500,
		shadow = true
	})
	surface.CreateFont("ScoreboardText", { 
		font = "Tahoma",
		size = 16 * UIScalingH,
		weight = 1000,
		shadow = true
	})
	surface.CreateFont("Signs", { 
		font = "csd",
		size = 42 * UIScalingH,
		weight = 500,
		shadow = true
	})
	surface.CreateFont("HUDFontTiny", { 
		font = "anthem",
		size = 16 * UIScalingH,
		weight = 250,
		antialias = false,
		shadow = true
	})
	surface.CreateFont("HUDFontSmall", { 
		font = "anthem",
		size = 28 * UIScalingH,
		weight = 400,
		antialias = false,
		shadow = true
	})
	surface.CreateFont("HUDFont", { 
		font = "anthem",
		size = 42 * UIScalingH,
		weight = 400,
		antialias = false,
		shadow = true
	})
	surface.CreateFont("HUDFontBig", { 
		font = "anthem",
		size = 72 * UIScalingH,
		weight = 400,
		antialias = false,
		shadow = true
	})
	surface.CreateFont("HUDFontTinyAA", { 
		font = "anthem",
		size = 16 * UIScalingH,
		weight = 250,
		shadow = true
	})
	surface.CreateFont("HUDFontSmallAA", { 
		font = "anthem",
		size = 28 * UIScalingH,
		weight = 400,
		shadow = true
	})
	surface.CreateFont("HUDFontAA", { 
		font = "anthem",
		size = 42 * UIScalingH,
		weight = 400,
		shadow = true
	})
	surface.CreateFont("HUDFontBigAA", { 
		font = "anthem",
		size = 72 * UIScalingH,
		weight = 400,
		shadow = true
	})
	surface.CreateFont("HUDFontTiny2", { 
		font = "AkbarPlain",
		size = 16 * UIScalingH,
		weight = 250,
		shadow = true
	})
	surface.CreateFont("HUDFontSmall2", { 
		font = "AkbarPlain",
		size = 28 * UIScalingH,
		weight = 500,
		shadow = true
	})
	surface.CreateFont("HUDFont2", { 
		font = "AkbarPlain",
		size = 42 * UIScalingH,
		weight = 500,
		shadow = true
	})
	surface.CreateFont("HUDFontBig2", { 
		font = "AkbarPlain",
		size = 72 * UIScalingH,
		weight = 500,
		shadow = true
	})
	surface.CreateFont("noxnetbig", { 
		font = "Frosty",
		size = 32 * UIScalingH,
		weight = 200,
		antialias = false,
		shadow = true
	})
	surface.CreateFont("noxnetnormal", { 
		font = "AkbarPlain",
		size = 22 * UIScalingH,
		weight = 500
	})
	surface.CreateFont("DefaultBold", { 
		font = "anthem",
		size = 20 * UIScalingH,
		weight = 400,
		shadow = true
	})
	surface.CreateFont("DefaultScaled", { 
		font = "Default",
		size = 14 * UIScalingH,
		weight = 700,
		antialias = true,
	})
	surface.CreateFont("DefaultSmallScaled", { 
		font = "DefaultSmall",
		size = 14 * UIScalingH,
		weight = 0,
	})

	if FORCE_NORMAL_GAMMA then
		RunConsoleCommand("mat_monitorgamma", "2.2")
		timer.Create("GammaChecker", 3, 0, function()
			RunConsoleCommand("mat_monitorgamma", "2.2")
		end)
	end
end

function GM:PlayerDeath(ply, attacker)
end

local function LoopLastHuman()
	if not ENDROUND then
		surface.PlaySound(LASTHUMANSOUND)
		timer.Simple(LASTHUMANSOUNDLENGTH, LoopLastHuman)
	end
end

local function DelayedLH()
	if not ENDROUND then
		local ply = LocalPlayer()

		if IsValid(ply) then
			if ply:Team() == TEAM_UNDEAD or not ply:Alive() then
				GAMEMODE:SplitMessage(h * 0.7, "<color=red><font=HUDFontAA>Kill the Last Human!</font></color>")
			else
				GAMEMODE:SplitMessage(h * 0.7, "<color=ltred><font=HUDFontAA>You are the Last Human!</font></color>", "<color=red><font=HUDFontAA>RUN!</font></color>")
			end
		end
	end
end

function GM:LastHuman()
	if LASTHUMAN then return end

	LASTHUMAN = true
	RunConsoleCommand("stopsound")
	timer.Simple(0.5, LoopLastHuman)
	DrawingDanger = 1
	timer.Simple(0.5, DelayedLH)
	GAMEMODE:SetLastHumanText()
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if attacker.Alive then
		return ply:Team() ~= attacker:Team() or ply == attacker
	end
	return true
end

function GM:HUDShouldDraw(name)
	return name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudSecondaryAmmo" and name ~= "CHUDQuickInfo"
end

local function ReceiveTopTimes(index, toptimes)
	Top[index] = toptimes
	if Top[index] == "Downloading" or Top[index] == "[STRING NOT POOLED]" then
		Top[index] = nil
	else
		Top[index] = index..". "..Top[index]
	end
end
net.Receive("RcTopTimes", function() ReceiveTopTimes(net.ReadInt(16), net.ReadString()) end)

local function ReceiveTopZombies(index, topzombies)
	TopZ[index] = topzombies
	if TopZ[index] == "Downloading" or TopZ[index] == "[STRING NOT POOLED]" then
		TopZ[index] = nil
	else
		TopZ[index] = index..". "..TopZ[index]
	end
end
net.Receive("RcTopZombies", function() ReceiveTopZombies(net.ReadInt(16), net.ReadString()) end)

local function ReceiveTopHumanDamages(index, tophumandamage)
	TopHD[index] = tophumandamage
	if TopHD[index] == "Downloading" or TopHD[index] == "[STRING NOT POOLED]" then
		TopHD[index] = nil
	else
		TopHD[index] = index..". "..TopHD[index]
	end
end
net.Receive("RcTopHumanDamages", function() ReceiveTopHumanDamages(net.ReadInt(16), net.ReadString()) end)

local function ReceiveTopZombieDamages(index, topzombiedamage)
	TopZD[index] = topzombiedamage
	if TopZD[index] == "Downloading" or TopZD[index] == "[STRING NOT POOLED]" then
		TopZD[index] = nil
	else
		TopZD[index] = index..". "..TopZD[index]
	end
end
net.Receive("RcTopZombieDamages", function() ReceiveTopZombieDamages(net.ReadInt(16), net.ReadString()) end)

local function ReceiveHeadcrabScale(somePly)
	if somePly:IsValid() then
		--somePly:SetModelScale(Vector(2,2,2))
		if somePly == LocalPlayer() then
			HCView = true
			hook.Add("Think", "HCView", function()
				if somePly:Health() <= 0 then
					HCView = false
					hook.Remove("Think", "HCView")
				end
			end)
		end
	end
end
net.Receive("RcHCScale", function() ReceiveHeadcrabScale(net.ReadEntity()) end)

function GM:HUDPaintBackground()
end

local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")
local matUIBottomLeft = surface.GetTextureID("zombiesurvival/zs_ui_bottomleft")
function GM:HUDPaint()
	local ply = LocalPlayer()

	if not ply:IsValid() then return end

	if not cvar_zs_roundtime then
		cvar_zs_roundtime = GetConVar("zs_roundtime")
	end

	if not cvar_zs_intermission_time then
		cvar_zs_intermission_time = GetConVar("zs_intermission_time")
	end

	-- Width, height
	h = ScrH()
	w = ScrW()

	local UIScalingW, UIScalingH, smoothingFactor = GetUIScale()

	surface.SetDrawColor(255, 255, 255, 180)
	surface.SetTexture(matUIBottomLeft)
	surface.DrawTexturedRect(0, h - 72 * UIScalingH, 256 * UIScalingW, 64 * UIScalingH)

	local myteam = ply:Team()

	-- TargetID
	self:HUDDrawTargetID(ply, myteam)

	-- Team Count
	local zombies = 0
	local humans = 0
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == TEAM_ZOMBIE then
			zombies = zombies + 1
		else
			humans = humans + 1
		end
	end

	local hunit = 84 --h*0.11
	local windowwidth = hunit * 3.1 * UIScalingH

	draw.RoundedBox(16, 0, 0, windowwidth, hunit * UIScalingH, color_black_alpha90)
	local w05 = hunit/2.2
	local w05Scaled = w05 * UIScalingH
	local h05Scaled = w05Scaled
	surface.SetDrawColor(235, 235, 235, 255)
	surface.SetTexture(matZomboHeadID)
	surface.DrawTexturedRect(0, 4, w05Scaled, h05Scaled)
	surface.SetTexture(matHumanHeadID)
	surface.DrawTexturedRect(0, h05Scaled + 4, w05Scaled, h05Scaled)
	draw.DrawText(zombies, "HUDFontAA", w05Scaled, 0, COLOR_DARKGREEN, TEXT_ALIGN_LEFT)
	draw.DrawText(zombies, "HUDFontAA", w05Scaled, 0, COLOR_DARKGREEN, TEXT_ALIGN_LEFT)
	draw.DrawText(humans, "HUDFontAA", w05Scaled, h05Scaled, COLOR_DARKBLUE, TEXT_ALIGN_LEFT)
	draw.DrawText(humans, "HUDFontAA", w05Scaled, h05Scaled, COLOR_DARKBLUE, TEXT_ALIGN_LEFT)

	-- Death Notice
	self:DrawDeathNotice(0.8 * UIScalingW, 0.04 * UIScalingH)

	local actionposx = w05 * 2.4
	local actionposy = hunit/2 - draw.GetFontHeight("HUDFontSmallAA")
	local killedposx = actionposx
	local killedposy = hunit/2 

	if myteam == TEAM_UNDEAD then
		if self.ZombieHUD then
			self:ZombieHUD(ply, actionposx, actionposy, killedposx, killedposy)
		end
	else
		if self.HumanHUD then
			self:HumanHUD(ply, killedposx, killedposy)
		end
		
		draw.DrawText("Survive: "..ToMinutesSeconds(cvar_zs_roundtime:GetInt() - CurTime()), "HUDFontSmallAA", actionposx * UIScalingW, actionposy * UIScalingH, COLOR_GRAY, TEXT_ALIGN_LEFT)
	end

	-- Infliction
	draw.DrawText("Infliction: " .. math.floor(INFLICTION * 100) .. "%", "HUDFontSmallAA", 8 * UIScalingW, h - 112 * UIScalingH, COLOR_INFLICTION, TEXT_ALIGN_LEFT)
end

util.PrecacheSound("npc/stalker/breathing3.wav")
util.PrecacheSound("npc/zombie/zombie_pain6.wav")
function GM:PlayerBindPress(ply, bind)
	if bind == "+walk" then
		return true
	--[[elseif bind == "impulse 100" then
		return ply:Team() == TEAM_UNDEAD]]--
	elseif bind == "+speed" and ply:Team() == TEAM_UNDEAD then
		if DLV then
			ply:EmitSound("npc/zombie/zombie_pain6.wav", 100, 110)
			DoZomC()
		else
			ply:EmitSound("npc/stalker/breathing3.wav", 100, 230)
			DLVC()
		end
	end
end

function GM:CalcView(ply, pos, ang, _fov)
	local ply = LocalPlayer()

	if not ply:IsValid() then return end

	local ragdoll = ply:GetRagdollEntity()

	if IsValid(ragdoll) then
		local lookup = ragdoll:LookupAttachment("eyes")
		if lookup > 0 then
			local attach = ragdoll:GetAttachment(lookup)
			if attach then
				return {origin=attach.Pos + attach.Ang:Forward(), angles=attach.Ang}
			end
		end
	end

	if (ply:Health() <= 30 and ply:Team() == TEAM_HUMAN) or ply:WaterLevel() > 2 then
		ang.roll = ang.roll + math.sin(RealTime()) * 7
	end

	if HCView then
		if not ply:KeyDown(IN_DUCK) then
			pos = pos - Vector(0, 0, 30)
		end
	end

	return {origin = pos, angles = ang, fov = _fov}
end

function GM:CreateMove(cmd)
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

	for k, v in ipairs(player.GetAll()) do
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

function Intermission(winner)
	ENDROUND = true
	hook.Remove("RenderScreenspaceEffects", "PostProcess")
	ENDTIME = CurTime()
	DrawingDanger = 0
	NearZombies = 0
	NextThump = 999999
	RunConsoleCommand("stopsound")
	LastLineY = h*0.4
	DoHumC()
	function GAMEMODE:HUDPaint()
		self:DrawDeathNotice(0.8, 0.04)
		draw.RoundedBox(16, 0, h*0.14, w, h*0.62, color_black)
		if math.Clamp(LastLineY, h*0.14, h*0.76) == LastLineY then
			surface.DrawLine(0, LastLineY, w, LastLineY)
		end
		LastLineY = LastLineY + h*0.1 * FrameTime()
		if LastLineY > h then
			LastLineY = h*0.14
		end
		if #Top > 0 then
			draw.DrawText("Survival Times", "HUDFont", w*0.1, h*0.15, COLOR_CYAN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if Top[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.DrawText(Top[i], "HUDFontSmall", w*0.13, h*0.15 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end
		if #TopHD > 0 then
			draw.DrawText("Damage to undead", "HUDFont", w*0.1, h*0.45, COLOR_CYAN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if TopHD[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.DrawText(TopHD[i], "HUDFontSmall", w*0.13, h*0.45 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end

		if #TopZ > 0 then
			draw.DrawText("Brains Eaten", "HUDFont", w*0.65, h*0.15, COLOR_GREEN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if TopZ[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.DrawText(TopZ[i], "HUDFontSmall", w*0.68, h*0.15 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end
		if #TopZD > 0 then
			draw.DrawText("Damage to humans", "HUDFont", w*0.65, h*0.45, COLOR_GREEN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if TopZD[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.DrawText(TopZD[i], "HUDFontSmall", w*0.68, h*0.45 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end

		local time = ENDTIME + cvar_zs_intermission_time:GetInt() - CurTime()
		draw.DrawText("Next: "..ToMinutesSeconds(time >= 0 and time or 0), "HUDFontSmall", w*0.5, h*0.7, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	if winner == TEAM_UNDEAD then
		hook.Add("HUDPaint", "DrawLose", DrawLose)
		timer.Simple(0.5, function()
			surface.PlaySound(ALLLOSESOUND)
		end)
	else
		if TEAM_HUMAN == LocalPlayer():Team() then
			hook.Add("HUDPaint", "DrawWin", DrawWin)
		else
			hook.Add("HUDPaint", "DrawLose", DrawLose)
		end
		timer.Simple(0.5, function()
			surface.PlaySound(HUMANWINSOUND)
		end)
	end
end

/*function DrawUnlock()
	if ENDROUND then
		hook.Remove("HUDPaint", "DrawUnlock")
		DrawRewardTime = nil
		return
	end
	DrawUnlockTime = DrawUnlockTime or RealTime() + 3
	draw.RoundedBox(16, w * 0.375, h * 0.07, w * 0.25, h * 0.06, color_black_alpha90)
	draw.DrawText(UnlockedClass.." unlocked!", "HUDFontSmall", w*0.5 + XNameBlur2, h*0.085 + YNameBlur, Color(200, 0, 0, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.DrawText(UnlockedClass.." unlocked!", "HUDFontSmall", w*0.5, h*0.085, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	if RealTime() > DrawUnlockTime then
		hook.Remove("HUDPaint", "DrawUnlock")
		DrawUnlockTime = nil
		UnlockedClass = nil
		return
	end
end*/

local function LoopUnlife()
	if UNLIFE and not ENDROUND and not LASTHUMAN then
		surface.PlaySound(UNLIFESOUND)
		timer.Simple(UNLIFESOUNDLENGTH, LoopUnlife)
	end
end

local function SetInf(infliction)
	INFLICTION = infliction

	local usesound = false
	local amount = 0
	local UnlockedClass
	for i in ipairs(ZombieClasses) do
		if ZombieClasses[i].Threshold <= INFLICTION and not ZombieClasses[i].Unlocked then
			ZombieClasses[i].Unlocked = true
			UnlockedClass = ZombieClasses[i].Name
			usesound = true
			amount = amount + 1
		end
	end

	if not LASTHUMAN then
		if INFLICTION >= 0.75 and not UNLIFE then
			UNLIFE = true
			HALFLIFE = true
			RunConsoleCommand("stopsound")
			timer.Simple(0.5, LoopUnlife)
			GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Un-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked at 75%</font></color>")
			GAMEMODE:SetUnlifeText()
		elseif INFLICTION >= 0.5 and not HALFLIFE then
			HALFLIFE = true
			GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Half-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 50%</font></color>")
			GAMEMODE:SetHalflifeText()
		elseif usesound then
			surface.PlaySound("npc/fast_zombie/fz_alert_far1.wav")
			/*if amount > 1 then
				UnlockedClass =  -- So you can have more than one class with the same infliction without getting spammed.
			end
			hook.Add("HUDPaint", "DrawUnlock", DrawUnlock)*/
			if amount == 1 then
				GAMEMODE:SplitMessage(h * 0.12, "<color=green><font=HUDFontAA>"..UnlockedClass.." unlocked!</font></color>")
			else
				GAMEMODE:SplitMessage(h * 0.12, "<color=green><font=HUDFontAA>"..amount.." classes unlocked!</font></color>")
			end
		end
	end
end
net.Receive("SetInf", function() SetInf(net.ReadFloat()) end)

local function SetInfInit(infliction)
	INFLICTION = infliction
	for i in ipairs(ZombieClasses) do
		if ZombieClasses[i].Threshold <= INFLICTION then
			ZombieClasses[i].Unlocked = true
		end
	end

	if INFLICTION >= 0.75 then
		UNLIFE = true
		HALFLIFE = true
		LoopUnlife()
	elseif INFLICTION >= 0.5 then
		HALFLIFE = true
	end
end
net.Receive("SetInfInit", function() SetInf(net.ReadFloat()) end)
/*
function DrawLastHuman()
	if ENDROUND then return end
	LASTHUMAN = true
	LastHumanY = LastHumanY or 0
	if LastHumanY > h*0.67 then
		LastHumanHoldTime = LastHumanHoldTime or RealTime()
		if RealTime() > LastHumanHoldTime + 3 then
			LastHumanY = nil
			LastHumanHoldTime = nil
			DrawLastHumanHoldSound = nil
			hook.Remove("HUDPaint", "DrawLastHuman")
			return
		end
	else
		for i=1, 5 do
			draw.DrawText("Last Human", "HUDFontBig", w*0.5, LastHumanY - i*h*0.02, Color(255, 0, 0, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		LastHumanY = LastHumanY + h*0.0075
	end
	if LastHumanHoldTime then
		if not DrawLastHumanHoldSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawLastHumanHoldSound = true
		end
		draw.RoundedBox(16, w*0.35, h*0.67, w*0.3, h*0.15, color_black_alpha90)
		draw.DrawText("Last Human", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + LastHumanY, color_blur1, TEXT_ALIGN_CENTER)
		draw.DrawText("Last Human", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + LastHumanY, color_blur1, TEXT_ALIGN_CENTER)
		draw.DrawText("Last Human", "HUDFontBig", w*0.5, LastHumanY, COLOR_RED, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("Last Human", "HUDFontBig", w*0.5, LastHumanY, COLOR_RED, TEXT_ALIGN_CENTER)
	end
end
*/

function Died()
	LASTDEATH = RealTime()
	//hook.Add("HUDPaint", "DrawDeath", DrawDeath)
	surface.PlaySound(DEATHSOUND)
	GAMEMODE:SplitMessage(h * 0.725, "<color=red><font=HUDFontSmallAA>You are dead.</font></color>")
end

function GM:KeyPress(ply, key)
	local ply = LocalPlayer()
	if key == IN_USE and ply:Team() == TEAM_HUMAN then
		local ent = util.TraceLine({start = ply:EyePos(), endpos = ply:EyePos() + ply:GetAimVector() * 50, filter = ply}).Entity
		if ent and ent:IsValid() and ent:IsPlayer() then
			RunConsoleCommand("shove", ent:EntIndex())
		end
	end
end

/*function DrawDeath()
	local ply = LocalPlayer()

	if ply:Alive() then
		LASTRESPAWN = LASTRESPAWN or RealTime()
		local alpha = 1 - (RealTime() - LASTRESPAWN + 0.5) * 2
		if alpha > 0 then
			surface.SetDrawColor(255, 255, 255, 255 * alpha)
			surface.DrawRect(0, 0, w, h)
		else
			LASTDEATH = nil
			LASTRESPAWN = nil
			hook.Remove("HUDPaint", "DrawDeath")
		end
		return
	end

	if not ply:GetRagdollEntity() then
		LASTDEATH = nil
		LASTRESPAWN = nil
		hook.Remove("HUDPaint", "DrawDeath")
		return
	end

	local timepassed = RealTime() - LASTDEATH
	local w, h = ScrW(), ScrH()
	local height = h * math.min(0.5, timepassed * 0.14)
	surface.SetDrawColor(0, 0, 0, math.min(255, timepassed * 80))
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, height)
	surface.DrawRect(0, h - height, w, height)
end*/

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
		if not DISABLE_PP:GetBool() and 90 <= render.GetDXLevel() then
			ColorModify["$pp_colour_contrast"] = math.Approach(ColorModify["$pp_colour_contrast"], 0.4, FrameTime()*0.5)
			DrawColorModify(ColorModify)
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

		if not DISABLE_PP:GetBool() then
			ColorModify["$pp_colour_contrast"] = math.Approach(ColorModify["$pp_colour_contrast"], 2, FrameTime() * 0.5)
			DrawColorModify(ColorModify)
		end

		draw.DrawText("You have survived!", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawWinY, Color(0, 0, 255, 90), TEXT_ALIGN_CENTER)
		draw.DrawText("You have survived!", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawWinY, Color(0, 0, 255, 180), TEXT_ALIGN_CENTER)
		draw.DrawText("You have survived!", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("You have survived!", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	end
end

function Rewarded()
	surface.PlaySound("weapons/physcannon/physcannon_charge.wav")
	GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontSmallAA>Arsenal Upgraded</font></color>", "<color=ltred><font=HL2MPTypeDeath>0</font></color>")
end
rW = Rewarded

// Todo later.
/*local FootModels = {}
FootModels["models/zombie/classic.mdl"] = function(ply, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and math.random(1, 2) < 2 then
		EmitSound("npc/zombie/foot_slide"..math.random(1,3)..".wav", vFootPos, 0, CHAN_AUTO, 1, math.max(55, fVolume), 0, math.random(97, 103))
	else
		EmitSound("npc/zombie/foot"..math.random(1,3)..".wav", vFootPos, 0, CHAN_AUTO, 1, math.max(55, fVolume), 0, math.random(97, 103))
	end

	return true
end

FootModels["models/zombie/fast.mdl"] = function(ply, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot ~= 0 then
		EmitSound("npc/fast_zombie/foot"..math.random(1,4)..".wav", vFootPos, 0, CHAN_AUTO, 1, math.max(50, fVolume), 0, math.random(115, 120))
	end

	return true
end

function GM:PlayerFootstep(ply, vFootPos, iFoot, strSoundName, fVolume)
	local cb = FootModels[string.lower(ply:GetModel())]
	if cb then
		return cb(ply, vFootPos, iFoot, strSoundName, fVolume)
	end
end
*/