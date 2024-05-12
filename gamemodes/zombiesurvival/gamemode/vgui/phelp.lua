function MakepCredits()
	local frame = vgui.Create("DFrame")
	frame:SetSize(640, 480)
	frame:Center()
	frame:SetTitle("Zombie Survival Credits")
	frame:SetCursor("pointer")
	frame:SetKeyboardInputEnabled(false)
	frame:SetVisible(true)
	frame:MakePopup()

	local ctrl = vgui.Create("DListView", frame)
	local Col1 = ctrl:AddColumn("Name")
	local Col2 = ctrl:AddColumn("Contact")
	local Col3 = ctrl:AddColumn("Credits")
	Col2:SetMinWidth(100)
	Col2:SetMinWidth(100)
	Col3:SetMinWidth(200)
	for authorindex, authortab in ipairs(GAMEMODE.Credits) do
		ctrl:AddLine(unpack(authortab))
	end
	ctrl:SetSize(608, 432)
	ctrl:SetPos(16, 32)
end

function MakepHelp()
	if pHelp then
		pHelp:SetVisible(true)
		pHelp:MakePopup()
		return
	end

	local wide = w * 0.5

	surface.SetFont("HUDFontSmallAA")
	local texw, texh = surface.GetTextSize("BLAH")

	local tall = math.min(h * 0.9, texh * 15 + 128)

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	pHelp = Window

	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText("F1: Help")
	surface.SetFont("noxnetnormal")
	local texw, texh = surface.GetTextSize("F1: Help")
	label:SetPos(16, 21)
	label:SetSize(texw, texh)

	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText("F2: Manual Redeem")
	surface.SetFont("noxnetnormal")
	local texw, texh = surface.GetTextSize("F2: Manual Redeem")
	label:SetPos(wide * 0.3 - texw * 0.5, 21)
	label:SetSize(texw, texh)

	local tx
	if MySelf:Team() == TEAM_HUMAN then
		tx = "F3: Arsenal Upgrades Tree"
	else
		tx = "F3: Change Zombie Class"
	end
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText(tx)
	surface.SetFont("noxnetnormal")
	local texw, texh = surface.GetTextSize(tx)
	label:SetPos(wide * 0.7 - texw * 0.5, 21)
	label:SetSize(texw, texh)

	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_RED)
	label:SetFont("noxnetnormal")
	label:SetText("F4: Options")
	surface.SetFont("noxnetnormal")
	local texw, texh = surface.GetTextSize("F4: Options")
	label:SetPos(wide - texw - 16, 21)
	label:SetSize(texw, texh)

	local y = 80

	surface.SetFont("HUDFontSmallAA")
	local texw, texh = surface.GetTextSize("Zombie Survival")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_LIMEGREEN)
	label:SetFont("HUDFontSmallAA")
	label:SetText("Zombie Survival")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh * 2

	surface.SetFont("HUDFontSmallAA")
	local texw, texh = surface.GetTextSize("Help for Humans")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_CYAN)
	label:SetFont("HUDFontSmallAA")
	label:SetText("Help for Humans")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("The objective of this game is to survive the zombie onslaught for "..NUM_WAVES.." waves.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("The objective of this game is to survive the zombie onslaught for "..NUM_WAVES.." waves.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("You start with a random loadout of weapons, each equally good for dealing with zombies in their own way.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("You start with a random loadout of weapons, each equally good for dealing with zombies in their own way.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("By killing zombies, you will unlock new weapons! See F3 for the weapon tree. You receive one random weapon each branch.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("By killing zombies, you will unlock new weapons! See F3 for the weapon tree. You receive one random weapon each branch.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("Ammo is sparse and you get more when the timer on the bottom right runs out!")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("Ammo is sparse and you get more when the timer on the bottom right runs out!")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("You can use right click on your guns to go in to ironsights mode. You aim much better when in this mode but you are also very slow.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("You can use right click on your guns to go in to ironsights mode. You aim much better when in this mode but you are also very slow.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("You can press USE on some props to carry and drag heavier ones. Press USE again to drop them.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("You can press USE on some props to carry and drag heavier ones. Press USE again to drop them.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("The Hammer weapon comes with 6 nails you can use to help fortify you. Use the hammer's right click for nails.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("The Hammer weapon comes with 6 nails you can use to help fortify you. Use the hammer's right click for nails.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("Each wave lasts slightly longer than the last and when it's over, gives you some time to refortify your positions.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("Each wave lasts slightly longer than the last and when it's over, gives you some time to refortify your positions.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("Harder zombies are unlocked as the game goes on so make sure to preserve your supplies.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("Harder zombies are unlocked as the game goes on so make sure to preserve your supplies.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("Use teamwork and keep away from those zombies! Zombies get a damage resistance while in groups!")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("Use teamwork and keep away from those zombies! Zombies get a damage resistance while in groups!")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh * 2

	surface.SetFont("HUDFontSmallAA")
	local texw, texh = surface.GetTextSize("Help for Zombies")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_GREEN)
	label:SetFont("HUDFontSmallAA")
	label:SetText("Help for Zombies")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	if REDEEM then
		if AUTOREDEEM then
			surface.SetFont("DefaultSmall")
			local texw, texh = surface.GetTextSize("If you are killed by a zombie, you become one! You can then redeem yourself by killing "..REDEEM_KILLS.." humans.")
			local label = vgui.Create("DLabel", Window)
			label:SetTextColor(color_white)
			label:SetFont("DefaultSmall")
			label:SetText("If you are killed by a zombie, you become one! You can then redeem yourself by killing "..REDEEM_KILLS.." humans.")
			label:SetPos(wide * 0.5 - texw * 0.5, y)
			label:SetSize(texw, texh)
			y = y + texh
		else
			surface.SetFont("DefaultSmall")
			local texw, texh = surface.GetTextSize("If you are killed by a zombie, you become one! You can then redeem yourself by killing "..REDEEM_KILLS.." humans and pressing F2.")
			local label = vgui.Create("DLabel", Window)
			label:SetTextColor(color_white)
			label:SetFont("DefaultSmall")
			label:SetText("If you are killed by a zombie, you become one! You can then redeem yourself by killing "..REDEEM_KILLS.." humans.")
			label:SetPos(wide * 0.5 - texw * 0.5, y)
			label:SetSize(texw, texh)
			y = y + texh
		end
	else
		surface.SetFont("DefaultSmall")
		local texw, texh = surface.GetTextSize("If you are killed by a zombie, you become one! You can't win the round anymore, but atleast you can stop others from doing it.")
		local label = vgui.Create("DLabel", Window)
		label:SetTextColor(color_white)
		label:SetFont("DefaultSmall")
		label:SetText("If you are killed by a zombie, you become one! You can't win the round anymore, but atleast you can stop others from doing it.")
		label:SetPos(wide * 0.5 - texw * 0.5, y)
		label:SetSize(texw, texh)
		y = y + texh
	end

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("As the waves go on, new and better zombie classes are unlocked. Access the class changing menu with F3.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("As the waves go on, new and better zombie classes are unlocked. Access the class changing menu with F3.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("Zombies receive a damage resistance when they are in groups (the bottom left meter). Stick with others to last longer!")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("Zombies receive a damage resistance when they are in groups (the bottom left meter). Stick with others to last longer!")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("You can destroy any barricade a human puts up by hitting them and even smash doors in. Door health is indicated by how red it is.")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("You can destroy any barricade a human puts up by hitting them and even smash doors in. Door health is indicated by how red it is.")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh

	surface.SetFont("DefaultSmall")
	local texw, texh = surface.GetTextSize("As a zombie, you have the gift of infinite lives. Don't let this go to waste!")
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(color_white)
	label:SetFont("DefaultSmall")
	label:SetText("As a zombie, you have the gift of infinite lives. Don't let this go to waste!")
	label:SetPos(wide * 0.5 - texw * 0.5, y)
	label:SetSize(texw, texh)
	y = y + texh


	local button = vgui.Create("DButton", Window)
	button:SetPos(wide * 0.5 - 168, tall - 48)
	button:SetSize(160, 32)
	button:SetText("Close")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) end

	local button = vgui.Create("DButton", Window)
	button:SetPos(wide * 0.5 + 8, tall - 48)
	button:SetSize(160, 32)
	button:SetText("Game Credits")
	button.DoClick = function(btn) MakepCredits() end
end
