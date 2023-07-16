local ac_tag = "[PEEDORAS]"

hook.Add("PlayerConnect", "Peedoras_AC_PCH", function(ply)
end)

local whitelist = {}

function GM:PlayerInitialSpawn(client)
    local steamid64 = client:SteamID64()
    if !client:IsBot() and client:OwnerSteamID64() != steamid64 and !whitelist[steamid64] then
       client:Kick(ac_tag.." Family Shared Account")
    end
end

function LogTeamChangeFromBreach()
end