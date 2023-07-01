--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[dev]_steam_functions/lua/autorun/steam_functions.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

/********************************
Utility functions
********************************/

function util.SteamIDTo32(steamid)
	local acc32 = tonumber(steamid:sub(11))

	return tostring((acc32 * 2) + tonumber(steamid:sub(9,9)))
end

function util.SteamIDFrom32(steamid32)
	steamid32 = tonumber( steamid32 )
	local y = steamid32 % 2
	local z = ( steamid32 - y ) / 2

	return "STEAM_0:" .. y .. ":" .. z
end

function util.SteamID64To32(steamid64)
	return util.SteamIDTo32(util.SteamIDFrom64(steamid64))
end

function util.SteamID64From32(steamid32)
	return util.SteamIDTo64(util.SteamIDFrom32(steamid32))
end

/********************************
Player functions
********************************/

local mply = FindMetaTable("Player")

function mply:SteamID32()
	return util.SteamIDTo32(self:SteamID())
end

function player.GetBySteamID32(steamid32)
	local players = player.GetAll()
	for i = 1, #players do
		if ( players[i]:SteamID32() == steamid32 ) then
			return players[i]
		end
	end

	return false
end