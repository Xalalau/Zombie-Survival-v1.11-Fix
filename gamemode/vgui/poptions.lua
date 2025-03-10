local function CheckChanged(obj, strNewValue)
	strNewValue = tostring(strNewValue)
	if obj.m_strConVar and strNewValue ~= GetConVar(obj.m_strConVar):GetString() then
		RunConsoleCommand(string.sub(obj.m_strConVar, 2), strNewValue)
	end
end

function MakepOptions()
	if pOptions then
		pOptions:SetVisible(true)
		pOptions:MakePopup()
		return
	end

	local UIScalingW, UIScalingH = GetUIScale()

	local Window = vgui.Create("DFrame")
	local wide = 610 * UIScalingW
	local tall = 220 * UIScalingH
	Window:SetSize(wide, tall)
	local wide = (wide) * 0.5
	local tall = (tall) * 0.5

	Window:CenterVertical()
	Window:CenterHorizontal()
	Window:SetTitle(" ")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetCursor("pointer")
	pOptions = Window

	local label = vgui.Create("DLabel", Window)
	label:SetFont("noxnetnormal")
	label:SetText("Options")
	label:SetPos(5 * UIScalingW, 2 * UIScalingH)
	surface.SetFont("noxnetnormal")
	local texw, texh = surface.GetTextSize("Options")
	label:SetSize(texw, texh)

	local options = vgui.Create("DPanel", Window)
	options:Dock(FILL)
	options:SetBackgroundColor(Color(0, 0, 0, 0))

	surface.SetFont("DefaultScaled")
	local ___, defh = surface.GetTextSize("|")

	local leftMargin = 32 * UIScalingW
	local lineSize = 30 * UIScalingH
	local sliderLineAdjust = lineSize * 0.5

	local slider = vgui.Create("DNumSlider", options)
	slider:SetPos(leftMargin, lineSize - sliderLineAdjust)
	slider:SetSize(300 * UIScalingW, 48 * UIScalingH)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 1600)
	slider:SetConVar("cl_detaildist")
	slider:SetText("Detail Props (FPS eater)")
	local sliderText = slider:GetTextArea()
	sliderText:SetFont("DefaultScaled")
	local sliderLabel = slider.Label
	sliderLabel:SetFont("DefaultScaled")

	local check = vgui.Create("DCheckBoxLabel", options)
	check:SetPos(leftMargin, lineSize * 3)
	check:SetSize(wide, 32 * UIScalingH)
	check:SetText("Source2007 Motion Blur")
	check:SetConVar("mat_motion_blur_enabled")
	check:SetFont("DefaultScaled")

	check = vgui.Create("DCheckBoxLabel", options)
	check:SetPos(leftMargin, lineSize * 4)
	check:SetSize(wide, 32 * UIScalingH)
	check:SetText("Draw Flashlights")
	check:SetConVar("r_shadows")
	check:SetFont("DefaultScaled")

	check = vgui.Create("DCheckBoxLabel", options)
	check:SetPos(wide + leftMargin, lineSize)
	check:SetSize(wide, 32 * UIScalingH)
	check:SetText("Disable ALL post processing")
	check:SetConVar("_disable_pp")
	check.Button.ConVarChanged = CheckChanged
	check:SetFont("DefaultScaled")

	check = vgui.Create("DCheckBoxLabel", options)
	check:SetPos(wide + leftMargin, lineSize * 2)
	check:SetSize(wide, 32 * UIScalingH)
	check:SetText("Enable Film Grain")
	check:SetConVar("_zs_enablefilmgrain")
	check.Button.ConVarChanged = CheckChanged
	check:SetFont("DefaultScaled")

	check = vgui.Create("DCheckBoxLabel", options)
	check:SetPos(wide + leftMargin, lineSize * 3)
	check:SetSize(wide, 32 * UIScalingH)
	check:SetText("Enable Color Mod")
	check:SetConVar("_zs_enablecolormod")
	check.Button.ConVarChanged = CheckChanged
	check:SetFont("DefaultScaled")

	check = vgui.Create("DCheckBoxLabel", options)
	check:SetPos(wide + leftMargin, lineSize * 4)
	check:SetSize(wide, 32 * UIScalingH)
	check:SetText("Enable Beats (ambient music)")
	check:SetConVar("_zs_enablebeats")
	check.Button.ConVarChanged = CheckChanged
	check:SetFont("DefaultScaled")

	slider = vgui.Create("DNumSlider", options)
	slider:SetPos(wide + leftMargin, lineSize * 5 - sliderLineAdjust)
	slider:SetSize(270 * UIScalingW, 48 * UIScalingH)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 48)
	slider:SetConVar("_zs_filmgrainopacity")
	slider:SetText("Film Grain Opacity")
	slider.OnValueChanged = function(slid, val)
		RunConsoleCommand("_zs_filmgrainopacity", val)
	end
	sliderText = slider:GetTextArea()
	sliderText:SetFont("DefaultScaled")
	sliderLabel = slider.Label
	sliderLabel:SetFont("DefaultScaled")
end
