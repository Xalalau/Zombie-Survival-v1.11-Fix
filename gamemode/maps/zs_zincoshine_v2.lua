hook.Add("InitPostEntity", "AddBlocker", function()
	hook.Remove("InitPostEntity", "AddBlocker")

	for _, ent in pairs(ents.FindByClass("item_ammo_crate")) do ent:Remove() end
end)
