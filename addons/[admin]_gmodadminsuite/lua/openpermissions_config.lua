--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/openpermissions_config.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[

	   ____                   ____                      _           _                 
	  / __ \____  ___  ____  / __ \___  _________ ___  (_)_________(_)___  ____  _____
	 / / / / __ \/ _ \/ __ \/ /_/ / _ \/ ___/ __ `__ \/ / ___/ ___/ / __ \/ __ \/ ___/
	/ /_/ / /_/ /  __/ / / / ____/  __/ /  / / / / / / (__  |__  ) / /_/ / / / (__  ) 
	\____/ .___/\___/_/ /_/_/    \___/_/  /_/ /_/ /_/_/____/____/_/\____/_/ /_/____/  
	    /_/                                                                           

	Welcome to the OpenPermissions configuration file.
	This is where you'll define who is an OpenPermissions Operator.

	Operators have maximum permissions - you could call them "superadmins" of OpenPermissions.
	They have access to changing the permissions of the server, so only add people you trust here!

]]

-- Enter usergroups that should be Operators
OpenPermissions.Operators.Usergroups = {"superadmin"}

-- Enter SteamIDs or SteamID64s of people who should be Operators
OpenPermissions.Operators.SteamIDs = {}

-- Don't delete the line below; your config will break.
return true