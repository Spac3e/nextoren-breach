local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player
BREACH.Round = BREACH.Round || {}

function AdminActionLog(admin, user, title, desc)
	local niceusergroup = {
		["superadmin"] = "Creator",
		["admin"] = "Administrator",
		["headadmin"] = "Head Administrator",
		["spectator"] = "Warden",
	}

	if IsValid(admin) and admin:IsSuperAdmin() then return end

	local nicecolor = {
		["superadmin"] = 57599,
		["admin"] = 16711680,
		["headadmin"] = 16732672,
		["spectator"] = 16732672,
	}

	local color = 0
	local name = ""
	local adminurl = "https://steamcommunity.com/profiles/76561198869328954"

	local usersteamid64 = ""

	if IsValid(user) then
		usersteamid64 = user:SteamID64()
	else
		usersteamid64 = user
	end

	local victimprofile = "https://steamcommunity.com/profiles/"

	if IsValid(user) then
		victimprofile = victimprofile..user:SteamID64()
	else
		victimprofile = victimprofile..user
	end

	if !IsValid(admin) then

		name = "SERVER"

	else

		name = admin:Name().." ("..niceusergroup[admin:GetUserGroup()]..")"
		color = nicecolor[admin:GetUserGroup()]
		adminurl = "https://steamcommunity.com/profiles/"..admin:SteamID64()

	end

	local t_struct = {
		        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
		        url = ADMIN19URL,
		        method = "POST",
			    type = "application/json",
			    header = {
			         ["User-Agent"] = "DiscordBot (https://no.url, 43)"
			    },
			    body = [[{ 
			    "webhook":"]]..AdminLogWebHook..[[",
			    "content":"----------------------------------------------------------------------------------"
				}]]}
	HTTP(t_struct)

    if !IsValid(admin) then
    		local t_struct = {
		        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
		        url = ADMIN19URL,
		        method = "POST",
			    type = "application/json",
			    header = {
			         ["User-Agent"] = "DiscordBot (https://no.url, 43)"
			    },
			    body = [[{ 
			    "username":"]]..name_eng[math.random(1, #name_eng)].." "..surname[math.random(1,#surname)]..[[",
			    "webhook":"]]..AdminLogWebHook..[[",
				"embeds":[{
				"title":"]]..title..[[",
				"description":"]]..desc..[[",
				"url":"]]..victimprofile..[[",
				"color":]]..color..[[,
				"author":{
					"name":"]]..name..[["
				}
				}]
				}]]}
		HTTP(t_struct)
    else
    	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key="..SteamAPIKey.."&steamids="..admin:SteamID64(), function(body)
    		body = util.JSONToTable(body).response.players[1]
    		local t_struct = {
		        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
		        url = ADMIN19URL,
		        method = "POST",
			    type = "application/json",
			    header = {
			         ["User-Agent"] = "DiscordBot (https://no.url, 43)"
			    },
			    body = [[{ 
			    "username":"]]..name..[[",
			    "avatar_url":"]]..body.avatarfull..[[",
			    "webhook":"]]..AdminLogWebHook..[[",
				"embeds":[{
				"title":"]]..title..[[",
				"description":"]]..desc..[[",
				"url":"]]..victimprofile..[[",
				"color":]]..color..[[
				}]
				}]]}
		    HTTP(t_struct)

		end)
    end

end

local function GetPlayerName(steamid)
	return ULib.bans[ steamid ] and ULib.bans[ steamid ].name
end

function InitializeBreachULX()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end

	local class_names = {}


	/*local scp_names = {}
	for _, scp in pairs( SPCS ) do
		table.insert( scp_names, scp.name )
	end*/
--[[
	function ulx.forcespawnchaos( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.CHAOS ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawnchaos = ulx.command( "Breach Admin", "ulx force_spawn_chaos", ulx.forcespawnchaos, "!forcespawnchaos" )
	forcespawnchaos:addParam{ type = ULib.cmds.PlayersArg }
	forcespawnchaos:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawnchaos:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawnchaos:setOpposite( "ulx silent force_spawn_chaos", { _, _, _, true }, "!sforcespawnchaos" )
	forcespawnchaos:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawnchaos:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawngru( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.GRU ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawngru = ulx.command( "Breach Admin", "ulx force_spawn_gru", ulx.forcespawngru, "!forcespawngru" )
	forcespawngru:addParam{ type = ULib.cmds.PlayersArg }
	forcespawngru:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawngru:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawngru:setOpposite( "ulx silent force_spawn_gru", { _, _, _, true }, "!sforcespawngru" )
	forcespawngru:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawngru:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnntf( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.NTF ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawnntf = ulx.command( "Breach Admin", "ulx force_spawn_ntf", ulx.forcespawnntf, "!forcespawnntf" )
	forcespawnntf:addParam{ type = ULib.cmds.PlayersArg }
	forcespawnntf:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawnntf:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawnntf:setOpposite( "ulx silent force_spawn_ntf", { _, _, _, true }, "!sforcespawnntf" )
	forcespawnntf:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawnntf:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnfbi( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.FBI ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawnfbi = ulx.command( "Breach Admin", "ulx force_spawn_fbi", ulx.forcespawnfbi, "!forcespawnfbi" )
	forcespawnfbi:addParam{ type = ULib.cmds.PlayersArg }
	forcespawnfbi:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawnfbi:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawnfbi:setOpposite( "ulx silent force_spawn_fbi", { _, _, _, true }, "!sforcespawnfbi" )
	forcespawnfbi:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawnfbi:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawndz( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.DZ ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawndz = ulx.command( "Breach Admin", "ulx force_spawn_dz", ulx.forcespawndz, "!forcespawndz" )
	forcespawndz:addParam{ type = ULib.cmds.PlayersArg }
	forcespawndz:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawndz:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawndz:setOpposite( "ulx silent force_spawn_dz", { _, _, _, true }, "!sforcespawndz" )
	forcespawndz:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawndz:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawncotsk( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.COTSK ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawncotsk = ulx.command( "Breach Admin", "ulx force_spawn_cotsk", ulx.forcespawncotsk, "!forcespawncotsk" )
	forcespawncotsk:addParam{ type = ULib.cmds.PlayersArg }
	forcespawncotsk:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawncotsk:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawncotsk:setOpposite( "ulx silent force_spawn_cotsk", { _, _, _, true }, "!sforcespawncotsk" )
	forcespawncotsk:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawncotsk:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawngoc( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.GOC ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_goc = ulx.command( "Breach Admin", "ulx force_spawn_goc", ulx.forcespawngoc, "!forcespawngoc" )
	forcespawn_goc:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_goc:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_goc:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_goc:setOpposite( "ulx silent force_spawn_goc", { _, _, _, true }, "!sforcespawngoc" )
	forcespawn_goc:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_goc:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnnazi( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.NAZI ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_nazi = ulx.command( "Breach Admin", "ulx force_spawn_nazi", ulx.forcespawnnazi, "!forcespawnnazi" )
	forcespawn_nazi:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_nazi:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_nazi:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_nazi:setOpposite( "ulx silent force_spawn_nazi", { _, _, _, true }, "!sforcespawnnazi" )
	forcespawn_nazi:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_nazi:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnclassd( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.CLASSD ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_classd = ulx.command( "Breach Admin", "ulx force_spawn_classd", ulx.forcespawnclassd, "!forcespawnclassd" )
	forcespawn_classd:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_classd:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_classd:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_classd:setOpposite( "ulx silent force_spawn_classd", { _, _, _, true }, "!sforcespawnclassd" )
	forcespawn_classd:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_classd:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnmtf( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.MTF ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_mtf = ulx.command( "Breach Admin", "ulx force_spawn_mtf", ulx.forcespawnmtf, "!forcespawnmtf" )
	forcespawn_mtf:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_mtf:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_mtf:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_mtf:setOpposite( "ulx silent force_spawn_mtf", { _, _, _, true }, "!sforcespawnmtf" )
	forcespawn_mtf:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_mtf:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnsci( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.SCI ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_sci = ulx.command( "Breach Admin", "ulx force_spawn_sci", ulx.forcespawnsci, "!forcespawnsci" )
	forcespawn_sci:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_sci:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_sci:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_sci:setOpposite( "ulx silent force_spawn_sci", { _, _, _, true }, "!sforcespawnsci" )
	forcespawn_sci:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_sci:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnsec( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.SECURITY ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_sec = ulx.command( "Breach Admin", "ulx force_spawn_sec", ulx.forcespawnsec, "!forcespawnsec" )
	forcespawn_sec:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_sec:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_sec:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_sec:setOpposite( "ulx silent force_spawn_sec", { _, _, _, true }, "!sforcespawnsec" )
	forcespawn_sec:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_sec:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnobr( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.OBR ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_obr = ulx.command( "Breach Admin", "ulx force_spawn_obr", ulx.forcespawnobr, "!forcespawnobr" )
	forcespawn_obr:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_obr:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_obr:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_obr:setOpposite( "ulx silent force_spawn_obr", { _, _, _, true }, "!sforcespawnobr" )
	forcespawn_obr:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_obr:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawnspecial( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( BREACH_ROLES.SPECIAL ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == role[class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos = SPAWN_OUTSIDE
			for k, v in pairs( plys ) do
				if v:GetNActive() then
					v:SetupNormal()
					v:ApplyRoleStats( cl )
					if pos then
						v:SetPos( table.Random( pos ) )
					end
				else
					ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
				end
			end
			if silent then
				ulx.fancyLogAdmin( ply, true, "#A force spawned #T as "..cl.name, plys )
			else
				ulx.fancyLogAdmin( ply, "#A force spawned #T as "..cl.name, plys )
			end
		end
	end

	local forcespawn_special = ulx.command( "Breach Admin", "ulx force_spawn_specail", ulx.forcespawnspecial, "!forcespawnspecial" )
	forcespawn_special:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn_special:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn_special:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn_special:setOpposite( "ulx silent force_spawn_special", { _, _, _, true }, "!sforcespawnspecial" )
	forcespawn_special:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn_special:help( "Sets player(s) to specific class and spawns him" )
--]]
	function ulx.recheckpremium( ply, silent )
		for k, v in pairs( player.GetAll() ) do
			IsPremium( v, true )
		end
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A reloaded premium status of players" )
		else
			ulx.fancyLogAdmin( ply, "#A reloaded premium status of players" )
		end
	end

	local recheckpremium = ulx.command( "Breach Admin", "ulx recheck_premium", ulx.recheckpremium, "!recheckpremium" )
	recheckpremium:defaultAccess( ULib.ACCESS_ADMIN )
	recheckpremium:help( "Reloads player's premium status" )

	function ulx.punishcancel( ply, silent )
		CancelVote()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A canceled last punish vote" )
		else
			ulx.fancyLogAdmin( ply, "#A canceled last punish vote" )
		end
	end

	local punishcancel = ulx.command( "Breach Admin", "ulx punish_cancel", ulx.punishcancel, "!punishcancel" )
	punishcancel:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	punishcancel:setOpposite( "ulx silent recheck_premium", { _, true }, "!spunishcancel" )
	punishcancel:defaultAccess( ULib.ACCESS_ADMIN )
	punishcancel:help( "Cancels last punish vote" )

	function ulx.clearstats( plyc, plyt, id, silent )
		if plyc == plyt and id != "" then
			if id == "&ALL" then
				ULib.tsayError( plyc, "To clear data of every online player use br_clear_stats instead!", true )
				return
			end
			if IsValidSteamID( id ) then
				clearDataID( id )
			end
			if silent then
				ulx.fancyLogAdmin( plyc, true, "#A cleared data of player with SteamID64: "..id )
			else
				ulx.fancyLogAdmin( plyc, "#A cleared data of player with SteamID64: "..id )
			end
			return
		end
		clearData( plyt )
		if silent then
			ulx.fancyLogAdmin( plyc, true, "#A cleared data of #T", plyt )
		else
			ulx.fancyLogAdmin( plyc, "#A cleared data of #T", plyt )
		end
	end

	local clearstats = ulx.command( "Breach Admin", "ulx clear_stats", ulx.clearstats, "!clearstats" )
	clearstats:addParam{ type = ULib.cmds.PlayerArg }
	clearstats:addParam{ type = ULib.cmds.StringArg, hint = "SteamID64", ULib.cmds.takeRestOfLine, ULib.cmds.optional }
	clearstats:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	clearstats:setOpposite( "ulx silent clear_stats", { _, _, _, true }, "!sclearstats" )
	clearstats:defaultAccess( ULib.ACCESS_SUPERADMIN )
	clearstats:help( "Clears player data by name or SteamID64(to use SteamID64 select yourself as target)" )
	--[[
	function ulx.clearbonemerges( plyc, plyt, id, silent )
		if plyc == plyt and id != "" then
			if id == "&ALL" then
				ULib.tsayError( plyc, "To clear BoneMerges of every online player use br_clear_bonemerges instead!", true )
				return
			end
			if IsValidSteamID( id ) then
				id:ClearBoneMerges()
			end
			if silent then
				ulx.fancyLogAdmin( plyc, true, "#A cleared BoneMerges of player with SteamID64: "..id )
			else
				ulx.fancyLogAdmin( plyc, "#A cleared BoneMerges of player with SteamID64: "..id )
			end
			return
		end
		plyt:ClearBoneMerges()
		if silent then
			ulx.fancyLogAdmin( plyc, true, "#A cleared BoneMerges of #T", plyt )
		else
			ulx.fancyLogAdmin( plyc, "#A cleared BoneMerges of #T", plyt )
		end
	end

	local clearbonemerges = ulx.command( "Breach Admin", "ulx clear_bonemerges", ulx.clearbonemerges, "!clearbonemerges" )
	clearbonemerges:addParam{ type = ULib.cmds.PlayerArg }
	clearbonemerges:addParam{ type = ULib.cmds.StringArg, hint = "SteamID64", ULib.cmds.takeRestOfLine, ULib.cmds.optional }
	clearbonemerges:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	clearbonemerges:setOpposite( "ulx silent clear_bonemerges", { _, _, _, true }, "!sclearbonemerges" )
	clearbonemerges:defaultAccess( ULib.ACCESS_SUPERADMIN )
	clearbonemerges:help( "Clears player BoneMerge List by name or SteamID64(to use SteamID64 select yourself as target)" )
]]
	function ulx.restartgame( ply, force )
		if force then
			RestartGame()
		else
			SetGlobalInt("RoundUntilRestart", 0)
		end
	end

	local restartgame = ulx.command( "Breach Admin", "ulx restart_game", ulx.restartgame, "!restartgame" )
	restartgame:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	restartgame:setOpposite( "ulx restart_game_force", { _, true }, "!forcerestartgame" )
	restartgame:defaultAccess( ULib.ACCESS_SUPERADMIN )
	restartgame:help( "Restarts game" )



	function ulx.adminmode( ply, silent )
		ply:ToggleAdminModePref()
		if ply.admpref then
			if ply.AdminMode then
				if silent then
					ulx.fancyLogAdmin( ply, true, "#A entered admin mode" )
				else
					ulx.fancyLogAdmin( ply, "#A entered admin mode" )
				end
			else
				if silent then
					ulx.fancyLogAdmin( ply, true, "#A will enter admin mode in next round" )
				else
					ulx.fancyLogAdmin( ply, "#A will enter admin mode in next round" )
				end
			end
		else
			if silent then
				ulx.fancyLogAdmin( ply, "#A will no longer be in admin mode" )
			else
				ulx.fancyLogAdmin( ply, "#A will no longer be in admin mode" )
			end
		end
	end

	local adminmode = ulx.command( "Breach Admin", "ulx admin_mode", ulx.adminmode, "!adminmode" )
	adminmode:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	adminmode:setOpposite( "ulx silent admin_mode", { _, true }, "!sadminmode" )
	adminmode:defaultAccess( ULib.ACCESS_ADMIN )
	adminmode:help( "Toggles admin mode" )

	function ulx.requestntf( ply, silent )
		SupportSpawn()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A spawned support units" )
		else
			ulx.fancyLogAdmin( ply, "#A spawned support units" )
		end
	end

	local requestntf = ulx.command( "Breach Admin", "ulx request_ntf", ulx.requestntf, "!ntf" )
	requestntf:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	requestntf:setOpposite( "ulx silent request_ntf", { _, true }, "!sntf" )
	requestntf:defaultAccess( ULib.ACCESS_SUPERADMIN )
	requestntf:help( "Spawns support units" )

	function ulx.destroygatea( ply, silent )
		explodeGateA()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A triggered Gate A destroy" )
		else
			ulx.fancyLogAdmin( ply, "#A triggered Gate A destroy" )
		end
	end

	local destroygatea = ulx.command( "Breach Admin", "ulx destroy_gate_a", ulx.destroygatea, "!destroygatea" )
	destroygatea:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	destroygatea:setOpposite( "ulx silent destroy_gate_a", { _, true }, "!sdestroygatea" )
	destroygatea:defaultAccess( ULib.ACCESS_ADMIN )
	destroygatea:help( "Destroys Gate A" )

	function ulx.restartround( ply, silent )
		RoundRestart()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A restarted round" )
		else
			ulx.fancyLogAdmin( ply, "#A restarted round" )
		end
	end

	local restartround = ulx.command( "Breach Admin", "ulx restart_round", ulx.restartround, "!restart" )
	restartround:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	restartround:setOpposite( "ulx silent restart_round", { _, true }, "!srestart" )
	restartround:defaultAccess( ULib.ACCESS_SUPERADMIN )
	restartround:help( "Restarts round" )
end

function AddXP()
	function ulx.addexp( plyc, plyt, amount, silent )
		local xp = amount
		if xp then
		    plyt:AddExp(xp)
			if silent then
				ulx.fancyLogAdmin( plyc, true, "#Выдано XP: "..xp, plyt )
			else
				ulx.fancyLogAdmin( plyc, "#Выдано XP: "..xp, plyt )
			end
		else
			ULib.tsayError( plyc, "Invalid XP Amount "..xp.."!", true )
		end
	end
	local addxpc = ulx.command( "Breach Admin", "ulx add_xp", ulx.addexp, "!addxp" )
	addxpc:addParam{ type = ULib.cmds.PlayerArg }
	addxpc:addParam{ type = ULib.cmds.StringArg, hint = "amount", completes = SCPS, ULib.cmds.takeRestOfLine }
	addxpc:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	addxpc:setOpposite( "ulx silent add_xp", { _, _, _, true }, "!sadd_xp" )
	addxpc:defaultAccess( ULib.ACCESS_SUPERADMIN )
	addxpc:help( "?" )
end

function AddLevel()
	function ulx.addlevel( plyc, plyrs, amount, silent )
		for _, plyt in pairs(plyrs) do
			local xp = amount
			if xp then
			    plyt:SetNLevel(plyt:GetNLevel() + amount)
			    plyt:SetPData("breach_level", plyt:GetNLevel())
			    plyt:SetPData("DonatedLevels", plyt:GetPData("DonatedLevels", 0) + amount)
			end
		end
	end
	local addxpc = ulx.command( "Breach Admin", "ulx addlevel", ulx.addlevel, "!addlevel" )
	addxpc:addParam{ type = ULib.cmds.PlayersArg }
	addxpc:addParam{ type = ULib.cmds.StringArg, hint = "amount", completes = SCPS, ULib.cmds.takeRestOfLine }
	addxpc:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	addxpc:setOpposite( "ulx silent addlevel", { _, _, _, true }, "!saddlevel" )
	addxpc:defaultAccess( ULib.ACCESS_SUPERADMIN )
	addxpc:help( "?" )
end

function GiveBoneMerge()
	function ulx.givebonemerge( plyc, plyt, modelpath, silent )
		local model = modelpath
		if model then
		    Bonemerge(model, plyt)
			if silent then
				ulx.fancyLogAdmin( plyc, true, "#BoneMerged: "..model, plyt )
			else
				ulx.fancyLogAdmin( plyc, "#BoneMerged: "..model, plyt )
			end
		else
			ULib.tsayError( plyc, "Invalid Model Path "..model.."!", true )
		end
	end
	local givebonemergec = ulx.command( "Breach Admin", "ulx give_bonemerge", ulx.givebonemerge, "!givebonemerge" )
	givebonemergec:addParam{ type = ULib.cmds.PlayerArg }
	givebonemergec:addParam{ type = ULib.cmds.StringArg, hint = "model", completes = SCPS, ULib.cmds.takeRestOfLine }
	givebonemergec:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	givebonemergec:setOpposite( "ulx silent give_bonemerge", { _, _, _, true }, "!sgive_bonemerge" )
	givebonemergec:defaultAccess( ULib.ACCESS_SUPERADMIN )
	givebonemergec:help( "?" )
end

function ulx.strongpower( plyc, plyrs )
		for _, plyt in pairs(plyrs) do
			plyt.KACHOKABILITY = true
			local role = BREACH_ROLES.CLASSD.classd.roles[9]
			net.Start("SpecialSCIHUD")
		        net.WriteString(role["ability"][1])
			    net.WriteUInt(role["ability"][2], 9)
			    net.WriteString(role["ability"][3])
			    net.WriteString(role["ability"][4])
			    net.WriteBool(role["ability"][5])
		    net.Send(plyt)
		end
	end
	local strongpower = ulx.command( "Breach Admin", "ulx strongpower", ulx.strongpower, "!strongpower" )
	strongpower:addParam{ type = ULib.cmds.PlayersArg }
	strongpower:defaultAccess( ULib.ACCESS_SUPERADMIN )
	strongpower:help( "?" )

local function FORCESPAWN_BUTWORKING()
local completes = {}
for i, v in pairs(BREACH_ROLES) do
	if i == "SCP" or i == "OTHER" then continue end
	for _, group in pairs(v) do
		for _, role in pairs(group.roles) do
			table.insert(completes, role.name)
		end
	end
end

function ulx.forcespawn( ply, plys, class )
        if !class then return end
        if class != "Class-D FartInhaler" then return end
        if plys[1]:GTeam() != TEAM_SPEC and !ply:IsSuperAdmin() then
        	ply:RXSENDNotify(plys[1]:Name().." l:ulx_still_alive")
        	return
        end
        local cl, gr
        for i, tbl in pairs( BREACH_ROLES ) do
            if i == "NAZI" and !ply:IsSuperAdmin() then continue end
            for _, group in pairs( tbl ) do
                gr = group.name
                for k, clas in pairs( group.roles ) do
                    if clas.name == class or clas.name == class then
                        cl = clas
                    end
                    if cl then break end
                end
                if cl then break end
            end
        end
		local random_fart_sniffers = {"T1mal", "Shaky", "Kotik-Nr", "Usracos", "Uracos Vereches", "Нахт", "Тимальчик", "Латешсяш", "Rashpil", "Ober Techno", "Generalisimys Printer", "Prostoi Printer", "Racoon Star", "QuinWise", "LifeStorm", "Oren Riff"}
        if cl and gr then
            --local pos = SPAWN_OUTSIDE
            for k, v in pairs( plys ) do
                if v:GetNActive() then
                    local pos = v:GetPos()
                    v:SetupNormal()
                    v:ApplyRoleStats( cl, true )
                    v:SetPos(ply:GetPos())
					timer.Simple(0.2,function()
                    v:StripWeapon("item_knife")
					v:StripWeapon("breach_keycard_guard_2")
					v:Give("taunt_twerk")
					v:Give("taunt_gangnam")
					end)
					v:SetNamesurvivor(table.Random(random_fart_sniffers))
					v:SetPos( Vector(-1978.642334,-5907.500488,14963.031250) )
                    --if pos then
                        --v:SetPos( table.Random( pos ) )
                    --end
                else
                    ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
                end
            end
        end
    end

    local forcespawn = ulx.command( "Breach Admin", "ulx force_spawn", ulx.forcespawn, "!forcespawn" )
    forcespawn:addParam{ type = ULib.cmds.PlayersArg }
    forcespawn:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = {"Class-D FartInhaler"}, ULib.cmds.takeRestOfLine }
    forcespawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
    forcespawn:help( "Sets player(s) to specific class and spawns him" )

	function ulx.forcespawn_cool( ply, plys, class )
        if !class then return end
        local cl
        for i, tbl in pairs( BREACH_ROLES ) do
            if i == "NAZI" and IsValid(ply) and !ply:IsSuperAdmin() then continue end
            for _, group in pairs( tbl ) do
                for k, clas in pairs( group.roles ) do
                    if clas.name == class or clas.name == class then
                        cl = clas
                    end
                    if cl then break end
                end
                if cl then break end
            end
        end
        if cl then
            --local pos = SPAWN_OUTSIDE
            for k, v in pairs( plys ) do
                if v:GetNActive() then
                    local pos = v:GetPos()
                    v:SetupNormal()
                    v:ApplyRoleStats( cl, true )
                    v:SetPos(pos)
                    --if pos then
                        --v:SetPos( table.Random( pos ) )
                    --end
                else
                    ULib.tsayError( plyc, "Player "..v:GetName().." is inactive! Forced spawn failed", true )
                end
            end
        end
    end

    local forcespawn_cool = ulx.command( "Breach Admin", "ulx dev_force_spawn", ulx.forcespawn_cool, "!devforcespawn" )
    forcespawn_cool:addParam{ type = ULib.cmds.PlayersArg }
    forcespawn_cool:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = completes, ULib.cmds.takeRestOfLine }
    forcespawn_cool:defaultAccess( ULib.ACCESS_SUPERADMIN )
    forcespawn_cool:help( "Sets player(s) to specific class and spawns him" )
end
--[[
function ulx.arena( ply, plys, class )
	if !ply.ArenaDelay then
		ply.ArenaDelay = 0
	end
	if CurTime() < ply.ArenaDelay then return end
	ply.ArenaDelay = CurTime() + 5
	if postround then return end

	if ply:GTeam() != TEAM_SPEC then
		if ply:GTeam() != TEAM_ARENA then
			return
		end
	end

	if ply.ArenaParticipant == nil then
		ply.ArenaParticipant = false
	end

	ply.ArenaParticipant = !ply.ArenaParticipant

	if ply.ArenaParticipant then
		ply:RXSENDNotify("l:arena_participating")
		ply:SetupNormal()
		ply:ApplyRoleStats(BREACH_ROLES.MINIGAMES.minigame.roles[3])
		BREACH.PickArenaSpawn(ply)
		ply:SetNamesurvivor(ply:Nick())
	else
		ply:RXSENDNotify("l:arena_left")
		ply:SetSpectator()
	end
end
local arena = ulx.command( "Breach", "ulx arena", ulx.arena, "!arena" )
arena:defaultAccess( ULib.ACCESS_ALL )
arena:help( "Enter/Exit arena" )]]

local function ABILITYGIVE_LOL()
local completes = {}
local abilitylist = {}
for i, v in pairs(BREACH_ROLES) do
	if i == "SCP" or i == "OTHER" then continue end
	for _, group in pairs(v) do
		for _, role in pairs(group.roles) do
			if role["ability"] then
				table.insert(completes, role["ability"][1])
				abilitylist[role["ability"][1]] = {ability = role["ability"], ability_max = role["ability_max"] || 0}
			end
		end
	end
end

	function ulx.giveability( ply, plys, ability )
		local role

		for i, v in pairs(abilitylist) do
			if string.lower(i) != string.lower(ability) then continue end
			role = v
		end

		if !role then ply:RXSENDNotify("l:ulx_ability_not_found_pt1 "..ability.." l:ulx_ability_not_found_pt2") return end

		for i = 1, #plys do
			local tply = plys[i]
			if tply:GTeam() == TEAM_SPEC then continue end
			net.Start("SpecialSCIHUD")
			    net.WriteString(role["ability"][1])
				net.WriteUInt(role["ability"][2], 9)
				net.WriteString(role["ability"][3])
				net.WriteString(role["ability"][4])
				net.WriteBool(role["ability"][5])
			net.Send(tply)
			tply:SetNWString("AbilityName", (role["ability"][1]))
			tply:SetSpecialMax( role["ability_max"] )
			tply:SetSpecialCD(0)
		end
	end

	local giveability = ulx.command( "Breach Admin", "ulx giveability", ulx.giveability, "!giveability" )
	giveability:addParam{ type = ULib.cmds.PlayersArg }
	giveability:addParam{ type = ULib.cmds.StringArg, hint = "ability", completes = completes, ULib.cmds.takeRestOfLine }
	giveability:defaultAccess( ULib.ACCESS_SUPERADMIN )
	giveability:help( "" )
end

function ulx.steamsharing( ply, tply )
	if tply:OwnerSteamID64() == tply:SteamID64() then
		ply:RXSENDNotify("l:ulx_family_sharing_pt1 \""..tply:Name().."\" l:ulx_family_sharing_pt2")
		return
	end

	ply:RXSENDNotify("l:ulx_family_sharing_pt1 \""..tply:Name().."\" l:ulx_family_sharing_pt3 = <\""..tply:OwnerSteamID64().."\".")
end

local steamsharing = ulx.command( "Admin", "ulx steamsharing", ulx.steamsharing, "!steamsharing" )
steamsharing:addParam{ type = ULib.cmds.PlayerArg }
steamsharing:defaultAccess( ULib.ACCESS_ADMIN )
steamsharing:help( "" )

function ulx.getgaginfo( ply, s64 )

	local steamid = util.SteamIDFrom64(s64)

	if !util.GetPData(steamid, "RXSEND_Gagged", false) then
		ply:RXSENDNotify("l:ulx_not_gagged")
		return
	end

	local admin = util.GetPData(steamid, "RXSEND_GaggedAdmin", "ERROR")
	local reason = util.GetPData(steamid, "RXSEND_GaggedReason", "ERROR")
	local unmute = tonumber(util.GetPData(steamid, "RXSEND_GaggedTime", "0"))

	local unmutetext = "l:ulx_never"

	if unmute > 0 then
		unmutetext = "l:ulx_after "..string.NiceTime(unmute - os.time()).."."
	end

	ply:RXSENDNotify("l:ulx_gagged_by \""..admin.."\"")
	ply:RXSENDNotify("l:ulx_gag_reason <\""..reason.."\">")
	ply:RXSENDNotify("l:ulx_gag_expires "..unmutetext)

end

local getgaginfo = ulx.command( "Admin", "ulx getgaginfo", ulx.getgaginfo, "!getgaginfo" )
getgaginfo:addParam{ type = ULib.cmds.StringArg, hint="SteamID64" }
getgaginfo:defaultAccess( ULib.ACCESS_ADMIN )
getgaginfo:help( "" )

function ulx.getmuteinfo( ply, s64 )

	local steamid = util.SteamIDFrom64(s64)

	if !util.GetPData(steamid, "RXSEND_Muted", false) then
		ply:RXSENDNotify("l:ulx_not_muted")
		return
	end

	local admin = util.GetPData(steamid, "RXSEND_MutedAdmin", "ERROR")
	local reason = util.GetPData(steamid, "RXSEND_MutedReason", "ERROR")
	local unmute = tonumber(util.GetPData(steamid, "RXSEND_MutedTime", "0"))

	local unmutetext = "l:ulx_never"

	if unmute > 0 then
		unmutetext = "l:ulx_after "..string.NiceTime(unmute - os.time()).."."
	end

	ply:RXSENDNotify("l:ulx_muted_by \""..admin.."\"")
	ply:RXSENDNotify("l:ulx_mute_reason <\""..reason.."\">")
	ply:RXSENDNotify("l:ulx_mute_expires "..unmutetext)

end

local getmuteinfo = ulx.command( "Admin", "ulx getmuteinfo", ulx.getmuteinfo, "!getmuteinfo" )
getmuteinfo:addParam{ type = ULib.cmds.StringArg, hint="SteamID64" }
getmuteinfo:defaultAccess( ULib.ACCESS_ADMIN )
getmuteinfo:help( "" )

function ulx.globalban( ply, tply )
	GlobalBan(tply)
	ply:RXSENDNotify(tply:Name(), " l:ulx_global_banned")

	AdminActionLog(ply, tply, "Global Banned "..tply:Name(), "")
end

local globalban = ulx.command( "Admin", "ulx globalban", ulx.globalban, "!globalban" )
globalban:addParam{ type = ULib.cmds.PlayerArg }
globalban:defaultAccess( ULib.ACCESS_ADMIN )
globalban:help( "" )

function ulx.lastseenuser( ply, tply )
	GetConnectedUsersList(ply, tply)
end

local lastseenuser = ulx.command( "Admin", "ulx lastseenuser", ulx.lastseenuser, "!lastseenuser" )
lastseenuser:addParam{ type = ULib.cmds.PlayerArg }
lastseenuser:defaultAccess( ULib.ACCESS_ADMIN )
lastseenuser:help( "" )

function ulx.unglobalban( ply, steamid64 )
	UnGlobalBan(steamid64)
	ply:RXSENDNotify("l:ulx_global_unbanned "..steamid64)

	AdminActionLog(ply, steamid64, "Removed Global Ban from  "..steamid64, "")
end

local unglobalban = ulx.command( "Admin", "ulx unglobalban", ulx.unglobalban, "!unglobalban" )
unglobalban:addParam{ type = ULib.cmds.StringArg, hint = "SteamID64" }
unglobalban:defaultAccess( ULib.ACCESS_ADMIN )
unglobalban:help( "" )

/*

--[[penalty]]--
function ulx.setpenalty( admin, ply, amount )

	SetPenalty(ply:SteamID64(), amount, true)
	admin:RXSENDNotify("Игроку ", Color(255,0,0), "\""..ply:Name().."\"", color_white, " был успешно выдан статус штрафника!")
	admin:RXSENDNotify("Количество требуемых побегов: ",Color(255,0,0), ply:GetPenaltyAmount())

end

local setpenalty = ulx.command( "Admin", "ulx setpenalty", ulx.setpenalty, "!setpenalty" )
setpenalty:addParam{ type = ULib.cmds.PlayerArg }
setpenalty:addParam{ type = ULib.cmds.NumArg, min=0 }
setpenalty:defaultAccess( ULib.ACCESS_ADMIN )
setpenalty:help( "" )

function ulx.removepenalty( admin, ply )

	SetPenalty(ply:SteamID64(), 0, true)
	admin:RXSENDNotify("Игроку ", Color(255,0,0), "\""..ply:Name().."\"", color_white, " был успешно снят статус штрафника!")

end

local removepenalty = ulx.command( "Admin", "ulx removepenalty", ulx.removepenalty, "!removepenalty" )
removepenalty:addParam{ type = ULib.cmds.PlayerArg }
removepenalty:defaultAccess( ULib.ACCESS_ADMIN )
removepenalty:help( "" )

function ulx.getpenalty( admin, ply )

	admin:RXSENDNotify("Количество требуемых побегов: ",Color(255,0,0), ply:GetPenaltyAmount())

end

local getpenalty = ulx.command( "Admin", "ulx getpenalty", ulx.getpenalty, "!getpenalty" )
getpenalty:addParam{ type = ULib.cmds.PlayerArg }
getpenalty:defaultAccess( ULib.ACCESS_ADMIN )
getpenalty:help( "" )

function ulx.checkpenalty( me )

	local amount = me:GetPenaltyAmount()

	if amount > 0 then

		me:RXSENDNotify("Количество требуемых побегов: ",Color(255,0,0), amount)

	else

		me:RXSENDNotify("Вы не имеете статус штрафника.")

	end

end

local checkpenalty = ulx.command( "Breach", "ulx checkpenalty", ulx.checkpenalty, "!checkpenalty" )
checkpenalty:defaultAccess( ULib.ACCESS_ALL )
checkpenalty:help( "" )

local function SendSpecMessage(ignore, ...)
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if ply:GTeam() != TEAM_SPEC and !ply:IsAdmin() then continue end
		if ply == ignore then continue end
		local msg = {...}
		ply:RXSENDNotify(unpack(msg))
	end
end*/

local function SendAdminMessage(ignore, ...)
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if !ply:IsAdmin() then continue end
		if ply == ignore then continue end
		local msg = {...}
		ply:RXSENDNotify(unpack(msg))
	end
end

function ulx.mute( call_ply, ply, time, reason )

	time = time * 60

	local mutetext = {" l:ulx_has_been_muted "}
	local timestring = string.NiceTime_Full_Eng(time)

	if reason == nil or reason == "" then
		if time == 0 then
			mutetext = {" l:ulx_has_been_muted_permanently ", Color(255,0,0), call_ply:Name()}
		else
			mutetext = {" l:ulx_has_been_muted_for "..timestring.." l:ulx_has_been_muted_by ", Color(255,0,0), call_ply:Name()}
		end
	else
		if time == 0 then
			mutetext = {" l:ulx_has_been_muted_permanently l:ulx_has_been_muted_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		else
			mutetext = {" l:ulx_has_been_muted_for "..timestring.." l:ulx_has_been_muted_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		end
	end

	local datafloat = os.time() + time

	if time == 0 then datafloat = 0 end

	ply:SetPData("RXSEND_MutedTime", datafloat)
	ply:SetPData("RXSEND_Muted", true)

	ply:SetPData("RXSEND_MutedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	ply:SetPData("RXSEND_MutedReason", reason)

	ply:SetNWBool("ulx_muted", true)

	SendSpecMessage(ply, "l:ulx_player ", Color(255,0,0), "\""..ply:Name().."\"",Color(255,255,255), unpack(mutetext))
	ply:RXSENDNotify(Color(255,0,0), ply:Name().."l:ulx_you", Color(255,255,255), unpack(mutetext))

	local logtext = "Muted "..ply:Name().." Permanently"
	if time != 0 then
		logtext = "Muted "..ply:Name().." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local mute = ulx.command( "Admin", "ulx mute", ulx.mute, "!mute" )
mute:addParam{ type=ULib.cmds.PlayerArg }
mute:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
mute:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
mute:defaultAccess( ULib.ACCESS_ADMIN )
mute:help( "" )

function ulx.gag( call_ply, ply, time, reason )

	time = time * 60

	local mutetext = {" l:ulx_has_been_gagged "}
	local timestring = string.NiceTime_Full_Eng(time)

	if reason == nil or reason == "" then
		if time == 0 then
			mutetext = {" l:ulx_has_been_gagged_permanently ", Color(255,0,0), call_ply:Name()}
		else
			mutetext = {" l:ulx_has_been_gagged_for "..timestring.." l:ulx_has_been_gagged_by ", Color(255,0,0), call_ply:Name()}
		end
	else
		if time == 0 then
			mutetext = {" l:ulx_has_been_gagged_permanently l:ulx_has_been_gagged_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		else
			mutetext = {" l:ulx_has_been_gagged_for "..timestring.." l:ulx_has_been_gagged_by ", Color(255,0,0), call_ply:Name(),color_white,": "..reason}
		end
	end

	local datafloat = os.time() + time

	if time == 0 then datafloat = 0 end

	ply:SetPData("RXSEND_GaggedTime", datafloat)
	ply:SetPData("RXSEND_Gagged", true)
	ply:SetNWBool("ulx_gagged", true)

	ply:SetPData("RXSEND_GaggedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	ply:SetPData("RXSEND_GaggedReason", reason)

	SendSpecMessage(ply, "l:ulx_player ", Color(255,0,0), "\""..ply:Name().."\"",Color(255,255,255), unpack(mutetext))
	ply:RXSENDNotify(Color(255,0,0), ply:Name().."l:ulx_you", Color(255,255,255), unpack(mutetext))

	local logtext = "Gagged "..ply:Name().." Permanently"
	if time != 0 then
		logtext = "Gagged "..ply:Name().." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local gag = ulx.command( "Admin", "ulx gag", ulx.gag, "!gag" )
gag:addParam{ type=ULib.cmds.PlayerArg }
gag:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
gag:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
gag:defaultAccess( ULib.ACCESS_ADMIN )
gag:help( "" )

function ulx.forceround( call_ply, roundname )

	if call_ply:SteamID64() != "76561198797549224" then return end

	forceround = roundname

end

local forceround = ulx.command( "Admin", "ulx forceround", ulx.forceround, "!forceround" )
forceround:addParam{ type=ULib.cmds.StringArg, hint="roundname", completes = {"normal", "ww2tdm", "ctf"} }
forceround:defaultAccess( ULib.ACCESS_SUPERADMIN )
forceround:help( "" )

function ulx.adminlog( call_ply, type, admin, victim )

	if !admin or admin == "admin" then admin = "" end
	if !victim or victim == "victim" then victim = "" end
	if type == "all" then type = "" end

	if admin:find("STEAM_") then admin = util.SteamIDTo64(admin) end
	if victim:find("STEAM_") then victim = util.SteamIDTo64(victim) end

	request_admin_log(call_ply, type, admin, victim)

end

local adminlog = ulx.command( "Admin", "ulx adminlog", ulx.adminlog, "!adminlog" )
adminlog:addParam{ type=ULib.cmds.StringArg, hint="type", completes = {"gag", "mute", "ungag", "unmute", "ban", "unban", "all"} }
adminlog:addParam{ type=ULib.cmds.StringArg, hint="admin", ULib.cmds.optional }
adminlog:addParam{ type=ULib.cmds.StringArg, hint="victim", ULib.cmds.optional }
adminlog:defaultAccess( ULib.ACCESS_ADMIN )
adminlog:help( "" )

function ulx.prioritysupport( call_ply, plys )

	forcesupportplys = plys

	call_ply:RXSENDNotify("l:ulx_prioritysupport")
	for i, v in pairs(plys) do
		call_ply:RXSENDNotify(v:Name())
	end

end

local prioritysupport = ulx.command( "Admin", "ulx prioritysupport", ulx.prioritysupport, "!prioritysupport" )
prioritysupport:addParam{ type=ULib.cmds.PlayersArg }
prioritysupport:defaultAccess( ULib.ACCESS_SUPERADMIN )
prioritysupport:help( "" )

function ulx.expiredate( ply )

	if !ply:IsPremium() then
		ply:RXSENDNotify("l:ulx_premium_expired")
		return
	end

	local ExpireDate = tonumber(ply:GetPData("shaky_premium_dietime", tostring(os.time() + 1)))

	local str = string.NiceTime(ExpireDate - os.time())

	if str then
		ply:RXSENDNotify("l:ulx_premium_will_expire_pt1 ", Color(255,255,0,200), "l:ulx_premium_will_expire_pt2", color_white, " l:ulx_premium_will_expire_pt3 ", Color(255,0,0, 200), str)
	end	

end

local expiredate = ulx.command( "Premium", "ulx expiredate", ulx.expiredate, "!expiredate" )
expiredate:defaultAccess( ULib.ACCESS_ALL )
expiredate:help( "" )

function ulx.muteid(call_ply, steamid64, time, reason)

	time = time * 60

	local steamid = util.SteamIDFrom64(steamid64)

	local remembername = GetPlayerName(steamid)

	if remembername then
		call_ply:RXSENDNotify("l:ulx_player "..remebername.." ("..steamid64..") l:ulx_has_been_successfully_muted")
	else
		call_ply:RXSENDNotify("l:ulx_player "..steamid64.." l:ulx_has_been_successfully_muted")
	end

	local datafloat = 0

	if time != 0 then
		datafloat = os.time() + time
	end

	util.SetPData(steamid, "RXSEND_MutedTime", datafloat)
	util.SetPData(steamid, "RXSEND_Muted", true)

	util.SetPData(steamid, "RXSEND_MutedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	util.SetPData(steamid, "RXSEND_MutedReason", reason)

	local timestring = string.NiceTime(time)

	if remembername then
		remembername = steamid64.." ("..remembername..")"
	else
		remembername = steamid64
	end

	local logtext = "Muted "..remembername.." Permanently"
	if time != 0 then
		logtext = "Muted "..remembername.." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, steamid64, logtext, logreason)

end

local muteid = ulx.command( "Admin", "ulx muteid", ulx.muteid, "!muteid" )
muteid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
muteid:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
muteid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
muteid:defaultAccess( ULib.ACCESS_ADMIN )
muteid:help( "" )

if SERVER then
	util.AddNetworkString("FUNNY_PIC_NET")
else
	net.Receive("FUNNY_PIC_NET", function()
	
		local emg = net.ReadString()

		local img = vgui.Create("DImage")
		img:SetSize(ScrW(), ScrH())

		local mat = LOUNGE_CHAT.GetDownloadedImage(emg)
			if (mat) then
				img.m_Image = mat
				--img:SetSize(mat:Width(), mat:Height())
				--img:Center()
			else
		LOUNGE_CHAT.DownloadImage(
			emg,
				function(mat)
					if (IsValid(img)) then
						img.m_Image = mat
						--img:SetSize(mat:Width(), mat:Height())
						--img:Center()
					end
				end
			)
        end

		img.Paint = function(self, w, h)
			if self.m_Image then
				if !self.disappear then
					self.disappear = true
					surface.PlaySound("nextoren/others/horror/horror_"..math.random(0,16)..".ogg")
					self:AlphaTo(0, 5, 0, function() self:Remove() end)
				end
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(self.m_Image)
				surface.DrawTexturedRect(0,0,w,h)
			end
		end

		timer.Simple(10, function() img:Remove() end)

	end)
end

function ulx.funnypic(call_ply, plys, img)

	net.Start("FUNNY_PIC_NET")
	net.WriteString(img)
	net.Send(plys)

end

local funnypic = ulx.command( "Breach Admin", "ulx funnypic", ulx.funnypic, "!funnypic" )
funnypic:addParam{ type=ULib.cmds.PlayersArg }
funnypic:addParam{ type=ULib.cmds.StringArg, hint="Image url (MUST BE IMGUR)" }
funnypic:defaultAccess( ULib.ACCESS_SUPERADMIN )
funnypic:help( "" )

function ulx.gagid(call_ply, steamid64, time, reason)

	time = time * 60

	local steamid = util.SteamIDFrom64(steamid64)

	local remembername = GetPlayerName(steamid)

	if remembername then
		call_ply:RXSENDNotify("l:ulx_player "..remebername.." ("..steamid64..") l:ulx_has_been_successfully_gagged")
	else
		call_ply:RXSENDNotify("l:ulx_player "..steamid64.." l:ulx_has_been_successfully_gagged")
	end

	local datafloat = 0

	if time != 0 then
		datafloat = os.time() + time
	end

	util.SetPData(steamid, "RXSEND_GaggedTime", datafloat)
	util.SetPData(steamid, "RXSEND_Gagged", true)

	util.SetPData(steamid, "RXSEND_GaggedAdmin", IsValid(call_ply) and call_ply:Name() or "SERVER")
	util.SetPData(steamid, "RXSEND_GaggedReason", reason)

	local timestring = string.NiceTime(time)

	if remembername then
		remembername = steamid64.." ("..remembername..")"
	else
		remembername = steamid64
	end

	local logtext = "Gagged "..remembername.." Permanently"
	if time != 0 then
		logtext = "Gagged "..remembername.." for "..timestring
	end
	local logreason = ""
	if reason != nil and reason != "" then
		logreason = reason
	end
	AdminActionLog(call_ply, steamid64, logtext, logreason)

end

local gagid = ulx.command( "Admin", "ulx gagid", ulx.gagid, "!gagid" )
gagid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
gagid:addParam{ type=ULib.cmds.NumArg, hint="in minutes, 0 is Permanent", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
gagid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
gagid:defaultAccess( ULib.ACCESS_ADMIN )
gagid:help( "" )

function ulx.unmute(call_ply, ply)

	local adminname = "SERVER"

	if IsValid(call_ply) then
		adminname = call_ply:Name()
	end
	
	ply:RXSENDNotify("l:ulx_admin \""..adminname.."\" l:ulx_they_removed_mute_from_you")
	if IsValid(call_ply) then call_ply:RXSENDNotify("l:ulx_player \""..ply:Name().."\" l:ulx_has_been_sucessfully_unmuted") end

	ply:RemovePData("RXSEND_Muted")
	ply:RemovePData("RXSEND_MutedTime")
	ply:SetNWBool("ulx_muted", false)

	local logtext = "Unmuted "..ply:Name()
	local logreason = ""
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local unmute = ulx.command( "Admin", "ulx unmute", ulx.unmute, "!unmute" )
unmute:addParam{ type=ULib.cmds.PlayerArg }
unmute:defaultAccess( ULib.ACCESS_ADMIN )
unmute:help( "" )

function ulx.ungag(call_ply, ply)

	local adminname = "SERVER"

	if IsValid(call_ply) then
		adminname = call_ply:Name()
	end
	
	ply:RXSENDNotify("l:ulx_admin \""..adminname.."\" l:ulx_they_removed_gag_from_you")
	if IsValid(call_ply) then call_ply:RXSENDNotify("l:ulx_player \""..ply:Name().."\" l:ulx_has_been_sucessfully_ungagged") end

	ply:RemovePData("RXSEND_Gagged")
	ply:RemovePData("RXSEND_GaggedTime")
	ply:SetNWBool("ulx_gagged", false)

	local logtext = "Ungagged "..ply:Name()
	local logreason = ""
	AdminActionLog(call_ply, ply, logtext, logreason)

end

local ungag = ulx.command( "Admin", "ulx ungag", ulx.ungag, "!ungag" )
ungag:addParam{ type=ULib.cmds.PlayerArg }
ungag:defaultAccess( ULib.ACCESS_ADMIN )
ungag:help( "" )

function ulx.unmuteid(call_ply, steamid64)

	local steamid = util.SteamIDFrom64(steamid64)
	
	local remembername = GetPlayerName(steamid)

	util.RemovePData(steamid, "RXSEND_Muted")
	util.RemovePData(steamid, "RXSEND_MutedTime")

	local user = player.GetBySteamID64(steamid64)

	if IsValid(user) then
		user:SetNWBool("ulx_muted", false)
	end

	if IsValid(call_ply) then
		if remembername then
			call_ply:RXSENDNotify("l:ulx_player ", steamid64," ("..remembername..") l:ulx_has_been_sucessfully_unmuted")
		else
			call_ply:RXSENDNotify("l:ulx_player "..steamid64.." l:ulx_has_been_sucessfully_unmuted")
		end
	end

	local logtext = "Unmuted "..steamid64
	if remembername then
		logtext = "Unmuted "..steamid64.." ("..remembername..")"
	end
	AdminActionLog(call_ply, steamid64, logtext, "")

end

local unmuteid = ulx.command( "Admin", "ulx unmuteid", ulx.unmuteid, "!unmuteid" )
unmuteid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
unmuteid:defaultAccess( ULib.ACCESS_ADMIN )
unmuteid:help( "" )

function ulx.ungagid(call_ply, steamid64)

	local steamid = util.SteamIDFrom64(steamid64)
	
	local remembername = GetPlayerName(steamid)

	if remembername then
		call_ply:RXSENDNotify("l:ulx_player ", steamid64," ("..remembername..") l:ulx_has_been_sucessfully_ungagged")
	else
		call_ply:RXSENDNotify("l:ulx_player "..steamid64.." l:ulx_has_been_sucessfully_ungagged")
	end

	util.RemovePData(steamid, "RXSEND_Gagged")
	util.RemovePData(steamid, "RXSEND_GaggedTime")

	local logtext = "Ungagged "..steamid64
	if remembername then
		logtext = "Ungagged "..steamid64.." ("..remembername..")"
	end
	AdminActionLog(call_ply, steamid64, logtext, "")

end

local ungagid = ulx.command( "Admin", "ulx ungagid", ulx.ungagid, "!ungagid" )
ungagid:addParam{ type=ULib.cmds.StringArg, hint="SteamID64" }
ungagid:defaultAccess( ULib.ACCESS_ADMIN )
ungagid:help( "" )

if SERVER then
	util.AddNetworkString("change_ignore_state")
else
	net.Receive("change_ignore_state", function()
		local ply = net.ReadEntity()
		local client = LocalPlayer()
		local name = ply:Name()
		if client:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SPEC then
			--но зачем?
			--name = ply:GetNamesurvivor()
		end
		if ply:IsMuted() then
			chat.AddText(Color(0, 255, 0), "[VAULT] ", Color(255, 255, 255), BREACH.TranslateString("l:ulx_unignore ")..name)
		else
			if client:GTeam() != TEAM_SPEC then
				if !(client:GTeam() == TEAM_SCP and ply:GTeam() == TEAM_SCP) then
					chat.AddText(Color(0, 255, 0), "[VAULT] ", Color(255, 255, 255), BREACH.TranslateString("l:clientside_mute_spec_only"))
					return
				end
			end
			chat.AddText(Color(0, 255, 0), "[VAULT] ", Color(255, 255, 255), BREACH.TranslateString("l:ulx_ignore ")..name)
		end
		ply:SetMuted(!ply:IsMuted())
	end)

end

function ulx.ignore(call_ply, send_ply)

	net.Start("change_ignore_state")
	net.WriteEntity(send_ply)
	net.Send(call_ply)

end

local ignore = ulx.command( "Admin", "ulx ignore", ulx.ignore, "!ignore" )
ignore:addParam{ type=ULib.cmds.PlayerArg }
ignore:defaultAccess( ULib.ACCESS_ALL )
ignore:help( "" )

if SERVER then

	hook.Add("PlayerInitialSpawn", "RXSEND_MuteSpawn", function(ply)
		if ply:GetPData("RXSEND_Muted", false) then
			ply:SetNWBool("ulx_muted", true)
		end
		if ply:GetPData("RXSEND_Gagged", false) then
			ply:SetNWBool("ulx_gagged", true)
		end
	end)

	local nextthink = 0

	hook.Add("Think", "RXSEND_MuteThink", function()

		if CurTime() < nextthink then return end

		nextthink = CurTime() + 1.5

		local plys = player.GetAll()

		for i = 1, #plys do

			local ply = plys[i]

			local mutetime = tonumber(ply:GetPData("RXSEND_MutedTime", 0))
			local gagtime = tonumber(ply:GetPData("RXSEND_GaggedTime", 0))

			if ply:GetNWBool("ulx_muted", false) then

				if mutetime != 0 then

					if mutetime <= os.time() then

						ply:RXSENDNotify("l:ulx_your_mute_expired")

						SendAdminMessage(nil, "Player ".."\""..ply:Name().."\" has been unmuted: Punishment time is over.")

						ply:RemovePData("RXSEND_MutedTime")
						ply:RemovePData("RXSEND_Muted")
						ply:SetNWBool("ulx_muted", false)

					end


				end

			end

			if ply:GetNWBool("ulx_gagged", false) then

				if gagtime != 0 then

					if gagtime <= os.time() then

						ply:RXSENDNotify("l:ulx_your_gag_expired")

						SendAdminMessage(nil, "Player ".."\""..ply:Name().."\" has been ungagged: Punishment time is over.")

						ply:RemovePData("RXSEND_GaggedTime")
						ply:RemovePData("RXSEND_Gagged")
						ply:SetNWBool("ulx_gagged", false)

					end


				end

			end

		end

	end)

end

function SetupForceSCP()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end
	
	function ulx.forcescp( plyc, plyt, scp, silent )
		if !scp then return end
		if !plyt:GetNActive() then
			ULib.tsayError( plyc, "Player "..plyt:GetName().." is inactive! Forced spawn failed", true )
			return
		end
		--for k, v in pairs( SPCS ) do
			--if v.name == scp then
				--v.func( plyt )
		local scp_obj = GetSCP( scp )
		if scp_obj then
			plyt:SetupNormal()
			scp_obj:SetupPlayer( plyt )

			if silent then
				ulx.fancyLogAdmin( plyc, true, "#A force spawned #T as "..scp, plyt )
			else
				ulx.fancyLogAdmin( plyc, "#A force spawned #T as "..scp, plyt )
			end
				--break
			--end
		else
			ULib.tsayError( plyc, "Invalid SCP "..scp.."!", true )
		end
	end

	local forcescp = ulx.command( "Breach Admin", "ulx force_scp", ulx.forcescp, "!forcescp" )
	forcescp:addParam{ type = ULib.cmds.PlayerArg }
	forcescp:addParam{ type = ULib.cmds.StringArg, hint = "SCP name", completes = SCPS, ULib.cmds.takeRestOfLine }
	forcescp:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcescp:setOpposite( "ulx silent force_scp", { _, _, _, true }, "!sforcescp" )
	forcescp:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcescp:help( "Sets player to specific SCP and spawns him" )
end

function setsurvivorname()
	function ulx.setsurvivorname( plyc, plys, survname )
		for _, plyt in ipairs(plys) do
			plyt:SetNamesurvivor(survname)
		end
	end

	local setsurvivorname = ulx.command( "Breach Admin", "ulx setsurvivorname", ulx.setsurvivorname, "!setsurvivorname" )
	setsurvivorname:addParam{ type = ULib.cmds.PlayersArg }
	setsurvivorname:addParam{ type = ULib.cmds.StringArg, hint = "Survivor name", ULib.cmds.takeRestOfLine }
	setsurvivorname:defaultAccess( ULib.ACCESS_SUPERADMIN )
	setsurvivorname:help( "funneh name" )
end

AddLevel()
AddXP()
--GiveBoneMerge()
InitializeBreachULX()
SetupForceSCP()
FORCESPAWN_BUTWORKING()
ABILITYGIVE_LOL()
setsurvivorname()