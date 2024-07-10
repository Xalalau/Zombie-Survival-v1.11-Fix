# Welcome to Zombie Survival v1.11 Fix!

Hey! I was there, in 2008, playing on the classic ZS servers, and I saw the day when simplicity was replaced by overkill! [JetBoom](https://steamcommunity.com/id/jetboom) evolved his awesome creation, GMod's Zombie Survival, into a very tumultuous and complex gamemode, full of anime girl skins, hats, particles, UI elements and timers - my simian brain simply couldn't keep up! That said, I always really missed that raw feeling of the old ZS, where I had nowhere to run, almost nothing to protect myself, all the models were the default ones and I didn't have to think about the game's progress, I just had to kill to be automatically rewarded! I confess that this gameplay is a little too raw, but it's really fun and easy to understand!

So here we are! I want to give my HUGE appreciation and thanks to [Yushe](http://steamcommunity.com/profiles/76561198360846296) and [Soldier](http://steamcommunity.com/profiles/76561198325469923), who have kept a lot of original files **to this day** and still maintain a classic ZS server with a proprietary fixed version. Thanks to their kindness in granting my request to reopen the original ZS to the public, I was able to begin my effort on this repository! After that, all I needed was free time, and over the weekends the work gradually got done.

I consider my changes a Fix to the original gamemode and also a light Adaptation of the code. I really needed to change some details in order to get this old version in a playable state (check the changelog below), and I recon that getting this checkpoint and making code improvements is a great idea. So, yes... Forget that hammer entity, waves, GUI markers, zombies spawning nests and crazy cages... It's all gone here!

And thank you all very much! I hope you enjoy this gamemode as much as I do.

> 4 the Devs: would you like to contribute to this base with **new features**? Well, fork it and create your own ZS!! I won't accept these PRs here because they'll actually ruin the restoration. Advances must be made elsewhere! But if you want to contribute following the repo main goals, go ahead. Here are the commits golden rules: 1) Commits cannot change the original experience, even if you want to fix bugs like moonwalk; 2) We can fix bugs that prevent the game from running; 3) We must port deprecated code from GMod 11 to the current GMod; 4) We may change internal code to make our lives easier, but don't try to fix the spaghetti because I won't accept it.

# REQUIREMENTS

- ``Counter-Strike: Source`` downloaded and mounted in GMod OR [this addon](https://steamcommunity.com/sharedfiles/filedetails/?id=3278214014) (CSS should be the right option anyway as many maps need it).

- Get some maps! You can:
  - use [this pack](https://steamcommunity.com/sharedfiles/filedetails/?id=3278214930); or
  - select some files from [here](https://github.com/MOHAA2002/zombiesurvival-map-archive-update); or
  - get newer maps from the Workshop if they exist.

# Installation

Clone this repo and place it in your addons folder or subscribe to the gamemode [in the Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3278538690).

I also like to install [Ultimate Workshop Downloader](https://steamcommunity.com/sharedfiles/filedetails/?id=2214712098), so new players get the required server files automatically.

# Settings

In the original ZS v1.11 the settings were supposed be manually changed in ``gamemode/zs_options.lua``, but I exposed most of them through the main menu (when starting a new game) and console commands (check zs_options.lua).

# Original files and gameplay

By [Soldier](http://steamcommunity.com/profiles/76561198325469923):

https://github.com/MOHAA2002/zombiesurvival-archive

https://github.com/MOHAA2002/zombiesurvival-map-archive-update

https://www.youtube.com/playlist?list=PLNhZJACsuqsA1am_ZEnn91YPY9DdZo6_F

You can play Yushe's classic ZS version every weekend at ToxicGaming Discord server:

https://discord.gg/mK2swJUZVf

Note: click [here](https://github.com/Xalalau/Zombie-Survival-v1.11-Fix/wiki/Some-urls-and-info) for more official stuff.

# v1.11 Fix by Xalalau & collaborators changelog

```
Changes from v1.11 Fix 3 -> v1.11 Fix 4
    * Added workshop wsid to the gamemode config file
    * Changed zs_intermission_time back to 35
    * Fixed (critical) gamemode failing to get cvar values

Changes from v1.11 Fix 2 -> v1.11 Fix 3
    * Added internal configuration to allow early game suicides
    * Added internal base for zombie weapons
    * Changed new cvar values are instantly applied (requested by Dx0M | Epp307)
    * Changed zs_roundtime from 600 to 720
    * Changed fastzombies back to climbing walls with the secondary attack
    * Fixed fastzombie attack area to better hit moving players
    * Fixed chemzombie not spawning with his green particles
    * Fixed player redeeming with chemzombie particles
    * Fixed all the remaining zombies damage detection
    * Fixed knife damage detection
    * Fixed headshot effect not working due to a nil access
    * Fixed playergib trying to remove nil emitter
    * Fixed the scoreboard didn't truncate servers with big names

Changes from v1.11 Fix 1 -> v1.11 Fix 2
    * Added support for votemap addons
    * Changed humans to shed blood when hit (better zombie attack feedback, a disabled feature)
    * Changed fastzombies now climb walls by jumping on them and pressing W
    * Changed the settings for a 10 player game (adaptation to the current days main demand):
        - changed zs_rewards_1 from 5 to 2
        - changed zs_rewards_2 from 10 to 4
        - changed zs_rewards_3 from 15 to 6
        - changed zs_rewards_4 from 28 to 8
        - changed zs_rewards_5 from 35 to 10
        - changed zs_rewards_6 from 60 to 12
        - changed zs_rewards_7 from 75 to 14
        - changed zs_ammo_regenerate_rate from 100 to 75
        - changed zs_roundtime from 1200 to 600
        - changed zs_intermission_time from 35 to 25
        - changed zs_redeem_kills from 4 to 3
        - changed zs_warmup_threshold from 4 to 2
    * Fixed headcrab, fastheadcrab, poisonheadcrab and fastzombie damage detection
    * Fixed put spectators in the undead team and spawn them instead of kicking them
    * Fixed player blacklisted models to the current GMod zombie models

Changes from v1.11 -> v1.11 Fix 1
    * Added gamemode setting to the game main menu
    * Added support for replacement weapons, so the ZS doesn't require CSS
    * Added missing config SURVIVALMODE to zs_options.lua
    * Added ZS gamemode icon
    * Added command zs_unlock_all_classes and zs_unlock_all_weapons to help development
    * Removed all the stupid SteamID bans from 2008
    * Changed default _zs_filmgrainopacity from 16 to 3 (So it's actually playable by default)
    * Changed many pairs() to ipairs() to improve performance
    * Changed some variable names to better fit their purpose or to improve standardization
    * Changed version to "v1.11 Fix by Xalalau & collaborators - For GMod March 2024 Update+"
    * Changed some game.ConsoleCommand to RunConsoleCommand
    * Changed kickid command to game.KickID() func
    * Changed player.GetAll() to player.GetHumans()
    * Changed timer.Destroy() to timer.Remove()
    * Changed umsg lib to net
    * Changed Kill the player after he picks a new zombie class (to avoid animation bugs)
    * Changed poison zombie green particles effect is reenabled
    * Changed license to JBGM
    * Fixed animations (backported and adapted from the latest ZS)
    * Fixed film grain post processing effect flickering due to two frames being too white
    * Fixed add missing IsValid checks to every timer
    * Fixed poison headcrab was missing the damage variable to calculate the attack knockback
    * Fixed poison zombie viewmodel FOV was too high for wide 19:6 screens
    * Fixed the path 'effects/zombiefireworks/init.lua' was invalid on Linux
    * Fixed GM:CalcView() in cl_init.lua was trying to access a nil phys obj for no reason at all
    * Fixed size calculations on human/zombie counter on the HUD
    * Fixed overall menu dimensions were no fit for monitors greater then 1024x768 (distorsions everywhere)
    * Fixed renamed variables like sound and player that were locally overriding global functions
    * Fixed the film grain slider was not working
    * Fixed zombie torso arms viewmodel pos
    * Fixed wraith was missing cloack failure when shot and a visible body after death
    * Fixed game.BroadcastLua was updated to RunBroadcastLua
    * Fixed self.GetOwner was updated to self:GetOwner()
    * Fixed info.txt was updated to zombiesurvival.txt
    * Fixed SinglePlayer() was updated to game.SinglePlayer()
    * Fixed file lib calls like file.Find were updated to use a second argument
    * Fixed MaxPlayers() was updated to game.MaxPlayers()
    * Fixed Entity:SetColor() calls were updated to receive the RGB inside a Color() object
    * Fixed surface.CreateFont() was updated to the current syntax
    * Fixed timer.Simple() and timer.Create() were updated to use anonymous functions instead of passing arguments
    * Fixed variable number of parameters syntax in GM:SplitMessage(y, ...) were on a weird and invalid format from the past
    * Fixed util.tobool() was updated to tobool()
    * Fixed GetConVarNumber() was updated to GetConvar() or to vars directly calling ConVar methods
    * Fixed WorldSound() was updated to EmitSound()
    * Fixed stopsounds command was updated to stopsound
    * Fixed timer.IsTimer() was updated to timer.Exists()
    * Fixed some Entity:SetAngles() were receiving a Vector() instead of an Angle()
    * Fixed all Vector() Normalize() methods were returning nil so I changed them to GetNormalized()
    * Fixed headcrab, fastheadcrab and fastzombie jumps were not working anymore (view offset and end pos)
    * Fixed intermission time counter becoming negative
    * Fixed fastzombie climb force was not enough to get over buildings or models
    * Fixed Wraith not becoming invisible and casting shadows
    * Fixed Wraith viewmodel fov was showing the missing parts of his arm
    * Fixed GM:ZombieHUD trying to access nil ply.Class
    * Fixed view camera inside the zombie head after death
    * Fixed EntityTakeDamage trying to process nil damage
    * Fixed scoreboard gamemode version info was being cropped
    * Fixed film grain filter trying to use nil materials
    * Fixed poison headcrab spit on dedicated servers
```

# (Very inaccurate but official) Changelog

```
Changes from v1.1 -> v1.11
    * Fixed poison headcrab having an error when hitting people.
    * Fixed Crossbow not firing.
    * Fixed a client-side error that would show up when the round ended.

Changes from v1.07 -> v1.1
    I'll release a full update to 1.1 probably tommarrow. I'll include the 'spectate' concommand protection I've been using as well.

    Main features:
    - Redone HUD.
    - Redone Scoreboard.
    - Redone VGUI.
    - F1 - F4 buttons all have individual functions instead of clogging up the scoreboard.
    - F4 now has all the post process options as well as some other stuff on it.
    - You can toggle the beats on/off.
    - You can change the film grain opacity!
    - Anti-overflow / pure virtual function calls for when many, many people blow up at the same time.
    - Wraith.
    - Configurable starting loadouts.
    - Dynamic movement speeds.
    - Everyone is slightly faster.
    - Doors can come off their hinges after taking a lot of damage.
    - So much stuff since 1.07 that I can't take the time to put them all down. Basically, everything is better. 

Changes from v1.05 -> v1.07
    - Added Fast Headcrab class. Faster and less health than the normal one.
    - Added Poison Headcrab class. This class will deal up to 40 or so damage over time if you hit someone. It also comes with a poison spit that will do only do 10 damage but will blind and lesser poison if it hits someone's head!
    - Added 'Ricochete' Magnum. This has the highest damage of all the pistols and has the ability to bounce off walls one time to deal half damage.
    - Changed 'Battleaxe' Handgun to do slightly more damage and less rate of fire.
    - Added 'Peashooter' Handgun.
    - Added 'Shredder' SMG.
    - Added 'Impaler' Crossbow. This has the unique ability of going through multiple enemies and it does plenty damage.
    - All weapons have cute names.
    - Added dynamic movement speed system. Having a weapon out that is heavy will slow you down while having a knife or a pistol out will make you faster.
    - Custom crosshair due to above system.
    - Added dynamic aim-cone system. Crouching and standing still reduce your aim cone while moving will greatly increase it.
    - Added Zombie Horde system and meter. This is exactly like the human's fear meter but for zombies. The more zombies that are packed together, the bigger this bar gets. The bigger it gets, the more damage the zombies do to humans. A full bar means DOUBLE damage. The chem zombie is especially sensitive to this bar. It even has it's own set of beats.
    - Added Zombie Feast system. Gibs are now server-side and zombies can simply walk in to them to eat them and regain 5% of their maximum health per gib.
    - Humans who die will now drop their weapons and can be picked up by other humans. If you run over that weapon again during a reward then you simply receive ammo for it.
    - The melee of zombies have absolutely nothing to do with bullets anymore. They now use pure TakeDamage and TraceHullAttack. Meaning you don't have to be 100% accurate when swinging your melee.
    - Health of every zombie class was increased by about 20% each.
    - Darkened some colors on the HUD.
    - Added commands: zs_enablecolormod 0/1 zs_enablemotionblur 0/1 zs_enablesharpen 0/1 zs_enablefilmgrain 0/1. If you like post processing but don't like a specific feature, you can turn it off with those.
    - First zombie is chosen randomly between the first 4 connected players instead of the 4th person to join.
    - Reduced size of 'Arsenal Upgraded' window since it was taking up half the screen.
    - Custom HUD for the bottom left portion of the HUD.
    - Changed some colormod stuff to make it look more menacing as a human.
    - Fixed reload animations on the Sweeper Shotgun and the Slug Rifle (gun held stupidly).
    - Humans can press USE on other humans to shove them. You can not shove another human if there is no ground for them to be shoved to. Meaning you can't shove them off a roof or out a window.
    - Suiciding will give whoever last hit you the kill, as long as they're not on the same team.
    - Headshots to zombies do 2x damage. Anywhere else does 3/4 damage.
    - Re-added Fast Zombie lunge damage.
    - Fast Zombie base damage reduced from 6 to 5. Maximum of 10 due to Horde meter.
    - Removed movement slow down when swinging as a Fast Zombie.
    - Dying as a human has new effects.
    - Being dead now puts your camera in your ragdoll's eyes.
    - Upgraded blood effects drastically.
    - Changed the way headshots are calculated. Now is distance to joint rather than distance to joint's height (more accurate calculation).
    - Removed clientside ragdoll creation on gibs due to them being spawned infinately when you would change visleafs.
    - Optimized HUD components and code.
    - Fixed Torso Zombies having incorrect starts on their tracelines for melee. Meaning that the attack was starting from way too high above your camera.
    - Fixed error on moving over a name in the scoreboard.
    - Fixed purple checkers on most materials due to the GM update removing gmdm.
    - Fixed black / purple screen on zombies.
    - Fixed exploit where zombies could shoot invisible, instant-kill bullets through glass and some small props like soda cans.
    - Fixed all client-side crashing. This means chem zombie explode overflow and other junk.
    - Fixed all server-side crashing. The last time I checked my server it had an uptime of 5 days with 0 crashes.
    - Fixed Regeneration powerup not working properly.
    - Fixed 2 portions of the end-time scoreboard not showing.
    - Fixed pain sounds not playing for humans.
    - Fixed bug where Humans couldn't switch to weapons that had no ammo for them. 

Changes from v1.04 -> v1.05
    Added Headcrab class.
    - Added powerups system.
    - Added map profile system. Lua files named after the current map (ie: zs_nastyhouse.lua) in the gamemodes/zombiesurvival/maps folder will be ran on map start. This is so you can make some creative things unique to your own server or give out public fixes. (The basement jamming in forestofthedamned?)
    - Added slug rifle.
    - Altered some zombie team melee damages to be a bit more balanced.
    - Added breathe meter. Affects humans only.
    - Added concommand disable_pp 1/0. 1 to turn post processing completely off. 0 to turn it on. (as long as you're above dxlevel 90)
    - Added OPTIONAL (zs_options, ANTI_VENT_CAMP) butt-cramp meter. Basically, if you stay in a cramped space for too long (a minute) then your spine will explode. Comes with a meter and only affects humans.
    - Added SEffect for redemption.
    - You will now see a glowing cross thing in the death messages when a person has redeemed themself.
    - Having less than 30 health on the human team or being underwater on any team will make your screen wobble back and forth a bit.
    - Ammo regeneration system optimized. It uses less code and stuff.
    - Ammo regeneration amounts can be edited in zs_options.
    - 357 ammo regeneration changed from 6 to 12.
    - Shotgun ammo regeneration changed from 20 to 12.
    - Fast zombie charge attack will push people a little harder than before. Objects are the same.
    - Fast zombie charge attack will disorient the zombie's screen less.
    - Fast zombie charge attack will disorient the person who gets hit's screen.
    - Fast zombie melee damage changed from 5 to 6.
    - Fixed a crash fix that happened to a few people when the round ends.
    - Got rid of the flatline sound that you hear whenever a player dies. You should now only hear the correct death sounds according to what I put in.
    - Fixed the help menu displaying blank items for Chance of...
    - All animation code has been severely optimized. You should notice a nice decrease in server-side lag.
    - Zombies now have a 1/3 chance to turn in to a torso zombie if not shot in the head and they survive, wich in it self has a 3/4 chance to happen. So roughly a 24% chance to happen if not headshotted. Also brought in the old 'legs gib' effect from gmod9.
    - Zombies need to have their attack key down in order to respawn.
    - Poison zombies can walk while swinging.
    - Added slam as reward 75.
    - Tons and tons of bug fixes and other little changes.

Changes from v1.03 -> v1.04
    * Zombies who have no teamates will spawn with x2 health.
    * Infliction can not reduce itself due to zombies leaving the server or redeeming. It can increase but never decrease.
    * Infliction is now directly affected by the amount of time remaining in a round. At 10 minutes, for example, infliction will be locked at %50 or more.
    * Fixed chem-zombie not doing damage when in vents and other low places.
    * Made music assigned to a team instead of win/lose. Example, you're a zombie and the humans win - you hear human win music. All the humans die - you hear lose music.
    * Made some adjustments to balance and when weapons are given. Nothing major.
    * Added a popup/sound thing when new zombie classes are unlocked.
    * Changed the end scoreboard around. It's now easier to read things, especially when you win and everything is really bright.
    * Gamemode will now track people's total damage dealt while on the zombie team and total damage while on the human team. It is displayed at the end of the round on the scoreboard.
    * Changed default health for poison zombies to be 280 (up from 250).
    * Increased poison zombie and chem-zombie walking speed by 4%.
    * Added a humanwin song instead of using a crappy hl2 one. Working on replacing the dumb mortal kombat song with something else.
    * Added DESTROY_DOORS option to zs_options file. Destroys all func_door and func_door_rotating's. On by default.
    * Added DESTROY_PROP_DOORS option to zs_options file. Destroys all prop_door_rotating. Off by default.
    * Added FORCE_NORMAL_GAMMA option to zs_options file. Forces people to have their mat_monitorgamma setting locked at 2.2. This means that people can't just adjust their brightness settings. They need to use flashlights. Won't be affected by the smarter people who use graphics card control panels and such. On by default.
    * Fixed problem where people could suicide after being hit by someone and not give that person a kill. Due to a gmod update or something, was working before.
    * Made starting knife actually swing like one. =)
    * A lot of other stuff I don't remember much about.

Changes from v1.02 -> v1.03
    * Reduced glock 3 bullet damage from 13 to 11.
    * Fixed support for older cards (dx89 and lower) seeing weirdness as a human.
    * Made it so that by using kill in the console or killing yourself by similair means will give the person who last hit you a kill. No more suiciding punks.
    * You can see your own gibs. (Not much contrast between the red overlay and the gibs but you can hear the squishy sounds and stuff.)
    * Lots of bug fixes and stuff.
    * Pressing f3 will go to the classes menu.
    * Added options to allow NPC's and scoring for killing NPC's in zs_options.lua. I suggest you up the DIFFICULTY variable to around 2.0 or more if you plan on doing this, otherwise you'll have cannon fodders for NPC's. NOT SUGGESTED FOR BIGGER SERVERS.

Changes from v1.01 -> v1.02
    * Made chem-zombie explosion more powerful.
    * Fixed lua/init.lua crash that was a result of a GMod update changing the behavior of ScriptEnforcer.

Changes from v1.0 -> v1.01
    * Fixed chem-zombies not exploding properly. 
```
