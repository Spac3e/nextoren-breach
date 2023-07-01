--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_ulx_ulib/lua/ulib/client/commands.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
	Function: redirect

	This redirects any command to the server.

	*DO NOT CALL DIRECTLY*

	Parameters:

		ply - The player using the command
		command - The command being used
		argv - The table of arguments
]]
function ULib.redirect( ply, command, argv )
	local totalArgv = table.Add( ULib.explode( " ", command ), argv )
	RunConsoleCommand( "_u", unpack( totalArgv ) )
end
