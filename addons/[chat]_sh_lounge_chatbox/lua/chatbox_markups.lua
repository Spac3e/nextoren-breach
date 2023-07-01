--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[chat]_sh_lounge_chatbox/lua/chatbox_markups.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

/**
* Markups Permissions configuration
**/

-- Here you can decide who is allowed to use a specific markup/parser.
-- If a markup isn't in the list below, then it'll be usable by anyone.
-- The server can use any markup available.
LOUNGE_CHAT.MarkupsPermissions = {
	// Only the "respected", "admin" and "superadmin" usergroups can use flash, rainbow and glow parsers.
	["flash"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},
	["rainbow"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},
	["glow"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},

	// Only those of "admin" and "superadmin" usergroups can send external images, avatars of other players and named URLs.
	["external image"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},
	["avatar other"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},
	["avatar"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},
	["named url"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		-- steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},

	// No one except the author (it's an example) should be allowed to use line breaks.
	["line break"] = {
		usergroups = {"superadmin"},
		--steamids = {"STEAM_0:1:8039869", "76561197976345467"},
	},

	// No one should be allowed to use lua buttons. It's internal.
	["lua"] = {
		usergroups = {"superadmin"},
	},
}