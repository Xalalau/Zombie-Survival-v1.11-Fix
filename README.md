Changelog:

New

```
Changes from v1.05 -> v1.05 Fix (unofficial)
    I'm not sure yet what shelkz fixed (-Xala)
```

Original 

```
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
