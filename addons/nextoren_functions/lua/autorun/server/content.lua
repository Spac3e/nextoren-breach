local function loadcontent()
    print("Content: Loading...")
    resource.AddWorkshop( "3044608151" ) -- Breach Facus
    resource.AddWorkshop( "3044608984" ) -- Breach Hedus
    resource.AddWorkshop( "3110317119" ) -- [NextOren Breach] Main Content
    resource.AddWorkshop( "3110306869" ) -- [NextOren Breach] Main Models
    resource.AddWorkshop( "3110302884" ) -- [NextOren Breach] Map
    resource.AddWorkshop( "3110307500" ) -- [NextOren Breach] Models Materials
    resource.AddWorkshop( "3110301328" ) -- [NextOren Breach] Other Content
    resource.AddWorkshop( "3110318382" ) -- [NextOren Breach] Other Staff
    resource.AddWorkshop( "3110318950" ) -- [NextOren Breach] Particles
    resource.AddWorkshop( "3110308889" ) -- [NextOren Breach] SCP Materials
    resource.AddWorkshop( "3110310204" ) -- [NextOren Breach] Weapons
    resource.AddWorkshop("1241946456")
    resource.AddWorkshop("657241323")
    print("Content: Ready")
    contentprecached = true
end

if not contentprecached then
    loadcontent()
    print("Content: Finished")
end