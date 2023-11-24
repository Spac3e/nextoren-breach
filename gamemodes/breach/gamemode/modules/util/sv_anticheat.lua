BREACH.AntiCheat = BREACH.AntiCheat or {}
BREACH.Relay = BREACH.Relay or {}
local ac_tag = "[PEEDORAS]"

function BREACH.AntiCheat.PlayerLoaded(ply)
	ply.JoinTimeAC = CurTime()
	ply.PlayerFullyAuthenticated = true
	ply:ConCommand("music_menu")
end

function BREACH.AntiCheat:KickPlayer(ply, reason)
	if !IsValid(ply) then
		return
	end

	reason = tostring(reason) or ''

	reason = reason .. '\n' .. 'You have to wait until map change before you can join'

	ply:Kick(ac_tag..' '..reason)
end

local whitelist = {}

function GM:PlayerInitialSpawn(client)
    local steamid64 = client:SteamID64()
    if !client:IsBot() and client:OwnerSteamID64() != steamid64 and !whitelist[steamid64] then
        BREACH.AntiCheat:KickPlayer(client,'Family Shared account')
    end
end

hook.Add('PlayerInitialSpawn', 'BREACH.AntiCheat:PlayerLoaded', BREACH.AntiCheat.PlayerLoaded)

function LogTeamChangeFromBreach(target,before,after)
	local form = {
		["username"] = Discord.hookname,
		["embeds"] = {{
			["title"] = target:Name()..' '..target:SteamID(),
			["description"] = "Смена команды\n"..gteams.GetName(before)..'\n'..gteams.GetName(after),
			["color"] = 6009554
		}}
	}
	Discord.send(form)
end

function BREACH.Relay:SendRoundStats(state)
	local до_рестарта = GetGlobalInt("RoundUntilRestart", 10)

	if state == продолжай then
		msg = "Рестарт, раундов "..до_рестарта or 0
	end

    if state == закончи then
		msg = "Рестарт"
	end
	
	local form = {
		["username"] = Discord.hookname,
		["embeds"] = {{
			["description"] = msg,
			["color"] = 6009554
		}}
	}
	Discord.send(form)
end