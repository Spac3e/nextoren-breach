if file.Find("lua/bin/gmcl_gdiscord_*.dll", "GAME")[1] == nil then return end
require("gdiscord")

local map_restrict = false
local map_list = {
    nextoren_site19_alpha = true
}

local discord_id = "1124936966136397914"
local refresh_time = 5

local discord_start = discord_start or -1

function DiscordUpdate()
    local rpc_data = {}
    local team_icon = {
        ["SCPs"] = "scp",
        ["MTF Guards"] = "mtf",
        ["Class-Ds"] = "class_d",
        ["Spectators"] = "scp",
        ["Scientists"] = "sci",
        ["Chaos Insurgency"] = "chaos",
        ["Security Department"] = "sb",
        ["GRU"] = "gru",
        ["Nine Tailed Fox"] = "ntf",
        ["Serpents Hand"] = "dz",
        ["Global Occult Coalition"] = "goc",
        ["Unusual Incidents Unit"] = "fbi",
        ["Quick Response Team"] = "obr",
        ["Children of the Scarlet King"] = "scarlet",
        ["Specials"] = "sci_special",
        ["Spec. Task Force"] = "osn",
        ["Nazi Germany"] = "scp",
        ["American Army"] = "scp",
    }
    local MP_ICONS = {
        ["nextoren_site19_alpha"] = {largeKey = "site19", largeText = "Зона #19. Сибирь."},
    }

    rpc_data["largeImageKey"] = "vault"
    rpc_data["largeImageText"] = "Загрузка на сервер"

    rpc_data["startTimestamp"] = discord_start
    rpc_data["details"] = "Загружается на сервер"
    
    for i, ply in ipairs(player.GetAll()) do
        if ply:GetNamesurvivor() == "Spectator" or !ply:GetNamesurvivor() then
            local faggot = LocalPlayer()
            rpc_data["details"] = "Роль: "..faggot:GetRoleName()
            rpc_data["state"] = "Ожидает в наблюдателях"
            rpc_data["smallImageKey"] = team_icon[gteams.GetName(faggot:GTeam())]
            rpc_data["smallImageText"] = gteams.GetName(faggot:GTeam())
            rpc_data["largeImageKey"] = MP_ICONS[game.GetMap()].largeKey
            rpc_data["largeImageText"] = MP_ICONS[game.GetMap()].largeText
    else
       if ply:GetNamesurvivor() != "Spectator" then
            local faggot = LocalPlayer()
            rpc_data["details"] = "Роль: "..faggot:GetRoleName()
            rpc_data["state"] = "Персонаж: "..faggot:GetNamesurvivor()
            rpc_data["smallImageKey"] = team_icon[gteams.GetName(faggot:GTeam())]
            rpc_data["smallImageText"] = gteams.GetName(faggot:GTeam())
            rpc_data["largeImageKey"] = MP_ICONS[game.GetMap()].largeKey
            rpc_data["largeImageText"] = MP_ICONS[game.GetMap()].largeText
        end
    end   
    end
    DiscordUpdateRPC(rpc_data)
end

hook.Add("Initialize", "UpdateDiscordStatus", function()
    discord_start = os.time()
    DiscordRPCInitialize(discord_id)
    DiscordUpdate()
    timer.Create("DiscordRPCTimer", refresh_time, 0, DiscordUpdate)
end)
