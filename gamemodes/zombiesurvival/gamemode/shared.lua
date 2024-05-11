include("obj_player_extend.lua")
include("obj_weapon_extend.lua")
include("gravitygun.lua")
include("zs_options.lua")

GM.Name 	= "Zombie Survival "..GM.Version.." FIX"
GM.Author 	= "JetBoom"
GM.Email 	= "jetboom@yahoo.com"
GM.Website 	= "www.noxiousnet.com"

INFLICTION = 0

TEAM_ZOMBIE = 3
TEAM_UNDEAD = TEAM_ZOMBIE
TEAM_SURVIVORS = 4
TEAM_HUMAN = TEAM_SURVIVORS

team.SetUp(TEAM_ZOMBIE, "The Undead", Color(0, 255, 0))
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 160, 255))

HumanGibs = {"models/gibs/HGIBS.mdl",
"models/gibs/HGIBS_spine.mdl",
"models/gibs/HGIBS_rib.mdl",
"models/gibs/HGIBS_scapula.mdl",
"models/gibs/antlion_gib_medium_2.mdl",
"models/gibs/Antlion_gib_Large_1.mdl",
"models/gibs/Strider_Gib4.mdl"
}

HumanTorsos = {
"models/Gibs/Fast_Zombie_Torso.mdl",
"models/Zombie/Classic_torso.mdl",
"models/Humans/Charple03.mdl"
}

HumanLegs = {
"models/Zombie/Classic_legs.mdl",
"models/Gibs/Fast_Zombie_Legs.mdl"
}

for i=2, 4 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end

util.PrecacheSound("ambient/energy/whiteflash.wav")

for k, v in pairs(HumanGibs) do
	util.PrecacheModel(v)
end

ENDROUND = false

VecRand = VectorRand

function GM:LastHuman()
	if LASTHUMAN then return end
	if SERVER then
		gmod.BroadcastLua("GAMEMODE:LastHuman()")
		LASTHUMAN = true
	end
	if CLIENT then
	    surface.PlaySound(LASTHUMANSOUND)
	    NextThump = 99999
		NextThumpCalculate = 99999
	    DrawingDanger = 1
	    rounded = 10
		BeatText[10] = "Last Human!"
		hook.Add("HUDPaint", "DrawLastHuman", DrawLastHuman)
	end
end

function GM:KeyPress(player, key)
end

function GM:KeyRelease(player, key)
end

function GM:PlayerConnect(name, address, steamid)
end

function GM:PropBreak(attacker, prop)
end

function GM:SetupMove(ply, move)
end

function GM:FinishMove(ply, move)
end

function GM:Move(ply, mv)
end

function GM:ContextScreenClick(aimvec, mousecode, pressed, ply)
end

function GM:GetGameDescription()
	return self.Name
end

function GM:EntityRemoved(ent)
end

function GM:UpdateAnimation(pl)
end

function GM:PlayerTraceAttack(ply, dmginfo, dir, trace)
	return false
end

-- ZS has no sprinting
function GM:SetPlayerSpeed(ply, walk)
	if SERVER then
		ply.WalkSpeed = walk
		ply.SprintSpeed = walk
		ply:SetMaxSpeed(walk)
		ply:SendLua("GAMEMODE:SetPlayerSpeed(0,"..walk..")")
	else
		LocalPlayer().WalkSpeed = walk
		LocalPlayer().SprintSpeed = walk
	end
end
