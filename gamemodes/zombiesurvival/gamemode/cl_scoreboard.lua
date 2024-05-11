include( "scoreboard/scoreboard.lua" )

local pScoreBoard = nil

function GM:CreateScoreboard()
	if ScoreBoard then
		ScoreBoard:Remove()
		ScoreBoard = nil
	end
	pScoreBoard = vgui.Create("ScoreBoard")
end

function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)
	
	if not pScoreBoard then
		self:CreateScoreboard()
	end
	
	pScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker(false)
	pScoreBoard:SetVisible(false)
end

function GM:HUDDrawScoreBoard()
end

function GM:GUIMousePressed(mousecode)
end

function GM:GUIMouseReleased(mousecode)
end

function GM:GUIMouseDoublePressed(mousecode)
end
