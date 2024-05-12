local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")

-- Replace beats with cuts of hl2_song2.mp3 here:
local Beats = {}
Beats[0] = {}
Beats[1] = {"beat1.wav"}
Beats[2] = {"beat1.wav", "beat2.wav"}
Beats[3] = {"beat2.wav", "beat3.wav"}
Beats[4] = {"beat2.wav", "beat3.wav", "beat5.wav"}
Beats[5] = {"beat1.wav", "beat2.wav", "beat8.wav"}
Beats[6] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat7.wav", "beat8.wav"}
Beats[7] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav"}
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

local NextAmmoDropOff = AMMO_REGENERATE_RATE

local COLOR_HUD_OK = Color(0, 150, 0, 255)
local COLOR_HUD_SCRATCHED = Color(35, 130, 0, 255)
local COLOR_HUD_HURT = Color(160, 160, 0, 255)
local COLOR_HUD_CRITICAL = Color(220, 0, 0, 255)

function GM:InitPostEntity()
	NextAmmoDropOff = math.ceil(CurTime() / AMMO_REGENERATE_RATE) * AMMO_REGENERATE_RATE
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
		BeatText[10] = "Un-Life"
		ZombieHordeText[10] = "Un-Life"
		NearZombies = 7.5
	end
end

function GM:SetHalflifeText()
	if HALFLIFE then
		BeatText[5] = "Half-Life"
		ZombieHordeText[5] = "Half-Life"
		NearZombies = 5
	end
end

CreateClientConVar("_zs_enablebeats", 1, true, false)
local ENABLE_BEATS = util.tobool(GetConVarNumber("_zs_enablebeats"))
local function EnableBeats(sender, command, arguments)
	ENABLE_BEATS = util.tobool(arguments[1])

	if ENABLE_BEATS then
		RunConsoleCommand("_zs_enablebeats", "1")
		MySelf:ChatPrint("Beats enabled.")
	else
		RunConsoleCommand("_zs_enablebeats", "0")
		MySelf:ChatPrint("Beats disabled.")
	end
end
concommand.Add("zs_enablebeats", EnableBeats)

local WATER_DROWNTIME

local lasttime = CurTime()
local tictime = 0.1
function GM:Think()
	if not MYSELFVALID then return end

	local myteam = MySelf:Team()
	for k,v in pairs(player.GetAll()) do
		if v:Team() == myteam then
			v:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		else
			v:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		end
	end

	local curtime = CurTime()
	local realtime = RealTime()

	tictime = curtime - lasttime
	lasttime = curtime

	if myteam == TEAM_UNDEAD then
		if DisplayHorde ~= ActualHorde and not LASTHUMAN then
			if ActualHorde <= 0 then
				DisplayHorde = math.min(math.Approach(DisplayHorde, ActualHorde, FrameTime() * 4), 10)
			elseif DisplayHorde < ActualHorde then
				DisplayHorde = math.min(math.Approach(DisplayHorde, ActualHorde, FrameTime() * 2), 10)
			else
				DisplayHorde = math.min(math.Approach(DisplayHorde, ActualHorde, FrameTime()), 10)
			end
		end

		if not ENDROUND and not LASTHUMAN and NextHordeCalculate < curtime then
			ActualHorde = math.min((GetZombieFocus2(MySelf:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.0001) * 10, 10)
			local rounded = math.Round(DisplayHorde)
			NextHordeCalculate = curtime + ZBeatLength[rounded]
			if ENABLE_BEATS then --and not UNLIFE then
				for i, beat in pairs(ZBeats[rounded]) do
					surface.PlaySound(beat)
				end
			end
		end
	else
		local mypos = MySelf:GetPos()
		if NearZombies ~= ActualNearZombies and not LASTHUMAN then
			if ActualNearZombies <= 0 then
				NearZombies = math.min(math.Approach(NearZombies, ActualNearZombies, FrameTime() * 4), 10)
			elseif NearZombies < ActualNearZombies then
				NearZombies = math.min(math.Approach(NearZombies, ActualNearZombies, FrameTime() * 2), 10)
			else
				NearZombies = math.min(math.Approach(NearZombies, ActualNearZombies, FrameTime()), 10)
			end
		end

		if not ENDROUND then
			if not LASTHUMAN and NextThump <= realtime then
				ActualNearZombies = math.min(GetZombieFocus(MySelf:GetPos(), FOCUS_RANGE, 0.001, 0) * 10, 10)
				local rounded = math.Round(NearZombies)
				NextThump = realtime + BeatLength[rounded]
				if ENABLE_BEATS then --and not UNLIFE then
					for i, beat in pairs(Beats[rounded]) do
						surface.PlaySound(beat)
					end
				end
			end

			if 2 < MySelf:WaterLevel() and MySelf:Alive() then
				WATER_DROWNTIME = WATER_DROWNTIME or curtime + 30
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0.45, FrameTime() * 0.2)
			elseif ColorModify["$pp_colour_addb"] ~= 0 then
				WATER_DROWNTIME = nil
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0, FrameTime() * 0.3)
			end
		end
	end
end

function GM:Move(pl, move)
	local speed = move:GetForwardSpeed()
	local sidespeed = move:GetSideSpeed()
	if pl:Team() == TEAM_HUMAN then
		if speed < 0 and speed - math.abs(sidespeed) < -130 then -- They're walking backwards but don't slow down already slow weapons.
			move:SetForwardSpeed(speed * 0.6) -- Fraction it.
			move:SetSideSpeed(sidespeed * 0.6) -- Also fraction this.
		end
	end

	if pl:IsOnGround() then
		local plpos = pl:GetPos()
		for _, ent in pairs(player.GetAll()) do
			if ent ~= pl and ent:IsPlayer() and ent:Team() == pl:Team() and ent:Alive() then
				local entpos = ent:GetPos()
				local dist = plpos:Distance(entpos)
				if dist < 24 then
					move:SetVelocity(move:GetVelocity() + math.max(12, 24 - dist) * FrameTime() * 80 * (plpos - entpos):Normalize())
				end
			end
		end
	end
end

local nextreward = -1
local lastwarntim = -1
local lasthealth = 0
local lasthealthupdate = 0
function GM:HumanHUD(MySelf, x, th)
	local curtime = CurTime()

	--[[local entityhealth = math.max(MySelf:Health(), 0)

	surface.SetFont("HUDIcons")
	local fHudW, fHudH = surface.GetTextSize("F")
	if 30 < entityhealth then
		draw.DrawTextShadow("F", "HUDIcons", w * 0.5 - 4, h - fHudH * 1.5, Color(255 - entityhealth * 2.54, entityhealth * 1.7, 0, 255), color_black, TEXT_ALIGN_RIGHT)
	else
		local alpha = math.sin(RealTime() * 6) * 127.5 + 127.5
		draw.DrawTextShadow("F", "HUDIcons", w * 0.5 - 4, h - fHudH * 1.5, Color(255 - entityhealth * 2.54, entityhealth * 1.7, 0, alpha), Color(0,0,0,alpha), TEXT_ALIGN_RIGHT)
	end
	draw.DrawTextShadow("C", "HUDIcons", w * 0.5 + 4, h - fHudH * 1.5, Color(NearZombies * 190, 140 - NearZombies * 139, 0, 255), color_black, TEXT_ALIGN_LEFT)
]]
	local rounded = math.Round(NearZombies)

	local entityhealth = math.max(MySelf:Health(), 0)
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

	--draw.SimpleText("HP", "HUDFontSmallAA", 16, h - 56, colortouse, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(entityhealth, "DefaultBold", 16, h - 56, colortouse, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if 30 < entityhealth then
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, 255)
	else
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, math.sin(RealTime() * 6) * 127.5 + 127.5)
	end

	surface.SetTexture(matHealthBar)
	surface.DrawTexturedRect(35, h - 62, (entityhealth / 100) * 213, 14)
	draw.SimpleText(BeatText[rounded], "HUDFontTinyAA", 128, h - 42, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local col = BeatColors[rounded]
	surface.SetDrawColor(col.r, col.g, col.b, 255)
	surface.DrawTexturedRect(10, h - 36, NearZombies * 23.6, 24)
	draw.SimpleText(BeatText[rounded], "HUDFontTinyAA", 128, h - 42, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local frags = MySelf:Frags()
	if nextreward ~= 9999 and nextreward <= frags then
		local maxn = table.maxn(self.Rewards)
		for i=1, maxn do
			if self.Rewards[i] and frags < i then
				nextreward = i
				break
			elseif i == maxn then
				nextreward = 9999
			end
		end
	end
	-- Kill display
	if nextreward == 9999 then
		draw.DrawText("Kills: "..frags, "HUDFontSmall", x, th * 2, COLOR_DARKRED_HUD, TEXT_ALIGN_LEFT)
	else
		draw.DrawText("Kills: "..frags.." | Needed: "..nextreward, "HUDFontSmall", x, th * 2, COLOR_DARKRED_HUD, TEXT_ALIGN_LEFT)
	end

	if not ENDROUND then
		local TimeLeft = NextAmmoDropOff - curtime
		if TimeLeft <= 0 then
			NextAmmoDropOff = math.ceil(curtime / AMMO_REGENERATE_RATE) * AMMO_REGENERATE_RATE
		end

		if WAVEZERO_LENGTH < curtime then
			draw.DrawText("Ammo Regeneration: "..string.ToMinutesSeconds(TimeLeft), "HUDFontSmallAA", 8, h - 98, COLOR_GRAY, TEXT_ALIGN_LEFT)
		else
			surface.SetFont("HUDFontSmallAA")
			local txtw, txth = surface.GetTextSize("Hi")
			draw.DrawText("Waiting for players... "..string.ToMinutesSeconds(math.max(0, WAVEZERO_LENGTH - curtime)), "HUDFontSmallAA", w * 0.5, h * 0.25, COLOR_GRAY, TEXT_ALIGN_CENTER)
			draw.DrawText("Go to an undead spawn area if you want to start as zombie", "HUDFontSmallAA", w * 0.5, h * 0.25 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER)

			local vols = 0
			local voltab = {}
			local allplayers = player.GetAll()
			for _, gasses in pairs(ents.FindByClass("zombiegasses")) do
				local gaspos = gasses:GetPos()
				for _, ent in pairs(allplayers) do
					if ent:GetPos():Distance(gaspos) <= 272 and not table.HasValue(voltab, ent) then
						vols = vols + 1
						table.insert(voltab, ent)
					end
				end
			end

			for _, pl in pairs(allplayers) do
				if pl:Team() == TEAM_UNDEAD then
					vols = vols + 1
					table.insert(voltab, pl)
				end
			end

			local numplayers = #allplayers
			local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))

			draw.DrawText("Number of initial zombies this game ("..WAVE_ONE_ZOMBIES * 100 .."%): "..desiredzombies, "HUDFontSmallAA", w * 0.5, h * 0.75, COLOR_GRAY, TEXT_ALIGN_CENTER)

			draw.DrawText("Zombie volunteers: "..vols, "HUDFontSmallAA", w * 0.5, h * 0.75 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER)
			surface.SetFont("Default")
			local y = h * 0.75 + txth * 2
			txtw, txth = surface.GetTextSize("Hi")
			for _, pl in pairs(voltab) do
				if h - txth <= y then break else
					draw.DrawText(pl:Name(), "DefaultBold", w * 0.5, y, COLOR_GRAY, TEXT_ALIGN_CENTER)
					y = y + txth
				end
			end
		end

		if WATER_DROWNTIME and 0 < WATER_DROWNTIME then
			draw.DrawText("Oxygen", "DefaultBold", w*0.6, h*0.3, COLOR_WHITE, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine(w*0.6, h*0.33, w*0.85, h*0.33)
			surface.SetDrawColor(40, 40, 255, 255)
			surface.DrawLine(w*0.6, h*0.33, w*0.6 + w*0.25 * (math.max(0, WATER_DROWNTIME - curtime) / 30), h*0.33)
		end
	end
end

CreateClientConVar("_zs_enableauras", 1, true, false)
local ENABLE_AURAS = util.tobool(GetConVarNumber("_zs_enableauras"))
local function EnableAuras(sender, command, arguments)
	ENABLE_AURAS = util.tobool(arguments[1])

	if ENABLE_AURAS then
		RunConsoleCommand("_zs_enableauras", "1")
		MySelf:ChatPrint("Auras enabled.")
	else
		RunConsoleCommand("_zs_enableauras", "0")
		MySelf:ChatPrint("Auras disabled.")
	end
end
concommand.Add("zs_enableauras", EnableAuras)

local NextAura = 0

function GM:ZombieHUD(MySelf, x, th)
	local realtime = RealTime()

	if MySelf:Alive() then
		local entityhealth = math.max(MySelf:Health(), 0)
		local maxhealth = self.ZombieClasses[MySelf.Class or 1].Health
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

		if 0.3 < percenthealth then
			surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, 255)
		else
			surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, (math.sin(realtime * 6) * 127.5) + 127.5)
		end

		surface.SetTexture(matHealthBar)
		surface.DrawTexturedRect(35, h - 62, math.min(percenthealth, 1) * 213, 14)
	end

	surface.SetTexture(matHealthBar)
	local rounded = math.Round(DisplayHorde)
	local col = ZombieHordeColors[rounded]
	surface.SetDrawColor(col.r, col.g, col.b, 255)
	surface.SetTexture(matHealthBar)
	surface.DrawTexturedRect(10, h - 36, DisplayHorde * 23.6, 24)
	draw.SimpleText(ZombieHordeText[rounded], "HUDFontTinyAA", 128, h - 42, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local killz = MySelf:Frags()

	if REDEEM then
		if AUTOREDEEM then
			draw.DrawText("Redemption: " .. REDEEM_KILLS - killz, "HUDFontSmall", x, th * 2, COLOR_DARKRED, TEXT_ALIGN_LEFT)
		else
			if REDEEM_KILLS <= killz then
				draw.DrawText("Redeem: F2!", "HUDFontSmall", x, th * 2, COLOR_WHITE, TEXT_ALIGN_LEFT)
			else
				draw.DrawText("Redemption: " .. REDEEM_KILLS - killz, "HUDFontSmall", x, th * 2, COLOR_DARKRED, TEXT_ALIGN_LEFT)
			end
		end
	else
		draw.DrawText("Brains eaten: "..killz, "HUDFontSmall", x, th * 2, COLOR_DARKRED, TEXT_ALIGN_LEFT)
	end

	if ENABLE_AURAS and NextAura < realtime then
		NextAura = realtime + 1.25 - DisplayHorde * 0.1
		local mypos = MySelf:GetPos()
		local cap = 0
		local auras = {}
		for _, pl in pairs(player.GetAll()) do
			if 10 <= cap then break end

			if pl:Team() == TEAM_HUMAN and pl:Alive() then
				local pos = pl:GetPos()
				if pos:Distance(mypos) < 1024 and pos:ToScreen().visible then
					auras[pl] = pos
					cap = cap + 1
				end
			end
		end

		if 0 < cap then
			local emitter = ParticleEmitter(MySelf:EyePos())

			for pl, pos in pairs(auras) do
				local vel = pl:GetVelocity() * 0.95
				local health = pl:Health()
				local attach = pl:GetAttachment(pl:LookupAttachment("chest"))
				local pos
				if attach then
					pos = attach.Pos
				else
					pos = pl:GetPos() + Vector(0,0,48)
				end

				local particle = emitter:Add("Sprites/light_glow02_add_noz", pos)
				particle:SetVelocity(vel)
				particle:SetDieTime(math.Rand(1, 1.2))
				particle:SetStartAlpha(255)
				particle:SetStartSize(math.Rand(14, 18))
				particle:SetEndSize(4)
				particle:SetColor(255 - health * 2, health * 2.1, 30)
				particle:SetRoll(math.Rand(0, 359))
				particle:SetRollDelta(math.Rand(-2, 2))

				for x=1, math.random(1, 3) do
					local particle = emitter:Add("Sprites/light_glow02_add_noz", pos + VectorRand() * 3)
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
