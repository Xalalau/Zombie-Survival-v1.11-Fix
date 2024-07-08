SWEP.Base = "weapon_zs_base_enemy"

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Delay = 2

function SWEP:Precache()
	util.PrecacheSound("npc/metropolice/pain1.wav")
	util.PrecacheSound("npc/metropolice/pain2.wav")
	util.PrecacheSound("npc/metropolice/pain3.wav")
	util.PrecacheSound("npc/metropolice/pain4.wav")
	util.PrecacheSound("npc/metropolice/knockout2.wav")
	util.PrecacheSound("ambient/fire/gascan_ignite1.wav")
end
