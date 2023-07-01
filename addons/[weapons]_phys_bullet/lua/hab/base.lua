--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_phys_bullet/lua/hab/base.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


hab = hab or {
	version = "0.7a",
--credits	
	author = "The_HAVOK",
	contact = "STEAM_0:1:40989742",
	contrib = {},
--tables
	Module = Module or {},
	modules = modules or {},

	CVars = CVars or {},
	cval = cval or {},

	ChatCom = ChatCom or {},

	hooks = hooks or {},
	hooksCalcView = hooksCalcView or {},

	Menu = Menu or {},

	menus = menus or {},

	controls = controls or {},
	key = key or {},

}

MsgN( )
MsgN( "---------------------------------------" )
MsgN( "-----------Start Loading HAB-----------" )
MsgN( "---------------------------------------" )
MsgN( )

-- load utils first
AddCSLuaFile( "hab/utils.lua" )
include( "hab/utils.lua" )
MsgN( "	utils.lua Loaded" )

AddCSLuaFile( "hab/enumerators.lua" )
include( "hab/enumerators.lua" )
MsgN( "	enumerators.lua Loaded" )

AddCSLuaFile( "hab/redefine.lua" )
include( "hab/redefine.lua" )
MsgN( "	redefine.lua Loaded" )

-- load modules last
AddCSLuaFile( "hab/modules.lua" )
include( "hab/modules.lua" )

MsgN( )
MsgN( "---------------------------------------" )
MsgN( "------------End Loading HAB------------" )
MsgN( "---------------------------------------" )
MsgN( )
