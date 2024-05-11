DISABLE_PP = false
CreateClientConVar("_disable_pp", 1, true, false)

DISABLE_PP = util.tobool(GetConVarNumber("_disable_pp"))

local matBlurEdges		= Material("bluredges")
local tex_MotionBlur	= render.GetMoBlurTex0()

MotionBlur = 0.0
ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 1
ColorModify[ "$pp_colour_mulg" ] 		= 1
ColorModify[ "$pp_colour_mulb" ] 		= 1

Sharpen = 0
if render.GetDXLevel() >= 90 then
function GM:RenderScreenspaceEffects()
	if DISABLE_PP then return end
	DrawColorModify(ColorModify)

	if MotionBlur > 0 then
		DrawMotionBlur(1 - MotionBlur, 1.0, 0.0)
		MotionBlur = MotionBlur - 0.3 * FrameTime()
	end

	if Sharpen > 0 then
		DrawSharpen(Sharpen, 0.5)
	end

	if not MySelf:Alive() then
		DeadC()
	elseif MySelf:Team() == TEAM_HUMAN then
		if MySelf:Health() <= 30 then
			render.SetMaterial(matBlurEdges)
			render.UpdateScreenEffectTexture()
			render.DrawScreenQuad()
			render.DrawScreenQuad()
			ColorModify["$pp_colour_addr"] = math.Approach(ColorModify["$pp_colour_addr"], 0.12, FrameTime() * 0.04)
			ColorModify["$pp_colour_mulr"] = 1
			MotionBlur = 0.4
			Sharpen = 3
		else
			ColorModify["$pp_colour_addr"] = 0
			ColorModify["$pp_colour_mulr"] = 1 + DrawingDanger*0.4
			ColorModify["$pp_colour_brightness"] = DrawingDanger*0.06
			Sharpen = DrawingDanger*3.5
		end
	else
		render.SetMaterial(matBlurEdges)
		render.UpdateScreenEffectTexture()
		render.DrawScreenQuad()
	end
end
else
	function GM:RenderScreenspaceEffects()
	end
end

function DeadC()
	MotionBlur = 0.91
	render.SetMaterial(matBlurEdges)
	render.UpdateScreenEffectTexture()
	render.DrawScreenQuad()
	render.DrawScreenQuad()
	render.DrawScreenQuad()
	ColorModify["$pp_colour_addr"] = 0.3
	ColorModify["$pp_colour_addg"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_brightness"] = 0
	ColorModify["$pp_colour_contrast"] = 1
	ColorModify["$pp_colour_colour"] = 1
	ColorModify["$pp_colour_mulr"] = 1
	ColorModify["$pp_colour_mulg"] = 1
	ColorModify["$pp_colour_mulb"] = 1
end

function ZomC()
	timer.Simple(0.3, DoZomC)
end

function DoZomC()
	ColorModify["$pp_colour_brightness"] = 0.04
	ColorModify["$pp_colour_contrast"] = 1.7
	ColorModify["$pp_colour_addr"] = 0
	ColorModify["$pp_colour_addg"] = 0.05
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_colour"] = 1.5
	ColorModify["$pp_colour_mulr"] = 4
	Sharpen = 0
	MotionBlur = 0
end

function HumC()
	timer.Simple(0.3, DoHumC)
end

function DoHumC()
	ColorModify["$pp_colour_addr"] = 0
	ColorModify["$pp_colour_addg"] = 0
	ColorModify["$pp_colour_addb"] = 0
	ColorModify["$pp_colour_brightness"] = 0
	ColorModify["$pp_colour_contrast"] = 1
	ColorModify["$pp_colour_colour"] = 1
	ColorModify["$pp_colour_mulr"] = 1
	ColorModify["$pp_colour_mulg"] = 1
	ColorModify["$pp_colour_mulb"] = 1
	HCView = false
end

local function DisablePP(sender, command, arguments)
	if arguments[1] == "1" then
		DISABLE_PP = true
		MySelf:ConCommand("_disable_pp 1")
		MySelf:ChatPrint("Post process disabled.")
	else
		DISABLE_PP = false
		MySelf:ConCommand("_disable_pp 0")
		MySelf:ChatPrint("Post process enabled.")
	end
end
concommand.Add("disable_pp", DisablePP)
