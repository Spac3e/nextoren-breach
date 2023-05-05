ROUNDS = {
	normal = {
		name = "Containment Breach",
		setup = function()
			MAPBUTTONS = table.Copy(BUTTONS)
			SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			disableNTF = false
		end,
		init = function()
			SpawnAllItems()
			timer.Create( "NTFEnterTime", GetNTFEnterTime(), 0, function()
				SpawnSupport()
			end )
end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function()
			local plys = GetActivePlayers()
			for k, v in pairs( plys ) do
				local r = tonumber( v:GetPData( "scp_penalty", 0 ) ) - 1
				r = math.max( r, 0 )

				if r == 0 then
					v:PrintTranslatedMessage( "scpready#50,200,50" )
					//print( v, "can be scp" )
				else
					v:PrintTranslatedMessage( "scpwait".."$"..r.."#200,50,50" )
					//dprint( v, "must wait", r )
				end
			end
		end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end	
			endround = false
			local ds = gteams.NumPlayers(TEAM_CLASSD)
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local res = gteams.NumPlayers(TEAM_SCI)
			local scps = gteams.NumPlayers(TEAM_SCP)
			local chaos = gteams.NumPlayers(TEAM_CHAOS)
			local all = #GetAlivePlayers()		
			why = "idk man"
			if scps == all then
				endround = true
				why = "there are only scps"
			elseif mtfs == all then
				endround = true
				why = "there are only mtfs"
			elseif res == all then
				endround = true
				why = "there are only researchers"
			elseif ds == all then
				endround = true
				why = "there are only class ds"
			elseif chaos == all then
				endround = true
				why = "there are only chaos insurgency members"
			elseif (mtfs + res) == all then
				endround = true
				why = "there are only mtfs and researchers"
			elseif (chaos + ds) == all then
				endround = true
				why = "there are only chaos insurgency members and class ds"
			end
		end,
	},
/*	dm = {
		name = "MTF vs CI Deathmatch",
		setup = function()
			MAPBUTTONS = GetTableOverride( table.Copy(BUTTONS) ) + GetTableOverride( table.Copy(BUTTONS_DM) )
			SetupPlayers( GetRoleTableCustom( #GetActivePlayers(),  ) )
			
			disableNTF = false
		end,
		init = function()
			SpawnAllItems()
			DestroyGateA()
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		cleanup = function() end,
	},*/
/*	omega = {
		name = "Omega Problem",
		setup = function()
			MAPBUTTONS = GetTableOverride( table.Copy(BUTTONS) ) + GetTableOverride( table.Copy(BUTTONS_OMEGA) )
			SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			disableNTF = false
		end,
		init = function()
			SpawnAllItems()
			timer.Create( "NTFEnterTime", GetNTFEnterTime(), 0, function()
				SpawnSupport()
			end )
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		cleanup = function() end,
	}, */
	--[[infect = {
		name = "Infect",
		setup = function()
			MAPBUTTONS = table.Copy(BUTTONS)
			SetupInfect( #GetActivePlayers() )
			disableNTF = true
		end,
		init = function()
			SpawnAllItems()
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function() end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end
			local ds = gteams.NumPlayers(TEAM_CLASSD)
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local scps = gteams.NumPlayers(TEAM_SCP)
			local all = #GetAlivePlayers()
			endround = false
			why = "idk"
			if ds == all then
				endround = true
				why = "there are only Class Ds"
			elseif mtfs == all then
				endround = true
				why = "there are only MTFs"
			elseif ds + mtfs == all then
				endround = true
				why = "there are only MTFs and Ds"
			elseif scps == all then
				endround = true
				why = "there are only SCPs"
			end		
		end,
	},--]] -- Мб потом сделаем, а может и не надо... идея хуйня
	multi = {
		name = "Multi Breach",
		setup = function()
			MAPBUTTONS = table.Copy(BUTTONS)
			SetupPlayers( GetRoleTable( #GetActivePlayers() ), true )
			disableNTF = false
		end,
		init = function()
			SpawnAllItems()
			timer.Create( "NTFEnterTime", GetNTFEnterTime(), 0, function()
				SpawnSupport()
			end )
		end,
		roundstart = function()
			OpenSCPDoors()
		end,
		postround = function()
			local plys = GetActivePlayers()
			for k, v in pairs( plys ) do
				local r = tonumber( v:GetPData( "scp_penalty", 0 ) ) - 1
				r = math.max( r, 0 )

				if r == 0 then
					v:PrintTranslatedMessage( "scpready#50,200,50" )
					//print( v, "can be scp" )
				else
					v:PrintTranslatedMessage( "scpwait".."$"..r.."#200,50,50" )
					//dprint( v, "must wait", r )
				end
			end
		end,
		endcheck = function()
			if #GetActivePlayers() < 2 then return end	
			endround = false
			local ds = gteams.NumPlayers(TEAM_CLASSD)
			local mtfs = gteams.NumPlayers(TEAM_GUARD)
			local res = gteams.NumPlayers(TEAM_SCI)
			local scps = gteams.NumPlayers(TEAM_SCP)
			local chaos = gteams.NumPlayers(TEAM_CHAOS)
			local all = #GetAlivePlayers()		
			why = "idk man"
			if scps == all then
				endround = true
				why = "there are only scps"
			elseif mtfs == all then
				endround = true
				why = "there are only mtfs"
			elseif res == all then
				endround = true
				why = "there are only researchers"
			elseif ds == all then
				endround = true
				why = "there are only class ds"
			elseif chaos == all then
				endround = true
				why = "there are only chaos insurgency members"
			elseif (mtfs + res) == all then
				endround = true
				why = "there are only mtfs and researchers"
			elseif (chaos + ds) == all then
				endround = true
				why = "there are only chaos insurgency members and class ds"
			end
		end,
	},
}