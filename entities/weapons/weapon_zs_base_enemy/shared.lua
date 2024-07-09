AddCSLuaFile("shared.lua")

SWEP.Author = "JetBoom & Xalalau"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HitDetection = {
	traceStartGet = nil, -- string ply callback name. Default "GetPos"
	traceStartExtraHeight = nil, -- number
	traceEndGetNormal = nil, -- string ply callback name. Default nil, then we use the ply weapon forward vec
	traceEndDistance = nil, -- number
	traceEndExtraHeight = nil, -- number
	traceMask = nil, -- MASK enum. Default MASK_SOLID
	hitScanHeight = nil, -- number
	hitScanRadius = nil, -- number
	upZThreshold = nil, -- number
	upZHeight = nil, -- number
	upZaimDistance = nil, -- number
	downZThreshold = nil, -- number
	downZHeight = nil, -- number
	downZaimDistance = nil, -- number
	midZHeight = nil, -- number
	midZaimDistance = nil -- number
}

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.DrawAmmo = false	
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
end

function SWEP:CalcHit()
	local tr = {}
	local hit = self.HitDetection
	local owner = self:GetOwner()
	local vStart = owner[hit.traceStartGet or "GetPos"](owner)
	local vEnd = hit.traceEndGetNormal and owner[hit.traceEndGetNormal](owner) or self:GetForward()

	tr.start = vStart + Vector(0, 0, hit.traceStartExtraHeight)
	tr.endpos = vStart + vEnd * hit.traceEndDistance + Vector(0, 0, hit.traceEndExtraHeight)
	tr.filter = owner
	tr.mask = hit.traceMask or MASK_SOLID
	local trace = util.TraceLine(tr)
	local ent = trace.Entity

	if not ent:IsValid() or not trace.HitNonWorld then
		local curZ = owner:GetForward().z
		local aimDistance

		if curZ > hit.upZThreshold then
			curZ = Vector(0, 0, owner:GetForward().z * hit.upZHeight)
			aimDistance = hit.upZaimDistance
		elseif curZ <= hit.downZThreshold then
			curZ = Vector(0, 0, owner:GetForward().z * hit.downZHeight)
			aimDistance = hit.downZaimDistance
		else
			curZ = Vector(0, 0, owner:GetForward().z * hit.midZHeight)
			aimDistance = hit.midZaimDistance
		end		

		local searchPos = owner:GetPos() + Vector(0, 0, hit.hitScanHeight) + owner:GetAimVector() * aimDistance + curZ

		for _, fin in ipairs(ents.FindInSphere(searchPos, hit.hitScanRadius)) do
			if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() then
				ent = fin
				break
			end
		end
	end

	if not ent:IsValid() then
		ent = nil
	end

	return trace, ent
end

function SWEP:Think()
end

function SWEP:Reload()
	return false
end

if CLIENT then
	function SWEP:CanPrimaryAttack()
		return false
	end
	
	function SWEP:CanSecondaryAttack()
		return false
	end

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
	end

	--[[
	-- use sv_cheats 1 and thirdperson to see the generated areas
	hook.Add("PostDrawTranslucentRenderables", "TestDamage", function()
		local owner = LocalPlayer()
		local wep = owner:GetActiveWeapon()

		if not wep:IsValid() or not wep.HitDetection or wep.HitDetection.hitScanHeight == nil then return end
		local hit = wep.HitDetection
		local tr = {}
		local owner = wep:GetOwner()
		local vStart = owner[hit.traceStartGet or "GetPos"](owner)
		local vEnd = hit.traceEndGetNormal and owner[hit.traceEndGetNormal](owner) or wep:GetForward()

		tr.start = vStart + Vector(0, 0, hit.traceStartExtraHeight)
		tr.endpos = vStart + vEnd * hit.traceEndDistance + Vector(0, 0, hit.traceEndExtraHeight)
		tr.filter = owner
		tr.mask = hit.traceMask or MASK_SOLID
		local trace = util.TraceLine(tr)
		local ent = trace.Entity

		render.DrawLine(tr.start, tr.endpos, Color(255, 0, 0))

		if IsValid(ent) then
			print("Detected trace", ent)
		end

		if not ent:IsValid() or not trace.HitNonWorld then
			local curZ = owner:GetForward().z
			local aimVectorMultiplier

			if curZ > hit.upZThreshold then
				curZ = Vector(0, 0, owner:GetForward().z * hit.upZHeight)
				aimDistance = hit.upZaimDistance
			elseif curZ <= hit.downZThreshold then
				curZ = Vector(0, 0, owner:GetForward().z * hit.downZHeight)
				aimDistance = hit.downZaimDistance
			else
				curZ = Vector(0, 0, owner:GetForward().z * hit.midZHeight)
				aimDistance = hit.midZaimDistance
			end

			local searchPos = owner:GetPos() + Vector(0, 0, hit.hitScanHeight) + owner:GetAimVector() * aimDistance + curZ

			for _, fin in ipairs(ents.FindInSphere(searchPos, hit.hitScanRadius)) do
				if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() then
					ent = fin
					print("Detected sphere", ent)
					break
				end
			end

			render.SetColorMaterial()
			render.DrawSphere(searchPos, hit.hitScanRadius, 30, 30, Color(0, 175, 175, 100))
		end
	end)
	--]]
end