--[[
	Zombie Survival 1.11 Fix

	"author_name"	"JetBoom"
	"author_email"	"jetboom@yahoo.com"
	"author_url"	"http://www.noxiousnet.com/"

	"maintainer_name"	"Xalalau"

	"info"		"Humans must survive for a set amount of time against the growing hordes of player zombies. From the maker of ZS for GMod9. Ported to GMod March 2024 Update+ by Xalalau."
]]

-- Don't change this. If you change this then you're an IDIOT.
GM.Version  = "v1.11 Fix 2"
-- Change this if you're not going to use the default install and/or settings. If you edit this file then it will automatically set it to Unofficial.
GM.SubVersion = "Unofficial"

function ToMinutesSeconds(TimeInSeconds)
	local iMinutes = math.floor(TimeInSeconds / 60.0)
	return string.format("%0d:%02d", iMinutes, math.floor(TimeInSeconds - iMinutes*60))
end

----------------------------------
--		STARTING LOADOUTS		--
----------------------------------

GM.STARTLOADOUTS = {
{"weapon_zs_battleaxe", "weapon_zs_swissarmyknife"},
{"weapon_zs_peashooter", "weapon_zs_swissarmyknife"}
}

-----------------------------------
-- 		KILL LEVEL REWARDS		 --
-----------------------------------

-- Rewards that start with _ will be called as a powerup. ( PowerupFunctions["_name"](ply) ) This is cAsE-SenSiTivE!
-- See powerups.lua for examples and stuff.
-- Changing these means you're most likely an idiot.

GM.Rewards = {} -- Leave this.
GM.Rewards[cvars.Number("zs_rewards_1", 2)] = {"weapon_zs_deagle", "weapon_zs_deagle", "weapon_zs_glock3", "weapon_zs_glock3", "weapon_zs_magnum"}
GM.Rewards[cvars.Number("zs_rewards_2", 4)] = {"_Heal", "_Heal", "_Shell"}
GM.Rewards[cvars.Number("zs_rewards_3", 6)] = {"weapon_zs_uzi", "weapon_zs_uzi", "weapon_zs_crossbow", "weapon_zs_smg"}
GM.Rewards[cvars.Number("zs_rewards_4", 8)] = {"weapon_zs_sweepershotgun", "weapon_zs_slugrifle"}
GM.Rewards[cvars.Number("zs_rewards_5", 10)] = {"weapon_zs_barricadekit"}
GM.Rewards[cvars.Number("zs_rewards_6", 12)] = {"_Regeneration", "_Heal"}
GM.Rewards[cvars.Number("zs_rewards_7", 14)] = {"weapon_slam"}

----------------------------------
--		AMMO REGENERATION		--
----------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
-- Changing these means you're an idiot.

GM.AmmoRegeneration = {} -- Leave it.
GM.AmmoRegeneration["ar2"] = 30
GM.AmmoRegeneration["alyxgun"] = 18
GM.AmmoRegeneration["pistol"] = 20
GM.AmmoRegeneration["smg1"] = 50
GM.AmmoRegeneration["357"] = 14
GM.AmmoRegeneration["xbowbolt"] = 10
GM.AmmoRegeneration["buckshot"] = 12
GM.AmmoRegeneration["ar2altfire"] = 1
GM.AmmoRegeneration["slam"] = 2
GM.AmmoRegeneration["rpg_round"] = 1
GM.AmmoRegeneration["smg1_grenade"] = 1
GM.AmmoRegeneration["sniperround"] = 1
GM.AmmoRegeneration["sniperpenetratedround"] = 5
GM.AmmoRegeneration["grenade"] = 1
GM.AmmoRegeneration["thumper"] = 1
GM.AmmoRegeneration["gravity"] = 1
GM.AmmoRegeneration["battery"] = 1
GM.AmmoRegeneration["gaussenergy"] = 50
GM.AmmoRegeneration["combinecannon"] = 10
GM.AmmoRegeneration["airboatgun"] = 100
GM.AmmoRegeneration["striderminigun"] = 100
GM.AmmoRegeneration["helicoptergun"] = 100

------------------------------
--		SERVER OPTIONS		--
------------------------------

-- If you like NPC's. NPC's will only spawn in maps that actually were built to have them in the first place. This gamemode won't create it's own.
USE_NPCS = cvars.Bool("zs_allow_map_npcs", false)

-- Set this to true if you want people to get 'kills' from killing NPC's.
-- IT IS STRONGLY SUGGESTED THAT YOU EDIT THE REWARDS TABLE TO
-- MAKE THE REWARDS REQUIRE MORE KILLS AND/OR MAKE THE DIFFICULTY HIGHER IF YOU DO THIS!!!
-- Example, change Rewards[6] to Rewards[15]. The number represents the kills.
NPCS_COUNT_AS_KILLS = cvars.Bool("zs_npcs_count_as_kills", false)

-- Auto apply NPC configs if the player is in singleplayer mode
if game.SinglePlayer() then
	USE_NPCS = true
	NPCS_COUNT_AS_KILLS = true
end

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = cvars.Number("zs_difficulty", 1.5)

-- Use Zombie Survival's custom footstep sounds? I'm not sure how bad it might lag considering you're potentially sending a lot of data on heavily packed servers.
CUSTOM_FOOTSTEPS = true

-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
-- if you set this number to something stupid like 0, you'll have some lag issues.
AMMO_REGENERATE_RATE = cvars.Number("zs_ammo_regenerate_rate", 75)

-- In seconds, how long humans need to survive.
ROUNDTIME = cvars.Number("zs_roundtime", 600) -- 10 minutes

-- Time in seconds between end round and next map.
INTERMISSION_TIME = cvars.Number("zs_intermission_time", 25)

-- New joining players will be put on the Undead team if the round is half over.
HUMAN_DEADLINE = cvars.Bool("zs_human_deadline", true)

-- Set this to true to destroy all brush-based doors that aren't based on phys_hinge and func_physbox or whatever. For door campers.
DESTROY_DOORS = cvars.Bool("zs_destroy_doors", true)

-- Set this to true to destroy all prop-based doors. Not recommended since some doors have boards on them and what-not. Only for true door camping whores.
DESTROY_PROP_DOORS = cvars.Bool("zs_destroy_prop_doors", false)

-- Set this to true to force players to have mat_monitorgamma set to 2.2. This could cause problems with non-calibrated screens so, whatever.
-- It forces people to use flashlights instead of whoring the video settings to make it brighter.
FORCE_NORMAL_GAMMA = false

-- Turn this to true if you don't want humans to be able to camp inside of vents and other hard to reach areas. They will die
-- if they are in a vent for 60 seconds or more.
ANTI_VENT_CAMP = cvars.Bool("zs_anti_vent_camp", true)

-- Set this to true to allow humans to shove other humans by pressing USE. Great for door blocking tards.
ALLOW_SHOVE = cvars.Bool("zs_allow_shove", true)

-- Set this to true if you want your admins to be able to use the 'noclip' concommand.
-- If they already have rcon then it's pointless to set this to false.
ALLOW_ADMIN_NOCLIP = cvars.Bool("zs_allow_admin_noclip", true)

-- Sound to play for last human.
LASTHUMANSOUND = "lasthuman.mp3"

-- In seconds, the length of the above file. It's important to have this correct or you may get delayed or overlapping music.
LASTHUMANSOUNDLENGTH = 119

-- Sound to play for ambient Un-Life music.
UNLIFESOUND = "unlife1.mp3"
UNLIFESOUNDLENGTH = 210

-- Sound played to a person when they lose.
ALLLOSESOUND = "lose_test.mp3"

-- Sound played to a person when they win.
HUMANWINSOUND = "humanwin.mp3"

-- Sound played to a person when they die as a human.
DEATHSOUND = "music/stingers/HL1_stinger_song28.mp3"

-- Turn off/on the redeeming system.
REDEEM = cvars.Bool("zs_allow_redeeming", true)

-- Human kills needed for a zombie player to redeem (resurrect). Do not set this to 0. If you want to turn this
-- system off, set AUTOREDEEM to false.
REDEEM_KILLS = cvars.Number("zs_redeem_kills", 3)

-- Players don't have a choice if they want to redeem or not. Setting to false makes them press F2.
AUTOREDEEM = cvars.Bool("zs_autoredeem", true)

-- If a person dies when there are less than the above amount of people, don't set them on the undead team if this is true. This should generally be true on public / big servers.
WARMUP_MODE = cvars.Bool("zs_warmup_mode", true)
WARMUP_THRESHOLD = cvars.Number("zs_warmup_threshold", 2)

-- Missing config - Xala
SURVIVALMODE = false


if game.MaxPlayers() < 4 then
	WARMUP_MODE = false
end

if CLIENT then
	util.PrecacheSound(LASTHUMANSOUND)
	util.PrecacheSound(UNLIFESOUND)
end

local shit = ""
if REDEEM then
	shit = [[You must hurry and redeem yourself before the round ends!]] ..
	[[@To redeem yourself, kill ]]..REDEEM_KILLS..[[ humans and you will respawn as a human.]]
end

if CLIENT then
	local weapon_table_text = ""
	for i=1, table.maxn(GM.Rewards) do
		if GM.Rewards[i] then
			if #GM.Rewards[i] > 1 then
				local printnames = {}
				for _, wep in ipairs(GM.Rewards[i]) do
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
				weapon_table_text = weapon_table_text..[[^r  ]]..i..[[ kills: Chance of ]]..table.concat(printnames, " or ")..[[@]]
			elseif string.sub(GM.Rewards[i][1], 1, 1) ~= "_" then
				if weapons.GetStored(GM.Rewards[i][1]) then
					weapon_table_text = weapon_table_text..[[^r  ]]..i..[[ kills: ]]..(weapons.GetStored(GM.Rewards[i][1]).PrintName or GM.Rewards[i][1])..[[@]]
				else
					weapon_table_text = weapon_table_text..[[^r  ]]..i..[[ kills: ]]..GM.Rewards[i][1]..[[@]]
				end
			else
				weapon_table_text = weapon_table_text..[[^r  ]]..i..[[ kills: ]]..string.sub(GM.Rewards[i][1], 2)..[[@]]
			end
		end
	end

	-- This is what is displayed on the scoreboard, in the help menu. Seperate lines with "@"
	-- Don't put @'s right next to eachother.
	-- Use ^r ^g ^b ^y  when the line starts to change color of the line

	HELP_TEXT =
		[[^gWelcome to Zombie Survival v1.11 Fix @^gBy JetBoom (2008). Adapted to GMod March 2024 Update+ by Xalalau.@ @^b          -- HUMANS --@^bSurvive for ]] ..
		ToMinutesSeconds(ROUNDTIME) ..
		[[ to win the match.@If you get killed by a zombie, you become one! ]] ..
		shit .. 
		[[@ @Watch the infliction bar. The bigger it is, the more humans are dead!@The bar at the bottom ]] ..
		[[of the screen represents your fear and how many zombies are in your immediate area.@^bA blue bar ]] ..
		[[means only 1 - 3 are near you.@^yA yellow or red bar means anywhere from 5 - 9 are near you.@^rA full ]] ..
		[[bar means that zombies are right near you, and in mass numbers!@ @If you lose enough health, your ]] ..
		[[vision will start to blur to signify your upcoming death.@Killing zombies will grant you more weapons ]] ..
		[[but your main objective is to survive!@If you stay together and defend your entrances then you are sure ]] ..
		[[to win.@If you seperate or don't push back the zombies then you're sure to join them.@ @^rRewards for killing zombies:@ @]] ..
		weapon_table_text ..
		[[ @ @^g          -- ZOMBIES --@You can change your class as a zombie by pressing F3.@Classes in red mean ]] .. 
		[[that more humans need to be killed to get that class unlocked.@ @^rYou lose the match if all humans die ]] ..
		[[or you're a zombie at the end of the round.@If redeeming is allowed then you can kill a certain amount of ]] .. 
		[[humans to ressurect yourself.@ @^yVisit https://github.com/Xalalau/Zombie-Survival-v1.11-Fix for updates to the game!]]

	HELP_TEXT_SURVIVALMODE =
		[[^rWelcome to Zombie Survival v1.11 Fix @^rBy JetBoom (2008). Adapted to GMod March 2024 Update+ by Xalalau.@ @^b          -- HUMANS --@^bSurvive for ]] ..
		ToMinutesSeconds(ROUNDTIME) ..
		[[ to win the match.@If you get killed by a zombie, you become one! ]] ..
		shit ..
		[[@ @Watch the infliction bar. The bigger it is, the more humans are dead!@The bar at the bottom of the screen ]] ..
		[[represents your fear and how many zombies are in your immediate area.@^bA blue bar means only 1 - 3 are near you]] ..
		[[.@^yA yellow or red bar means anywhere from 5 - 9 are near you.@^rA full bar means that zombies are right near you, ]] ..
		[[and in mass numbers!@ @If you lose enough health, your vision will start to blur to signify your upcoming ]] ..
		[[death.@Killing zombies will grant you more weapons but your main objective is to survive!@If you stay together and ]] ..
		[[defend your entrances then you are sure to win.@If you seperate or don't push back the zombies then you're sure to ]] ..
		[[join them.@ @^rYou can scavenge for weapons and ammo by looking around the map for them.@ @^g          -- ZOMBIES --@You ]] ..
		[[can change your class as a zombie by pressing F3.@Classes in red mean that more humans need to be killed to get that ]] ..
		[[class unlocked.@ @^rYou lose the match if all humans die or you're a zombie at the end of the round.@If redeeming is ]] ..
		[[allowed then you can kill a certain amount of humans to ressurect yourself.@ @^yVisit https://github.com/Xalalau/Zombie-Survival-v1.11-Fix ]] ..
		[[for updates to the game!]]

	HELP_TEXT = string.Explode("@", HELP_TEXT)
	for _, text in ipairs(HELP_TEXT) do
		text = string.gsub(text, "@", "")
	end

	HELP_TEXT_SURVIVALMODE = string.Explode("@", HELP_TEXT_SURVIVALMODE)
	for _, text in ipairs(HELP_TEXT_SURVIVALMODE) do
		text = string.gsub(text, "@", "")
	end
end

----------------------------
-- ZOMBIE CLASSES --
-----------------------------
-- Changing these means you're an idiot.
ZombieClasses = {} -- Leave this.

util.PrecacheSound("npc/zombie/foot1.wav")
util.PrecacheSound("npc/zombie/foot2.wav")
util.PrecacheSound("npc/zombie/foot3.wav")
util.PrecacheSound("npc/zombie/foot_slide1.wav")
util.PrecacheSound("npc/zombie/foot_slide2.wav")
util.PrecacheSound("npc/zombie/foot_slide3.wav")

ZombieClasses[1] =						-- The number should not be the same as any other class. You can't skip numbers.
{
	Name = "Zombie",					-- Display name.
	Revives = true,						-- Zombie will revive if not shot in the head.
	Health = 175,						-- Obviously enough, health
	Threshold = 0.0,					-- Infliction <a number between 0.0 and 1.0, 0 being anytime and 1 being when there's 100% zombies> needed in order to change to this class.
	SWEP = "weapon_zs_zombie",			-- The SWEP to give them.
	ANIM = "zombie",                    -- The animation file in gamemode/zombieanims -- Xala Fix 1.11
	Model = Model("models/player/zombie_classic_hbfix.mdl"), -- The world model to use. If you make your own class, you must set up it's own animations or use the default HL2MP ones.
	Speed = 150,						-- Speed moving on the ground.
	Description="The slow, sulking bag of flesh. This is your basic zombie.@Unique abilities: Can claw at objects to send them flying.", -- Description to display at class selection. Seperate lines by the @ character.
	PainSounds = {
		Sound("npc/zombie/zombie_pain1.wav"),
		Sound("npc/zombie/zombie_pain2.wav"),
		Sound("npc/zombie/zombie_pain3.wav"),
		Sound("npc/zombie/zombie_pain4.wav"),
		Sound("npc/zombie/zombie_pain5.wav"),
		Sound("npc/zombie/zombie_pain6.wav")
	}, -- Played when the zombie is hurt by something (bullet ect). You must use the Sound() function so it precaches!
	DeathSounds = {
		Sound("npc/zombie/zombie_die1.wav"),
		Sound("npc/zombie/zombie_die2.wav"),
		Sound("npc/zombie/zombie_die3.wav")
	}, -- Played when the zombie is killed.
	PlayerFootstep = true, -- Custom footstep callback.
	Unlocked = true -- Don't change this. This is only for 0.0 infliction classes.
}

ZombieClasses[2] = 
{
	Name = "Fast Zombie",
	Health = 100,
	Threshold = 0.5,
	SWEP = "weapon_zs_fastzombie",
	ANIM = "fastzombie",
	Model = Model("models/player/zombie_fast.mdl"),
	Speed = 245,
	Description = "The faster, more decomposed, boney zombie. This is your fast attack zombie.@Unique abilities: Can climb walls and leap long distances.",
	PainSounds = {
		Sound("npc/fast_zombie/leap1.wav"),
		Sound("npc/fast_zombie/wake1.wav")
	},
	DeathSounds = {
		Sound("npc/fast_zombie/fz_alert_close1.wav")
	},
	PlayerFootstep = true
}

ZombieClasses[3] =
{
	Name = "Poison Zombie",
	Health = 325,
	Threshold = 0.65,
	SWEP = "weapon_zs_poisonzombie",
	ANIM = "poisonzombie",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 135,
	Description="A giant mass of decaying flesh.@Unique abilities: Massive melee damage and can throw headcrabs.",
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
	Health = 40,
	Threshold = 0.75,
	SWEP = "weapon_zs_chemzombie",
	ANIM = "chemzombie",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 170,
	Description="Mutated zombie full of volatile chemicals.@Unique abilities: Explodes when killed.",
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
	Name = "Wraith",
	Health = 75,
	Threshold = 0.4,
	SWEP = "weapon_zs_wraith",
	ANIM = "wraith",
	Model = Model("models/stalker.mdl"),
	Speed = 205,
	Description="An apparition that does large amounts of damage.@Unique abilities: Heavy damage. Completely invisible while standing still.",
	PainSounds = {
		Sound("npc/barnacle/barnacle_pull1.wav"),
		Sound("npc/barnacle/barnacle_pull2.wav"),
		Sound("npc/barnacle/barnacle_pull3.wav"),
		Sound("npc/barnacle/barnacle_pull4.wav")
	},
	DeathSounds = {
		Sound("npc/stalker/go_alert2.wav")
	}
}

ZombieClasses[6] =
{
	Name = "Headcrab",
	Health = 35,
	Threshold = 0.26,
	SWEP = "weapon_zs_headcrab",
	ANIM = "headcrab",
	Model = Model("models/headcrabclassic.mdl"),
	Speed = 175,
	Description="A headcrab.@Unique abilities: humps heads.",
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

ZombieClasses[7] =
{
	Name = "Fast Headcrab",
	Health = 20,
	Threshold = 0.3333,
	SWEP = "weapon_zs_fastheadcrab",
	ANIM = "fastheadcrab",
	Model = Model("models/headcrab.mdl"),
	Speed = 245,
	Description="A faster headcrab.@Unique abilities: humps heads.",
	PainSounds = {
		Sound("npc/headcrab_fast/pain1.wav"),
		Sound("npc/headcrab_fast/pain2.wav"),
		Sound("npc/headcrab_fast/pain3.wav")
	},
	DeathSounds = {
		Sound("npc/headcrab_fast/die1.wav"),
		Sound("npc/headcrab_fast/die2.wav")
	}
}

ZombieClasses[8] =
{
	Name = "Poison Headcrab",
	Health = 60,
	Threshold = 0.6,
	SWEP = "weapon_zs_poisonheadcrab",
	ANIM = "poisonheadcrab",
	Model = Model("models/headcrabblack.mdl"),
	Speed = 140,
	Description="A poison headcrab. The bane of all encampments.@Unique abilities: poisons players and poison spit!",
	PainSounds = {
		Sound("npc/headcrab_poison/ph_pain1.wav"),
		Sound("npc/headcrab_poison/ph_pain2.wav"),
		Sound("npc/headcrab_poison/ph_pain3.wav")
	},
	DeathSounds = {
		Sound("npc/headcrab_poison/ph_rattle1.wav"),
		Sound("npc/headcrab_poison/ph_rattle2.wav"),
		Sound("npc/headcrab_poison/ph_rattle3.wav")
	}
}

ZombieClasses[9] =
{
	Name = "Zombie Torso",
	Health = 30,
	Threshold = 0,
	SWEP = "weapon_zs_zombietorso",
	ANIM = "zombietorso",
	Model = Model("models/Zombie/Classic_torso.mdl"),
	Speed = 120,
	Description = "You shouldn't even be seeing this.",
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

-- Add models to this table to prevent human players from using them (Zombie skins and such).

GM.RestrictedModels = {
	["models/player/corpse1.mdl"] = true, -- This is the only one that really looks like a zombie.
	["models/player/skeleton.mdl"] = true,
	["models/player/zombie_classic.mdl"] = true,
	["models/player/zombie_soldier.mdl"] = true,
	["models/player/zombie_fast.mdl"] = true
}