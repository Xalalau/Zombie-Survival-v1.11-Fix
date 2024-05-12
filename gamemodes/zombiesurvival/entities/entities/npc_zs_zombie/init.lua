AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local schdPatrol = ai_schedule.New()
schdPatrol:AddTask("Wander")
schdPatrol:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
schdPatrol:EngTask("TASK_RUN_PATH", 0)
schdPatrol:EngTask("TASK_WAIT", 1)
schdPatrol:AddTask("FindEnemySmart")

local schdChase = ai_schedule.New()
--schdChase:AddTask("GetPathToEnemy")
--schdChase:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
schdChase:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
schdChase:EngTask("TASK_RUN_PATH_TIMED", 0.1)
schdChase:AddTask("CheckEnemyDead")
--schdChase:EngTask("TASK_WAIT", 0.1)

local schdAttack = ai_schedule.New()
schdAttack:EngTask("TASK_FACE_ENEMY", 0)
schdAttack:AddTask("RestartGesture", {Name=ACT_MELEE_ATTACK1, StartSounds={"npc/zombie/zo_attack1.wav", "npc/zombie/zo_attack2.wav"}})
schdAttack:EngTask("TAST_WAIT", 0.75)
schdAttack:AddTask("Attack")
schdAttack:AddTask("CheckEnemyDead")

function ENT:TaskStart_Attack(data)
	self:TaskComplete()

	local hit

	local trueeye = self:TrueEyePos()
	for _, pl in pairs(ents.FindInSphere(trueeye + self:GetAimVector() * 25, 72)) do
		if pl:IsPlayer() and pl:Team() == TEAM_HUMAN and pl:Alive() then
			hit = true
			pl:TakeDamage(30, self, self)
		end
	end

	if hit then
		self:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
	else
		self:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	end
end

function ENT:Task_Attack(data)
end

function ENT:TaskStart_RestartGesture(data)
	self:TaskComplete()

	self:RestartGesture(data.Name)

	local tab = data.StartSounds
	if tab then
		self:EmitSound(tab[math.random(1, #tab)])
	end
end

function ENT:Task_RestartGesture(data)
end

function ENT:TaskStart_GetPathToEnemy(data)
	self:TaskComplete()

	local enemy = self.Enemy
	if enemy:IsValid() then
		local enemypos = enemy:GetPos() + Vector(0, 0, 16)
		self:SetLastPosition(enemypos + (self:GetPos() + Vector(0, 0, 16) - enemypos):Normalize() * 48)
	end
end

function ENT:Task_GetPathToEnemy(data)
end

function ENT:TaskStart_FindEnemySmart(data)
	self:TaskComplete()

	local dist = 999999
	local playa

	local mypos = self:GetPos()

	for _, pl in pairs(player.GetAll()) do
		if pl:Alive() and pl:Team() == TEAM_HUMAN then
			local distfrom = pl:GetPos():Distance(mypos)
			if distfrom < dist then
				playa = pl
				dist = distfrom
			end
		end
	end

	if playa and playa ~= self.Enemy then
		self.Enemy = playa
		self:SetEnemy(playa)
		self:UpdateEnemyMemory(playa, playa:GetPos())
		self:EmitSound("npc/fast_zombie/fz_alert_close1.wav")
		self:StartSchedule(schdChase)
	end
end

function ENT:Task_FindEnemySmart(data)
end

function ENT:TaskStart_CheckEnemyDead()
	self:TaskComplete()

	local enemy = self.Enemy

	if enemy:IsValid() then
		if enemy:Alive() then
			local trueeye = self:TrueEyePos()
			local dist = enemy:NearestPoint(trueeye):Distance(trueeye)
			if 1024 < dist then
				self.Enemy = NULL
			elseif dist < 100 then
				self:StartSchedule(schdAttack)
			else
				self:StartSchedule(schdChase)
			end
		else
			self.Enemy = NULL
		end
	end
end

function ENT:Task_CheckEnemyDead()
end

function ENT:TaskStart_Wander()
	self:TaskComplete()

	self:SetLastPosition(self:GetPos() + Vector(math.Rand(-200, 200), math.Rand(-200, 200), 16))
end

function ENT:Task_Wander()
end

function ENT:Think()
end

function ENT:Initialize()
	self:SetModel("models/zombie/classic.mdl")

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()

	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)

	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN)
	self:SetMaxYawSpeed(5000)

	local classtab = GAMEMODE.ZombieClasses["Zombie"]
	if classtab then
		self:SetHealth(classtab.Health)
	else
		self:SetHealth(200)
	end

	self.Noded = ents.FindByClass("ai_node")[1] ~= nil
	self.Enemy = NULL
end

function ENT:OnTakeDamage(dmg)
	if self.DEAD then return end

	local attacker = dmg:GetAttacker()

	local owner = attacker:GetOwner()
	if owner and owner:IsValid() then
		attacker = owner
	end

	if attacker and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		return
	end

	self:SetHealth(self:Health() - dmg:GetDamage())

	if math.random(1, 2) == 1 then
		self:EmitSound("npc/fast_zombie/leap1.wav")
	else
		self:EmitSound("npc/fast_zombie/wake1.wav")
	end

	if self:Health() <= 0 then
		self.DEAD = true
		local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:SetModel(self:GetModel())
			ragdoll:Spawn()
			ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			if dmg and dmg.GetDamageForce then
				local force = dmg:GetDamageForce()
				if force:Length() == 0 then
					force = VectorRand() * 64
				end
				ragdoll:GetPhysicsObject():SetVelocityInstantaneous(force * 250)
			end
			ragdoll:Fire("kill", "", 7.5)
		end

		if self.Owner and self.Owner:IsValid() and self.Owner.NPCS then
			self.Owner.NPCS = self.Owner.NPCS - snpc.Zombie.Slots
			self.Owner:SendLua("MySelf.NPCS="..self.Owner.NPCS)
		end

		self:Remove()
		return
	end

	local enemy = self.Enemy

	if not (enemy and enemy:IsValid()) and attacker and attacker:IsValid() and (attacker:IsPlayer() or attacker:IsNPC()) and TrueVisible(self:TrueEyePos(), attacker:NearestPoint(self:TrueEyePos())) then
		self.EndChase = CurTime() + math.Rand(10, 12)
		self.Enemy = attacker
		self:SetEnemy(attacker)
		self:UpdateEnemyMemory(attacker, attacker:GetPos())
		self:EmitSound("npc/fast_zombie/fz_alert_far1.wav")
		--self:StartSchedule(schdChase)
	end
end 

function ENT:SelectSchedule()
	local enemy = self.Enemy

	if enemy:IsValid() then
		if enemy:Alive() then
			local trueeye = self:TrueEyePos()
			local dist = enemy:NearestPoint(trueeye):Distance(trueeye)
			if 1024 < dist then
				self.Enemy = NULL
			elseif 100 < dist then
				self:StartSchedule(schdChase)
			else
				self:StartSchedule(schdAttack)
			end
			return
		else
			self.Enemy = NULL
		end
	else
		self:StartSchedule(schdPatrol)
	end
end

function ENT:GetAttackSpread(weapon, target)
	return 0
end
