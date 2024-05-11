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

function GM:HUDDrawTargetID(MySelf, team)
	local trace = MySelf:GetEyeTrace()

	local entity = trace.Entity
	if not (entity:IsValid() and entity:IsPlayer()) then return end

	local text = entity:Name()

	local x, y = w * 0.5, h * 0.54 + 30
	local otherteam = entity:Team() or 1
	if team == otherteam then
		draw.SimpleText(text, "HUDFontSmallAA", x + XNameBlur, y + YNameBlur, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, "HUDFontSmallAA", x + XNameBlur2, y + YNameBlur2, color_blur2, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, "HUDFontSmallAA", x, y, COLOR_FRIENDLY, TEXT_ALIGN_CENTER)

		y = y + h * 0.06

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

		draw.SimpleText("F", "Signs", x, y, colortouse, TEXT_ALIGN_RIGHT)
		draw.SimpleText("F", "Signs", x + XNameBlur2, y + YNameBlur, color_blur1, TEXT_ALIGN_RIGHT)
		draw.SimpleText("F", "Signs", x + XNameBlur, y + YNameBlur2, color_blur2, TEXT_ALIGN_RIGHT)
		draw.SimpleText(entityhealth, "HUDFontAA", x, y - h*0.01, colortouse, TEXT_ALIGN_LEFT)
		draw.SimpleText(entityhealth, "HUDFontAA", x + XNameBlur, y + YNameBlur2 - h*0.01, color_blur1, TEXT_ALIGN_LEFT)
		draw.SimpleText(entityhealth, "HUDFontAA", x + XNameBlur2, y + YNameBlur - h*0.01, color_blur2, TEXT_ALIGN_LEFT)
	/*else
		draw.SimpleText( text, "HUDFontSmallAA", x + XNameBlur, y + YNameBlur, color_blur1, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "HUDFontSmallAA", x + XNameBlur2, y + YNameBlur2, color_blur2, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "HUDFontSmallAA", x, y, COLOR_RED, TEXT_ALIGN_CENTER )*/
	end
end

timer.Create("ShuffleNameBlur", 0.1, 0, function()
	XNameBlur = math.random(-8, 8)
	XNameBlur2 = math.random(-8, 8)
	YNameBlur = math.random(-8, 8)
	YNameBlur2 = math.random(-8, 8)
end)
