local function SwitchClass(btn)
	RunConsoleCommand("zs_class", btn.Class.Name)
	surface.PlaySound("buttons/button15.wav")
	pClasses:SetVisible(false)
end

function MakepClasses()
	if pClasses then
		pClasses:Remove()
		pClasses = nil
	end

	local Window = vgui.Create("DFrame")
	Window:SetPos(w * 0.25, h * 0.025)
	Window:SetSize(w * 0.5, h * 0.95)
	Window:SetTitle(" ")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	pClasses = Window

	local button = vgui.Create("DButton", Window)
	button:SetPos(w * 0.5 - 72, 72)
	button:SetSize(64, 29)
	button:SetText("Donations")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) OpenDonationHTML() end

	local button = vgui.Create("DButton", Window)
	button:SetPos(w * 0.5 - 72, 104)
	button:SetSize(64, 29)
	button:SetText("Global Store")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) RunConsoleCommand("shopmenu") end

	local button = vgui.Create("DButton", Window)
	button:SetPos(w * 0.5 - 72, 136)
	button:SetSize(64, 29)
	button:SetText("Server Portal")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) RunConsoleCommand("serverportal") end

	surface.SetFont("HUDFontAA")
	local tw, th = surface.GetTextSize("Choose a class...")
	local label = vgui.Create("DLabel", Window)
	label:SetPos(w * 0.25 - tw * 0.5, 21)
	label:SetSize(tw, th)
	label:SetFont("HUDFontAA")
	label:SetText("Choose a class...")
	label:SetTextColor(color_white)

	local y = 60

	for i, class in ipairs(GAMEMODE.ZombieClasses) do
		if not class.Hidden then
			local button = vgui.Create("SpawnIcon", Window)
			button:SetPos(16, y)
			button:SetSize(48, 48)
			button:SetModel(class.Model)
			button.Class = class
			button.OnMousePressed = SwitchClass

			surface.SetFont("HUDFontSmallAA")
			local tw, th = surface.GetTextSize(class.Name)
			local label = vgui.Create("DLabel", Window)
			label:SetPos(button:GetWide() + 24, y + 2)
			label:SetSize(tw, th)
			label:SetFont("HUDFontSmallAA")
			label:SetText(class.Name)
			if class.Wave <= GAMEMODE:GetWave() or class.Wave - 1 <= GAMEMODE:GetWave() and not GAMEMODE:GetFighting() then
				label:SetTextColor(COLOR_LIMEGREEN)
			else
				label:SetTextColor(COLOR_RED)
			end

			local yy = y + 2 + th
			for i, line in ipairs(string.Explode("@", class.Description)) do
				surface.SetFont("Default")
				local tw, th = surface.GetTextSize(line)
				local label = vgui.Create("DLabel", Window)
				label:SetPos(button:GetWide() + 27, yy)
				label:SetSize(tw, th)
				label:SetFont("Default")
				label:SetText(line)
				label:SetTextColor(COLOR_GRAY)
				yy = yy + th + 1
			end

			y = y + button:GetTall() + 16
		end
	end
end
