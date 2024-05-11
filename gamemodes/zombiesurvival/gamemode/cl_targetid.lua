MySelf = LocalPlayer()

COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255)
COLOR_BLACK = Color(0, 0, 0)

COLOR_FRIENDLY = COLOR_GREEN
COLOR_HEALTHY = COLOR_GREEN
COLOR_HURT = COLOR_YELLOW
COLOR_CRITICAL = COLOR_RED
COLOR_SCRATCHED = Color(100, 255, 0)

color_blur1 = Color(100, 20, 0, 220)
color_blur2 = Color(100, 20, 0, 140)

NAMEBLUR_REPEAT_RATE = 0.1
XNameBlur = 0
XNameBlur2 = 0
YNameBlur = 0
YNameBlur2 = 0

function GM:HUDDrawTargetID()
	local trace = util.TraceLine(utilx.GetPlayerTrace(MySelf, MySelf:GetAimVector()))
	local entity = trace.Entity
	if not entity:IsValid() then return end
	if not entity:IsPlayer() then return end

	local text = entity:Nick() or "ERROR"

	local x, y = gui.MousePos()
	y = y + 30
	local team = MySelf:Team() or 1
	local otherteam = entity:Team() or 1
    if team == otherteam then
		draw.SimpleText( text, "HUDFontSmall", x + XNameBlur, y + YNameBlur, color_blur1, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "HUDFontSmall", x + XNameBlur2, y + YNameBlur2, color_blur2, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "HUDFontSmall", x, y, COLOR_FRIENDLY, TEXT_ALIGN_CENTER )
	
		y = y + h*0.06
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
		draw.SimpleText(entityhealth, "HUDFont", x, y - h*0.01, colortouse, TEXT_ALIGN_LEFT)
		draw.SimpleText(entityhealth, "HUDFont", x + XNameBlur, y + YNameBlur2 - h*0.01, color_blur1, TEXT_ALIGN_LEFT)
		draw.SimpleText(entityhealth, "HUDFont", x + XNameBlur2, y + YNameBlur - h*0.01, color_blur2, TEXT_ALIGN_LEFT)
	else
	    draw.SimpleText( text, "HUDFontSmall", x + XNameBlur, y + YNameBlur, color_blur1, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "HUDFontSmall", x + XNameBlur2, y + YNameBlur2, color_blur2, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "HUDFontSmall", x, y, COLOR_RED, TEXT_ALIGN_CENTER )
	end
end

function ShuffleNameBlur()
	XNameBlur = math.random(-8, 8)
	XNameBlur2 = math.random(-8, 8)
	YNameBlur = math.random(-8, 8)
	YNameBlur2 = math.random(-8, 8)
end
timer.Create("ShuffleNameBlur", NAMEBLUR_REPEAT_RATE, 0, ShuffleNameBlur)
