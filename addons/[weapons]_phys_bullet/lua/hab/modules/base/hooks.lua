--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_phys_bullet/lua/hab/modules/base/hooks.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local MODULE = hab.Module.Base

local FuncReloadHooksAutoComplete = function( cmd, args )

	args = string.Trim( args ) -- remove spaces
	args = string.lower( args ) -- lowercase

	local tbl = {} -- define table

	for k, v in pairs( hab.hooks ) do -- check modules

		local Hook = v

		if string.find( string.lower( Hook ), args ) then

			Hook = "hab_reload_hooks" .. ( CLIENT and "_cl" or "" ) .. Hook -- insert command name before arg

			table.insert( tbl, Hook )

		end

	end

	return tbl

end

local FuncReloadHooks = function( player, command, args )

	for name, t in pairs( hab.hooks ) do

		if !t.g or !name or !t.f then error( "failed to reload hook " .. tostring( t.g ) .. ' ' .. tostring( name ) .. ' ' .. tostring( t.f ) ) end

		print( "Reloaded " .. name )

		hook.Add( t.g, name, t.f )

	end

end

hab.AddConCommand( nil, "reload_hooks" .. ( CLIENT and "_cl" or "" ), FuncReloadHooks, FuncReloadHooksAutoComplete, "Used to reload HAB hooks", HAB_FCVAR_CLIENT_SERVER_ONCE )


if CLIENT then

	hab.hook( "NeedsDepthPass", "HAB_Base_NeedsDepthPass", function( )

		DOFModeHack( tobool( hab.cval.Base.Enable_DOF_Hack ) )

		return true

	end )

	hab.hook( "AddToolMenuTabs", "HAB_AddToolMenuTabs", function( ) spawnmenu.AddToolTab( "HAB", "HAB", "icon16/hab.png" ) end )

	net.Receive( "HAB_Base_PlayerSpawn_c", function( len )

		local ply = net.ReadEntity( )
		hook.Run( "cPlayerSpawn", ply )

	end )

	net.Receive( "HAB_Base_PlayerInitialSpawnDelayed_c", function( len )

		local ply = net.ReadEntity( )
		hook.Run( "cPlayerInitialSpawnDelayed", ply )

	end )

end

if SERVER then

	util.AddNetworkString( "HAB_Base_PlayerInitialSpawnDelayed_c" )
	util.AddNetworkString( "HAB_Base_PlayerSpawn_c" )

	hab.hook( "PlayerInitialSpawn", "HAB_Base_PlayerInitialSpawn", function( ply )

		timer.Simple( 1, function( )

			ply:SetNWString( "hab_steam_id", ply:SteamID64( ) )
			ply:SetNW2String( "hab_steam_id", ply:SteamID64( ) )

			net.Start( "HAB_Base_PlayerInitialSpawnDelayed_c" )

				net.WriteEntity( ply )

			net.Broadcast( )

			hook.Run( "PlayerInitialSpawnDelayed", ply )

		end )

	end )

	hab.hook( "PlayerSpawn", "HAB_Base_cPlayerSpawn", function( ply )

		net.Start( "HAB_Base_PlayerSpawn_c" )

			net.WriteEntity( ply )

		net.Broadcast( )

	end )

end
--[[
hab.hook( "EntityNetworkedVarChanged", "HAB_Base_EntityNetworkedVarChanged", function( ent, name, old, new )

	hook.Run( "On_" .. name .. "_Changed", ent, old, new )

end )
]]
hab.hook( "PlayerFootstep", "HAB_Base_PlayerFootstep", function( ply, pos, foot, sound, volume, filter )

	if IsValid( ply ) and ( ( hab.cval.Base.Footstep_Suppress_Crouched > 0 and ply:Crouching( ) ) or ply:GetMaxSpeed( ) < hab.cval.Base.Footstep_Min_Speed ) then

		return true

	end

end )
