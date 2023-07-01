--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/commands/sh_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if (SERVER) then
	AddCSLuaFile("cl_commands.lua")
end

GAS.Commands = {}

GAS.Commands.ACTION_COMMANDS_MENU   = 0
GAS.Commands.ACTION_COMMAND         = 1
GAS.Commands.ACTION_CHAT            = 2
GAS.Commands.ACTION_WEBSITE         = 3
GAS.Commands.ACTION_TELEPORT        = 4
GAS.Commands.ACTION_LUA_FUNCTION_SV = 5
GAS.Commands.ACTION_LUA_FUNCTION_CL = 6
GAS.Commands.ACTION_GAS_MODULE      = 7

GAS:hook("gmodadminsuite:LoadModule:commands", "LoadModule:commands", function()
	if (SERVER) then
		include("gmodadminsuite/modules/commands/sv_commands.lua")
		include("gmodadminsuite/modules/commands/sv_permissions.lua")
	else
		include("gmodadminsuite/modules/commands/cl_commands.lua")
	end
end)