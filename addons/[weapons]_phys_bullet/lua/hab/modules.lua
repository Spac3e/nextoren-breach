--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_phys_bullet/lua/hab/modules.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local folderList = file.Find( "hab/modules/*.lua", "LUA" )
MsgN( )
MsgN( "  ===================================  " )
MsgN( "  =====Start Loading HAB Modules=====  " )
MsgN( "  ===================================  " )
MsgN( )

MsgN( )
MsgN( "	Module base.lua Loaded..." )

AddCSLuaFile( "hab/modules/base.lua" )
include( "hab/modules/base.lua" )
hab.modules[ 0 ] = "base.lua"

for i, f in pairs(folderList) do

	if f != "base.lua" then -- base is loaded separatley

		MsgN( )
		MsgN( "	Module " .. f .. " Loaded..." )

		AddCSLuaFile( "hab/modules/" .. f )
		include( "hab/modules/" .. f )

		hab.modules[i] = f

	end

end

MsgN( )
MsgN( "  ===================================  " )
MsgN( "  ======End Loading HAB Modules======  " )
MsgN( "  ===================================  " )
MsgN( )
