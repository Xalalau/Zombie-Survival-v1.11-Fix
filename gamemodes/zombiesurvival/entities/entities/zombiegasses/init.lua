AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Heal = self.Heal or 20
	self:DrawShadow(false)
	self:Fire("attack", "", 1.5)
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "radius" then
		self:SetRadius(tonumber(value))
	elseif key == "heal" then
		self.Heal = tonumber(value) or self.Heal
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

local function TrueVisible(posa, posb)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, ents.FindByClass("npc_*"))
	filt = table.Add(filt, ents.FindByClass("prop_*"))
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name == "attack" then
		self:Fire("attack", "", 1.5)

		if 0 < GAMEMODE:GetWave() then
			local vPos = self:GetPos()
			for _, ent in pairs(ents.FindInSphere(vPos, self:GetRadius())) do
				if ent:IsPlayer() and ent:Alive() and TrueVisible(vPos, ent:EyePos()) then
					if ent:Team() == TEAM_UNDEAD then
						if GAMEMODE:GetFighting() and CurTime() < GAMEMODE:GetWaveEnd() then
							ent:SetHealth(math.min(ent.ClassTable.Health, ent:Health() + self.Heal))
						end
					elseif 5 < ent:Health() then
						DoPoisoned(ent, self, "dumb")
					end
				end
			end
		end

		return true
	end
end
