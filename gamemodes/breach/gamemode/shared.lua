MODULES_PATH = GM.FolderName .. "/gamemode/modules"
LANGUAGES_PATH = GM.FolderName .. "/gamemode/languages"
MAP_CONFIG_PATH = GM.FolderName .. "/gamemode/mapconfigs"

ALLLANGUAGES = {}
WEPLANG = {}
BREACH = {} or BREACH
concommand.Add( "player_position", function( ply, cmd, args )
	chat.AddText( Color( 255, 255, 255 ), "Ваша позиция была скопирована. CTRL+V,чтобы вставить")
	SetClipboardText(("Vector(%s)"):format(string.gsub(tostring(ply:GetPos())," ", ",")))
end )
--ARG

BREACH.ARG_TYPE_BOOL = 0
BREACH.ARG_TYPE_COLOR = 1
BREACH.ARG_TYPE_PLAYER = 2
BREACH.ARG_TYPE_PLAYERLIST = 3
BREACH.ARG_TYPE_LIST = 4
BREACH.ARG_TYPE_NUMBER = 5
BREACH.ARG_TYPE_STRING = 6
BREACH.ARG_TYPE_TIME = 7


--Mute types
BREACH.MUTE_TYPE_NONE = 0
BREACH.MUTE_TYPE_CHAT = 2^0
BREACH.MUTE_TYPE_VOICE = 2^1
BREACH.MUTE_TYPE_ALL = bit.bor( BREACH.MUTE_TYPE_CHAT, BREACH.MUTE_TYPE_VOICE )


--Script side
BREACH.SIDE_CLIENT = 2^0
BREACH.SIDE_SERVER = 2^1
BREACH.SIDE_SHARED = bit.bor( BREACH.SIDE_CLIENT, BREACH.SIDE_SERVER )


--Var type
BREACH.VAR_TYPE_ANY = 0
BREACH.VAR_TYPE_BOOL = 1
BREACH.VAR_TYPE_INTEGER = 2
BREACH.VAR_TYPE_REAL = 3
BREACH.VAR_TYPE_STRING = 4

BREACH.Enums = {}


MsgC( Color(255,0,255), "[NextOren Breach] Legend: ", Color(0,255,255), "Server ", Color(255,255,0), "Shared ", Color(255,100,0), "Client\n" )
Msg("======================================================================\n")
MsgC( Color(0,255,0), "----------------Loading Languages----------------\n")
local files = file.Find(LANGUAGES_PATH .. "/*.lua", "LUA" )
for k, f in pairs( files ) do
	if SERVER then
		MsgC( Color(255,255,0), "[NextOren Breach] Loading Language: " .. f .. "\n" )
		AddCSLuaFile( LANGUAGES_PATH.."/"..f )
		include( LANGUAGES_PATH.."/"..f )
	else
		MsgC( Color(255,255,0), "[NextOren Breach] Loading Language: " .. f .. "\n" )
		include( LANGUAGES_PATH.."/"..f )
		if string.sub( f, 1, 3 ) != "wep" then
			MsgC( Color(255,255,0), "[NextOren Breach] Loading Language: " .. f .. "\n" )
		end
	end
end

if SERVER then
	AddCSLuaFile( "modules/cl_module.lua" )
	AddCSLuaFile( "modules/sh_module.lua" )

	include( "modules/sv_module.lua" )
	include( "modules/sh_module.lua" )
else
	include( "modules/cl_module.lua" )
	include( "modules/sh_module.lua" )
end

MsgC( Color(0,255,0),"----------------Loading Modules----------------\n")
local modules = file.Find( MODULES_PATH.."/*.lua", "LUA" )
local skipped = 0
for k, f in pairs( modules ) do
	if f == "sv_module.lua" or f == "sh_module.lua" or f == "cl_module.lua" then continue end

	if string.sub( f, 1, 1 ) == "_" then
		skipped = skipped + 1
		continue
	end

	if string.len( f ) > 3 then
		local ext = string.sub( f, 1, 3 )

		if ext == "cl_" then
			if SERVER then
				MsgC( Color(255,100,0), "[NextOren Breach] Loading CLIENT file: " .. f .. "\n" )
				AddCSLuaFile( MODULES_PATH .. "/" .. f )
			else
				MsgC( Color(255,100,0), "[NextOren Breach] Loading CLIENT file: " .. f .. "\n" )
				include( MODULES_PATH .. "/" .. f )
			end
		elseif ext == "sv_" then
			if SERVER then
				MsgC( Color(0,255,255), "[NextOren Breach] Loading SERVER file: " .. f .. "\n" )
				include( MODULES_PATH .. "/" .. f )
			end
		elseif ext == "sh_" then
			if SERVER then
				AddCSLuaFile( MODULES_PATH .. "/" .. f )
			end
			MsgC( Color(255,255,0), "[NextOren Breach] Loading SHARED file: " .. f .. "\n" )
			include( MODULES_PATH .. "/" .. f )
		end
	else
		skipped = skipped + 1
	end
end

MsgC( Color(0,255,0),"-----------------Loading Animation Base-----------------\n")
MODULES_PATH = GM.FolderName .. "/gamemode/modules/anim_base"
local modules = file.Find( MODULES_PATH.."/*.lua", "LUA" )
local skipped = 0
for k, f in pairs( modules ) do
	if f == "sv_module.lua" or f == "sh_module.lua" or f == "cl_module.lua" then continue end

	if string.sub( f, 1, 1 ) == "_" then
		skipped = skipped + 1
		continue
	end

	if string.len( f ) > 3 then
		local ext = string.sub( f, 1, 3 )

		if ext == "cl_" then
			if SERVER then
				MsgC( Color(255,100,0), "[NextOren Breach] Loading CLIENT file: " .. f .. "\n" )
				AddCSLuaFile( MODULES_PATH .. "/" .. f )
			else
				MsgC( Color(255,100,0), "[NextOren Breach] Loading CLIENT file: " .. f .. "\n" )
				include( MODULES_PATH .. "/" .. f )
			end
		elseif ext == "sv_" then
			if SERVER then
				MsgC( Color(0,255,255), "[NextOren Breach] Loading SERVER file: " .. f .. "\n" )
				include( MODULES_PATH .. "/" .. f )
			end
		elseif ext == "sh_" then
			if SERVER then
				AddCSLuaFile( MODULES_PATH .. "/" .. f )
			end
			MsgC( Color(255,255,0), "[NextOren Breach] Loading SHARED file: " .. f .. "\n" )
			include( MODULES_PATH .. "/" .. f )
		end
	else
		skipped = skipped + 1
	end
end


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

MsgC( Color(0,255,0), "----------------Loading Complete-----------------\n" )