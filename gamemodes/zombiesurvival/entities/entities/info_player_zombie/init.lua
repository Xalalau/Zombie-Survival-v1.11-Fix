ENT.Type = "point"

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
	if key == "disabled" then
		self.Disabled = value == "1"
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name == "enable" then
		self.Disabled = false

		return true
	elseif name == "disable" then
		self.Disabled = true

		return true
	end
end
