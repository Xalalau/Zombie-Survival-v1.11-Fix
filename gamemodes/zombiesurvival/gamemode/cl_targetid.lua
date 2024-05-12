COLOR_FRIENDLY = COLOR_GREEN
COLOR_HEALTHY = COLOR_GREEN
COLOR_HURT = COLOR_YELLOW
COLOR_CRITICAL = COLOR_RED
COLOR_SCRATCHED = Color(100, 255, 0)

XNameBlur = 0
XNameBlur2 = 0
YNameBlur = 0
YNameBlur2 = 0

local color_blur1 = Color(100, 20, 0, 220)
local color_blur2 = Color(100, 20, 0, 140)

local weptranslate = {}
weptranslate["weapon_physgun"] = "Physics Gun"
weptranslate["weapon_physcannon"] = "Gravity Gun"
weptranslate["weapon_357"] = "357 Magnum"
weptranslate["weapon_ar2"] = "AR2"
weptranslate["weapon_smg1"] = "SMG1"
weptranslate["weapon_pistol"] = "Pistol"
weptranslate["weapon_rpg"] = "RPG"
weptranslate["weapon_frag"] = "Frag Grenade"
weptranslate["weapon_crowbar"] = "Crowbar"
weptranslate["weapon_stunstick"] = "Stunstick"
weptranslate["weapon_bugbait"] = "Bugbait"
weptranslate["weapon_"] = "Gravity Gun"

function GM:HUDDrawTargetID(MySelf, team)
	local trace = MySelf:GetEyeTrace()

	local entity = trace.Entity
	if entity:IsPlayer() then
		local text = entity:Name()

		local x, y = w * 0.5, h * 0.55
		local otherteam = entity:Team() or 1
		if team == otherteam then
			draw.DrawText(text, "HUDFontSmallAA", x + XNameBlur, y + YNameBlur, color_blur1, TEXT_ALIGN_CENTER)
			draw.DrawText(text, "HUDFontSmallAA", x + XNameBlur2, y + YNameBlur2, color_blur2, TEXT_ALIGN_CENTER)
			draw.DrawText(text, "HUDFontSmallAA", x, y, COLOR_FRIENDLY, TEXT_ALIGN_CENTER)

			surface.SetFont("HUDFontSmallAA")
			local texw, texh = surface.GetTextSize(text)
			y = y + texh + 8

			local entityhealth = entity:Health() or 1
			entityhealth = math.Clamp(entityhealth, 0, 1000)
			local colortouse = COLOR_FRIENDLY
			if entityhealth > 75 then
				colortouse = COLOR_HEALTHY
			elseif entityhealth > 50 then
				colortouse = COLOR_HURT
			else
				colortouse = COLOR_CRITICAL
			end

			draw.DrawText("F", "Signs", x, y, colortouse, TEXT_ALIGN_RIGHT)
			draw.DrawText("F", "Signs", x + XNameBlur2, y + YNameBlur, color_blur1, TEXT_ALIGN_RIGHT)
			draw.DrawText("F", "Signs", x + XNameBlur, y + YNameBlur2, color_blur2, TEXT_ALIGN_RIGHT)

			draw.DrawText(entityhealth, "HUDFontAA", x, y - h*0.01, colortouse, TEXT_ALIGN_LEFT)
			draw.DrawText(entityhealth, "HUDFontAA", x + XNameBlur, y + YNameBlur2 - h*0.01, color_blur1, TEXT_ALIGN_LEFT)
			draw.DrawText(entityhealth, "HUDFontAA", x + XNameBlur2, y + YNameBlur - h*0.01, color_blur2, TEXT_ALIGN_LEFT)

			if otherteam == TEAM_HUMAN then
				local wep = entity:GetActiveWeapon()
				local wepname
				if wep.PrintName then
					wepname = wep.PrintName
				elseif wep:IsValid() then
					local classname = wep:GetClass()
					wepname = weptranslate[classname] or classname
				end

				if wepname then
					surface.SetFont("HUDFontAA")
					local texw, texh = surface.GetTextSize(entityhealth)
					y = y + texh + 4

					draw.DrawText(wepname, "DefaultBold", x, y - h*0.01, color_white, TEXT_ALIGN_CENTER)
					draw.DrawText(wepname, "Default", x + XNameBlur, y + YNameBlur2 - h*0.01, color_blur1, TEXT_ALIGN_CENTER)
					draw.DrawText(wepname, "Default", x + XNameBlur2, y + YNameBlur - h*0.01, color_blur2, TEXT_ALIGN_CENTER)
				end
			end
		-- Draw other team on targetID
		--[[else
			draw.DrawText(text, "HUDFontSmallAA", x + XNameBlur, y + YNameBlur, color_blur1, TEXT_ALIGN_CENTER)
			draw.DrawText(text, "HUDFontSmallAA", x + XNameBlur2, y + YNameBlur2, color_blur2, TEXT_ALIGN_CENTER)
			draw.DrawText(text, "HUDFontSmallAA", x, y, COLOR_RED, TEXT_ALIGN_CENTER)]]
		end
	end
end

timer.Create("ShuffleNameBlur", 0.1, 0, function()
	XNameBlur = math.random(-8, 8)
	XNameBlur2 = math.random(-8, 8)
	YNameBlur = math.random(-8, 8)
	YNameBlur2 = math.random(-8, 8)
end)
