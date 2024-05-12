AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:SetNetworkedBool("IsHolding", true)
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() then
			wep:SendWeaponAnim(ACT_VM_HOLSTER)
			if wep.SetIronsights then
				wep:SetIronsights(false)
			end
		end
	end

	local object = self.Object
	if object:IsValid() then
		object.OriginalAngles = object:GetAngles()
		if owner:IsValid() then
			--object.OriginalOwnerAngles = owner:GetAngles()
			object.OwnerAngles = owner:GetAngles()
		else
			--object.OriginalOwnerAngles = Angle(0,0,0)
			object.OwnerAngles = Angle(0,0,0)
		end
		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			object.OriginalMass = objectphys:GetMass()
			objectphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
			objectphys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			if objectphys:GetMass() < CARRY_DRAG_MASS then
				objectphys:EnableGravity(false)
				objectphys:SetMass(2)
			end
		end
	end

	self.LastThink = CurTime()
end

function ENT:Think()
	local ct = CurTime()

	local frametime = ct - self.LastThink
	self.LastThink = ct

	local object = self.Object
	if not (object and object:IsValid() and not object.Nails) then self:Remove() return end

	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:Alive() and not owner:KeyDown(IN_ATTACK)) then
		self:Remove()
		return
	end

	local shootpos = owner:GetShootPos()
	local nearestpoint = object:NearestPoint(shootpos)

	local objectphys = object:GetPhysicsObject()
	if object:GetMoveType() ~= MOVETYPE_VPHYSICS or not objectphys:IsValid() or 64 < nearestpoint:Distance(shootpos) or owner:GetGroundEntity() == object then
		self:Remove()
		return
	end

	objectphys:Wake()

	if object.OriginalMass < CARRY_DRAG_MASS and object:OBBMins():Length() + object:OBBMaxs():Length() < CARRY_DRAG_VOLUME then
		local targetpos = shootpos + owner:GetAimVector() * 64

		local ShadowParams={}
		ShadowParams.secondstoarrive = 0.1
		ShadowParams.pos = targetpos
		ShadowParams.angle = object:GetAngles()
		ShadowParams.maxangular = 1000
		ShadowParams.maxangulardamp = 10000
		ShadowParams.maxspeed = 500
		ShadowParams.maxspeeddamp = 1000
		ShadowParams.dampfactor = 0.8
		ShadowParams.teleportdistance = 0
		ShadowParams.deltatime = frametime
		objectphys:ComputeShadowControl(ShadowParams)
	else
		local targetpos = shootpos + owner:GetAimVector() * 16
		local vel = (targetpos - object:NearestPoint(targetpos)):Normalize()
		vel.z = 0
		objectphys:ApplyForceCenter(objectphys:GetMass() * frametime * 500 * vel:Normalize())
	end

	object:SetPhysicsAttacker(owner)

	self:NextThink(ct)
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsPlayer() then
		owner:SetNetworkedBool("IsHolding", false)
		if owner:Alive() then
			GAMEMODE:SetPlayerSpeed(owner, owner:GetActiveWeapon().WalkSpeed or 200)
			local wep = owner:GetActiveWeapon()
			if wep:IsValid() then
				wep:SendWeaponAnim(ACT_VM_DRAW)
			end
		end
	end

	local object = self.Object
	if object:IsValid() then
		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			objectphys:ClearGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			objectphys:EnableGravity(true)
			objectphys:SetMass(object.OriginalMass)
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
