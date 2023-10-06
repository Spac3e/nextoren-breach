ROUNDS = {
	normal = {
		name = "Containment Breach",
		setup = function()
			BUTTONS = table.Copy(BUTTONS)
			SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			disableNTF = false
		end,
		init = function()
			BREACH.SPAWN_LOOT()
        end,
		roundstart = function()
			BREACH.Round_Open_Dblock()
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
			if #GetActivePlayers() < 1 then return end	
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
	dm = {
		name = "Nazi and USA",
		setup = function()
			--BUTTONS = table.Copy(BUTTONS)
			--SetupPlayers( GetRoleTable( #GetActivePlayers() ) )
			---disableNTF = false
		end,
		init = function()
			--SpawnShawmAndDocs()
		end,
		roundstart = function()
		end,
		postround = function() end,
		cleanup = function() end,
	},
}