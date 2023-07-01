--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_ulx_ulib/lua/ulx/sh_defines.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ulx.LOW_ARGS = "You did not specify enough arguments for this command. Type 'ulx help' in console for help."

ulx.version = 3.73 -- Current release version. Don't access directly, use ULib.pluginVersionStr( "ULX" ) instead.
ulx.release = true -- Is this the release?

ulx.ID_ORIGINAL = 1
ulx.ID_PLAYER_HELP = 2
ulx.ID_HELP = 3

ulx.ID_MMAIN = 1
ulx.ID_MCLIENT = 2
ulx.ID_MADMIN = 3

ulx.HOOK_ULXDONELOADING = "ULXLoaded"
ulx.HOOK_VETO = "ULXVetoChanged"
