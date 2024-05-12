function MakepWeapons()
	if pWeapons then
		pWeapons:Remove()
		pWeapons = nil
	end

	local numrewards = table.Count(GAMEMODE.Rewards)
	local wspacing = 128
	local hspacing = 80

	local totalgroups = 0
	local maxrewcount = 0
	for i=1, table.maxn(GAMEMODE.Rewards) do
		local tab = GAMEMODE.Rewards[i]
		if tab then
			totalgroups = totalgroups + 1
			local chances = {}
			local totalchances = 0
			for _, entry in pairs(tab) do
				chances[entry] = (chances[entry] or 0) + 1
				totalchances = totalchances + 1
			end

			local numsquares = table.Count(chances)

			maxrewcount = math.max(maxrewcount, numsquares)
		end
	end

	local windowwide, windowtall = totalgroups * wspacing + 128, maxrewcount * hspacing + 148

	local Window = vgui.Create("DFrame")
	Window:SetSize(windowwide, windowtall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	pWeapons = Window

	surface.SetFont("HUDFontAA")
	local tw, th = surface.GetTextSize("Arsenal Upgrades Tree")
	local label = vgui.Create("DLabel", Window)
	label:SetPos(windowwide * 0.5 - tw * 0.5, 21)
	label:SetSize(tw, th)
	label:SetFont("HUDFontAA")
	label:SetText("Arsenal Upgrades Tree")
	label:SetTextColor(color_white)

	surface.SetFont("DefaultBold")
	local defbw, defbh = surface.GetTextSize("|Test|")

	local x = 80

	local curfrags = MySelf:Frags()

	for i=1, table.maxn(GAMEMODE.Rewards) do
		local tab = GAMEMODE.Rewards[i]
		if tab then
			local y = 128

			local chances = {}
			local totalchances = 0
			for _, entry in pairs(tab) do
				chances[entry] = (chances[entry] or 0) + 1
				totalchances = totalchances + 1
			end

			local numsquares = table.Count(chances)

			surface.SetFont("HUDFontSmall")
			local bigw, bigh = surface.GetTextSize(i.." kills")
			local dlabel = vgui.Create("DLabel", Window)
			dlabel:SetText(i.." kills")
			dlabel:SetPos(x + 32 - bigw * 0.5, 72)
			dlabel:SetSize(bigw, bigh)
			dlabel:SetFont("HUDFontSmall")
			if curfrags < i then
				dlabel:SetTextColor(COLOR_RED)
			else
				dlabel:SetTextColor(COLOR_LIMEGREEN)
			end
			dlabel:SetKeyboardInputEnabled(false)
			dlabel:SetMouseInputEnabled(false)

			for name, chance in pairs(chances) do
				local mdl
				local prettyname = name
				local tab = weapons.Get(name)
				if string.sub(name, 1, 1) == "_" then
					prettyname = "Powerup: "..string.sub(name, 2)
				elseif tab then
					mdl = tab.WorldModel
					prettyname = tab.PrintName or prettyname
				end

				local dbut = vgui.Create("SpawnIcon", Window)
				dbut:SetSize(64, 64)
				dbut:SetPos(x, y)
				dbut:SetModel(GAMEMODE.RewardIcons[name] or mdl or "models/error.mdl")
				dbut:SetKeyboardInputEnabled(false)
				dbut:SetMouseInputEnabled(false)

				--[[local dbut = vgui.Create("DModelPanel", Window)
				dbut:SetSize(64, 64)
				dbut:SetPos(x, y)
				dbut:SetCamPos(Vector(25, 25, 30))
				dbut:SetLookAt(Vector(0, 0, 10))
				dbut:SetModel(GAMEMODE.RewardIcons[name] or mdl or "models/error.mdl")
				dbut:SetKeyboardInputEnabled(false)
				dbut:SetMouseInputEnabled(false)]]

				prettyname = prettyname.." ("..math.Round((chance / totalchances) * 100).."%)"

				surface.SetFont("DefaultSmall")
				local texw, texh = surface.GetTextSize(prettyname)
				local dlabel = vgui.Create("DLabel", Window)
				dlabel:SetSize(texw, texh)
				dlabel:SetPos(x + 32 - texw * 0.5, y + 63)
				dlabel:SetText(prettyname)
				dlabel:SetFont("DefaultSmall")
				dlabel:SetTextColor(color_white)
				dlabel:SetKeyboardInputEnabled(false)
				dlabel:SetMouseInputEnabled(false)

				y = y + hspacing
			end

			x = x + wspacing
		end
	end
end
