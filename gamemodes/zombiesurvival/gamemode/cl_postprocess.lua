DISABLE_PP = false
CreateClientConVar("_disable_pp", 0, true, false)
CreateClientConVar("_zs_enablefilmgrain", 0, true, false)
CreateClientConVar("_zs_enablecolormod", 1, true, false)
CreateClientConVar("_zs_filmgrainopacity", 2.25, true, false)
--CreateClientConVar("_zs_enablemotionblur", 1, true, false)

DISABLE_PP = util.tobool(GetConVarNumber("_disable_pp"))
local FILM_GRAIN = util.tobool(GetConVarNumber("_zs_enablefilmgrain"))
local FILM_GRAIN_OPACITY = GetConVarNumber("_zs_filmgrainopacity")
COLOR_MOD = util.tobool(GetConVarNumber("_zs_enablecolormod"))
--local MOTION_BLUR = util.tobool(GetConVarNumber("_zs_enablemotionblur"))

--local tex_MotionBlur = render.GetMoBlurTex0()

--local MotionBlur = 0.0

ColorModify = {}
ColorModify["$pp_colour_addr"] = 0
ColorModify["$pp_colour_addg" ] = 0
ColorModify["$pp_colour_addb" ] = 0
ColorModify["$pp_colour_brightness" ] = 0
ColorModify["$pp_colour_contrast" ] = 1
ColorModify["$pp_colour_colour" ] = 1
ColorModify["$pp_colour_mulr" ] = 0
ColorModify["$pp_colour_mulg" ] = 0
ColorModify["$pp_colour_mulb" ] = 0

local CURRENTGRAIN = 1

local matFilmGrain = {}
for _, filename in pairs(file.Find("../materials/zombiesurvival/filmgrain?.vtf")) do
	table.insert(matFilmGrain, surface.GetTextureID("zombiesurvival/"..string.sub(filename, 1, -5)))
end

local ZomCM = {}
ZomCM["$pp_colour_brightness"] = -0.05
ZomCM["$pp_colour_contrast"] = 1.5
ZomCM["$pp_colour_colour"] = 1
ZomCM["$pp_colour_addr"] = 0
ZomCM["$pp_colour_addg"] = 0.15
ZomCM["$pp_colour_addb"] = 0
ZomCM["$pp_colour_mulr"] = 50
ZomCM["$pp_colour_mulg"] = 0
ZomCM["$pp_colour_mulb"] = 0

local HumCM = {}
HumCM["$pp_colour_addr"] = 0
HumCM["$pp_colour_addg"] = 0
HumCM["$pp_colour_addb"] = 0
HumCM["$pp_colour_brightness"] = -0.08
HumCM["$pp_colour_contrast"] = 1.25
HumCM["$pp_colour_colour"] = 1
HumCM["$pp_colour_mulr"] = 0
HumCM["$pp_colour_mulg"] = 0
HumCM["$pp_colour_mulb"] = 0

local DeadCM = {}
DeadCM["$pp_colour_contrast"] = 1.25
DeadCM["$pp_colour_colour"] = 0
DeadCM["$pp_colour_addr"] = 0
DeadCM["$pp_colour_addg"] = 0
DeadCM["$pp_colour_addb"] = 0
DeadCM["$pp_colour_brightness"] = -0.08
DeadCM["$pp_colour_mulr"] = 0
DeadCM["$pp_colour_mulg"] = 0
DeadCM["$pp_colour_mulb"] = 0

if 90 <= render.GetDXLevel() then
	function GM:RenderScreenspaceEffects()
		if DISABLE_PP or not MYSELFVALID then return end

		if FILM_GRAIN then
			surface.SetTexture(matFilmGrain[math.floor(CURRENTGRAIN)])
			if COLOR_MOD and MySelf:Team() == TEAM_UNDEAD then
				surface.SetDrawColor(225, 225, 225, FILM_GRAIN_OPACITY * 0.5)
			else
				surface.SetDrawColor(225, 225, 225, FILM_GRAIN_OPACITY)
			end
			for x=0, w, 1024 do
				for y=0, h, 512 do
					surface.DrawTexturedRect(x, y, 1024, 512)
				end
			end
			CURRENTGRAIN = CURRENTGRAIN + FrameTime() * 25
			if CURRENTGRAIN >= 6 then
				CURRENTGRAIN = 1
			end
		end

		if COLOR_MOD and MYSELFVALID then
			if not MySelf:Alive() then
				DrawColorModify(DeadCM)
			elseif MySelf:Team() == TEAM_UNDEAD then
				DrawColorModify(ZomCM)
			else
				local curr = HumCM["$pp_colour_addr"]
				if MySelf:Health() <= 30 then
					HumCM["$pp_colour_addr"] = math.Approach(curr, 0.12, FrameTime() * 0.04)
				elseif 0 < curr then
					HumCM["$pp_colour_addr"] = math.Approach(curr, 0, FrameTime() * 0.04)
				end
				DrawColorModify(HumCM)
			end
		end
	end
else
	function GM:RenderScreenspaceEffects()
	end
end

local texPoison = surface.GetTextureID("Decals/decal_birdpoop004.vmt")

local function PaintBlindness()
	surface.SetTexture(texPoison)
	surface.SetDrawColor(40, 255, 40, math.min(230, (MySelf.Blindness - CurTime()) * 90))
	surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, w * 0.9, h * 0.9, MySelf.BlindRotate)

	MySelf.BlindRotate = MySelf.BlindRotate + FrameTime() * 15
	if 360 < MySelf.BlindRotate then
		MySelf.BlindRotate = MySelf.BlindRotate - 360
	end

	if MySelf.Blindness < CurTime() then
		MySelf.Blindness = nil
		MySelf.BlindRotate = nil
		hook.Remove("HUDPaint", "EyePoison")
	end
end

local function DecayPoisonedEffect()
	HumCM["$pp_colour_addg"] = math.Approach(ColorModify["$pp_colour_addg"], 0, FrameTime() * 0.5)
	HumCM["$pp_colour_brightness"] = math.Approach(ColorModify["$pp_colour_brightness"], 0, FrameTime() * 0.5)

	if HumCM["$pp_colour_addg"] <= 0 then
		timer.Destroy("poison")
	end
end

local function PoisEff(um)
	HumCM["$pp_colour_addg"] = 0.25
	HumCM["$pp_colour_brightness"] = 0.25
	timer.Create("poison", 0, 0, DecayPoisonedEffect)
end
usermessage.Hook("PoisonEffect", PoisEff)

function EyePoisoned()
	MySelf.Blindness = CurTime() + math.random(14, 18)
	MySelf.BlindRotate = 0
	PoisEff()

	hook.Add("HUDPaint", "EyePoison", PaintBlindness)
end

function DeadC()
	--MotionBlur = 0.91

	ColorModify["$pp_colour_addr"] = 0
	ColorModify["$pp_colour_addg"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_brightness"] = 0
	ColorModify["$pp_colour_contrast"] = 1.25
	ColorModify["$pp_colour_colour"] = 0
	ColorModify["$pp_colour_mulr"] = 0
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_mulb"] = 0

	DLV = nil
end

function DoZomC()
	ZomCM["$pp_colour_brightness"] = -0.05
	ZomCM["$pp_colour_contrast"] = 1.5
	ZomCM["$pp_colour_colour"] = 1
	ZomCM["$pp_colour_addr"] = 0
	ZomCM["$pp_colour_addg"] = 0.15
	ZomCM["$pp_colour_mulr"] = 50
	DLV = nil
	--MotionBlur = 0
end

function ZomC()
	GAMEMODE:ResetWaterAndCramps()
	hook.Remove("Think", "ApproachDLC")
	timer.Simple(0.3, DoZomC)
end

local function ApproachDLVC()
	local ft = FrameTime()
	ZomCM["$pp_colour_mulr"] = math.Approach(ZomCM["$pp_colour_mulr"], 10, ft * 30)
	ZomCM["$pp_colour_colour"] = math.Approach(ZomCM["$pp_colour_colour"], 0, ft)
	ZomCM["$pp_colour_brightness"] = math.Approach(ZomCM["$pp_colour_brightness"], -0.17, ft * 0.25)
	ZomCM["$pp_colour_contrast"] = math.Approach(ZomCM["$pp_colour_contrast"], -5, ft * 5)
	ZomCM["$pp_colour_addg"] = math.Approach(ZomCM["$pp_colour_addg"], -0.02, ft)
	--ZomCM["$pp_colour_mulb"] = 0
	--ZomCM["$pp_colour_addb"] = 0
	--ZomCM["$pp_colour_mulg"] = 0
	--ZomCM["$pp_colour_addr"] = 0
	if ZomCM["$pp_colour_mulr"] == 10 and ZomCM["$pp_colour_contrast"] == -5 and ZomCM["$pp_colour_addg"] == -0.02 and ZomCM["$pp_colour_brightness"] == -0.17 and ZomCM["$pp_colour_colour"] == 0 then
		hook.Remove("Think", "ApproachDLC")
		DLV = true
	end
end

function DLVC()
	hook.Add("Think", "ApproachDLC", ApproachDLVC)
end

function DoDLC()
	ZomCM["$pp_colour_mulr"] = -15
	ZomCM["$pp_colour_colour"] = 0
	ZomCM["$pp_colour_brightness"] = -0.17
	ZomCM["$pp_colour_contrast"] = -5
	ZomCM["$pp_colour_addg"] = -0.02
	ZomCM["$pp_colour_mulb"] = 0
	ZomCM["$pp_colour_addb"] = 0
	ZomCM["$pp_colour_mulg"] = 0
	ZomCM["$pp_colour_addr"] = 0
end

function DoHumC()
	ColorModify["$pp_colour_addr"] = 0
	ColorModify["$pp_colour_addg"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_brightness"] = -0.08
	ColorModify["$pp_colour_contrast"] = 1.25
	ColorModify["$pp_colour_colour"] = 1
	ColorModify["$pp_colour_mulr"] = 0
	ColorModify["$pp_colour_mulg"] = 0
	ColorModify["$pp_colour_mulb"] = 0
	DLV = nil
end

--[[function HumC()
	hook.Remove("Think", "ApproachDLC")
	timer.Simple(0.3, DoHumC)
end]]

concommand.Add("disable_pp", function(sender, command, arguments)
	DISABLE_PP = util.tobool(arguments[1])

	if DISABLE_PP then
		RunConsoleCommand("_disable_pp", "1")
		MySelf:ChatPrint("Post process disabled.")
	else
		RunConsoleCommand("_disable_pp", "0")
		MySelf:ChatPrint("Post process enabled.")
	end
end)

--[[
concommand.Add("zs_enablemotionblur", function(sender, command, arguments)
	MOTION_BLUR = util.tobool(arguments[1])

	if MOTION_BLUR then
		RunConsoleCommand("_zs_enablemotionblur", "1")
		MySelf:ChatPrint("Motion Blur enabled.")
	else
		RunConsoleCommand("_zs_enablemotionblur", "0")
		MySelf:ChatPrint("Motion Blur disabled.")
	end
end)]]

concommand.Add("zs_enablefilmgrain", function(sender, command, arguments)
	FILM_GRAIN = util.tobool(arguments[1])

	if FILM_GRAIN then
		RunConsoleCommand("_zs_enablefilmgrain", "1")
		MySelf:ChatPrint("Film Grain enabled.")
	else
		RunConsoleCommand("_zs_enablefilmgrain", "0")
		MySelf:ChatPrint("Film Grain disabled.")
	end
end)

concommand.Add("zs_enablecolormod", function(sender, command, arguments)
	COLOR_MOD = util.tobool(arguments[1])

	if COLOR_MOD then
		RunConsoleCommand("_zs_enablecolormod", "1")
		MySelf:ChatPrint("Color Mod enabled.")
	else
		RunConsoleCommand("_zs_enablecolormod", "0")
		MySelf:ChatPrint("Color Mod disabled.")
	end
end)

concommand.Add("zs_filmgrainopacity", function(sender, command, arguments)
	FILM_GRAIN_OPACITY = arguments[1]

	RunConsoleCommand("_zs_filmgrainopacity", FILM_GRAIN_OPACITY)
end)
