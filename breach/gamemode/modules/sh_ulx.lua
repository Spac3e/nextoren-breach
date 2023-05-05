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

function InitializeBreachULX()
	if !ulx or !ULib then 
		print( "ULX or ULib not found" )
		return
	end

	local class_names = {}
	for _, group in pairs( ALLCLASSES ) do
		for k, class in pairs( group.roles ) do
			table.insert( class_names, class.name )
		end
	end

	/*local scp_names = {}
	for _, scp in pairs( SPCS ) do
		table.insert( scp_names, scp.name )
	end*/

	function ulx.forcespawn( ply, plys, class, silent )
		if !class then return end
		local cl, gr
		for _, group in pairs( ALLCLASSES ) do
			gr = group.name
			for k, clas in pairs( group.roles ) do
				if clas.name == class or clas.name == ROLES["ROLE_"..class] then
					cl = clas
				end
				if cl then break end
			end
			if cl then break end
		end
		if cl and gr then
			local pos
			if gr == "Armed Site Support" then
				pos = SPAWN_OUTSIDE
			elseif gr == "Armed Site Security" then
				pos = SPAWN_GUARD
			elseif gr == "Unarmed Site Staff" then
				pos = SPAWN_SCIENT
			elseif  gr == "Class D Personell" then
				pos = SPAWN_CLASSD
			end
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

	local forcespawn = ulx.command( "Breach Admin", "ulx force_spawn", ulx.forcespawn, "!forcespawn" )
	forcespawn:addParam{ type = ULib.cmds.PlayersArg }
	forcespawn:addParam{ type = ULib.cmds.StringArg, hint = "class name", completes = class_names, ULib.cmds.takeRestOfLine }
	forcespawn:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	forcespawn:setOpposite( "ulx silent force_spawn", { _, _, _, true }, "!sforcespawn" )
	forcespawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
	forcespawn:help( "Sets player(s) to specific class and spawns him" )



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

	function ulx.restartgame( ply, silent )
		RestartGame()
		if silent then
			ulx.fancyLogAdmin( ply, true, "#A restarted game" )
		else
			ulx.fancyLogAdmin( ply, "#A restarted game" )
		end
	end

	local restartgame = ulx.command( "Breach Admin", "ulx restart_game", ulx.restartgame, "!restartgame" )
	restartgame:addParam{ type = ULib.cmds.BoolArg, invisible = true }
	restartgame:setOpposite( "ulx silent restart_game", { _, true }, "!srestartgame" )
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
		SpawnSupport()
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
local function ABILITYGIVE_LOL()
	local completes = {}
	local abilitylist = {}
	for i, v in pairs(ALLCLASSES) do
		if i == "SCP" or i == "OTHER" then continue end
		for _, group in pairs(ALLCLASSES) do
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
	
			if !role then ply:RXSENDNotify("Способность "..ability.." не найдена.") return end
	
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
			end
		end
	
		local giveability = ulx.command( "Breach Admin", "ulx giveability", ulx.giveability, "!giveability" )
		giveability:addParam{ type = ULib.cmds.PlayersArg }
		giveability:addParam{ type = ULib.cmds.StringArg, hint = "ability", completes = completes, ULib.cmds.takeRestOfLine }
		giveability:defaultAccess( ULib.ACCESS_SUPERADMIN )
		giveability:help( "" )
	end
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

InitializeBreachULX()
SetupForceSCP()
ABILITYGIVE_LOL()
