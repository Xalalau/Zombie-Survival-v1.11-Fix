local meta = FindMetaTable("Weapon")
if not meta then return end

function meta:GetNextPrimaryFire()
	return self.m_NextPrimaryFire or 0
end

function meta:GetNextSecondaryFire()
	return self.m_NextSecondaryFire or 0
end

meta.OldSetNextPrimaryFire = meta.SetNextPrimaryFire
function meta:SetNextPrimaryFire(fTime)
	self.m_NextPrimaryFire = fTime
	self:OldSetNextPrimaryFire(fTime)
end

meta.OldSetNextSecondaryFire = meta.SetNextSecondaryFire
function meta:SetNextSecondaryFire(fTime)
	self.m_NextSecondaryFire = fTime
	self:OldSetNextSecondaryFire(fTime)
end

function meta:SetNextReload(fTime)
	self.m_NextReload = fTime
end

function meta:GetNextReload()
	return self.m_NextReload or 0
end

local TranslatedAmmo = {}
TranslatedAmmo[-1] = "none"
TranslatedAmmo[0] = "none"
TranslatedAmmo[1] = "ar2"
TranslatedAmmo[2] = "alyxgun"
TranslatedAmmo[3] = "pistol"
TranslatedAmmo[4] = "smg1"
TranslatedAmmo[5] = "357"
TranslatedAmmo[6] = "xbowbolt"
TranslatedAmmo[7] = "buckshot"
TranslatedAmmo[8] = "rpg_round"
TranslatedAmmo[9] = "smg1_grenade"
TranslatedAmmo[10] = "sniperround"
TranslatedAmmo[11] = "sniperpenetratedround"
TranslatedAmmo[12] = "grenade"
TranslatedAmmo[13] = "thumper"
TranslatedAmmo[14] = "gravity"
TranslatedAmmo[14] = "battery"
TranslatedAmmo[15] = "gaussenergy"
TranslatedAmmo[16] = "combinecannon"
TranslatedAmmo[17] = "airboatgun"
TranslatedAmmo[18] = "striderminigun"
TranslatedAmmo[19] = "helicoptergun"
TranslatedAmmo[20] = "ar2altfire"
TranslatedAmmo[21] = "slam"

function meta:GetPrimaryAmmoTypeString()
	if self.Primary and self.Primary.Ammo then return self.Primary.Ammo end
	return TranslatedAmmo[self:GetPrimaryAmmoType()] or "none"
end

function meta:GetSecondaryAmmoTypeString()
	if self.Secondary and self.Secondary.Ammo then return self.Secondary.Ammo end
	return TranslatedAmmo[self:GetSecondaryAmmoType()] or "none"
end
