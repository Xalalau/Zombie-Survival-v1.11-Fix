local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")

-- Replace beats with cuts of hl2_song2.mp3 here:
local Beats = {}
Beats[0] = {}
Beats[1] = {"beat1.wav"}
Beats[2] = {"beat1.wav", "beat2.wav"}
Beats[3] = {"beat1.wav", "beat2.wav", "beat3.wav"}
Beats[4] = {"beat2.wav", "beat3.wav", "beat4.wav"}
Beats[5] = {"beat2.wav", "beat3.wav", "beat5.wav"}
Beats[6] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav"}
Beats[7] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat7.wav", "beat8.wav"}
Beats[8] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav", "beat7.wav"}
Beats[9] = {"beat3.wav", "beat5.wav", "beat8.wav", "beat9.wav", "beat7.wav"}
Beats[10] = {"ecky.wav"}

local ZBeats = {}
ZBeats[0] = {}
ZBeats[1] = {"zbeat1.wav"}
ZBeats[2] = {"zbeat2.wav"}
ZBeats[3] = {"zbeat3.wav"}
ZBeats[4] = {"zbeat4.wav"}
ZBeats[5] = {"zbeat5.wav"}
ZBeats[6] = {"zbeat6.wav"}
ZBeats[7] = {"zbeat7.wav"}
ZBeats[8] = {"zbeat8.wav"}
ZBeats[9] = {"zbeat8.wav"}
ZBeats[10] = {"zbeat8.wav"}

local ZBeatLength = {}
ZBeatLength[0] = 1
ZBeatLength[1] = 2.4
ZBeatLength[2] = 3.3
ZBeatLength[3] = 4.5
ZBeatLength[4] = 9.9
ZBeatLength[5] = 9.95
ZBeatLength[6] = 7.4
ZBeatLength[7] = 5.1
ZBeatLength[8] = 10.3
ZBeatLength[9] = 10.3
ZBeatLength[10] = 10.2

util.PrecacheSound("beat1.wav")
util.PrecacheSound("beat2.wav")
util.PrecacheSound("beat3.wav")
util.PrecacheSound("beat4.wav")
util.PrecacheSound("beat5.wav")
util.PrecacheSound("beat6.wav")
util.PrecacheSound("beat7.wav")
util.PrecacheSound("beat8.wav")
util.PrecacheSound("beat9.wav")
util.PrecacheSound("zbeat1.wav")
util.PrecacheSound("zbeat2.wav")
util.PrecacheSound("zbeat3.wav")
util.PrecacheSound("zbeat4.wav")
util.PrecacheSound("zbeat5.wav")
util.PrecacheSound("zbeat6.wav")
util.PrecacheSound("zbeat7.wav")
util.PrecacheSound("zbeat8.wav")
util.PrecacheSound("ecky.wav")

local BeatLength = {}
BeatLength[0] = 1.0
BeatLength[1] = 1.7
BeatLength[2] = 1.7
BeatLength[3] = 1.7
BeatLength[4] = 1.7
BeatLength[5] = 1.7
BeatLength[6] = 1.7
BeatLength[7] = 1.65
BeatLength[8] = 1.7
BeatLength[9] = 1.7
BeatLength[10] = 21.8

local BeatText = {}
BeatText[0] = "Perfectly Safe"
BeatText[1] = "Not Too Safe"
BeatText[2] = "Unsafe"
BeatText[3] = "Impending Danger"
BeatText[4] = "Dangerous"
BeatText[5] = "Very Dangerous"
BeatText[6] = "Blood Bath"
BeatText[7] = "Horror Show"
BeatText[8] = "Zombie Survival"
BeatText[9] = "Zombie Cluster-Fuck"
BeatText[10] = "OH SHI-"

local BeatColors = {}
BeatColors[0]  = Color(  0,   0, 240, 255)
BeatColors[1]  = Color( 10,  10, 225, 255)
BeatColors[2]  = Color( 50,  85, 190, 255)
BeatColors[3]  = Color(145, 145,  40, 255)
BeatColors[4]  = Color(150, 190,  10, 255)
BeatColors[5]  = Color(210, 210,   5, 255)
BeatColors[6]  = Color(190, 160,   0, 255)
BeatColors[7]  = Color(220,  90,   0, 255)
BeatColors[8]  = Color(220,  40,   0, 255)
BeatColors[9]  = Color(230,  15,   0, 255)
BeatColors[10] = Color(245,   0,   0, 255)

local ZombieHordeText = {}
ZombieHordeText[0] = "No One Around"
ZombieHordeText[1] = "All Alone"
ZombieHordeText[2] = "Undead Duo"
ZombieHordeText[3] = "Undead Trio"
ZombieHordeText[4] = "Zombie Assault"
ZombieHordeText[5] = "Flesh Pile"
ZombieHordeText[6] = "Zombie Party"
ZombieHordeText[7] = "Lawn Mower"
ZombieHordeText[8] = "Steam Roller"
ZombieHordeText[9] = "Zombie Horde"
ZombieHordeText[10] = "DEAD MEAT"

local ZombieHordeColors = {}
ZombieHordeColors[0]  = Color(  0,   0, 240, 210)
ZombieHordeColors[1]  = Color(  0,  10, 225, 210)
ZombieHordeColors[2]  = Color(  0,  30, 220, 210)
ZombieHordeColors[3]  = Color(  0,  65, 180, 210)
ZombieHordeColors[4]  = Color(  0,  95, 155, 210)
ZombieHordeColors[5]  = Color(  0, 108, 108, 210)
ZombieHordeColors[6]  = Color(  0, 130,  85, 210)
ZombieHordeColors[7]  = Color(  0, 170,  65, 210)
ZombieHordeColors[8]  = Color(  0, 210,  40, 210)
ZombieHordeColors[9]  = Color(  5, 240,   0, 210)
ZombieHordeColors[10] = Color( 25, 240,  20, 210)

local WATER_DROWNTIME = 0
local CRAMP_METER_TIME = 0

function GM:ResetWaterAndCramps()
	WATER_DROWNTIME = 0
	CRAMP_METER_TIME = 0
end

local cvar_zs_ammo_regenerate_rate = GetConVar("zs_ammo_regenerate_rate")
local cvar_zs_anti_vent_camp = GetConVar("zs_anti_vent_camp")
local cvar_zs_allow_redeeming = GetConVar("zs_allow_redeeming")
local cvar_zs_redeem_kills = GetConVar("zs_redeem_kills")
local cvar_zs_autoredeem = GetConVar("zs_autoredeem")
local cvar_zs_roundtime = GetConVar("zs_roundtime")

local NextAmmoDropOff = cvar_zs_ammo_regenerate_rate:GetInt()

local COLOR_HUD_OK = Color(0, 150, 0, 255)
local COLOR_HUD_SCRATCHED = Color(35, 130, 0, 255)
local COLOR_HUD_HURT = Color(160, 160, 0, 255)
local COLOR_HUD_CRITICAL = Color(220, 0, 0, 255)

local function GetNextAmmoRegenerate()
	return math.ceil(CurTime() / cvar_zs_ammo_regenerate_rate:GetInt()) * cvar_zs_ammo_regenerate_rate:GetInt()
end

function GM:InitPostEntity()
	NextAmmoDropOff = GetNextAmmoRegenerate()
end
local NextHordeCalculate = 0
local DisplayHorde = 0
local ActualHorde = 0
local NextThump = 0

function GM:SetLastHumanText()
	if LASTHUMAN then
		BeatText[10] = "LAST HUMAN!"
		ZombieHordeText[10] = "LAST HUMAN!"
		NextHordeCalculate = 999999
		NearZombies = 10
		DisplayHorde = 10
		ActualHorde = 10
	end
end

function GM:SetUnlifeText()
	if UNLIFE then
		//BeatText[10] = "Un-Life"
		//ZombieHordeText[10] = "Un-Life"
		NearZombies = 10
	end
end

function GM:SetHalflifeText()
	if HALFLIFE then
		//BeatText[5] = "Half-Life"
		//ZombieHordeText[5] = "Half-Life"
		NearZombies = 5
	end
end


local ENABLE_BEATS = CreateClientConVar("_zs_enablebeats", 1, true, false)
local function EnableBeats(sender, command, arguments)
	local ply = LocalPlayer()

	if tobool(arguments[1]) then
		RunConsoleCommand("_zs_enablebeats", "1")
		ply:ChatPrint("Beats enabled.")
	else
		RunConsoleCommand("_zs_enablebeats", "0")
		ply:ChatPrint("Beats disabled.")
	end
end
concommand.Add("zs_enablebeats", EnableBeats)

function GM:Think()
	local ply = LocalPlayer()
	if not ply:IsValid() then return end

	local curtime = CurTime()
	local realtime = RealTime()

	if ply:Team() == TEAM_UNDEAD then
		if DisplayHorde ~= ActualHorde and not LASTHUMAN then
			if ActualHorde <= 0 then
				DisplayHorde = math.min(math.Approach(DisplayHorde, ActualHorde, FrameTime() * 10), 10)
			else
				DisplayHorde = math.min(math.Approach(DisplayHorde, ActualHorde, FrameTime() * 5), 10)
			end
		end

		if not LASTHUMAN and NextHordeCalculate < curtime then
			ActualHorde = math.min((GetZombieFocus2(ply:GetPos(), 300, 0.001, 0) - 0.0001) * 10, 10)
			local rounded = math.Round(DisplayHorde)
			NextHordeCalculate = curtime + ZBeatLength[rounded]
			if ENABLE_BEATS:GetBool() and not UNLIFE then
				for i, beat in pairs(ZBeats[rounded]) do
					surface.PlaySound(beat)
				end
			end
		end
	else
		local mypos = ply:GetPos()
		if NearZombies ~= ActualNearZombies and not LASTHUMAN then
			if ActualNearZombies <= 0 then
				NearZombies = math.min(math.Approach(NearZombies, ActualNearZombies, FrameTime() * 10), 10)
			else
				NearZombies = math.min(math.Approach(NearZombies, ActualNearZombies, FrameTime() * 5), 10)
			end
		end

		if not LASTHUMAN and NextThump <= realtime then
			ActualNearZombies = math.min(GetZombieFocus2(ply:GetPos(), 300, 0.001, 0) * 10, 10)
			local rounded = math.Round(NearZombies)
			NextThump = realtime + BeatLength[rounded]
			if ENABLE_BEATS:GetBool() and not UNLIFE then
				for i, beat in pairs(Beats[rounded]) do
					surface.PlaySound(beat)
				end
			end
		end

		if cvar_zs_anti_vent_camp:GetBool() then
			local cramped = util.TraceLine({start = mypos, endpos = mypos + Vector(0,0,64), filter = ply, mask=COLLISION_GROUP_DEBRIS}).HitWorld
			if cramped then
				CRAMP_METER_TIME = math.min(CRAMP_METER_TIME + FrameTime(), 60)
				if 60 <= CRAMP_METER_TIME then
					RunConsoleCommand("cramped_death")
					CRAMP_METER_TIME = 0
				end
			elseif 0 < CRAMP_METER_TIME then
				CRAMP_METER_TIME = math.max(CRAMP_METER_TIME - FrameTime() * 3, 0)
			end
		end
	end
end

function GM:HumanHUD(ply, killedposx, killedposy)
	local rounded = math.Round(NearZombies)

	// Health
	local entityhealth = math.max(ply:Health(), 0)
	local colortouse

	if 80 < entityhealth then
		colortouse = COLOR_HUD_OK
	elseif 50 < entityhealth then
		colortouse = COLOR_HUD_SCRATCHED
	elseif 30 < entityhealth then
		colortouse = COLOR_HUD_HURT
	else
		colortouse = COLOR_HUD_CRITICAL
	end

	draw.SimpleText("HP", "HUDFontSmallAA", 16, h - 56, colortouse, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	//draw.SimpleText(entityhealth, "DefaultBold", 16, h - 56, colortouse, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if 30 < entityhealth then
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, 255)
	else
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, math.sin(RealTime() * 6) * 127.5 + 127.5)
	end

	surface.SetTexture(matHealthBar)
	surface.DrawTexturedRect(35, h - 62, (entityhealth / 100) * 213, 14)

	local col = BeatColors[rounded]
	surface.SetDrawColor(col.r, col.g, col.b, 180)
	surface.SetTexture(matHealthBar)
	surface.DrawTexturedRect(10, h - 36, NearZombies * 23.6, 24)
	//draw.SimpleText(BeatText[rounded], "HUDFontSmallAA", 128, h - 24, COLOR_GRAY_HUD, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(BeatText[rounded], "HUDFontTinyAA", 128, h - 42, COLOR_GRAY_HUD, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	// Kill display
	draw.DrawText("Kills: "..ply:Frags(), "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED_HUD, TEXT_ALIGN_LEFT)

	if not ENDROUND then
		if SURVIVALMODE then
			draw.DrawText("Survival Mode", "DefaultSmall", 248, h - 90, COLOR_GRAY, TEXT_ALIGN_LEFT)
		else
			local curtime = CurTime()
			local TimeLeft = NextAmmoDropOff - curtime

			if TimeLeft < 0 then
				NextAmmoDropOff = GetNextAmmoRegenerate()
			end
			draw.DrawText("Ammo Regeneration: "..ToMinutesSeconds(TimeLeft), "HUDFontTinyAA", 8, h - 90, COLOR_GRAY, TEXT_ALIGN_LEFT)
		end

		if 2 < ply:WaterLevel() then
			WATER_DROWNTIME = math.min(WATER_DROWNTIME + FrameTime(), 30)
			if 30 <= WATER_DROWNTIME then
				RunConsoleCommand("water_death")
				WATER_DROWNTIME = 0
			elseif 20 < WATER_DROWNTIME then
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0.45, FrameTime() * 0.2)
				//ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 0, FrameTime() * 0.25)
			end
			draw.DrawText("Air", "DefaultBold", w*0.5, h*0.3, COLOR_WHITE, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine(w*0.5, h*0.33, w*0.75, h*0.33)
			surface.SetDrawColor(40, 40, 255, 255)
			surface.DrawLine(w*0.5, h*0.33, w*0.5 + w*0.25 * (WATER_DROWNTIME / 30), h*0.33)
		elseif 0 < WATER_DROWNTIME then
			WATER_DROWNTIME = math.max(WATER_DROWNTIME - FrameTime() * 3, 0)
			if WATER_DROWNTIME <= 0 then
				ColorModify["$pp_colour_addb"] = 0
				//ColorModify["$pp_colour_colour"] = 1
			else
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0, FrameTime() * 0.3)
				//ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 1, FrameTime())
			end
			draw.DrawText("Air", "DefaultBold", w*0.6, h*0.3, COLOR_WHITE, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine(w*0.6, h*0.33, w*0.85, h*0.33)
			surface.SetDrawColor(40, 40, 255, 255)
			surface.DrawLine(w*0.6, h*0.33, w*0.6 + w*0.25 * (WATER_DROWNTIME / 30), h*0.33)
		end

		if 20 < CRAMP_METER_TIME then
			draw.DrawText("BUTT CRAMPS!", "DefaultBold", w*0.6, h*0.4, COLOR_RED, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine(w*0.6, h*0.43, w*0.85, h*0.43)
			surface.SetDrawColor(40, 40, 255, 255)
			surface.DrawLine(w*0.6, h*0.43, w*0.6 + w*0.25 * (CRAMP_METER_TIME / 60), h*0.43)
		end
	end
end

local NextAura = 0

function GM:ZombieHUD(ply, actionposx, actionposy, killedposx, killedposy)
	if not ply.Class then return end

	local entityhealth = math.max(ply:Health(), 0)
	local maxhealth = ZombieClasses[ply.Class].Health
	local percenthealth = entityhealth / maxhealth

	local colortouse

	if 0.8 < percenthealth then
		colortouse = COLOR_HUD_OK
	elseif 0.5 < percenthealth then
		colortouse = COLOR_HUD_SCRATCHED
	elseif 0.3 < percenthealth then
		colortouse = COLOR_HUD_HURT
	else
		colortouse = COLOR_HUD_CRITICAL
	end

	draw.SimpleText(entityhealth, "HUDFontSmall", 16, h - 56, colortouse, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local realtime = RealTime()

	if 0.3 < percenthealth then
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, 255)
	else
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, (math.sin(realtime * 6) * 127.5) + 127.5)
	end

	surface.SetTexture(matHealthBar)
	surface.DrawTexturedRect(35, h - 62, (entityhealth / maxhealth) * 213, 14)

	local rounded = math.Round(DisplayHorde)
	local col = ZombieHordeColors[rounded]
	surface.SetDrawColor(col.r, col.g, col.b, 255)
	surface.SetTexture(matHealthBar)
	surface.DrawTexturedRect(10, h - 36, DisplayHorde * 23.6, 24)
	draw.SimpleText(ZombieHordeText[rounded], "HUDFontTinyAA", 128, h - 42, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local killz = ply:Frags()
	local allow_redeeming = cvar_zs_allow_redeeming:GetBool()
	local redeem_kills = cvar_zs_redeem_kills:GetInt()
	local autoredeem = cvar_zs_autoredeem:GetBool()
	if SMALL_HUD then
		draw.DrawText("Feed: "..ToMinutesSeconds(cvar_zs_roundtime:GetInt() - CurTime()), "HUDFontSmall", actionposx, actionposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)

		if allow_redeeming then
			if autoredeem then
				draw.DrawText("Redemption: " .. redeem_kills - killz, "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)
			else
				if redeem_kills <= killz then
					draw.DrawText("Redeem: F2!", "HUDFontSmall", killedposx, killedposy, COLOR_WHITE, TEXT_ALIGN_LEFT)
				else
					draw.DrawText("Redemption: " .. redeem_kills - killz, "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)
				end
			end
		else
			draw.DrawText("Brains: "..killz, "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)
		end
	else
		draw.DrawText("Feed: "..ToMinutesSeconds(cvar_zs_roundtime:GetInt() - CurTime()), "HUDFontSmall", actionposx, actionposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)

		if allow_redeeming then
			if autoredeem then
				draw.DrawText("Redemption: " .. redeem_kills - killz, "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)
			else
				if redeem_kills <= killz then
					draw.DrawText("Redeem: F2!", "HUDFontSmall", killedposx, killedposy, COLOR_WHITE, TEXT_ALIGN_LEFT)
				else
					draw.DrawText("Redemption: " .. redeem_kills - killz, "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)
				end
			end
		else
			draw.DrawText("Brains: "..killz, "HUDFontSmall", killedposx, killedposy, COLOR_DARKRED, TEXT_ALIGN_LEFT)
		end
	end

	if NextAura < realtime then
		NextAura = realtime + 1.25 - DisplayHorde * 0.1
		local mypos = ply:GetPos()
		local cap = 0
		local auras = {}
		for _, curPly in ipairs(player.GetHumans()) do
			if 10 <= cap then break end

			if curPly:Team() == TEAM_HUMAN and curPly:Alive() then
				local pos = curPly:GetPos()
				if pos:Distance(mypos) < 1024 and pos:ToScreen().visible then
					auras[curPly] = pos
					cap = cap + 1
				end
			end
		end

		if 0 < cap then
			local emitter = ParticleEmitter(EyePos())

			for curPly, pos in pairs(auras) do
				local vel = curPly:GetVelocity() * 0.95
				local health = curPly:Health()
				local attach = curPly:GetAttachment(curPly:LookupAttachment("chest"))
				if not attach then
					attach = {Pos=curPly:GetPos() + Vector(0,0,48)}
				end

				local particle = emitter:Add("Sprites/light_glow02_add_noz", attach.Pos)
				particle:SetVelocity(vel)
				particle:SetDieTime(math.Rand(1, 1.2))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(14, 18))
				particle:SetEndSize(4)
				particle:SetColor(255 - health * 2, health * 2.1, 30)
				particle:SetRoll(math.Rand(0, 359))
				particle:SetRollDelta(math.Rand(-2, 2))

				for x=1, math.random(1, 3) do
					local particle = emitter:Add("Sprites/light_glow02_add_noz", attach.Pos + VectorRand() * 3)
					particle:SetVelocity(vel)
					particle:SetDieTime(math.Rand(0.9, 1.1))
					particle:SetStartAlpha(255)
					particle:SetStartSize(math.Rand(10, 14))
					particle:SetEndSize(0)
					particle:SetColor(255 - health * 2, health * 2.1, 30)
					particle:SetRoll(math.Rand(0, 359))
					particle:SetRollDelta(math.Rand(-2, 2))
				end
			end

			emitter:Finish()
		end
	end
end
