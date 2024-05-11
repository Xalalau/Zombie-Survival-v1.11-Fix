include("shared.lua")
include("cl_scoreboard.lua")
include("cl_targetid.lua")
include("cl_hudpickup.lua")
include("cl_spawnmenu.lua")
include("cl_postprocess.lua")
include("cl_deathnotice.lua")

NextThump = 0
NextThumpCalculate = 0

Beats = {}
Beats[0] = {}
Beats[1] = {"beat1.wav"}
Beats[2] = {"beat1.wav", "beat2.wav"}
Beats[3] = {"beat1.wav", "beat2.wav", "beat3.wav"}
Beats[4] = {"beat3.wav", "beat4.wav"}
Beats[5] = {"beat1.wav", "beat2.wav", "beat3.wav", "beat5.wav"}
Beats[6] = {"beat1.wav", "beat2.wav", "beat3.wav", "beat5.wav", "beat8.wav"}
Beats[7] = {"beat1.wav", "beat2.wav", "beat3.wav", "beat5.wav", "beat7.wav", "beat8.wav"}
Beats[8] = {"beat1.wav", "beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav", "beat7.wav"}
Beats[9] = {"beat1.wav", "beat3.wav", "beat5.wav", "beat8.wav", "beat9.wav", "beat7.wav"}
Beats[10] = {"ecky.wav"}

BeatLength = {}
BeatLength[0] = 0.1
BeatLength[1] = 1.7
BeatLength[2] = 1.7
BeatLength[3] = 1.7
BeatLength[4] = 1.7
BeatLength[5] = 1.7
BeatLength[6] = 1.7
BeatLength[7] = 1.7
BeatLength[8] = 1.7
BeatLength[9] = 1.7
BeatLength[10] = 21.8

BeatText = {}
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

BeatColors = {}
BeatColors[0]  = Color(  0,   0, 255, 254)
BeatColors[1]  = Color( 25,  25, 200, 254)
BeatColors[2]  = Color( 50,  75, 150, 254)
BeatColors[3]  = Color(125, 125,  50, 254)
BeatColors[4]  = Color(200, 200,  25, 254)
BeatColors[5]  = Color(255, 255,   0, 254)
BeatColors[6]  = Color(255, 200,   0, 254)
BeatColors[7]  = Color(255, 100,   0, 254)
BeatColors[8]  = Color(255,  50,   0, 254)
BeatColors[9]  = Color(255,  25,   0, 254)
BeatColors[10] = Color(255,   0,   0, 254)

NearZombies = 0
DrawingDanger = 0
rounded = 0
-----------------
color_white = Color(255, 255, 255, 220)
color_black = Color(50, 50, 50, 255)
color_black_alpha180 = Color(0,0,0,180)
color_black_alpha90 = Color(0,0,0,90)
color_white_alpha200 = Color(255,255,255,200)
color_white_alpha180 = Color(255,255,255,180)
color_white_alpha90 = Color(255,255,255,90)
COLOR_INFLICTION = Color(255, 200, 0, 160)

ENDTIME = 0

Top = {}
TopZ = {}
TopZD = {}
TopHD = {}
NextAmmoDropOff = AMMO_REGENERATE_RATE
NextAmmoDropOffTimeLeft = AMMO_REGENERATE_RATE

NextAura = 0

-- Why run a function everytime you need it if it never changes anyway?
MySelf = LocalPlayer()
-- I really don't know why you would do h = and w = for every single HUD function.
-- This is updated only once every HUDPaint()
h = ScrH()
w = ScrW()
matHumanHead = Material("humanhead")
matZomboHead = Material("zombohead")
matHumanHeadID = surface.GetTextureID("humanhead")
matZomboHeadID = surface.GetTextureID("zombohead")

killicon.AddFont("headshot", "CSKillIcons", "D", Color(255, 20, 0, 255))
killicon.Add("weapon_zs_zombie", "killicon/zs_zombie", Color(255, 255, 255, 255))
killicon.Add("weapon_zs_fastzombie", "killicon/zs_zombie", Color(255, 255, 255, 255))
killicon.Add("weapon_zs_poisonzombie", "killicon/zs_zombie", Color(255, 255, 255, 255))
killicon.Add("weapon_zs_headcrab", "killicon/zs_zombie", Color(255, 255, 255, 255))
killicon.Add("weapon_zs_zombietorso", "killicon/zs_zombie", Color(255, 255, 255, 255))

function GM:Initialize()
	GAMEMODE.ShowScoreboard = false
	surface.CreateFont("coolvetica", 48, 500, true, false, "ScoreboardHead")
	surface.CreateFont("coolvetica", 24, 500, true, false, "ScoreboardSub")
	surface.CreateFont("Tahoma", 16, 1000, true, false, "ScoreboardText")
	surface.CreateFont("csd", 42, 500, true, true, "Signs")
	surface.CreateFont("akbar", 28, 500, true, true, "HUDFontSmall")
	surface.CreateFont("akbar", 72, 500, true, true, "HUDFontBig")
	surface.CreateFont("akbar", 42, 500, true, true, "HUDFont")
	if FORCE_NORMAL_GAMMA then // Let's make people actually use flashlights.
		MySelf:ConCommand("mat_monitorgamma 2.2")
		timer.Create("GammaChecker", 5, 0, function () MySelf:ConCommand("mat_monitorgamma 2.2") end)
	end
end

function GM:InitPostEntity()
	NextAmmoDropOff = math.ceil(CurTime() / AMMO_REGENERATE_RATE) * AMMO_REGENERATE_RATE
end

function GM:Think()
	NextAmmoDropOffTimeLeft = NextAmmoDropOff - CurTime()
	if NextAmmoDropOffTimeLeft < 0 then
	    NextAmmoDropOff = math.ceil(CurTime() / AMMO_REGENERATE_RATE) * AMMO_REGENERATE_RATE
	end
	if MySelf:Team() == TEAM_HUMAN then
		if RealTime() >= NextThump and MySelf:Alive() then
			local zombies = 0
			local mypos = MySelf:GetPos()
			for _, pl in pairs(player.GetAll()) do
	    		if pl:Alive() and pl:Team() == TEAM_UNDEAD then
	    			local dist = pl:GetPos():Distance(mypos)
	    			if dist < 150 then
	    				zombies = zombies + 2
	    			elseif dist < 256 then
	    				zombies = zombies + 1.5
	    			elseif dist < 600 then
	    	    		zombies = zombies + 1
	    			end
	    		end
			end
			if Beats[rounded] then
				for i=1, #Beats[rounded] do
	    			surface.PlaySound(Beats[rounded][i])
				end
			end
			NextThump = RealTime() + BeatLength[rounded]
			NearZombies = math.Clamp(math.Approach(NearZombies, zombies, 1), 0, 10)
			ForceFullBeat = true
		end
		if ANTI_VENT_CAMP then
			local cramped = util.TraceLine({start = MySelf:GetPos(), endpos = MySelf:GetPos() + Vector(0,0,64), ignore = MySelf, mask=COLLISION_GROUP_DEBRIS}).HitWorld
			if cramped then
				CRAMP_METER_TIME = math.min(CRAMP_METER_TIME + FrameTime(), 60)
				if CRAMP_METER_TIME >= 60 then
					MySelf:ConCommand("~Z_~_cramped_death")
					CRAMP_METER_TIME = 0
				end
			elseif CRAMP_METER_TIME > 0 then
				CRAMP_METER_TIME = math.max(CRAMP_METER_TIME - FrameTime() * 3, 0)
			end
		end
	end
end

function GM:PlayerDeath(ply, attacker)
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if attacker.Alive then
		return ply:Team() ~= attacker:Team() or ply == attacker
	end
	return true
end

function GM:HUDShouldDraw(name)
	return name ~= "CHudHealth" and name ~= "CHudBattery"
end

WATER_DROWNTIME = 0
CRAMP_METER_TIME = 0
-- TODO: Clean up all the HUDPaint code and make it smoother.
function GM:HumanHUD()
	rounded = math.Round(DrawingDanger*10)
	draw.SimpleText(BeatText[rounded], "ScoreboardSub", w*0.5, h*0.91, BeatColors[rounded], TEXT_ALIGN_CENTER)


	local entityhealth = math.Clamp(MySelf:Health(), 0, 999)
	local colortouse = COLOR_HEALTHY
	if entityhealth > 75 then
		colortouse = COLOR_HEALTHY
	elseif entityhealth > 50 then
	    colortouse = COLOR_SCRATCHED
	elseif entityhealth > 25 then
		colortouse = COLOR_HURT
	else
		colortouse = COLOR_CRITICAL
	end

    draw.RoundedBox(8, w*0.14, h*0.92, w*0.11, h*0.04, color_black_alpha90)
	draw.SimpleText("Humans", "HUDFontSmall", w*0.2, h*0.92, COLOR_CYAN, TEXT_ALIGN_CENTER)
	
	draw.RoundedBox(8, w*0.02, h*0.89, w*0.11, h*0.07, color_black_alpha90)
	draw.SimpleText("F", "Signs", w*0.06, h*0.915, colortouse, TEXT_ALIGN_RIGHT)
	draw.SimpleText(entityhealth, "HUDFont", w*0.06, h*0.9, colortouse, TEXT_ALIGN_LEFT)

	draw.SimpleText("Kills: "..MySelf:Frags(), "HUDFont", w*0.09, h*0.04, COLOR_RED, TEXT_ALIGN_LEFT)
	if ENDROUND then return end

	draw.RoundedBox(4, w*0.38, h*0.045, w*0.23 * (1 - (NextAmmoDropOffTimeLeft / AMMO_REGENERATE_RATE)), h*0.02, COLOR_RED)
	surface.DrawLine(w*0.38, h*0.045, w*0.61, h*0.045)
	surface.DrawLine(w*0.38, h*0.065, w*0.61, h*0.065)
	surface.DrawLine(w*0.38, h*0.045, w*0.38, h*0.065)
	surface.DrawLine(w*0.61, h*0.045, w*0.61, h*0.065)
	draw.SimpleText("Ammo Regenerate", "Default", w*0.5, h*0.047, COLOR_WHITE, TEXT_ALIGN_CENTER)
	//draw.SimpleText("Ammo Regenerate:\n"..ToMinutesSeconds(NextAmmoDropOffTimeLeft), "HUDFontSmall", w*0.39, h*0.04, COLOR_WHITE, TEXT_ALIGN_LEFT)

	if MySelf:WaterLevel() > 2 then
		WATER_DROWNTIME = math.min(WATER_DROWNTIME + FrameTime(), 30)
		if WATER_DROWNTIME >= 30 then
			MySelf:ConCommand("~Z_~_water_death")
			WATER_DROWNTIME = 0
		elseif WATER_DROWNTIME >= 20 then
			ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0.6, FrameTime() * 0.4)
			ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 0, FrameTime() * 0.5)
		end
		draw.SimpleText("Air", "DefaultBold", w*0.5, h*0.3, COLOR_WHITE, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawLine(w*0.5, h*0.33, w*0.75, h*0.33)
		surface.SetDrawColor(40, 40, 255, 255)
		surface.DrawLine(w*0.5, h*0.33, w*0.5 + w*0.25 * (WATER_DROWNTIME / 30), h*0.33)
	elseif WATER_DROWNTIME > 0 then
		WATER_DROWNTIME = math.max(WATER_DROWNTIME - FrameTime() * 3, 0)
		if WATER_DROWNTIME <= 0 then
			ColorModify["$pp_colour_addb"] = 0
			ColorModify["$pp_colour_colour"] = 1
		else
			ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0, FrameTime() * 0.8)
			ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 1, FrameTime())
		end
		draw.SimpleText("Air", "DefaultBold", w*0.5, h*0.3, COLOR_WHITE, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawLine(w*0.5, h*0.33, w*0.75, h*0.33)
		surface.SetDrawColor(40, 40, 255, 255)
		surface.DrawLine(w*0.5, h*0.33, w*0.5 + w*0.25 * (WATER_DROWNTIME / 30), h*0.33)
	end

	if CRAMP_METER_TIME > 20 then
		draw.SimpleText("BUTT CRAMPS!", "DefaultBold", w*0.5, h*0.4, COLOR_RED, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawLine(w*0.5, h*0.43, w*0.75, h*0.43)
		surface.SetDrawColor(40, 40, 255, 255)
		surface.DrawLine(w*0.5, h*0.43, w*0.5 + w*0.25 * (CRAMP_METER_TIME / 60), h*0.43)
	end
end

function GM:ZombieHUD()
	local entityhealth = math.Clamp(MySelf:Health(), 0, 999)
	local colortouse = COLOR_HEALTHY
	if entityhealth > 75 then
		colortouse = COLOR_HEALTHY
	elseif entityhealth > 50 then
	    colortouse = COLOR_SCRATCHED
	elseif entityhealth > 25 then
		colortouse = COLOR_HURT
	else
		colortouse = COLOR_CRITICAL
	end

    draw.RoundedBox(8, w*0.14, h*0.92, w*0.11, h*0.04, color_black_alpha90)
	draw.SimpleText("Undead", "HUDFontSmall", w*0.2, h*0.92, COLOR_GREEN, TEXT_ALIGN_CENTER)

	draw.RoundedBox(8, w*0.02, h*0.89, w*0.11, h*0.07, color_black_alpha90)
	draw.SimpleText("F", "Signs", w*0.06, h*0.915, colortouse, TEXT_ALIGN_RIGHT)
	draw.SimpleText(entityhealth, "HUDFont", w*0.06, h*0.9, colortouse, TEXT_ALIGN_LEFT)

	local killz = MySelf:Frags()
	if REDEEM then
		if AUTOREDEEM then
			draw.SimpleText("Redemption: "..killz.."/"..REDEEM_KILLS, "HUDFontSmall", w*0.09, h*0.04, COLOR_RED, TEXT_ALIGN_LEFT)
		else
			if killz >= REDEEM_KILLS then
				draw.SimpleText("Redeem: F2! ("..killz..")", "HUDFontSmall", w*0.09, h*0.04, COLOR_WHITE, TEXT_ALIGN_LEFT)
			else
				draw.SimpleText("Redemption: "..killz.."/"..REDEEM_KILLS, "HUDFontSmall", w*0.09, h*0.04, COLOR_RED, TEXT_ALIGN_LEFT)
			end
		end
	else
		draw.SimpleText("Slaughters: "..killz, "HUDFontSmall", w*0.09, h*0.04, COLOR_RED, TEXT_ALIGN_LEFT)
	end

	if RealTime() < NextAura then return end
	NextAura = RealTime() + 0.5
	local mypos = MySelf:GetPos()
	local cap = 0
	for _, pl in pairs(player.GetAll()) do
		if cap >= 8 then return end -- Cult linked list overflow with lots of humans
		if pl:Team() == TEAM_HUMAN and pl:Alive() then
			local pos = pl:GetPos() + Vector(0,0,32)
			if pos:Distance(mypos) < 1024 then
				local toscreen = pos:ToScreen() -- hacky shit to stop making emitters off screen.
				if toscreen.x > 0 and toscreen.x < w and toscreen.y > 0 and toscreen.y < h then
					local vel = pl:GetVelocity() * 0.7
					local health = pl:Health()
					local emitter = ParticleEmitter(pos)
					for i=1, 4 do
						local particle = emitter:Add("Sprites/light_glow02_add_noz", pos)
						particle:SetVelocity(vel + Vector(math.random(-35, 35),math.random(-35, 35), math.Rand(45, 95)))
						particle:SetDieTime(0.49)
						particle:SetStartAlpha(240)
						particle:SetEndAlpha(40)
						particle:SetStartSize(math.random(12, 14))
						particle:SetEndSize(4)
						particle:SetColor(255 - health * 2, 30, health * 2.1)
						particle:SetRoll(math.random(0, 360))
					end
					emitter:Finish()
					cap = cap + 1
				end
			end
		end
	end
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
	local pl = um:ReadEntity()
	if pl:IsValid() then
		//pl:SetModelScale(Vector(2,2,2))
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

function GM:HUDPaint()
	h = ScrH()
	w = ScrW()
	draw.RoundedBox(16, 0, 0, w*0.24, h*0.11, color_black_alpha90)
	self:HUDDrawTargetID()
	self:DrawTeamCount()
	self:DrawDeathNotice(0.8, 0.04)
	if MySelf:Team() == TEAM_UNDEAD then
		self:ZombieHUD()
		draw.SimpleText("Feed: "..ToMinutesSeconds(ROUNDTIME - CurTime()), "HUDFontSmall", w*0.09, 0, COLOR_RED, TEXT_ALIGN_LEFT)
	else
		self:DrawDangerBack()
		self:HUDDrawPickupHistory()
		self:HumanHUD()
		draw.SimpleText("Survive: "..ToMinutesSeconds(ROUNDTIME - CurTime()), "HUDFontSmall", w*0.09, 0, COLOR_CYAN, TEXT_ALIGN_LEFT)
	end
/*
	surface.SetDrawColor(70, 255, 70, 200)
	local midw = w*0.5
	local midh = h*0.5
	surface.DrawLine(midw - 32, midh, midw - 10, midh)
	surface.DrawLine(midw + 10, midh, midw + 32, midh)
	surface.DrawLine(midw, midh - 32, midw, midh - 10)
	surface.DrawLine(midw, midh + 10, midw, midh + 32)

	surface.SetDrawColor(255, 25, 25, 220)
	surface.DrawLine(midw - 1, midh, midw + 1, midh)
	*/
end

function GM:PlayerBindPress(pl, bind)
	if bind == "impulse 100" then
		return MySelf:Team() == TEAM_UNDEAD
	end
	return bind == "+walk"
end

function GM:DrawTeamCount()
	local zombies = team.NumPlayers(TEAM_ZOMBIE)
	local humans = team.NumPlayers(TEAM_HUMAN)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(matZomboHeadID)
	surface.DrawTexturedRect(0, 0, w*0.05, h*0.05)
	surface.SetTexture(matHumanHeadID)
	surface.DrawTexturedRect(0, h*0.05, w*0.05, h*0.05)

	draw.SimpleText(zombies, "HUDFont", w*0.05, 0, COLOR_GREEN, TEXT_ALIGN_LEFT)
	draw.SimpleText(humans, "HUDFont", w*0.05, h*0.05, COLOR_BLUE, TEXT_ALIGN_LEFT)
end

function GM:HUDPaintBackground()
	draw.RoundedBox(8, w*0.36, 0, w*0.28, h*0.07, color_black)
	draw.RoundedBox(4, w*0.37, h*0.005, w*0.26*INFLICTION, h*0.03, COLOR_INFLICTION)
	surface.DrawLine(w*0.37, h*0.005, w*0.63, h*0.005)
	surface.DrawLine(w*0.37, h*0.035, w*0.63, h*0.035)
	surface.DrawLine(w*0.37, h*0.005, w*0.37, h*0.035)
	surface.DrawLine(w*0.63, h*0.005, w*0.63, h*0.035)
	draw.SimpleText("Infliction", "HUDFontSmall", w*0.5, 0, COLOR_RED, TEXT_ALIGN_CENTER)
end

function GM:DrawDangerBack()
	if RealTime() >= NextThumpCalculate then
		NextThumpCalculate = RealTime() + 0.1
		local danger = DrawingDanger * 10
		if NearZombies == 0 then
			DrawingDanger = math.Clamp(DrawingDanger - 0.01, 0.01, 1)
		elseif NearZombies > danger then
	    	DrawingDanger = math.Clamp(DrawingDanger + 0.02, 0.01, 1)
		elseif NearZombies < danger then
			DrawingDanger = math.Clamp(DrawingDanger - 0.0016, 0.01, 1)
		end
	end

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(w*0.42, h*0.905, w*0.16, h*0.0345)
	draw.RoundedBox(8, w*0.37, h*0.94, w*0.26, h*0.1, color_black)
	draw.RoundedBox(2, w*0.37, h*0.94, w*0.26*DrawingDanger, h*0.1, BeatColors[rounded])
end

function GM:CalcView(pl, pos, ang, _fov)
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
	rounded = 0
	NextThump = 999999
	MySelf:ConCommand("stopsounds\n")
	LastLineY = h*0.4
	DoHumC()
	function GAMEMODE:HUDPaint()
		draw.RoundedBox(16, 0, h*0.14, w, h*0.62, color_black)
		if math.Clamp(LastLineY, h*0.14, h*0.76) == LastLineY then
			surface.DrawLine(0, LastLineY, w, LastLineY)
		end
		LastLineY = LastLineY + h*0.1 * FrameTime()
		if LastLineY > h then
			LastLineY = h*0.14
		end
		if #Top > 0 then
			draw.SimpleText("Survival Times", "HUDFont", w*0.1, h*0.15, COLOR_CYAN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if Top[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.SimpleText(Top[i], "HUDFontSmall", w*0.13, h*0.15 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end
		if #TopHD > 0 then
			draw.SimpleText("Damage to undead", "HUDFont", w*0.1, h*0.45, COLOR_CYAN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if TopHD[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.SimpleText(TopHD[i], "HUDFontSmall", w*0.13, h*0.45 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end

		if #TopZ > 0 then
			draw.SimpleText("Brains Eaten", "HUDFont", w*0.65, h*0.15, COLOR_GREEN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if TopZ[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.SimpleText(TopZ[i], "HUDFontSmall", w*0.68, h*0.15 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end
		if #TopZD > 0 then
			draw.SimpleText("Damage to humans", "HUDFont", w*0.65, h*0.45, COLOR_GREEN, TEXT_ALIGN_LEFT)
			for i=1, 5 do
				if TopZD[i] and CurTime() > ENDTIME + i * 0.7 then
					draw.SimpleText(TopZD[i], "HUDFontSmall", w*0.68, h*0.45 + h*0.05*i, Color(285 - i*30, 0, i*65 - 65, 255), TEXT_ALIGN_LEFT)
				end
			end
		end

		draw.SimpleText("Next: "..ToMinutesSeconds(ENDTIME + INTERMISSION_TIME - CurTime()), "HUDFontSmall", w*0.5, h*0.7, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function GAMEMODE:CalcView(pl, origin, ang, _fov)
		ang.roll = ang.roll + math.sin(RealTime()*0.3) * 256

		return {origin = pos, angles = ang, fov = _fov}
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

function DrawUnlock()
	if ENDROUND then
		hook.Remove("HUDPaint", "DrawUnlock")
		DrawRewardTime = nil
		return
	end
	DrawUnlockTime = DrawUnlockTime or RealTime() + 3
	draw.RoundedBox(16, w*0.35, h*0.07, w*0.3, h*0.06, color_black_alpha90)
	draw.SimpleText(UnlockedClass.." unlocked!", "HUDFontSmall", w*0.5 + XNameBlur2, h*0.1 + YNameBlur, COLOR_INFLICTION, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(UnlockedClass.." unlocked!", "HUDFontSmall", w*0.5, h*0.1, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	if RealTime() > DrawUnlockTime then
		hook.Remove("HUDPaint", "DrawUnlock")
		DrawUnlockTime = nil
		UnlockedClass = nil
		return
	end
end

local function SetInf(um)
	INFLICTION = um:ReadFloat()
	local sound = false
	local amount = 0
	for i in ipairs(ZombieClasses) do
		if ZombieClasses[i].Threshold <= INFLICTION and not ZombieClasses[i].Unlocked then
			ZombieClasses[i].Unlocked = true
			UnlockedClass = ZombieClasses[i].Name
			sound = true
			amount = amount + 1
		end
	end
	if sound then
		surface.PlaySound("npc/fast_zombie/fz_alert_far1.wav")
		if amount > 1 then
			UnlockedClass = amount.." classes" // So you can have more than one class with the same infliction without getting spammed.
		end
		hook.Add("HUDPaint", "DrawUnlock", DrawUnlock)
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
end
usermessage.Hook("SetInfInit", SetInfInit)

function DrawLastHuman()
	if ENDROUND then return end
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
			draw.SimpleText("Last Human", "HUDFontBig", w*0.5, LastHumanY - i*h*0.02, Color(255, 0, 0, 200 - i*25), TEXT_ALIGN_CENTER)
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
		draw.SimpleText("Last Human", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + LastHumanY, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText("Last Human", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + LastHumanY, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText("Last Human", "HUDFontBig", w*0.5, LastHumanY, COLOR_RED, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("Last Human", "HUDFontBig", w*0.5, LastHumanY, COLOR_RED, TEXT_ALIGN_CENTER)
	end
end

function Died()
	hook.Add("HUDPaint", "DrawDeath", DrawDeath)
	surface.PlaySound(DEATHSOUND)
end

function GM:KeyPress(pl, key)
	if key == IN_WALK then
		MySelf:ConCommand("kick_me\n")
	end
end

function DrawDeath()
	if LastHumanY or ENDROUND then return end -- This kind of gives priority to things
	DrawDeathY = DrawDeathY or 0
	if DrawDeathY > h*0.67 then
		DrawDeathHoldTime = DrawDeathHoldTime or RealTime()
		if RealTime() > DrawDeathHoldTime + 3 then
			DrawDeathY = nil
			DrawDeathHoldTime = nil
			DrawDeathHoldSound = nil
			hook.Remove("HUDPaint", "DrawDeath")
			return
		end
	else
		for i=1, 5 do
			draw.SimpleText("You are dead", "HUDFontBig", w*0.5, DrawDeathY - i*h*0.02, Color(0, 255, 0, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawDeathY = DrawDeathY + h*0.0075
	end
	if DrawDeathHoldTime then
		if not DrawDeathHoldSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawDeathHoldSound = true
		end
		draw.RoundedBox(16, w*0.32, h*0.67, w*0.36, h*0.15, color_black_alpha90)
		draw.SimpleText("You are dead", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawDeathY, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText("You are dead", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawDeathY, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText("You are dead", "HUDFontBig", w*0.5, DrawDeathY, COLOR_GREEN, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("You are dead", "HUDFontBig", w*0.5, DrawDeathY, COLOR_GREEN, TEXT_ALIGN_CENTER)
	end
end

function DrawLose()
	DrawLoseY = DrawLoseY or 0
	if DrawLoseY > h*0.8 then
		DrawLoseHoldTime = true
	else
		for i=1, 5 do
			draw.SimpleText("You have lost.", "HUDFontBig", w*0.5, DrawLoseY - i*h*0.02, Color(255, 0, 0, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawLoseY = DrawLoseY + h*0.0075
	end
	if DrawLoseHoldTime then
		if not DrawLoseSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawLoseSound = true
		end
		if not DISABLE_PP then
			ColorModify["$pp_colour_contrast"] = math.Approach(ColorModify["$pp_colour_contrast"], 0.4, FrameTime()*0.5)
			DrawColorModify(ColorModify)
		end
		draw.SimpleText("You have lost.", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawLoseY, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText("You have lost.", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawLoseY, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText("You have lost.", "HUDFontBig", w*0.5, DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("You have lost.", "HUDFontBig", w*0.5, DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
	end
end

function DrawWin()
	DrawWinY = DrawWinY or 0
	if DrawWinY > h*0.8 then
		DrawWinHoldTime = true
	else
		for i=1, 5 do
			draw.SimpleText("You have won!", "HUDFontBig", w*0.5, DrawWinY - i*h*0.02, Color(0, 0, 255, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawWinY = DrawWinY + h*0.0075
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
		draw.SimpleText("You have won!", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawWinY, Color(0, 0, 255, 90), TEXT_ALIGN_CENTER)
		draw.SimpleText("You have won!", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawWinY, Color(0, 0, 255, 180), TEXT_ALIGN_CENTER)
		draw.SimpleText("You have won!", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("You have won!", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	end
end

function DrawRewarded()
	if ENDROUND then
		hook.Remove("HUDPaint", "DrawRewarded")
		DrawRewardTime = nil
		return
	end
	DrawRewardTime = DrawRewardTime or RealTime() + 3
	draw.RoundedBox(16, w*0.32, h*0.28, w*0.36, h*0.15, color_black_alpha90)
	draw.SimpleText("Arsenal Upgraded", "HUDFont", w*0.5, h*0.28, COLOR_GREEN, TEXT_ALIGN_CENTER)
	if RealTime() > DrawRewardTime then
		hook.Remove("HUDPaint", "DrawRewarded")
		DrawRewardTime = nil
		return
	end
end

function Rewarded()
	surface.PlaySound("weapons/physcannon/physcannon_charge.wav")
	hook.Add("HUDPaint", "DrawRewarded", DrawRewarded)
end
rW = Rewarded
