if (SERVER) then
    AddCSLuaFile()
end
LeyHitreg = LeyHitreg or {}
LeyHitreg.Disabled = false
LeyHitreg.NoSpread = false
LeyHitreg.BrokenDefaultSpread = false
LeyHitreg.LogHitgroupMismatches = false
LeyHitreg.LogFixedBullets = false
LeyHitreg.BulletAimbot = false
LeyHitreg.LogTargetBone = false
LeyHitreg.AnnounceClientHits = false
LeyHitreg.DisableLagComp = false
LeyHitreg.svfiles = {
    "leyhitreg/server/receiveshotinfo/receiveshotinfo.lua",
    "leyhitreg/server/processbullet/processbullet.lua",
    "leyhitreg/server/damageinfo/scaledamagehack.lua",
    "leyhitreg/server/damageinfo/fixscaling.lua",
}
LeyHitreg.clfiles = {
    "leyhitreg/client/sendshots/sendshots.lua",
    "leyhitreg/client/spreadsystem/bulletspread.lua"
}
LeyHitreg.sharedfiles = {
    "leyhitreg/shared/disablelagcomp/disablelagcomp.lua",
    "leyhitreg/shared/workarounds/workarounds.lua"
}
local function includeOnCS(filename)
    if (SERVER) then
        print("Sending to clients: " .. filename)
        AddCSLuaFile(filename)
    end
    if (CLIENT) then
        include(filename)
    end
end
local function includeOnSV(filename)
    if (SERVER) then
        print("Loading: " .. filename)
        include(filename)
    end
end
function LeyHitreg:ProcessLuaFiles()
    for k,v in pairs(LeyHitreg.clfiles) do
        includeOnCS(v)
    end
    for k,v in pairs(LeyHitreg.svfiles) do
        includeOnSV(v)
    end
    for k,v in pairs(LeyHitreg.sharedfiles) do
        includeOnCS(v)
        includeOnSV(v)
    end
end
LeyHitreg:ProcessLuaFiles()
function LeyHitreg:DisableMoatHitreg()
    if (MOAT_HITREG) then
        MOAT_HITREG.MaxPing = 1
    end
    if (ConVarExists("moat_alt_hitreg")) then
        RunConsoleCommand("moat_alt_hitreg", "0")
    end
    if (SHR) then
        if (SHR.Config) then
            SHR.Config.Enabled = false
            SHR.Config.ClientDefault = 0
        end
        hook.Remove("EntityFireBullets", "SHR.FireBullets")
        hook.Remove("EntityFireBullets", "‍a")
        net.Receivers["shr"] = function() end
    end
end
print("[Ley hitreg]")