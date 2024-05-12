-- You should not be changing the Version or anything. Ever. The only change you should make is the SubVersion.
-- If you make huge changes to the game that seperates it from the official release, change this variable to reflect that.
-- That way when you ruin the game by adding in stupid SWEPs and 100 models you got from garrysmod.org, people (the smarter bunch at least)
-- will know that your idiotic decisions don't reflect the ideas and decisions of myself.
GM.SubVersion = "Official"

-- Weapon sets that humans randomly start with.
GM.STARTLOADOUTS[1] = {"weapon_zs_battleaxe", "weapon_zs_swissarmyknife"}
GM.STARTLOADOUTS[2] = {"weapon_zs_owens", "weapon_zs_swissarmyknife"}
GM.STARTLOADOUTS[3] = {"weapon_zs_owens", "weapon_zs_plank"}
GM.STARTLOADOUTS[4] = {"weapon_zs_peashooter", "weapon_zs_axe"}
GM.STARTLOADOUTS[5] = {"weapon_zs_battleaxe", "weapon_zs_plank"}
GM.STARTLOADOUTS[6] = {"weapon_zs_peashooter", "weapon_zs_sledgehammer"}
GM.STARTLOADOUTS[7] = {"weapon_zs_peashooter", "weapon_zs_hammer"}
GM.STARTLOADOUTS[8] = {"weapon_zs_battleaxe", "weapon_zs_hammer"}
GM.STARTLOADOUTS[9] = {"weapon_zs_battleaxe", "weapon_zs_axe"}
GM.STARTLOADOUTS[10] = {"weapon_zs_owens", "weapon_zs_hammer"}
GM.STARTLOADOUTS[11] = {"weapon_zs_peashooter", "weapon_zs_shovel"}
GM.STARTLOADOUTS[12] = {"weapon_zs_owens", "weapon_zs_axe"}
GM.STARTLOADOUTS[13] = {"weapon_zs_peashooter", "weapon_zs_swissarmyknife"}
GM.STARTLOADOUTS[14] = {"weapon_zs_battleaxe", "weapon_zs_fryingpan"}

-- Here's where you can add laser cannons, give sniper rifles at 10 kills, and other game-ruining stuff.
GM.Rewards[5] = {"weapon_zs_deagle", "weapon_zs_glock3", "weapon_zs_magnum"}
GM.Rewards[10] = {"_Heal", "_Heal", "_Shell"}
GM.Rewards[15] = {"weapon_zs_uzi", "weapon_zs_smg", "weapon_zs_bulletstorm", "weapon_zs_reaper"}
GM.Rewards[20] = {"weapon_zs_barricadekit", "weapon_zs_grenade"}
GM.Rewards[25] = {"weapon_zs_sweepershotgun", "weapon_zs_boomstick", "weapon_zs_annabelle"}
GM.Rewards[35] = {"weapon_zs_slugrifle", "weapon_zs_crossbow", "weapon_zs_m4", "weapon_zs_inferno"}
GM.Rewards[45] = {"_Regeneration", "_Heal"}

-- Powerups don't have models and sometimes you want to override a weapon's model display in the rewards tree.
if CLIENT then
	GM.RewardIcons["_Heal"] = "models/healthvial.mdl"
	GM.RewardIcons["_Shell"] = "models/Items/hevsuit.mdl"
	GM.RewardIcons["_Regeneration"] = "models/Items/HealthKit.mdl"
	GM.RewardIcons["weapon_zs_barricadekit"] = "models/props_debris/wood_board05a.mdl"
end

-- AMMO REGENERATION
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.

GM.AmmoRegeneration["ar2"] = 22
GM.AmmoRegeneration["alyxgun"] = 16
GM.AmmoRegeneration["pistol"] = 10
GM.AmmoRegeneration["smg1"] = 30
GM.AmmoRegeneration["357"] = 8
GM.AmmoRegeneration["xbowbolt"] = 4
GM.AmmoRegeneration["buckshot"] = 7
GM.AmmoRegeneration["ar2altfire"] = 1
GM.AmmoRegeneration["slam"] = 1
GM.AmmoRegeneration["rpg_round"] = 1
GM.AmmoRegeneration["smg1_grenade"] = 1
GM.AmmoRegeneration["sniperround"] = 1
GM.AmmoRegeneration["sniperpenetratedround"] = 1
GM.AmmoRegeneration["grenade"] = 0
GM.AmmoRegeneration["thumper"] = 1
GM.AmmoRegeneration["gravity"] = 1
GM.AmmoRegeneration["battery"] = 1
GM.AmmoRegeneration["gaussenergy"] = 1
GM.AmmoRegeneration["combinecannon"] = 1
GM.AmmoRegeneration["airboatgun"] = 1
GM.AmmoRegeneration["striderminigun"] = 1
GM.AmmoRegeneration["helicoptergun"] = 1

-- To be used later.
GM.AmmoCache["ar2"] = 90
GM.AmmoCache["alyxgun"] = 60
GM.AmmoCache["pistol"] = 48
GM.AmmoCache["smg1"] = 150
GM.AmmoCache["357"] = 14
GM.AmmoCache["xbowbolt"] = 10
GM.AmmoCache["buckshot"] = 12
GM.AmmoCache["ar2altfire"] = 0
GM.AmmoCache["slam"] = 0
GM.AmmoCache["rpg_round"] = 0
GM.AmmoCache["smg1_grenade"] = 0
GM.AmmoCache["sniperround"] = 0
GM.AmmoCache["sniperpenetratedround"] = 0
GM.AmmoCache["grenade"] = 0
GM.AmmoCache["thumper"] = 0
GM.AmmoCache["gravity"] = 3
GM.AmmoCache["battery"] = 0
GM.AmmoCache["gaussenergy"] = 0
GM.AmmoCache["combinecannon"] = 0
GM.AmmoCache["airboatgun"] = 0
GM.AmmoCache["striderminigun"] = 0
GM.AmmoCache["helicoptergun"] = 0

-- If for some reason you have one of these HL2 weapons, what ammo should regeneration give you?
GM.AmmoTranslations["weapon_physcannon"] = "pistol"
GM.AmmoTranslations["weapon_ar2"] = "ar2"
GM.AmmoTranslations["weapon_shotgun"] = "buckshot"
GM.AmmoTranslations["weapon_smg1"] = "smg1"
GM.AmmoTranslations["weapon_pistol"] = "pistol"
GM.AmmoTranslations["weapon_357"] = "357"
GM.AmmoTranslations["weapon_slam"] = "pistol"
GM.AmmoTranslations["weapon_crowbar"] = "pistol"
GM.AmmoTranslations["weapon_stunstick"] = "pistol"

-- If you like NPC's. NPC's will only spawn in maps that actually were built to have them in the first place. This gamemode won't create it's own or anything.
USE_NPCS = false

-- Fraction of people that should be set as zombies at the beginning of the game.
WAVE_ONE_ZOMBIES = 0.1

-- Set this to true if you want people to get 'kills' from killing NPC's.
-- IT IS STRONGLY SUGGESTED THAT YOU EDIT THE REWARDS TABLE TO
-- MAKE THE REWARDS REQUIRE MORE KILLS AND/OR MAKE THE DIFFICULTY HIGHER IF YOU DO THIS!!!
-- Example, change Rewards[6] to Rewards[15]. The number represents the kills.
NPCS_COUNT_AS_KILLS = false

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5

-- Number of waves the humans need to survive through to completely win.
NUM_WAVES = 10

-- Display current wave on the server list.
DISPLAY_WAVES_ON_SERVERLIST = true

-- Initial length for wave 1.
WAVEONE_LENGTH = 120

-- Add this many seconds for each additional wave.
WAVE_TIMEADD = 5

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
NONEWJOIN_WAVE = 3

-- Humans can not commit suicide if the current wave is this or lower. Negative numbers will effectively disable it but it's not suggested since people can just join quickly, suicide, and make it half-life (thus making all new players in to zombies).
NOSUICIDE_WAVE = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
WAVEZERO_LENGTH = 90

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator view and any living ones will still be living.
WAVE_INTERMISSION_LENGTH = 45

-- Seconds the first zombie needs to be AFK before they are kicked.
FIRSTZOMBIE_AFK_LENGTH = 60

-- Humans can not carry OR drag anything heavier than this (in kg.)
CARRY_MAXIMUM_MASS = 300

-- Objects with more mass than this will be dragged instead of carried.
CARRY_DRAG_MASS = 145

-- Anything bigger than this is dragged regardless of mass.
CARRY_DRAG_VOLUME = 120

-- Humans can not carry anything with a volume more than this (OBBMins():Length() + OBBMaxs():Length()).
CARRY_MAXIMUM_VOLUME = 150

-- Humans are slowed by this amount per kg carried.
CARRY_SPEEDLOSS_PERKG = 1.3

-- But never slower than this.
CARRY_SPEEDLOSS_MINSPEED = 88

-- Range to use for danger meter and when horde bonuses for zombies.
FOCUS_RANGE = 300

-- In seconds, repeatatively, the gamemode gives all humans a box of whatever ammo of the weapon they use.
-- if you set this number to something stupid like 0, you'll have some lag issues.
-- Changing this means you're an idiot.
AMMO_REGENERATE_RATE = 60

-- Time in seconds between end round and next map.
INTERMISSION_TIME = 35

-- New joining players will be put on the Undead team if the round is half over.
HUMAN_DEADLINE = true

-- Set this to true to destroy all brush-based doors that aren't based on phys_hinge and func_physbox or whatever. For door campers.
DESTROY_DOORS = false

-- Set this to true to destroy all prop-based doors. Not recommended since some doors have boards on them and what-not. Only for true door camping whores.
-- (DEPRICATED SINCE THESE DOORS CAN BE DESTROYED NOW)
-- DESTROY_PROP_DOORS = false

-- Set this to true if you want your admins to be able to use the 'noclip' concommand.
-- If they already have rcon then it's pointless to set this to false.
ALLOW_ADMIN_NOCLIP = true

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
LASTHUMANSOUND = "lasthuman.mp3"

-- In seconds, the length of the above file. It's important to have this correct or you may get delayed or overlapping music.
LASTHUMANSOUNDLENGTH = 120

-- Sound to play for ambient Un-Life music. Depricated as of v2.0
UNLIFESOUND = "unlife1.mp3"
UNLIFESOUNDLENGTH = 210

-- Sound played to a person when they lose the game.
ALLLOSESOUND = "lose_test.mp3"

-- Sound played to a person when they win the game.
HUMANWINSOUND = "humanwin.mp3"

-- Sound played to a person when they die as a human.
DEATHSOUND = "music/stingers/HL1_stinger_song28.mp3"

-- Turn off/on the redeeming system. If you want a really unforgiving environment then you can turn this off.
REDEEM = true

-- Human kills needed for a zombie player to redeem (resurrect). Do not set this to 0. If you want to turn this
-- system off, set AUTOREDEEM to false.
REDEEM_KILLS = 4

-- Players don't have a choice if they want to redeem or not. Setting to false makes them press F2.
AUTOREDEEM = true

-- Anti-spawncamping. Puts noxious gasses around zombie spawns which damage humans and heal zombies.
-- WARNING. Turning this off will BREAK the volunteer system!
ZOMBIEGASSES = true

WARMUP_THRESHOLD = 4
-- If a person dies when there are less than the above amount of people, don't set them on the undead team if this is true. This should generally be true on public / big servers and always false on small LAN's and such.
WARMUP_MODE = true

--[[
-- ZOMBIE CLASSES
-- Added RegisterZombieClass in order to streamline adding new classes. 
-- Classes appear in the order you add them.
]]

RegisterZombieClass("Zombie",
{
	Name = "Zombie",					-- Display name.
	Wave = 0,							-- Wave it's unlocked. 0 for always unlocked.
	Revives = true,						-- Zombie will revive if not shot in the head.
	Health = 200,						-- Obviously enough, health
	SWEP = "weapon_zs_zombie",			-- The SWEP to give them.
	Model = Model("models/Zombie/Classic.mdl"), -- The world model to use. If you make your own class, you must set up its own animations or use the default HL2MP ones.
	Speed = 130,						-- Speed moving on the ground.
	Description="This is your basic undead monstrosity.@Unique abilities: Very durable and can even come back to life after being killed.", -- Description to display at class selection. Seperate lines by the @ character.
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
	Unlocked = true, -- Don't change this. This is only for 0.0 infliction classes.
	PlayerFootsteps = true, -- Override footsteps (bottom of cl_init.lua).
	ReviveCallback = function(pl, attacker, dmginfo) -- In the case of the Zombie, it can have its legs blown off and transform in to a half-zombie when it revives. Return true to tell the gamemode that we revived.
		if math.random(1, 3) == 3 then -- 1 / 3 chance to be a torso zombie.
			local deathclass = pl.DeathClass
			pl:SetZombieClass(GAMEMODE.ZombieClasses["Zombie Torso"].Index)
			--pl.DeathClass = GAMEMODE.ZombieClasses["Zombie"].Index
			pl.DeathClass = deathclass
			pl:LegsGib()
			pl.Gibbed = nil
			timer.Simple(0, SecondWind, pl)
			return true
		elseif math.random(1, 4) ~= 1 then -- If we're not a torso zombie then a 3/4 chance to just get back up.
			DefaultRevive(pl)
			return true
		end

		return false
	end
})

RegisterZombieClass("Fast Zombie",
{
	Name = "Fast Zombie",
	Wave = 0.3, -- The decimal is a percent of the total waves. Example, this would be wave 3 in a game with 10 waves total. Always rounded down.
	Health = 125,
	SWEP = "weapon_zs_fastzombie",
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 240,
	Description = "A fast, heavily decomposed cadaver.@Unique abilities: Can climb walls and lunge at its victims.",
	PainSounds = {
				Sound("npc/fast_zombie/leap1.wav"),
				Sound("npc/fast_zombie/wake1.wav")
				},
	DeathSounds = {
				Sound("npc/fast_zombie/fz_alert_close1.wav")
				},
	PlayerFootstep = true
})

RegisterZombieClass("Poison Zombie",
{
	Name = "Poison Zombie",
	Wave = 0.6,
	Health = 400,
	SWEP = "weapon_zs_poisonzombie",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 120,
	Description="A giant mass of toxic, decaying flesh.@Unique abilities: Can tear out its own toxic flesh and throw it at its victims.",
	PainSounds = {
				Sound("npc/zombie_poison/pz_pain1.wav"),
				Sound("npc/zombie_poison/pz_pain2.wav"),
				Sound("npc/zombie_poison/pz_pain3.wav")
				},
	DeathSounds = {
				Sound("npc/zombie_poison/pz_die1.wav"),
				Sound("npc/zombie_poison/pz_die2.wav")
				}
})

RegisterZombieClass("Chem-Zombie",
{
	Name = "Chem-Zombie",
	Wave = 0.7,
	Health = 50,
	SWEP = "weapon_zs_chemzombie",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 150,
	Description="A mutated zombie full of volatile chemicals.@Unique abilities: Explodes when killed and damages nearby humans.",
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
})

RegisterZombieClass("Wraith",
{
	Name = "Wraith",
	Wave = 0.4,
	Health = 100,
	SWEP = "weapon_zs_wraith",
	Model = Model("models/stalker.mdl"),
	Speed = 195,
	Description="An apparition that sneaks up on its unsuspecting victims.@Unique abilities: Surprise attacks. Completely invisible while standing still.",
	PainSounds = {
				Sound("npc/barnacle/barnacle_pull1.wav"),
				Sound("npc/barnacle/barnacle_pull2.wav"),
				Sound("npc/barnacle/barnacle_pull3.wav"),
				Sound("npc/barnacle/barnacle_pull4.wav")
				},
	DeathSounds = {
				Sound("wraithdeath1.wav"),
				Sound("wraithdeath2.wav"),
				Sound("wraithdeath3.wav"),
				Sound("wraithdeath4.wav")
				}
})

RegisterZombieClass("Headcrab",
{
	Name = "Headcrab",
	Wave = 0,
	Health = 30,
	SWEP = "weapon_zs_headcrab",
	Model = Model("models/headcrabclassic.mdl"),
	Speed = 155,
	Unlocked = true,
	Description="The root of the infection.@Unique abilities: Lunges and bites to deal damage. Hard to hit.",
	PainSounds = {
				Sound("npc/headcrab/pain1.wav"),
				Sound("npc/headcrab/pain2.wav"),
				Sound("npc/headcrab/pain3.wav")
				},
	DeathSounds = {
				Sound("npc/headcrab/die1.wav"),
				Sound("npc/headcrab/die2.wav")
				},
	ViewOffset = Vector(0, 0, -50),
	CrouchedWalkSpeed = 1
})

RegisterZombieClass("Fast Headcrab",
{
	Name = "Fast Headcrab",
	Wave = 0.2,
	Health = 20,
	Threshold = 0.3333,
	SWEP = "weapon_zs_fastheadcrab",
	Model = Model("models/headcrab.mdl"),
	Speed = 225,
	Description="A faster Headcrab.@Unique abilities: Lunges and bites to deal damage. Even harder to hit.",
	PainSounds = {
				Sound("npc/headcrab_fast/pain1.wav"),
				Sound("npc/headcrab_fast/pain2.wav"),
				Sound("npc/headcrab_fast/pain3.wav")
				},
	DeathSounds = {
				Sound("npc/headcrab_fast/die1.wav"),
				Sound("npc/headcrab_fast/die2.wav")
				},
	ViewOffset = Vector(0, 0, -50),
	CrouchedWalkSpeed = 1
})

RegisterZombieClass("Poison Headcrab",
{
	Name = "Poison Headcrab",
	Wave = 0.5,
	Health = 75,
	Threshold = 0.6,
	SWEP = "weapon_zs_poisonheadcrab",
	Model = Model("models/headcrabblack.mdl"),
	Speed = 125,
	Description="A Headcrab full of toxic chemicals.@Unique abilities: Can inject neurotoxins with its bite and even spit them!",
	PainSounds = {
				Sound("npc/headcrab_poison/ph_pain1.wav"),
				Sound("npc/headcrab_poison/ph_pain2.wav"),
				Sound("npc/headcrab_poison/ph_pain3.wav")
				},
	DeathSounds = {
				Sound("npc/headcrab_poison/ph_rattle1.wav"),
				Sound("npc/headcrab_poison/ph_rattle2.wav"),
				Sound("npc/headcrab_poison/ph_rattle3.wav")
				},
	ViewOffset = Vector(0, 0, -50),
	CrouchedWalkSpeed = 1
})

RegisterZombieClass("Zombie Torso", 
{
	Name = "Zombie Torso",
	Health = 30,
	Wave = 0,
	Threshold = 0,
	SWEP = "weapon_zs_zombietorso",
	Model = Model("models/Zombie/Classic_torso.mdl"),
	Speed = 110,
	Description = "You shouldn't even be seeing this.@Unique abilities: Isn't hidden on servers ran by dumbasses.",
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
	ViewOffset = Vector(0, 0, -40),
	CrouchedWalkSpeed = 1,
	Hidden = true -- The class won't show up in any menus and can't be switched to unless the script is told to switch to it.
})

-- Add models to this table to prevent human players from using them (Zombie skins and such). Use lower-case letters.

GM.RestrictedModels["models/player/classic.mdl"] = true
GM.RestrictedModels["models/player/zombine.mdl"] = true
GM.RestrictedModels["models/player/zombie_soldier.mdl"] = true
GM.RestrictedModels["models/player/zombiefast.mdl"] = true
