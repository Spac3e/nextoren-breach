--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/secondaryusergroups/sh_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if (SERVER) then
	AddCSLuaFile("sh_core.lua")
	AddCSLuaFile("cl_menu.lua")
end

GAS:hook("gmodadminsuite:LoadModule:secondaryusergroups", "LoadModule:secondaryusergroups", function()
	include("gmodadminsuite/modules/secondaryusergroups/sh_core.lua")
	if (SERVER) then
		include("gmodadminsuite/modules/secondaryusergroups/sv_secondaryusergroups.lua")
		include("gmodadminsuite/modules/secondaryusergroups/sv_permissions.lua")
	else
		include("gmodadminsuite/modules/secondaryusergroups/cl_menu.lua")
	end
end)