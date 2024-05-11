MySelf = NULL
hook.Add("Think", "GetLocal", function()
	MySelf = LocalPlayer()
	if MySelf:IsValid() then
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

	if FORCE_NORMAL_GAMMA then
		RunConsoleCommand("mat_monitorgamma", "2.2")
		timer.Create("GammaChecker", 3, 0, function() RunConsoleCommand("mat_monitorgamma", "2.2") end)
	end
end

function GM:PlayerDeath(pl, attacker)
end

local function LoopLastHuman()
	if not ENDROUND then
		surface.PlaySound(LASTHUMANSOUND)
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
	return name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudSecondaryAmmo"
end

local function ReceiveTopTimes(um)
	local index = um:ReadShort()
	Top[index] = um:ReadString()
	if Top[index] == "Downloading" or Top[index] == "[STRING NOT POOLED]" then
		Top[index] = nil
	else
		Top[index] = index..". "..Top[index]
	end
end
usermessage.Hook("RcTopTimes", ReceiveTopTimes)

local function ReceiveTopZombies(um)
	local index = um:ReadShort()
	TopZ[index] = um:ReadString()
	if TopZ[index] == "Downloading" or TopZ[index] == "[STRING NOT POOLED]" then
		TopZ[index] = nil
	else
		TopZ[index] = index..". "..TopZ[index]
	end
end
usermessage.Hook("RcTopZombies", ReceiveTopZombies)

local function ReceiveTopHumanDamages(um)
	local index = um:ReadShort()
	TopHD[index] = um:ReadString()
	if TopHD[index] == "Downloading" or TopHD[index] == "[STRING NOT POOLED]" then
		TopHD[index] = nil
	else
		TopHD[index] = index..". "..TopHD[index]
	end
end
usermessage.Hook("RcTopHumanDamages", ReceiveTopHumanDamages)

local function ReceiveTopZombieDamages(um)
	local index = um:ReadShort()
	TopZD[index] = um:ReadString()
	if TopZD[index] == "Downloading" or TopZD[index] == "[STRING NOT POOLED]" then
		TopZD[index] = nil
	else
		TopZD[index] = index..". "..TopZD[index]
	end
end
usermessage.Hook("RcTopZombieDamages", ReceiveTopZombieDamages)

local function ReceiveHeadcrabScale(um)
	local MySelf = LocalPlayer()

	local pl = um:ReadEntity()
	if pl:IsValid() then
		--pl:SetModelScale(Vector(2,2,2))
		if pl == MySelf then
			HCView = true
			hook.Add("Think", "HCView", function()
				if MySelf:Health() <= 0 then
					HCView = false
					hook.Remove("Think", "HCView")
				end
			end)
		end
	end
end
usermessage.Hook("RcHCScale", ReceiveHeadcrabScale)

function GM:HUDPaintBackground()
end

local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")
local matUIBottomLeft = surface.GetTextureID("zombiesurvival/zs_ui_bottomleft")
function GM:HUDPaint()
	if not MySelf:IsValid() then return end

	-- Width, height
	h = ScrH()
	w = ScrW()

	surface.SetDrawColor(255, 255, 255, 180)
	surface.SetTexture(matUIBottomLeft)
	surface.DrawTexturedRect(0, h - 72, 256, 64)

	local myteam = MySelf:Team()

	-- TargetID
	self:HUDDrawTargetID(MySelf, myteam)

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

	draw.RoundedBox(16, 0, 0, w*0.25, h*0.11, color_black_alpha90)
	local w05 = w * 0.05
	local h05 = h * 0.05
	surface.SetDrawColor(235, 235, 235, 255)
	surface.SetTexture(matZomboHeadID)
	surface.DrawTexturedRect(0, 0, w05, h05)
	surface.SetTexture(matHumanHeadID)
	surface.DrawTexturedRect(0, h05, w05, h05)
	draw.DrawText(zombies, "HUDFontAA", w05, 0, COLOR_DARKGREEN, TEXT_ALIGN_LEFT)
	draw.DrawText(zombies, "HUDFontAA", w05, 0, COLOR_DARKGREEN, TEXT_ALIGN_LEFT)
	draw.DrawText(humans, "HUDFontAA", w05, h05, COLOR_DARKBLUE, TEXT_ALIGN_LEFT)
	draw.DrawText(humans, "HUDFontAA", w05, h05, COLOR_DARKBLUE, TEXT_ALIGN_LEFT)

	-- Death Notice
	self:DrawDeathNotice(0.8, 0.04)

	if myteam == TEAM_UNDEAD then
		self:ZombieHUD(MySelf)
	else
		self:HumanHUD(MySelf)
		draw.DrawText("Survive: "..ToMinutesSeconds(ROUNDTIME - CurTime()), "HUDFontSmallAA", w*0.09, 0, COLOR_GRAY, TEXT_ALIGN_LEFT)
	end

	-- Infliction
	draw.DrawText("Infliction: " .. math.floor(INFLICTION * 100) .. "%", "HUDFontSmallAA", 8, h - 112, COLOR_INFLICTION, TEXT_ALIGN_LEFT)
end

util.PrecacheSound("npc/stalker/breathing3.wav")
util.PrecacheSound("npc/zombie/zombie_pain6.wav")
function GM:PlayerBindPress(pl, bind)
	if bind == "+walk" then
		return true
	--[[elseif bind == "impulse 100" then
		return pl:Team() == TEAM_UNDEAD]]--
	elseif bind == "+speed" and pl:Team() == TEAM_UNDEAD then
		if DLV then
			pl:EmitSound("npc/zombie/zombie_pain6.wav", 100, 110)
			DoZomC()
		else
			pl:EmitSound("npc/stalker/breathing3.wav", 100, 230)
			DLVC()
		end
	end
end

function GM:CalcView(pl, pos, ang, _fov)
	if not MySelf:IsValid() then return end

	if MySelf:GetRagdollEntity() then
		local phys = MySelf:GetRagdollEntity():GetPhysicsObjectNum(12)
		local ragdoll = MySelf:GetRagdollEntity()
		if ragdoll then
			local lookup = MySelf:LookupAttachment("eyes")
			if lookup then
				local attach = ragdoll:GetAttachment(lookup)
				if attach then
					return {origin=attach.Pos + attach.Ang:Forward() * -5, angles=attach.Ang}
				end
			end
		end
	end

	if (MySelf:Health() <= 30 and MySelf:Team() == TEAM_HUMAN) or MySelf:WaterLevel() > 2 then
		ang.roll = ang.roll + math.sin(RealTime()) * 7
	end

	if HCView then
		if not MySelf:KeyDown(IN_DUCK) then
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

function Intermission(nextmap, winner)
	ENDROUND = true
	hook.Remove("RenderScreenspaceEffects", "PostProcess")
	ENDTIME = CurTime()
	DrawingDanger = 0
	NearZombies = 0
	NextThump = 999999
	RunConsoleCommand("stopsounds")
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

		draw.DrawText("Next: "..ToMinutesSeconds(ENDTIME + INTERMISSION_TIME - CurTime()), "HUDFontSmall", w*0.5, h*0.7, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

local function SetInf(um)
	INFLICTION = um:ReadFloat()

	local sound = false
	local amount = 0
	local UnlockedClass
	for i in ipairs(ZombieClasses) do
		if ZombieClasses[i].Threshold <= INFLICTION and not ZombieClasses[i].Unlocked then
			ZombieClasses[i].Unlocked = true
			UnlockedClass = ZombieClasses[i].Name
			sound = true
			amount = amount + 1
		end
	end

	if not LASTHUMAN then
		if INFLICTION >= 0.75 and not UNLIFE then
			UNLIFE = true
			HALFLIFE = true
			RunConsoleCommand("stopsounds")
			timer.Simple(0.5, LoopUnlife)
			GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Un-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked at 75%</font></color>")
			GAMEMODE:SetUnlifeText()
		elseif INFLICTION >= 0.5 and not HALFLIFE then
			HALFLIFE = true
			GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Half-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 50%</font></color>")
			GAMEMODE:SetHalflifeText()
		elseif sound then
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
usermessage.Hook("SetInf", SetInf)

local function SetInfInit(um)
	INFLICTION = um:ReadFloat()
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
usermessage.Hook("SetInfInit", SetInfInit)
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

function GM:KeyPress(pl, key)
	if key == IN_USE and MySelf:Team() == TEAM_HUMAN then
		local ent = util.TraceLine({start = MySelf:EyePos(), endpos = MySelf:EyePos() + MySelf:GetAimVector() * 50, filter = MySelf}).Entity
		if ent and ent:IsValid() and ent:IsPlayer() then
			RunConsoleCommand("shove", ent:EntIndex())
		end
	end
end

/*function DrawDeath()
	if MySelf:Alive() then
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

	if not MySelf:GetRagdollEntity() then
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
		if not DISABLE_PP and 90 <= render.GetDXLevel() then
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

		if not DISABLE_PP then
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
FootModels["models/zombie/classic.mdl"] = function(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and math.random(1, 2) < 2 then
		WorldSound("npc/zombie/foot_slide"..math.random(1,3)..".wav", vFootPos, math.max(55, fVolume), math.random(97, 103))
	else
		WorldSound("npc/zombie/foot"..math.random(1,3)..".wav", vFootPos, math.max(55, fVolume), math.random(97, 103))
	end

	return true
end

FootModels["models/zombie/fast.mdl"] = function(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot ~= 0 then
		WorldSound("npc/fast_zombie/foot"..math.random(1,4)..".wav", vFootPos, math.max(50, fVolume), math.random(115, 120))
	end

	return true
end

function GM:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume)
	local cb = FootModels[string.lower(pl:GetModel())]
	if cb then
		return cb(pl, vFootPos, iFoot, strSoundName, fVolume)
	end
end
*/