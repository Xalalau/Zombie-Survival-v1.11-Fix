include("vgui/scoreboard.lua")

local pScoreBoard = nil

function GM:CreateScoreboard()
	local pan = vgui.Create("ScoreBoard")
end

function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true

	gui.EnableScreenClicker(true)

	if SCOREBOARD then
		SCOREBOARD:ElementRefresh()
	else
		self:CreateScoreboard()
	end

	SCOREBOARD:SetVisible(true)
end

function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false

	gui.EnableScreenClicker(false)

	SCOREBOARD:SetVisible(false)
end

function GM:HUDDrawScoreBoard()
end
