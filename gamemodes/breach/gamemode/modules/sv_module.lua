	
// Variables
gamestarted = gamestarted or false
preparing = false
postround = false
roundcount = 0
BUTTONS = table.Copy(BUTTONS)


hook.Add("PlayerSay", "RRadioTextChat", function( speaker, text, teamChat )
	local findA = string.find(text, "!z")
	local findB = string.find(text, "/z")
	if findA or findB then 
		net.Start("dradio_sendMessage")
		net.WriteString(text)
		net.WriteDouble(speaker.frequency)
		net.WriteEntity(speaker)
		net.Broadcast() 
		return ""
	end 


end)


local nets = {
	"dradio_edit",
	"dradio_adjustfrequency",
	"dradio_updatefrequency",
	"dradio_networkfrequency",
	"dradio_clearfrequency",
	"dradio_sendMessage",
}

for k,v in pairs(nets) do
	util.AddNetworkString(v)
end 

function GM:PlayerSpray( ply )
return ply:IsSuperAdmin()
end

function GhostBoneMerge()
end
function Bonemerge()
end

function GetActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if IsValid( v ) then
			if v.ActivePlayer == nil then
				v.ActivePlayer = true
				v:SetNActive( true )
			end

			if v.ActivePlayer == true then
				table.ForceInsert(tab, v)
			end
		end
	end
	return tab
end

function GetNotActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true v:SetNActive( true ) end
		if v.ActivePlayer == false then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GM:ShutDown()
	--
end

function WakeEntity(ent)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocity( Vector( 0, 0, 25 ) )
	end
end

function PlayerNTFSound(sound, ply)
	if (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) and ply:Alive() then
		if ply.lastsound == nil then ply.lastsound = 0 end
		if ply.lastsound > CurTime() then
			ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
			return
		end
		//ply:EmitSound( "Beep.ogg", 500, 100, 1 )
		ply.lastsound = CurTime() + 3
		//timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
			ply:EmitSound( sound, 450, 100, 1 )
		//end)
	end
end

function OnUseEyedrops(ply)
	if ply.usedeyedrops == true then
		ply:PrintMessage(HUD_PRINTTALK, "Don't use them that fast!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	ply:PrintMessage(HUD_PRINTTALK, "Used eyedrops, you will not be blinking for 10 seconds")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
		ply.usedeyedrops = false
		ply:PrintMessage(HUD_PRINTTALK, "You will be blinking now")
	end)
end

/*timer.Create( "CheckStart", 10, 0, function() 
	if !gamestarted then
		CheckStart()
	end
end )*/

timer.Create("BlinkTimer", GetConVar("br_time_blinkdelay"):GetInt(), 0, function()
	local time = GetConVar("br_time_blink"):GetFloat()
	if time >= 5 then return end
	for k,v in pairs(player.GetAll()) do
		if v.canblink and v.blinkedby173 == false and v.usedeyedrops == false then
			net.Start("PlayerBlink")
				net.WriteFloat(time)
			net.Send(v)
			v.isblinking = true
		end
	end
	timer.Create("UnBlinkTimer", time + 0.2, 1, function()
		for k,v in pairs(player.GetAll()) do
			if v.blinkedby173 == false then
				v.isblinking = false
			end
		end
	end)
end)

timer.Create("EffectTimer", 0.3, 0, function()
	for k, v in pairs( player.GetAll() ) do
		if v.mblur == nil then v.mblur = false end
		net.Start("Effect")
			net.WriteBool( v.mblur )
		net.Send(v)
	end
end )

function GetPocketPos()
	if istable( POS_POCKETD ) then
		return table.Random( POS_POCKETD )
	else
		return POS_POCKETD
	end
end

function UseAll()
	for k, v in pairs( FORCE_USE ) do
		local enttab = ents.FindInSphere( v, 3 )
		for _, ent in pairs( enttab ) do
			if ent:GetPos() == v then
				ent:Fire( "Use" )
				break
			end
		end
	end
end

function DestroyAll()
	for k, v in pairs( FORCE_DESTROY ) do
		if isvector( v ) then
			local enttab = ents.FindInSphere( v, 1 )
			for _, ent in pairs( enttab ) do
				if ent:GetPos() == v then
					ent:Remove()
					break
				end
			end
		elseif isnumber( v ) then
			local ent = ents.GetByIndex( v )
			if IsValid( ent ) then
				ent:Remove()
			end
		end
	end
end

util.AddNetworkString( "NTF_Intro" )

function SpawnSupport()
	local useuiu = math.random( 1, 100 ) <= 25
	local usegop = math.random( 1, 100 ) <= 35
	local usedz = math.random( 1, 100 ) <= 45
	local usentf = math.random( 1, 100 ) <= 65
	local usechaos = math.random( 1, 100 ) <= 100
	local roles = {}
	local plys = {}
	local inuse = {}
	local podhod_p = 0
	local spawnpos = SPAWN_OUTSIDE
	for k, v in pairs( ALLCLASSES.support.roles ) do
	
			print( usechaos )
	
			if useuiu then 
				if v.team == TEAM_USA then
					table.insert( roles, v )
				end
			elseif usegop then
				if v.team == TEAM_GOC then
					table.insert( roles, v )
				end
			elseif usentf then
				if v.team == TEAM_GUARD then
					table.insert( roles, v )
				end
			elseif usechaos then
				if v.team == TEAM_CHAOS then
					table.insert( roles, v )
				end
			elseif usedz then
				if v.team == TEAM_DZ then
					table.insert( roles, v )
				end
			end
	end
	for k, v in pairs( roles ) do
			plys[v.name] = {}
			inuse[v.name] = 0
			for _, ply in pairs( player.GetAll() ) do
				if ply:GTeam() == TEAM_SPEC and ply.ActivePlayer then
					if ply:GetLevel() >= v.level and ( v.customcheck and c.customcheck( ply ) or true ) then
						table.insert( plys[v.name], ply )
						podhod_p = (table.Count( plys[v.name] ))
					end
				end
			end
	
			if #plys[v.name] < 1 then
				roles[k] = nil
			end
	end
	
		if #roles < 1 then
			return
		end
		if podhod_p > 4 then 
			for i = 1, 5 do
				local role = table.Random( roles )
				local ply = table.remove( plys[role.name], math.random( 1, #plys[role.name] ) )
		
				ply:SetupNormal()
				ply:ApplyRoleStats( role )
				ply:SetPos( spawnpos[i] )
		
				inuse[role.name] = inuse[role.name] + 1
		
				if ply:GTeam() == TEAM_CHAOS then
					ply:SendLua("RunConsoleCommand( 'intro_ci' )")
				elseif ply:GTeam() == TEAM_GOC then
					ply:SendLua("RunConsoleCommand( 'intro_goc' )")
				elseif ply:GTeam() == TEAM_GUARD then
					ply:SendLua("RunConsoleCommand( 'intro_ntf' )")	
				elseif ply:GTeam() == TEAM_USA then
					ply:SendLua("RunConsoleCommand( 'intro_onp' )")
				elseif ply:GTeam() == TEAM_DZ then
					ply:SendLua("RunConsoleCommand( 'intro_dz' )")
				end

				if #plys[role.name] < 1 or inuse[role.name] >= role.max then
					table.RemoveByValue( roles, role )
				end
		
				if #roles < 1 then
					break
				end
			end	
			if useuiu then
			BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )' )
			return
			end
			if usegop then
			BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/goc_enter.mp3" )' )
			return
			end	
			if usentf then
			BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/ntf_enter.ogg" )' )
			return
			end
			if usechaos then
			BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )' )
			return
			end
			if usedz then
				BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )' )
				return
			end
		end
end

function SpawnAllItems()
        local wep = ents.Create( "esc_vse" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( Vector(Vector(-8019.227051,-1090.048584,1728.031250)) )
			WakeEntity( wep )
    end

    local wep = ents.Create( "object_intercom" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( Vector( -2610.555664, 2270.446777, 320.494934 ) )
            WakeEntity( wep )
    end
    

	local wep = ents.Create( "bg" )
	if IsValid( wep ) then
		wep:Spawn()
		wep:SetPos( Vector(-710.249207,-6288.395508,-2372.594971) )
		WakeEntity( wep )
    end
	local wep = ents.Create( "scp_tree" )
	if IsValid( wep ) then
		wep:Spawn()
		wep:SetPos( Vector(9085.486328, -1932.134644, 5.520229) )
		WakeEntity( wep )
    end
	for k,v in pairs( SPAWN_BREACH_CAMERA ) do
        local wep = ents.Create( "br_camera" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v.pos )
			wep:SetAngles(v.ang)
			WakeEntity( wep )
        end
    end
	for k,v in pairs( SCP_914_BUTTON ) do
        local wep = ents.Create( "entity_scp_914" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v )
            WakeEntity( wep )
        end
    end


	for k,v in pairs( SPAWN_TESLA_0 ) do
        local wep = ents.Create( "test_entity_tesla" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v )
            WakeEntity( wep )
        end
    end

	for k,v in pairs( SPAWN_LIVETAB_LZ ) do
        local wep = ents.Create( "livetablz" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v.pos )
			wep:SetAngles(v.ang)
			WakeEntity( wep )
        end
    end

	for k,v in pairs( SPAWN_LIVETAB_EZ ) do
        local wep = ents.Create( "livetab" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v.pos )
			wep:SetAngles(v.ang)
			WakeEntity( wep )
        end
    end

    for k,v in pairs( SPAWN_TESLA_90 ) do
        local wep = ents.Create( "test_entity_tesla" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v )
            wep:SetAngles( Angle( 0,90,0 ) )
            WakeEntity( wep )
        end
    end

	for k,v in pairs( SPAWN_GENERATORS ) do
        local wep = ents.Create( "ent_generator" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v.Pos )
            wep:SetAngles( v.Ang )
            WakeEntity( wep )
        end
    end



	for k, v in pairs( SPAWN_ITEMS ) do
        local spawns = table.Copy( v.spawns )
        local dices = {}

        local n = 0
        for _, dice in pairs( v.ents ) do
            local d = {
                min = n,
                max = n + dice[2],
                ent = dice[1]
            }
            
            table.insert( dices, d )
            n = n + dice[2]
        end

        for i = 1, math.min( v.amount, #spawns ) do
            local spawn = table.remove( spawns, math.random( 1, #spawns ) )
            local dice = math.random( 0, n - 1 )
            local ent

            for _, d in pairs( dices ) do
                if d.min <= dice and d.max > dice then
                    ent = d.ent
                    break
                end
            end

            if ent then
                local keycard = ents.Create( ent )
                if IsValid( keycard ) then
                    keycard:Spawn()
                    keycard:SetPos( spawn )
                end
            end
        end
    end

	for k, v in pairs( SPAWN_AMMONEW ) do
        local spawns = table.Copy( v.spawns )
        //local cards = table.Copy( v.ents )
        local dices = {}

        local n = 0
        for _, dice in pairs( v.ents ) do
            local d = {
                min = n,
                max = n + dice[2],
                ent = dice[1]
            }
            
            table.insert( dices, d )
            n = n + dice[2]
        end

        for i = 1, math.min( v.amount, #spawns ) do
            local spawn = table.remove( spawns, math.random( 1, #spawns ) )
            local dice = math.random( 0, n - 1 )
            local ent

            for _, d in pairs( dices ) do
                if d.min <= dice and d.max > dice then
                    ent = d.ent
                    break
                end
            end

            if ent then
                local keycard = ents.Create( ent )
                if IsValid( keycard ) then
                    keycard:Spawn()
                    keycard:SetPos( spawn )
                    --keycard:SetKeycardType( ent )
                end
            end
        end
    end
    
	if GetConVar("br_allow_vehicle"):GetInt() != 0 then
	
		for k, v in ipairs(SPAWN_VEHICLE) do
			if k > math.Clamp( GetConVar( "br_cars_ammount" ):GetInt(), 0, 12 ) then
				break
			end
			local car = ents.Create("prop_vehicle_jeep")
			car:SetModel("models/tdmcars/jeep_wrangler_fnf.mdl")
			car:SetKeyValue("vehiclescript","scripts/vehicles/TDMCars/wrangler_fnf.txt")
			car:SetPos( v[1] )
			car:SetAngles( v[2] )
				car:Spawn()
			WakeEntity( car )
		end
	end

	for k, v in pairs( SPAWN_FBI_MONITORS ) do
        local wep = ents.Create( "onp_monitor" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v.pos )
			wep:SetAngles(v.ang)
            WakeEntity( wep )
        end
    end
	
	for k, v in pairs( SPAWN_VENDOR ) do
        local wep = ents.Create( "ent_vendormachine" )
        if IsValid( wep ) then
            wep:Spawn()
            wep:SetPos( v )
			wep:SetAngles(Angle(0,-90,0))
            WakeEntity( wep )
        end
    end
	local wep = ents.Create( "ent_scp_409" )
    --local sp = v.Spawns
    if IsValid( wep ) then
        wep:Spawn()
        wep:SetPos( Vector(1148.37109375, -6633.662109375, -2360.96875) )
        wep:SetAngles( Angle(0,0,0) )
        WakeEntity( wep )
    end

    local wep = ents.Create( "ent_ammocrate" )
    --local sp = v.Spawns
    if IsValid( wep ) then
        wep:Spawn()
        wep:SetPos( Vector(7562.3012695313, -4243.8090820313, 17.431785583496) )
        wep:SetAngles( Angle(0, -90, 0) )
        WakeEntity( wep )
    end

    local wep = ents.Create( "ent_ammocrate" )
    --local sp = v.Spawns
    if IsValid( wep ) then
        wep:Spawn()
        wep:SetPos( Vector(9344.3896484375, -3276.6135253906, 16.921831130981) )
        wep:SetAngles( Angle(0, 0, 0) )
        WakeEntity( wep )
    end

    local wep = ents.Create( "ent_ammocrate" )
    --local sp = v.Spawns
    if IsValid( wep ) then
        wep:Spawn()
        wep:SetPos( Vector(246.13401794434, -3920.3305664063, -1233.5209960938) )
        wep:SetAngles( Angle(0, -90, 0) )
        WakeEntity( wep )
    end

    local wep = ents.Create( "ent_ammocrate" )
    --local sp = v.Spawns
    if IsValid( wep ) then
        wep:Spawn()
        wep:SetPos( Vector(156.32833862305, 5842.767578125, 15.887740135193) )
        wep:SetAngles( Angle(0, 0, 0) )
        WakeEntity( wep )
    end

	for k,v in pairs(SPAWN_WEAPONRY) do
		local ent = ents.Create("ent_weaponry")
		if IsValid( ent ) then
			ent:Spawn()
			ent:SetPos( v )
			ent:SetAngles(Angle(0, -90, 0))
			WakeEntity(ent)
		end
	end
		local ent = ents.Create("weapon_special_gaus")
		if IsValid( ent ) then
			ent:Spawn()
			ent:SetPos( Vector(2032.1343994141, 6344.05859375, 61.311496734619) )
			ent:SetAngles(Angle(0, -90, 0))
			WakeEntity(ent)
	end

	for k, v in pairs( SPAWN_UNIFORMS) do
        local spawns = table.Copy( v.spawns )
        local dices = {}

        local n = 0
        for _, dice in pairs( v.entities ) do
            local d = {
                min = n,
                max = n + dice[2],
                ent = dice[1]
            }
            
            table.insert( dices, d )
            n = n + dice[2]
        end

        for i = 1, math.min( v.amount, #spawns ) do
            local spawn = table.remove( spawns, math.random( 1, #spawns ) )
            local dice = math.random( 0, n - 1 )
            local ent

            for _, d in pairs( dices ) do
                if d.min <= dice and d.max > dice then
                    ent = d.ent
                    break
                end
            end

            if ent then
                local keycard = ents.Create( ent )
                if IsValid( keycard ) then
                    keycard:Spawn()
                    keycard:SetPos( spawn )
                    --keycard:SetKeycardType( ent )
                end
            end
        end
    end
end

util.AddNetworkString( "cassie_pizdelka_start" )
util.AddNetworkString( "cassie_pizdelka_stop" )

function Round_Work()

	for k,ball in pairs(ents.FindInSphere((Vector(4668, -2227, 70)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(6890, -1496, 57)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(7433, -1045, 63)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(8161, -1507, 64)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9631, -526, 73)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(-1065, 5475, 50)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(-1851, 5388, 76)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(-2147, 5706, 58)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9871, -1514, 68)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	net.Start( "cassie_pizdelka_start" )
	net.Broadcast()

timer.Create( "mog_door_open", 40, 1, function()

		for k,ball in pairs(ents.FindInSphere((Vector(-1065, 5475, 50)), 50)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
		end
		end

		for k,ball in pairs(ents.FindInSphere((Vector(-1851, 5388, 76)), 50)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
		end
		end

		for k,ball in pairs(ents.FindInSphere((Vector(-2147, 5706, 58)), 50)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
		end
		end

end)

timer.Create( "sb_door_open", 80, 1, function()

	for k,ball in pairs(ents.FindInSphere((Vector(9871, -1514, 68)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
	  end
	end

end)

timer.Create( "lc_15_sv_scp_open_door", 180, 1, function()
	OpenSCPDoors()
	
	for k,ball in pairs(ents.FindInSphere((Vector(4668, -2227, 70)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(6890, -1496, 57)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(7433, -1045, 63)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(8161, -1507, 64)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9631, -526, 73)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
	  end
	end

end )

timer.Create( "lc_11_open_kpp_15_s", 375, 1, function()
	for k,ball in pairs(ents.FindInSphere((Vector(4668, -2227, 70)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(6890, -1496, 57)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(7433, -1045, 63)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(8161, -1507, 64)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9631, -526, 73)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end
end )

timer.Create( "spawnsupport_12_11", 360, 1, function()

	SpawnSupport()

end )

timer.Create( "spawnsupport_9_8", 540, 1, function()

	SpawnSupport()

end )

timer.Create( "lc_11_s_close", 420, 1, function()

	local heli = ents.Create( "lz_gaz" )
	heli:Spawn()

	for k,ball in pairs(ents.FindInSphere((Vector(4668, -2227, 70)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(6890, -1496, 57)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(7433, -1045, 63)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(8161, -1507, 64)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9631, -526, 73)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  end
	end
end )


timer.Create( "lc_2_10_s_sv", 955, 1, function()

	local heli = ents.Create( "heli" )
	heli:Spawn()

	local btr = ents.Create( "btr" )
	btr:Spawn()

	local portal = ents.Create( "portal" )
	portal:Spawn()

end)

end

function Round_Work_stop()
	--local ply = LocalPlayer()
	-- пизделка на 15 мин
	timer.Remove( "lc_15_sv_scp_open_door" )
	timer.Remove( "lc_2_10_s_sv" )
	timer.Remove( "lc_11_open_kpp_15_s" )
	timer.Remove( "lc_11_s_close" )
	timer.Remove( "spawnsupport_12_11" )
	timer.Remove( "spawnsupport_9_8" )
	timer.Remove( "mog_door_open" )
	timer.Remove( "sb_door_open" )
	net.Start( "cassie_pizdelka_stop" )
    net.Broadcast()

	--[[
    timer.Simple(120, function()
		surface.PlaySound( "nextoren/round_sounds/main_decont/decont_15_b.mp3" )
		self:BrTip(0, "[Vault Breach]", Color(255, 0, 0), "До взрыва Альфа Боеголовки осталось 15 мин!", Color(255, 255, 255))
	end)
	]]--
end

function Auto_door_close()

	for k,v in pairs(door.GetAll()) do

	

	end

end

SCP914InUse = false
function Use914( ent )
	if SCP914InUse then return false end
	SCP914InUse = true

	if SCP_914_BUTTON and ent:GetPos() != SCP_914_BUTTON then
		for k, v in pairs( ents.FindByClass( "func_door" ) ) do
			if v:GetPos() == SCP_914_DOORS[1] or v:GetPos() == SCP_914_DOORS[2] then
				v:Fire( "Close" )
				timer.Create( "914DoorOpen"..v:EntIndex(), 15, 1, function()
					v:Fire( "Open" )
				end )
			end
		end
	end

	local button = ents.FindByName( SCP_914_STATUS )[1]
	local angle = button:GetAngles().roll
	local mode = 0

	if angle == 45 then
		mode = 1
	elseif	angle == 90 then
		mode = 2
	elseif	angle == 135 then
		mode = 3
	elseif	angle == 180 then
		mode = 4
	end
	
	timer.Create( "SCP914UpgradeEnd", 16, 1, function()
		SCP914InUse = false
	end )

	timer.Create( "SCP914Upgrade", 10, 1, function() 
		local items = ents.FindInBox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS )
		for k, v in pairs( items ) do
			if IsValid( v ) then
				if v.HandleUpgrade then
					v:HandleUpgrade( mode, SCP_914_OUTPUT )
				elseif v.betterone or v.GetBetterOne then
					local item_class
					if v.betterone then item_class = v.betterone end
					if v.GetBetterOne then item_class = v:GetBetterOne( mode ) end

					local item = ents.Create( item_class )
					if IsValid( item ) then
						v:Remove()
						item:SetPos( SCP_914_OUTPUT )
						item:Spawn()
						WakeEntity( item )
					end
				end
			end
		end
	end )

	return true
end

function LockSCPDoors()

	local scp_b_1 = Vector(8253, 826, 50) 
	local scp_b_2 = Vector(5787, 1538, 51) 
	local scp_b_3 = Vector(5235, 1540, 51) 
	local scp_b_4 = Vector(4996, 3598, 49) 
	local scp_b_5 = Vector(4249, 2257, 28) 
	local scp_b_6 = Vector(3694, 389, 49) 
	local scp_b_7 = Vector(6282, -3953, 279) 
	local scp_b_8 = Vector(7584, -272, 64) 

	local scp_item_1 = Vector(7700, -4140, 53) 
	local scp_item_2 = Vector(7788, -3988, 53) 
	local scp_item_3 = Vector(8113, -3921, 56) 
	local scp_item_4 = Vector(8561, -3769, 55) 
	local scp_item_5 = Vector(8405, -3682, 55) 
	local scp_item_6 = Vector(8547, -1905, 53) 
	local scp_item_7 = Vector(7132, -2114, 56) 
	local scp_item_8 = Vector(6629, -2299, 56) 
	local scp_item_9 = Vector(6715, -2114, 53) 
	local scp_item_10 = Vector(6246, -1957, 55) 
	local scp_item_11 = Vector(6314, -2459, 57) 

		for k,ball in pairs(ents.FindInSphere((scp_item_1), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_2), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_3), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_4), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_5), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_6), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_7), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_8), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_9), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_10), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
			for k,ball in pairs(ents.FindInSphere((scp_item_11), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end

	for k,ball in pairs(ents.FindInSphere((scp_b_1), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_2), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_3), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_4), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
	for k,ball in pairs(ents.FindInSphere((scp_b_5), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_6), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_7), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("lock") end
          end
    end

end

function D_class_open_door()

	for k,box in pairs(ents.FindInBox( Vector( 7815, -6224, 239 ), Vector( 7900, -4864, 460 ) )) do
          if IsValid(box) then
		      if box:GetClass() == "func_door" then 
			  	box:Fire("open") 
			  end
          end
    end

	for k,box in pairs(ents.FindInBox( Vector( 6256, -6260, 117 ), Vector( 6057, -4922, 310 ) )) do
          if IsValid(box) then
		      if box:GetClass() == "func_door" then 
			  	box:Fire("open") 
			  end
          end
    end

end
--[[
util.AddNetworkString("start_mog_intro")

function startmogintro()

	net.Start( "start_mog_intro" )
	net.Broadcast()

end
]]--
function OpenSCPDoors()
--[[
    local entsinbox = ents.FindInBox( Vector( 7815, -6224, 239 ), Vector( 7900, -4864, 460 ) ) 
    for k, v in ipairs( entsinbox ) do
      if v:GetClass() == "func_button" then
	  	v:Fire("Open")
      end
    end
]]--

	local scp_b_1 = Vector(8253, 826, 50) 
	local scp_b_2 = Vector(5787, 1538, 51) 
	local scp_b_3 = Vector(5235, 1540, 51) 
	local scp_b_4 = Vector(4996, 3598, 49) 
	local scp_b_5 = Vector(4249, 2257, 28) 
	local scp_b_6 = Vector(3694, 389, 49) 
	local scp_b_7 = Vector(6282, -3953, 279) 
	local scp_b_8 = Vector(7584, -272, 64) 

	local scp_item_1 = Vector(7700, -4140, 53) 
	local scp_item_2 = Vector(7788, -3988, 53) 
	local scp_item_3 = Vector(8113, -3921, 56) 
	local scp_item_4 = Vector(8561, -3769, 55) 
	local scp_item_5 = Vector(8405, -3682, 55) 
	local scp_item_6 = Vector(8547, -1905, 53) 
	local scp_item_7 = Vector(7132, -2114, 56) 
	local scp_item_8 = Vector(6629, -2299, 56) 
	local scp_item_9 = Vector(6715, -2114, 53) 
	local scp_item_10 = Vector(6246, -1957, 55) 
	local scp_item_11 = Vector(6314, -2459, 57) 

	for k,ball in pairs(ents.FindInSphere((scp_item_1), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_2), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_3), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_4), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_5), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_6), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_7), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_8), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_9), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_10), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_item_11), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
          end
    end

	print("Ну все")
		for k,ball in pairs(ents.FindInSphere((scp_b_1), 5)) do
          if IsValid(ball) then
		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_2), 5)) do
          if IsValid(ball) then
		  		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_3), 5)) do
          if IsValid(ball) then
		  		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_4), 5)) do
          if IsValid(ball) then
		  		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_5), 5)) do
          if IsValid(ball) then
		  		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_6), 5)) do
          if IsValid(ball) then
		  		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_7), 5)) do
          if IsValid(ball) then
		  		      if ball:GetClass() == "func_button" then ball:Fire("unlock") end
              if ball:GetClass() == "func_button" then ball:Fire("use") end
          end
    end
		for k,ball in pairs(ents.FindInSphere((scp_b_8), 5)) do
          if IsValid(ball) then
              if ball:GetModel() == "models/next_breach/door_frame_sealed.mdl" then ball:Remove() end
			  if ball:GetModel() == "models/next_breach/entrance_door.mdl" then ball:Remove() end
			  if ball:GetModel() == "models/next_breach/light_cz_door.mdl" then ball:Remove() end
          end
    end
end

function GetAlivePlayers()
	local plys = {}
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() or v:GetNClass() == ROLES.ROLE_SCP076 then
				table.ForceInsert(plys, v)
			end
		end
	end
	return plys
end

function BroadcastDetection( ply, tab )
	local transmit = { ply }
	local radio = ply:GetWeapon( "item_radio" )

	if radio and radio.Enabled and radio.Channel > 4 then
		local ch = radio.Channel

		for k, v in pairs( player.GetAll() ) do
			if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v != ply then
				local r = v:GetWeapon( "item_radio" )

				if r and r.Enabled and r.Channel == ch then
					table.insert( transmit, v )
				end
			end
		end
	end

	local info = {}

	for k, v in pairs( tab ) do
		table.insert( info, {
			name = v:GetNClass(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 4 )
end

function PlayerCount()
	return #player.GetAll()
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
end

function GetPlayer(nick)
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == nick then
			return v
		end
	end
	return nil
end

function CreateSCPRAG(ply, inflictor, attacker, knockedout)
	local team = ply:Team()
	if ( team == TEAM_SCP && ply.DeathAnimation ) then
		local SCPRagdoll = ents.Create( "base_gmodentity" )
		SCPRagdoll:SetPos( ply:GetPos() )
		SCPRagdoll:SetModel( ply:GetModel() )
		SCPRagdoll:SetMaterial( ply:GetMaterial() )
		SCPRagdoll:SetAngles( ply:GetAngles() )
		SCPRagdoll:Spawn()
		SCPRagdoll:SetPlaybackRate( 1 )
		SCPRagdoll:SetSequence( ply.DeathAnimation )
		SCPRagdoll.AutomaticFrameAdvance = true
		SCPRagdoll.Think = function( self )
			self:NextThink( CurTime() )
			return true
		end

		if ( !ply.DeathLoop ) then

			timer.Simple( SCPRagdoll:SequenceDuration() - .1, function()
				local SCPRagdoll2 = ents.Create( "prop_ragdoll" )
				SCPRagdoll2:SetModel( SCPRagdoll:GetModel() )
				SCPRagdoll2:SetPos( SCPRagdoll:GetPos() )
				SCPRagdoll2:SetAngles( SCPRagdoll:GetAngles() )
				SCPRagdoll2:SetMaterial( SCPRagdoll:GetMaterial() )
				SCPRagdoll2:SetSequence( SCPRagdoll:GetSequence() )
				SCPRagdoll2:SetCycle( SCPRagdoll:GetCycle() )
				SCPRagdoll2:Spawn()

				if ( SCPRagdoll2 && SCPRagdoll2:IsValid() ) then
					SCPRagdoll2:SetCollisionGroup( COLLISION_GROUP_WEAPON )
					for i = 1, SCPRagdoll2:GetPhysicsObjectCount() do

						local physicsObject = SCPRagdoll2:GetPhysicsObjectNum( i )
						local boneIndex = SCPRagdoll2:TranslatePhysBoneToBone( i )
						local position, angle = SCPRagdoll:GetBonePosition( boneIndex )

						if ( physicsObject && physicsObject:IsValid() ) then
							physicsObject:SetPos( position )
							physicsObject:SetMass( 65 )
							physicsObject:SetAngles( angle )

						end
					end
				end
				SCPRagdoll:Remove()
			end)
		end
		return
	end
end


function ServerSound( file, ent, filter )
	ent = ent or game.GetWorld()
	if !filter then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end

	local sound = CreateSound( ent, file, filter )

	return sound
end

inUse = false
function explodeGateA( ply )
	if ply and !isInTable( ply, ents.FindInSphere(POS_EXPLODE_A, 250) ) then return end
	if inUse == true then return end
	if isGateAOpen() then return end
	inUse = true
	
	local filter = RecipientFilter()
	filter:AddAllPlayers()
	local sound = CreateSound( game.GetWorld(), "ambient/alarms/alarm_citizen_loop1.wav", filter )
	sound:SetSoundLevel( 0 )
	
	BroadcastLua( 'surface.PlaySound("radio/franklin1.ogg")' )
	sound:Play()
	sound:ChangeVolume( 0.25 )
	local waitTime = GetConVar( "br_time_explode" ):GetInt()
	local ttime = 0
	PrintMessage( HUD_PRINTTALK, "Time to Gate A explosion: "..waitTime.."s")
	timer.Create( "GateExplode", 1, waitTime, function()
		if ttime > waitTime then return end
		if isGateAOpen() then 
			timer.Destroy( "GateExplode" )
			sound:Stop()
			PrintMessage( HUD_PRINTTALK, "Gate A explosion terminated")
			inUse = false
			return
		end
		
		ttime = ttime + 1
		if ttime % 5 == 0 then PrintMessage( HUD_PRINTTALK, "Time to Gate A explosion: "..waitTime - ttime.."s" ) end
		if ttime + 1 == waitTime then sound:Stop() end
		if ttime == waitTime then
			BroadcastLua( 'surface.PlaySound("ambient/explosions/exp2.wav")' )
			local explosion = ents.Create( "env_explosion" ) // Creating our explosion
			explosion:SetKeyValue( "spawnflags", 210 ) //Setting the key values of the explosion 
			explosion:SetPos( POS_MIDDLE_GATE_A )
			explosion:Spawn()
			explosion:Fire( "explode", "", 0 )
			destroyGate()
			takeDamage( explosion, ply )
			if ply then
				ply:AddExp(100, true)
			end
		end
	end )
end

function takeDamage( ent, ply )
	local dmg = 0
	for k, v in pairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 1000 ) ) do
		if v:IsPlayer() then
			if v:Alive() then
				if v:GTeam() != TEAM_SPEC then
					dmg = ( 1001 - v:GetPos():Distance( POS_MIDDLE_GATE_A ) ) * 10
					if dmg > 0 then 
						v:TakeDamage( dmg, ply or v, ent )
					end
				end
			end
		end
	end
end

function destroyGate()
	if isGateAOpen() then return end
	local doorsEnts = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doorsEnts ) do
		if v:GetClass() == "prop_dynamic" or v:GetClass() == "func_door" then
			v:Remove()
		end
	end
end

function isGateAOpen()
	local doors = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doors ) do
		if v:GetClass() == "prop_dynamic" then 
			if isInTable( v:GetPos(), POS_GATE_A_DOORS ) then return false end
		end
	end
	return true
end

function Recontain106( ply )
	if Recontain106Used then
		ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 recontain procedure can be triggered only once per round" )
		return false
	end

	local cage
	for k, v in pairs( ents.GetAll() ) do
		if v:GetPos() == CAGE_DOWN_POS then
			cage = v
			break
		end
	end
	if !cage then
		ply:PrintMessage( HUD_PRINTCENTER, "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure" )
		return false
	end

	local e = ents.FindByName( SOUND_TRANSMISSION_NAME )[1]
	if e:GetAngles().roll == 0 then
		ply:PrintMessage( HUD_PRINTCENTER, "Enable sound transmission in order to start SCP 106 recontain procedure" )
		return false
	end

	local fplys = ents.FindInBox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS )
	local plys = {}
	for k, v in pairs( fplys ) do
		if IsValid( v ) and v:IsPlayer() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
			table.insert( plys, v )
		end
	end

	if #plys < 1 then
		ply:PrintMessage( HUD_PRINTCENTER, "Living human in cage is required in order to start SCP 106 recontain procedure" )
		return false
	end

	local scps = {}
	for k, v in pairs( player.GetAll() ) do
		if IsValid( v ) and v:GTeam() == TEAM_SCP and v:GetNClass() == ROLES.ROLE_SCP106 then
			table.insert( scps, v )
		end
	end

	if #scps < 1 then
		ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 is already recontained" )
		return false
	end

	Recontain106Used = true

	timer.Simple( 6, function()
		if postround or !Recontain106Used then return end
		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:Kill()
			end
		end

		for k, v in pairs( scps ) do
			if IsValid( v ) then
				local swep = v:GetActiveWeapon()
				if IsValid( swep ) and swep:GetClass() == "weapon_scp_106" then
					swep:TeleportSequence( CAGE_INSIDE )
				end
			end
		end

		timer.Simple( 11, function()
			if postround or !Recontain106Used then return end
			for k, v in pairs( scps ) do
				if IsValid( v ) then
					v:Kill()
				end
			end
			local eloiid = ents.FindByName( ELO_IID_NAME )[1]
			eloiid:Use( game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1 )
			if IsValid( ply ) then
				ply:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for recontaining SCP 106!")
				ply:AddFrags( 10 )
			end
		end )


	end )

	return true
end

OMEGAEnabled = false
OMEGADoors = false
function OMEGAWarhead( ply )
	if OMEGAEnabled then return end

	local remote = ents.FindByName( OMEGA_REMOTE_NAME )[1]
	if GetConVar( "br_enable_warhead" ):GetInt() != 1 or remote:GetAngles().pitch == 180 then
		ply:PrintMessage( HUD_PRINTCENTER, "You inserted keycard but nothing happened" )
		return
	end

	OMEGAEnabled = true

	--local alarm = ServerSound( "warhead/alarm.ogg" )
	--alarm:SetSoundLevel( 0 )
	--alarm:Play()
	net.Start( "SendSound" )
		net.WriteInt( 1, 2 )
		net.WriteString( "warhead/alarm.ogg" )
	net.Broadcast()

	timer.Create( "omega_announcement", 3, 1, function()
		--local announcement = ServerSound( "warhead/announcement.ogg" )
		--announcement:SetSoundLevel( 0 )
		--announcement:Play()
		net.Start( "SendSound" )
			net.WriteInt( 1, 2 )
			net.WriteString( "warhead/announcement.ogg" )
		net.Broadcast()

		timer.Create( "omega_delay", 11, 1, function()
			for k, v in pairs( ents.FindByClass( "func_door" ) ) do
				if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
					v:Fire( "Unlock" )
					v:Fire( "Open" )
					v:Fire( "Lock" )
				end
			end

			OMEGADoors = true

			--local siren = ServerSound( "warhead/siren.ogg" )
			--siren:SetSoundLevel( 0 )
			--siren:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/siren.ogg" )
			net.Broadcast()
			timer.Create( "omega_alarm", 12, 5, function()
				--siren = ServerSound( "warhead/siren.ogg" )
				--siren:SetSoundLevel( 0 )
				--siren:Play()
				net.Start( "SendSound" )
					net.WriteInt( 1, 2 )
					net.WriteString( "warhead/siren.ogg" )
				net.Broadcast()
			end )

			timer.Create( "omega_check", 1, 89, function()
				if !IsValid( remote ) or remote:GetAngles().pitch == 180 or !OMEGAEnabled then
					WarheadDisabled( siren )
				end
			end )
		end )

		timer.Create( "omega_detonation", 90, 1, function()
			--local boom = ServerSound( "warhead/explosion.ogg" )
			--boom:SetSoundLevel( 0 )
			--boom:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/explosion.ogg" )
			net.Broadcast()
			for k, v in pairs( player.GetAll() ) do
				v:Kill()
			end
		end )
	end )
end

function WarheadDisabled( siren )
	OMEGAEnabled = false
	OMEGADoors = false
	net.Start( "SendSound" )
		net.WriteInt( 0, 2 )
		net.WriteString( "warhead/siren.ogg" )
	net.Broadcast()

	if timer.Exists( "omega_check" ) then timer.Remove( "omega_check" ) end
	if timer.Exists( "omega_alarm" ) then timer.Remove( "omega_alarm" ) end
	if timer.Exists( "omega_detonation" ) then timer.Remove( "omega_detonation" ) end
	
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
			v:Fire( "Unlock" )
			v:Fire( "Close" )
		end
	end
end

function GM:BreachSCPDamage( ply, ent, dmg )
	if IsValid( ply ) and IsValid( ent ) then
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( dmg, ply, ply )
			return true
		end
	end
end

function isInTable( element, tab )
	for k, v in pairs( tab ) do
		if v == element then return true end
	end
	return false
end

function DARK()
    engine.LightStyle( 0, "a" )
    BroadcastLua('render.RedownloadAllLightmaps(true)')
    BroadcastLua('RunConsoleCommand("mat_specular", 0)')
end