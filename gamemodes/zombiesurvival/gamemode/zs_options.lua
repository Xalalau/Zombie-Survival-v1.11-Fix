// Change this if you edit the gamemode in a big way or something. v1.0_Reloaded or something like that. For the server list.
GM.Version  = "v1.05"


function ToMinutesSeconds(TimeInSeconds)
	local iMinutes = math.floor(TimeInSeconds / 60.0)
	return string.format("%0d:%02d", iMinutes, math.floor(TimeInSeconds - iMinutes*60))
end

----------------------------------
-- KILL LEVEL REWARDS --
-----------------------------------
-- Rewards that start with _ will be called as a powerup. ( PowerupFunctions["_name"](ply) ) This is cAsE-SenSiTivE!
-- See powerups.lua for examples and stuff.

Rewards = {} -- Leave this.
Rewards[5] = {"weapon_zs_deagle", "weapon_zs_glock3"}
Rewards[10] = {"_Heal", "_Heal", "_Shell"}
Rewards[15] = {"weapon_zs_uzi"}
Rewards[28] = {"weapon_zs_sweepershotgun", "weapon_zs_slugrifle"}
Rewards[60] = {"_Regeneration", "_Heal"}
Rewards[75] = {"weapon_slam"}

--------------------------------------
-- AMMO REGENERATION --
--------------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
AmmoRegeneration = {} -- Leave it.
AmmoRegeneration["ar2"] = 30
AmmoRegeneration["alyxgun"] = 18
AmmoRegeneration["pistol"] = 20
AmmoRegeneration["smg1"] = 50
AmmoRegeneration["357"] = 14
AmmoRegeneration["xbowbolt"] = 5
AmmoRegeneration["buckshot"] = 12
AmmoRegeneration["ar2altfire"] = 1
AmmoRegeneration["slam"] = 2
AmmoRegeneration["rpg_round"] = 1
AmmoRegeneration["smg1_grenade"] = 1
AmmoRegeneration["sniperround"] = 5
AmmoRegeneration["sniperpenetratedround"] = 5
AmmoRegeneration["grenade"] = 1
AmmoRegeneration["thumper"] = 1
AmmoRegeneration["gravity"] = 1
AmmoRegeneration["battery"] = 1
AmmoRegeneration["gaussenergy"] = 50
AmmoRegeneration["combinecannon"] = 10
AmmoRegeneration["airboatgun"] = 100
AmmoRegeneration["striderminigun"] = 100
AmmoRegeneration["helicoptergun"] = 100

------------------------------
-- SERVER OPTIONS --
------------------------------
-- If you like NPC's.
USE_NPCS = false
-- Set this to true if you want people to get 'kills' from killing NPC's.
-- IT IS STRONGLY SUGGESTED THAT YOU EDIT THE REWARDS TABLE TO
-- MAKE THE REWARDS REQUIRE MORE KILLS AND/OR MAKE THE DIFFICULTY HIGHER IF YOU DO THIS!!!
-- Example, change Rewards[6] to Rewards[15]. The number represents the kills.
NPCS_COUNT_AS_KILLS = false

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5
-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
-- if you set this number to something stupid like 0, you'll have some lag issues.
AMMO_REGENERATE_RATE = 110

-- In seconds, how long humans need to survive.
ROUNDTIME = 20 * 60
-- Time in seconds between end round and next map.
INTERMISSION_TIME = 35
-- New joining players will be put on the Undead team if the round is half over.
HUMAN_DEADLINE = true
-- Set this to true to destroy all brush-based doors that aren't based on phys_hinge and func_physbox or whatever. For door campers.
DESTROY_DOORS = true
-- Set this to true to destroy all prop-based doors. Not recommended since some doors have boards on them and what-not. Only for true door camping whores.
DESTROY_PROP_DOORS = false
-- Set this to true to force players to have mat_monitorgamma set to 2.2. This could cause problems with non-calibrated screens so, whatever.
-- It forces people to use flashlights instead of whoring the video settings to make it brighter.
FORCE_NORMAL_GAMMA = true
-- Turn this to true if you don't want humans to be able to camp inside of vents and other hard to reach areas. They will die
-- if they are in a vent for 60 seconds or more.
ANTI_VENT_CAMP = true
-- Set this to true if you want your admins to be able to use the 'noclip' concommand.
-- If they already have rcon then it's pointless to set this to false.
ALLOW_ADMIN_NOCLIP = true
-- Sound to play for last human.
LASTHUMANSOUND = "lasthuman.mp3"
-- Sound played to a person when they lose.
ALLLOSESOUND = "lose_test.mp3"
-- Sound played to a person when they win.
HUMANWINSOUND = "humanwin.mp3"
-- Sound played to a person when they die as a human.
DEATHSOUND = "music/stingers/HL1_stinger_song28.mp3"

-- Human kills needed for a zombie player to redeem (resurrect). Do not set this to 0. If you want to turn this
-- system off, set AUTOREDEEM to false.
REDEEM_KILLS = 4
-- Turn off/on the redeeming system.
REDEEM = true
-- Players don't have a choice if they want to redeem or not. Setting to false makes them press F2.
AUTOREDEEM = true

local shit = ""
if REDEEM then
	shit = [[You must hurry and redeem yourself before the round ends!@
To redeem yourself, kill ]]..REDEEM_KILLS..[[ humans and you will respawn as a human.]]
end

if CLIENT then
local weapon_table_text = ""
for i=1, table.maxn(Rewards) do
	if Rewards[i] then
		if #Rewards[i] > 1 then
			local printnames = {}
			for _, wep in pairs(Rewards[i]) do
				if string.sub(wep, 1, 1) ~= "_" then
					if weapons.GetStored(wep) then
						table.insert(printnames, weapons.GetStored(wep).PrintName)
					else
						table.insert(printnames, wep)
					end
				else
					table.insert(printnames, wep)
				end
			end
			weapon_table_text = weapon_table_text..[[^r          ]]..i..[[ kills: Chance of ]]..table.concat(printnames, " or ")..[[@]]
		elseif string.sub(Rewards[i][1], 1, 1) ~= "_" then
			if weapons.GetStored(Rewards[i][1]) then
				weapon_table_text = weapon_table_text..[[^r          ]]..i..[[ kills: ]]..(weapons.GetStored(Rewards[i][1]).PrintName or Rewards[i][1])..[[@]]
			else
				weapon_table_text = weapon_table_text..[[^r          ]]..i..[[ kills: ]]..Rewards[i][1]..[[@]]
			end
		else
			weapon_table_text = weapon_table_text..[[^r          ]]..i..[[ kills: ]]..string.sub(Rewards[i][1], 2)..[[@]]
		end
	end
end

-- This is what is displayed on the scoreboard, in the help menu. Seperate lines with "@"
-- Don't put @'s right next to eachother.
-- Use ^r ^g ^b ^y  when the line starts to change color of the line

HELP_TEXT = [[^rWelcome to Zombie Survival, for GMod10.@ @^b          -- HUMANS --@^bSurvive for ]]..ToMinutesSeconds(ROUNDTIME)..[[ to win the match.@If you get killed by a zombie, you become one! ]]..shit..[[@ @Watch the infliction bar. The bigger it is, the more humans are dead!@The bar at the bottom of the screen represents your fear and how many zombies are in your immediate area.@^bA blue bar means only 1 - 3 are near you.@^yA yellow or red bar means anywhere from 5 - 9 are near you.@^rA full bar means that zombies are right near you, and in mass numbers!@ @If you lose enough health, your vision will enhance due to adrenaline.@ @^rRewards for killing zombies:@]]..weapon_table_text..[[ @ @^g          -- ZOMBIES --@You can change your class as a zombie by going in the scoreboard and pressing the "classes" tab.@Classes in red mean that more humans need to be killed to get that class unlocked.@ @^rYou lose the match if all humans die or you're a zombie at the end of the round.@ @^yVisit www.noxiousnet.com or forums.facepunchstudios.com for updates to the game!]]

HELP_TEXT = string.Explode("@", HELP_TEXT)
for _, text in pairs(HELP_TEXT) do
	text = string.gsub(text, "@", "")
end
end

----------------------------
-- ZOMBIE CLASSES --
-----------------------------
ZombieClasses = {} -- Leave this.

ZombieClasses[1] =						-- The number should not be the same as any other class. You can't skip numbers.
{
	Name = "Zombie",					-- Display name.
	Revives = true,						-- Zombie will revive if not shot in the head.
	Health = 150,						-- Obviously enough, health
	Threshold = 0.0,					-- Infliction <a number between 0.0 and 1.0, 0 being anytime and 1 being when there's 100% zombies> needed in order to change to this class.
	SWEP = "weapon_zs_zombie",			-- The weapon file to use.
	Model = Model("models/Zombie/Classic.mdl"),	-- The world model to use. If you make your own class, you must set up it's own animations or use the default HL2MP ones.
	Speed=130,							-- Speed moving on the ground.
	Description="The slow, sulking bag of flesh. This is your basic zombie.@Unique abilitys: Can claw at objects to send them flying.", -- Description to display at class selection. Seperate lines by the @ character.
	PainSounds = {
				Sound("npc/zombie/zombie_pain1.wav"),
				Sound("npc/zombie/zombie_pain2.wav"),
				Sound("npc/zombie/zombie_pain3.wav"),
				Sound("npc/zombie/zombie_pain4.wav"),
				Sound("npc/zombie/zombie_pain5.wav"),
				Sound("npc/zombie/zombie_pain6.wav")
				}, -- Played when the zombie is hurt by something. (bullet ect)
	DeathSounds = {
				Sound("npc/zombie/zombie_die1.wav"),
				Sound("npc/zombie/zombie_die2.wav"),
				Sound("npc/zombie/zombie_die3.wav")
				}, -- Played when the zombie is killed.
	Unlocked = true // Don't change this. This is only for 0.0 infliction classes.
}

ZombieClasses[2] = 
{
	Name = "Fast Zombie",
	Health = 80,
	Threshold = 0.5,
	SWEP = "weapon_zs_fastzombie",
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 225,
	Description = "The faster, more decomposed, boney zombie. This is your fast attack zombie@Unique abilitys: Can climb walls and leep good distances.",
	PainSounds = {
				Sound("npc/fast_zombie/leap1.wav"),
				Sound("npc/fast_zombie/wake1.wav")
				},
	DeathSounds = {
				Sound("npc/fast_zombie/fz_alert_close1.wav")
				}
}

ZombieClasses[3] =
{
	Name = "Poison Zombie",
	Health = 280,
	Threshold = 0.65,
	SWEP = "weapon_zs_poisonzombie",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 115,
	Description="A giant mass of decaying flesh.@Unique abilitys: Massive melee damage and can throw headcrabs.",
	PainSounds = {
				Sound("npc/zombie_poison/pz_pain1.wav"),
				Sound("npc/zombie_poison/pz_pain2.wav"),
				Sound("npc/zombie_poison/pz_pain3.wav")
				},
	DeathSounds = {
				Sound("npc/zombie_poison/pz_die1.wav"),
				Sound("npc/zombie_poison/pz_die2.wav")
				}
}

ZombieClasses[4] =
{
	Name = "Chem-Zombie",
	Health = 25,
	Threshold = 0.75,
	SWEP = "weapon_zs_chemzombie",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 135,
	Description="Mutated zombie full of volatile chemicals.@Unique abilitys: explodes when killed.",
	PainSounds = {
				Sound("npc/metropolice/pain1.wav"),
				Sound("npc/metropolice/pain2.wav"),
				Sound("npc/metropolice/pain3.wav"),
				Sound("npc/metropolice/pain4.wav"),
				Sound("npc/metropolice/knockout2.wav")
				},
	DeathSounds = {
				Sound("ambient/fire/gascan_ignite1.wav")
				}
}

ZombieClasses[5] =
{
	Name = "Headcrab",
	Health = 15,
	Threshold = 0.26,
	SWEP = "weapon_zs_headcrab",
	Model = Model("models/headcrabclassic.mdl"),
	Speed = 140,
	Description="A headcrab.@Unique abilitys: humps heads.",
	PainSounds = {
				Sound("npc/headcrab/pain1.wav"),
				Sound("npc/headcrab/pain2.wav"),
				Sound("npc/headcrab/pain3.wav")
				},
	DeathSounds = {
				Sound("npc/headcrab/die1.wav"),
				Sound("npc/headcrab/die2.wav")
				}
}

ZombieClasses[6] =
{
	Name="Zombie Torso",
	Health=30,
	Threshold=0,
	SWEP="weapon_zs_zombietorso",
	Model=Model("models/Zombie/Classic_torso.mdl"),
	Speed=100,
	Description="You shouldn't even be seeing this.",
	PainSounds = {
				Sound("npc/zombie/zombie_pain1.wav"),
				Sound("npc/zombie/zombie_pain2.wav"),
				Sound("npc/zombie/zombie_pain3.wav"),
				Sound("npc/zombie/zombie_pain4.wav"),
				Sound("npc/zombie/zombie_pain5.wav"),
				Sound("npc/zombie/zombie_pain6.wav")
				},
	DeathSounds = {
				Sound("npc/zombie/zombie_die1.wav"),
				Sound("npc/zombie/zombie_die2.wav"),
				Sound("npc/zombie/zombie_die3.wav")
				},
	Unlocked = true,
	Hidden = true -- The class won't show up in any menus and can't be switched to unless the script is told to switch to it.
}

-- Male pain / death sounds
MalePainSoundsLight = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

MalePainSoundsMed = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

MalePainSoundsHeavy = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

MaleDeathSounds = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav")
}

-- Female pain / death sounds
FemalePainSoundsLight = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

FemalePainSoundsMed = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

FemalePainSoundsHeavy = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

FemaleDeathSounds = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav")
}

-- Add models to this table to prevent human players from using them. (Zombie skins and such)

RestrictedModels = {}
RestrictedModels["models/player/classic.mdl"] = true -- This is the only one that really looks like a zombie.
