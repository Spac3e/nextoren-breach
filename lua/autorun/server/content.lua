local workshop_items = engine.GetAddons()
for i = 1, #workshop_items do
    local addon_id = workshop_items[i].wsid
    resource.AddWorkshop(addon_id)
end