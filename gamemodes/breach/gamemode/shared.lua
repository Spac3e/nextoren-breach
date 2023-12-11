// Shared file
GM.Name 	= "Breach"
GM.Author 	= "NextOren/-Spac3"
GM.Email 	= ""
GM.Website 	= ""

VERSION = "2.6.0"
DATE = "16/07/2023"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

function GM:Think()
end

ALLLANGUAGES = {}
WEPLANG = {}
BREACH = BREACH || {}

russian = russian or {}
nontranslated = {}

TEAM_SCP = 1
TEAM_GUARD = 2
TEAM_CLASSD = 3
TEAM_SCI = 5
TEAM_CHAOS = 6
TEAM_SECURITY = 7
TEAM_GRU = 8
TEAM_NTF = 9
TEAM_DZ = 10
TEAM_GOC = 11
TEAM_USA = 12
TEAM_QRT = 13
TEAM_COTSK = 14
TEAM_SPECIAL = 15
TEAM_OSN = 16
TEAM_NAZI = 17
TEAM_AMERICA = 18
TEAM_ARENA = 19
TEAM_SPEC = 20

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

local enumToSide = {}
enumToSide[ BREACH.SIDE_CLIENT ] = "cl"
enumToSide[ BREACH.SIDE_SERVER ] = "sv"
enumToSide[ BREACH.SIDE_SHARED ] = "sh"

local sideToEnum = {}
sideToEnum[ "cl" ] = BREACH.SIDE_CLIENT
sideToEnum[ "sv" ] = BREACH.SIDE_SERVER
sideToEnum[ "sh" ] = BREACH.SIDE_SHARED

function BREACH.Enums:MuteTypeToString( muteType )
  if ( muteType == BREACH.MUTE_TYPE_ALL ) then
    return "Chat/Voice"
  elseif ( muteType == BREACH.MUTE_TYPE_CHAT ) then
    return "Chat"
  elseif ( muteType == BREACH.MUTE_TYPE_VOICE ) then
    return "Voice"
  else
    return "*ERROR*"
  end
end

function BREACH.Enums:TranslateEnumToSide( enum )
  return enumToSide[ enum ]
end

function BREACH.Enums:TranslateSideToEnum( enum )
  return sideToEnum[ enum ]
end

------------------
BREACH.Round = BREACH.Round || {}
BREACH.Round.GameStarted = BREACH.Round.GameStarted || false
BREACH.Round.RoundsTillRestart = BREACH.Round.RoundsTillRestart || 10

BREACH.NukePos = Vector( -712.862427, 6677.729492, 2225.919189 )
BREACH.BlackListedSCPPlayers = {}

if ( SERVER ) then
	AddCSLuaFile( "modules/teams/cl_module.lua" )
	AddCSLuaFile( "modules/teams/sh_module.lua" )
	include( "modules/teams/sv_module.lua" )
	include( "modules/teams/sh_module.lua" )
else
	include( "modules/teams/cl_module.lua" )
	include( "modules/teams/sh_module.lua" )
end

local files = file.Find(GM.FolderName .. "/gamemode/languages" .. "/*.lua", "LUA" )
for k, f in pairs( files ) do
	if SERVER then
		MsgC( Color(255,255,0), "[NextOren Breach] Loading Language: " .. f .. "\n" )
		AddCSLuaFile( GM.FolderName .. "/gamemode/languages".."/"..f )
		include( GM.FolderName .. "/gamemode/languages".."/"..f )
	else
		MsgC( Color(255,255,0), "[NextOren Breach] Loading Language: " .. f .. "\n" )
		include( GM.FolderName .. "/gamemode/languages".."/"..f )
		if string.sub( f, 1, 3 ) != "wep" then
			--MsgC( Color(255,255,0), "[NextOren Breach] Loading Language: " .. f .. "\n" )
		end
	end
end

MsgC( Color(255,255,0), "[NextOren Breach] Comparing languages: \n" )

function BREACH.CompareLanguage(lang)
	local no_translations = {}
	for k, v in pairs(russian) do
		local found = false
		for _, ass in pairs(lang) do
			if _ == k then
				found = true
			end
		end
		if !found then
			no_translations[k] = v
		end
	end

	return no_translations
end

local function AutoComplete(cmd, stringargs)
	local tbl = {}
    for k, v in pairs(ALLLANGUAGES) do
    	table.insert(tbl, "breach_compare_language "..tostring(k))
    end
    return tbl
end

concommand.Add("breach_compare_language",
	function(ply, cmd, args, argstr)
		if !ALLLANGUAGES[args[1]] then
			print("language not found: "..args[1])
			return
		end
		local tbl = BREACH.CompareLanguage(ALLLANGUAGES[args[1]])
		if #table.GetKeys(tbl) > 0 then
			PrintTable(tbl)
			print("found "..#table.GetKeys(tbl).." missing phrases")
		else
			print("language is up to date")
		end
	end,
AutoComplete)

local obsolete_found = false
for k, v in pairs(ALLLANGUAGES) do
	local tbl = BREACH.CompareLanguage(v)

	if #table.GetKeys(tbl) > 0 then
		MsgC( Color(255,0,0), "[NextOren Breach] Language "..tostring(k).." is obsolete. Found "..#table.GetKeys(tbl).." missing phrases\n" )
		obsolete_found = true
	else
		MsgC( Color(0,255,0), "[NextOren Breach] Language "..tostring(k).." is up to date\n" )
	end
end

if obsolete_found then
	MsgC( Color(255,255,0), "[NextOren Breach] Use command breach_compare_language (language) to get missing phrases\n" )
else
	MsgC( Color(0,255,0), "[NextOren Breach] All languages are up to date\n" )
end
