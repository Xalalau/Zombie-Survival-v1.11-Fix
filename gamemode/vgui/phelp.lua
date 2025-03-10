function MakepHelp()
	if pHelp then
		pHelp:SetVisible(true)
		pHelp:MakePopup()
		return
	end

	local window = vgui.Create("DFrame")

	local UIScalingW, UIScalingH, smoothingFactor = GetUIScale()

	local scaleWidth = 0.49 * smoothingFactor
	local scaleHeight = 0.95 * smoothingFactor
	local width = w * scaleWidth
	local height = h * scaleHeight

	window:SetSize(width, height)
	local x = (w - width) * 0.5
	local y = (h - height) * 0.5
	window:SetPos(x, y)
	window:SetTitle(" ")
	window:SetVisible(true)
	window:SetDraggable(false)
	window:MakePopup()
	window:SetDeleteOnClose(false)
	window:SetCursor("pointer")
	pHelp = window

	local scrollPanel = vgui.Create("DScrollPanel", window)
	scrollPanel:Dock(FILL)

	surface.SetFont("noxnetnormal")
	texw, texh = surface.GetTextSize("A")

	local headerBackground = vgui.Create("DPanel", scrollPanel)
	headerBackground:SetBackgroundColor(COLOR_TEAM_BLUE)
	headerBackground:SetSize(width, texh * 1.25)

	local label = vgui.Create("DLabel", headerBackground)
	local text = "F1: Help"
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText(text)
	label:SetPos(16 * UIScalingW, 5 * UIScalingH)
	local texw, texh = surface.GetTextSize(text)
	label:SetSize(texw, texh)

	label = vgui.Create("DLabel", headerBackground)
	text = "F2: Manual Redeem"
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText(text)
	texw, texh = surface.GetTextSize(text)
	label:SetPos(195 * UIScalingW - texw * 0.5, 5 * UIScalingH)
	label:SetSize(texw, texh)

	label = vgui.Create("DLabel", headerBackground)
	text = "F3: Change Zombie Class"
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText(text)
	texw, texh = surface.GetTextSize(text)
	label:SetPos(405 * UIScalingW - texw * 0.5, 5 * UIScalingH)
	label:SetSize(texw, texh)

	label = vgui.Create("DLabel", headerBackground)
	text = "F4: Options"
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText(text)
	texw, texh = surface.GetTextSize(text)
	label:SetPos(650 * UIScalingW - texw - 16 * UIScalingW, 5 * UIScalingH)
	label:SetSize(texw, texh)

	surface.SetFont("Default")
	local ___, defh = surface.GetTextSize("|")

	local touse = HELP_TEXT
	if SURVIVALMODE then
		touse = HELP_TEXT_SURVIVALMODE
	end
	local y = 25 * UIScalingH
	for i, text in ipairs(touse) do
		if string.len(text) <= 1 then
			y = y + defh
		else
			local label = vgui.Create("DLabel", scrollPanel)
			local pretext = string.sub(text, 1, 2)
			if pretext == "^r" then
				label:SetTextColor(COLOR_READABLERED)
				text = string.sub(text, 3)
			elseif pretext == "^g" then
				label:SetTextColor(COLOR_LIMEGREEN)
				text = string.sub(text, 3)
			elseif pretext == "^y" then
				label:SetTextColor(COLOR_YELLOW)
				text = string.sub(text, 3)
			elseif pretext == "^b" then
				label:SetTextColor(COLOR_CYAN)
				text = string.sub(text, 3)
			else
				label:SetTextColor(color_white)
			end
			if i == 1 then
				label:SetFont("HUDFontSmallAA")
			else
				label:SetFont("DefaultSmallScaled")
			end
			label:SetText(text)
			label:SetPos(16 * UIScalingW, y * UIScalingH)
			label:SetSize(640 * UIScalingW, 64 * UIScalingH)
			y = y + defh
		end
	end
end
