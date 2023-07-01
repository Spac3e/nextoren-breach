--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[begotten]_advmelee/lua/autorun/adv_melee_load.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

print("Advanced Melee by UracosVereches loading")

advmelee = {}

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )
		print( "[AUTOLOAD] SERVER INCLUDE: " .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print( "[AUTOLOAD] SHARED ADDCS: " .. File )
		end
		include( directory .. File )
		print( "[AUTOLOAD] SHARED INCLUDE: " .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print( "[AUTOLOAD] CLIENT ADDCS: " .. File )
		elseif CLIENT then
			include( directory .. File )
			print( "[AUTOLOAD] CLIENT INCLUDE: " .. File )
		end
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		print( "[AUTOLOAD] Directory: " .. v )
		IncludeDir( directory .. v )
	end
end

IncludeDir("advanced_melee")