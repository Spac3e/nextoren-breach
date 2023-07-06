AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

MsgC( Color(0,255,0),"---------------Loading Map Config----------------\n" )
if file.Exists( MAP_CONFIG_PATH .. "/" .. game.GetMap() .. ".lua", "LUA" ) then
	local relpath = "mapconfigs/" .. game.GetMap() .. ".lua"
	if SERVER then
		AddCSLuaFile( relpath )
	end
	include( relpath )
	MsgC( Color(0,255,0), "# Loading config for map " .. game.GetMap().."\n" )
	MAP_LOADED = true
else
	MsgC( Color(0,255,0), "----------------Loading Complete-----------------\n" )
	error( "Unsupported map " .. game.GetMap() .. "!" )
end