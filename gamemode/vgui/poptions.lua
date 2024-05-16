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

	local Window = vgui.Create("DFrame")
	local wide = 500
	local tall = 360
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
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText("Options")
	label:SetPos(16, 22)
	surface.SetFont("noxnetnormal")
	local texw, texh = surface.GetTextSize("Options")
	label:SetSize(texw, texh)

	surface.SetFont("Default")
	local ___, defh = surface.GetTextSize("|")

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetPos(32, 80)
	slider:SetSize(200, 48)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 1600)
	slider:SetConVar("cl_detaildist")
	slider:SetText("Detail Props (FPS eater)")

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(32, 140)
	check:SetSize(wide, 32)
	check:SetText("Source2007 Motion Blur")
	check:SetConVar("mat_motion_blur_enabled")

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(32, 190)
	check:SetSize(wide, 32)
	check:SetText("Draw Flashlights")
	check:SetConVar("r_shadows")

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(wide + 32, 80)
	check:SetSize(wide, 32)
	check:SetText("Disable ALL post processing")
	check:SetConVar("_disable_pp")
	check.Button.ConVarChanged = CheckChanged

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(wide + 32, 110)
	check:SetSize(wide, 32)
	check:SetText("Enable Film Grain")
	check:SetConVar("_zs_enablefilmgrain")
	check.Button.ConVarChanged = CheckChanged

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(wide + 32, 140)
	check:SetSize(wide, 32)
	check:SetText("Enable Color Mod")
	check:SetConVar("_zs_enablecolormod")
	check.Button.ConVarChanged = CheckChanged

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(wide + 32, 170)
	check:SetSize(wide, 32)
	check:SetText("Enable Beats (ambient music)")
	check:SetConVar("_zs_enablebeats")
	check.Button.ConVarChanged = CheckChanged

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetPos(wide + 32, 200)
	slider:SetSize(200, 48)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 48)
	slider:SetConVar("_zs_filmgrainopacity")
	slider:SetText("Film Grain Opacity")
	slider.OnValueChanged = function(slid, val)
		RunConsoleCommand("_zs_filmgrainopacity", val)
	end


	local button = vgui.Create("DButton", Window)
	button:SetPos(wide * 0.5 - 70, Window:GetTall() - 64)
	button:SetSize(140, 32)
	button:SetText("Close")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) end
end
