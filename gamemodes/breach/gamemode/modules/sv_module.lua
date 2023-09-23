local mply = FindMetaTable( "Player" )

function spawn_ents()
end

concommand.Add("loot", spawn_ents)

function test1()
	SetGlobalInt("EnoughPlayersCountDownStart", 11)
	SetGlobalBool("EnoughPlayersCountDown", true)
end
concommand.Add("test", test1)

function test2(ply)
	--ply:SetNWBool("RXSEND_ONFIRE", true)
	--ply:SetNEXP("1000")

	ply:SetNEXP( 0 )
	print(ply:GetNEXP())
	ply:SetPData( "breach_exp", 0 )
	print(ply:GetPData("breach_exp"))

	local xp = ply:GetNEXP()
	local lvl = ply:GetNLevel()

	if xp >= (680 * math.max(1, ply:GetNLevel())) then
		ply:AddLevel(lvl + 1)
		ply:SetNEXP(xp - (680 * math.max(1, ply:GetNLevel())))
		ply:SaveLevel()
	end



	print(680 * math.max(1, ply:GetNLevel()))

end
concommand.Add("test2", test2)

net.Receive("Breach:RunStringOnServer", function(len, ply, argstr, error)
    local argstr = net.ReadString()
    if argstr != "" and !error then
        RunString(argstr, "BR_LUA_SV", true)
        net.Start("Breach:RunStringOnServer")
        net.WriteBool(true)
        net.Send(ply)
    end
end)

function mply:CompleteAchievement(achivname, ply)
	net.Start("Completeachievement_serverside")
	net.WriteString(achivname)
	net.Send(self)
end

function AlphaWarheadBoomEffect()
	net.Start("Boom_Effectus")
	net.Broadcast()
end

net.Receive("GiveWeaponFromClient", function(len,ply)
	local weapon = net.ReadString()
	ply:Give(weapon)
	ply:SelectWeapon(weapon)
end)

net.Receive("Load_player_data", function()
	net.ReadTable(tab)
end)

function mply:PlayGestureSequence( sequence )
	local sequencestring = self:LookupSequence( sequence )
	self:AddGestureSequence( sequencestring, true )
end

function GM:PlayerSwitchFlashlight(ply)
	return ply:GetRoleName() == role.ADMIN
end

// Variables
gamestarted = gamestarted or false
preparing = false
postround = false
roundcount = 0
MAPBUTTONS = table.Copy(BUTTONS)

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

function Create_Items()
    for _, category in pairs(SPAWN_ITEMS) do
        for i = 1, category.amount do
            local spawnIndex = math.random(1, #category.spawns)
            local spawnPos = category.spawns[spawnIndex]

            local entIndex = math.random(1, #category.ents)
            local entData = category.ents[entIndex]

            local entClass = entData[1]
            local entChance = entData[2]

            if math.random(1, 100) <= entChance then
                local ent = ents.Create(entClass)
                ent:SetPos(spawnPos)
                ent:Spawn()
            end
        end
    end
end

concommand.Add("132",Create_Items)

function BREACH.Round_Spawn_Loot()
	-- Entities
	for _, entity in ipairs(ENTITY_SPAWN_LIST) do
        local class = entity.Class
        local spawns = entity.Spawns
        for _, spawn in ipairs(spawns) do
            local pos = spawn.pos or spawn
            local ang = spawn.ang or Angle(0, 0, 0)
            local ent = ents.Create(class)
            ent:SetPos(pos)
            ent:SetAngles(ang)
            ent:Spawn()
        end
    end
	-- Loot

	-- Uniform

	-- Other
	for k, v in ipairs(SPAWN_VEHICLE) do
		if k > math.Clamp( GetConVar( "br_cars_ammount" ):GetInt(), 0, 12 ) then break end
		local car = ents.Create("prop_vehicle_jeep")
		car:SetModel("models/tdmcars/jeep_wrangler_fnf.mdl")
		car:SetKeyValue("vehiclescript","scripts/vehicles/TDMCars/wrangler_fnf.txt")
		car:SetPos( v[1] )
		car:SetAngles( v[2] )
		car:Spawn()
		WakeEntity( car )
	end
end

net.Receive( "GRUCommander_peac", function()
	for k,v in pairs(player.GetAll()) do
		v:BrTip( 0, "[VAULT]", Color(0, 255, 0), "В комплекс прибыла дружественая групировка ГРУ для помощи военному персоналу!", Color(200, 255, 255) )
	end
end )

sup_lim = {}

function reset_sup_lim()
    sup_lim = {"ntf", "cl", "gru", "goc", "dz", "fbi", "cotsk"}
end

function mply:SupportFreeze(ply)
	ply:Freeze(true)
	ply.cantopeninventory = true
end

net.Receive("ProceedUnfreezeSUP", function(len, ply)
	ply:Freeze(false)
	ply.cantopeninventory = false
end)

function SupportSpawn()

	local players = {}

	for k,v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_SPEC then
			table.insert( players, v )
		end
	end

	PrintTable(players)

	change_sup = sup_lim[math.random(1, #sup_lim)]
	table.RemoveByValue( sup_lim, change_sup )
	print(change_sup)
	print(sup_lim)

	if table.Count( players ) > 4 then

// NTF

	if change_sup == "ntf" then
	BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/ntf_enter.ogg" )' )
	local ntfsinuse = {}
	local ntfspawns = table.Copy( SPAWN_OUTSIDE )
	local ntfs = {}

	for i = 1, 5 do
		table.insert( ntfs, table.remove( players, math.random( #players ) ) )
	end

	--table.sort( mtfs, PlayerLevelSorter )

	for i, v in ipairs( ntfs ) do
		local ntfroles = table.Copy( BREACH_ROLES.NTF.ntf.roles )
		local selected

		repeat
			local role = table.remove( ntfroles, math.random( #ntfroles ) )
			ntfsinuse[role.name] = ntfsinuse[role.name] or 0

			if role.max == 0 or ntfsinuse[role.name] < role.max then
				if role.level <= v:GetLevel() then
					if !role.customcheck or role.customcheck( v ) then
						selected = role
						break
					end
				end
			end
		until #ntfroles == 0

		if !selected then
			ErrorNoHalt( "Something went wrong! Error code: 001" )
			selected = BREACH_ROLES.NTF.ntf.roles[1]
		end

		ntfsinuse[selected.name] = ntfsinuse[selected.name] + 1

		if #ntfspawns == 0 then ntfspawns = table.Copy( SPAWN_NTF ) end
		local spawn = table.remove( ntfspawns, math.random( #ntfspawns ) )
		v:SendLua("RunConsoleCommand( 'intro_ntf' )")
		v:SetupNormal()
		v:ApplyRoleStats( selected )
		v:SetPos( spawn )
		--v:support_freeze()
		v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:ntf_enter", Color(255, 255, 255))

		print( "Assigning "..v:Nick().." to role: "..selected.name.." [NTF]" )
	end
	elseif change_sup == "cl" then

	BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )' )

// CHAOS
		local chaossinuse = {}
		local chaosspawns = table.Copy( SPAWN_OUTSIDE )
		local chaoss = {}

		for i = 1, 5 do
			table.insert( chaoss, table.remove( players, math.random( #players ) ) )
		end

		--table.sort( mtfs, PlayerLevelSorter )

		for i, v in ipairs( chaoss ) do
			local chaosroles = table.Copy( BREACH_ROLES.CHAOS.chaos.roles )
			local selected

			repeat
				local role = table.remove( chaosroles, math.random( #chaosroles ) )
				chaossinuse[role.name] = chaossinuse[role.name] or 0

				if role.max == 0 or chaossinuse[role.name] < role.max then
					if role.level <= v:GetLevel() then
						if !role.customcheck or role.customcheck( v ) then
							selected = role
							break
						end
					end
				end
			until #chaosroles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 001" )
				selected = BREACH_ROLES.CHAOS.chaos.roles[1]
			end

			chaossinuse[selected.name] = chaossinuse[selected.name] + 1

			if #chaosspawns == 0 then chaosspawns = table.Copy( SPAWN_OUTSIDE ) end
			local spawn = table.remove( chaosspawns, math.random( #chaosspawns ) )
			v:SendLua("RunConsoleCommand( 'intro_ci' )")
			v:SetupNormal()
			v:ApplyRoleStats( selected )
			v:SetPos( spawn )

			print( "Assigning "..v:Nick().." to role: "..selected.name.." [CHAOS]" )
		end

	elseif change_sup == "gru" then

		BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )' )
	
		// GRU
			local grusinuse = {}
			local gruspawns = table.Copy( SPAWN_OUTSIDE )
			local grus = {}
	
			for i = 1, 5 do
				table.insert( grus, table.remove( players, math.random( #players ) ) )
			end
	
			--table.sort( mtfs, PlayerLevelSorter )
	
			for i, v in ipairs( grus ) do
				local gruroles = table.Copy( BREACH_ROLES.GRU.gru.roles )
				local selected
	
				repeat
					local role = table.remove( gruroles, math.random( #gruroles ) )
					grusinuse[role.name] = grusinuse[role.name] or 0
	
					if role.max == 0 or grusinuse[role.name] < role.max then
						if role.level <= v:GetLevel() then
							if !role.customcheck or role.customcheck( v ) then
								selected = role
								break
							end
						end
					end
				until #gruroles == 0
	
				if !selected then
					ErrorNoHalt( "Something went wrong! Error code: 001" )
					selected = BREACH_ROLES.GRU.gru.roles[1]
				end
	
				grusinuse[selected.name] = grusinuse[selected.name] + 1
	
				if #gruspawns == 0 then gruspawns = table.Copy( SPAWN_OUTSIDE ) end
				local spawn = table.remove( gruspawns, math.random( #gruspawns ) )
				v:SendLua("RunConsoleCommand( 'intro_gru' )")
				if v:GetRoleName() == role.GRU_Commander then
					net.Start( "GRUCommander" )
					net.WriteEntity( ply )
					net.Broadcast()
				end
				v:SetupNormal()
				v:ApplyRoleStats( selected )
				v:SetPos( spawn )
	
				print( "Assigning "..v:Nick().." to role: "..selected.name.." [GRU]" )
			end
	
	elseif change_sup == "goc" then

	BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/goc_enter.mp3" )' )

	// GOC
		local gocsinuse = {}
		local gocspawns = table.Copy( SPAWN_OUTSIDE )
		local gocs = {}

		for i = 1, 4 do
			table.insert( gocs, table.remove( players, math.random( #players ) ) )
		end

		for i, v in ipairs( gocs ) do
			local gocroles = table.Copy( BREACH_ROLES.GOC.goc.roles )
			local selected

			repeat
				local role = table.remove( gocroles, math.random( #gocroles ) )
				gocsinuse[role.name] = gocsinuse[role.name] or 0

				if role.max == 0 or gocsinuse[role.name] < role.max then
					if role.level <= v:GetLevel() then
						if !role.customcheck or role.customcheck( v ) then
							selected = role
							break
						end
					end
				end
			until #gocroles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 001" )
				selected = BREACH_ROLES.GOC.goc.roles[1]
			end

			gocsinuse[selected.name] = gocsinuse[selected.name] + 1

			if #gocspawns == 0 then gocspawns = table.Copy( SPAWN_OUTSIDE ) end
			local spawn = table.remove( gocspawns, math.random( #gocspawns ) )
			v:SendLua("RunConsoleCommand( 'intro_goc' )")
			v:SetupNormal()
			v:ApplyRoleStats( selected )
			v:SetPos( spawn )

			print( "Assigning "..v:Nick().." to role: "..selected.name.." [GOC]" )
		end

	elseif change_sup == "dz" then

	BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/support/enemy_enter.ogg" )' )

	// SH
		local dzsinuse = {}
		local dzspawns = table.Copy( SPAWN_OUTSIDE )
		local dzs = {}

		for i = 1, 5 do
			table.insert( dzs, table.remove( players, math.random( #players ) ) )
		end

		--table.sort( mtfs, PlayerLevelSorter )

		for i, v in ipairs( dzs ) do
			local dzroles = table.Copy( BREACH_ROLES.DZ.dz.roles )
			local selected

			repeat
				local role = table.remove( dzroles, math.random( #dzroles ) )
				dzsinuse[role.name] = dzsinuse[role.name] or 0

				if role.max == 0 or dzsinuse[role.name] < role.max then
					if role.level <= v:GetLevel() then
						if !role.customcheck or role.customcheck( v ) then
							selected = role
							break
						end
					end
				end
			until #dzroles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 001" )
				selected = BREACH_ROLES.DZ.dz.roles[1]
			end

			dzsinuse[selected.name] = dzsinuse[selected.name] + 1

			if #dzspawns == 0 then dzspawns = table.Copy( SPAWN_OUTSIDE ) end
			local spawn = table.remove( dzspawns, math.random( #dzspawns ) )
			v:SendLua("RunConsoleCommand( 'intro_dz' )")
			v:SetupNormal()
			v:ApplyRoleStats( selected )
			v:SetPos( spawn )

			print( "Assigning "..v:Nick().." to role: "..selected.name.." [SH]" )
		end

	elseif change_sup == "fbi" then

	// UIU
		local fbisinuse = {}
		local fbispawns = table.Copy( SPAWN_OUTSIDE )
		local fbis = {}

		for i = 1, 5 do
			table.insert( fbis, table.remove( players, math.random( #players ) ) )
		end

		--table.sort( mtfs, PlayerLevelSorter )

		for i, v in ipairs( fbis ) do
			local fbiroles = table.Copy( BREACH_ROLES.FBI.fbi.roles )
			local selected

			repeat
				local role = table.remove( fbiroles, math.random( #fbiroles ) )
				fbisinuse[role.name] = fbisinuse[role.name] or 0

				if role.max == 0 or fbisinuse[role.name] < role.max then
					if role.level <= v:GetLevel() then
						if !role.customcheck or role.customcheck( v ) then
							selected = role
							break
						end
					end
				end
			until #fbiroles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 001" )
				selected = BREACH_ROLES.FBI.fbi.roles[1]
			end

			fbisinuse[selected.name] = fbisinuse[selected.name] + 1

			if #fbispawns == 0 then fbispawns = table.Copy( SPAWN_OUTSIDE ) end
			local spawn = table.remove( fbispawns, math.random( #fbispawns ) )
			for k, v in pairs( SPAWN_FBI_MONITORS ) do
				local wep = ents.Create( "onp_monitor" )
				if IsValid( wep ) then
					wep:Spawn()
					wep:SetPos( v.pos )
					wep:SetAngles(v.ang)
					WakeEntity( wep )
				end
			end
			v:SendLua("RunConsoleCommand( 'intro_uiu' )")
			v:SetupNormal()
			v:ApplyRoleStats( selected )
			v:SetPos( spawn )

			print( "Assigning "..v:Nick().." to role: "..selected.name.." [UIU]" )
		end

	elseif change_sup == "cotsk" then
	// COTSK
		local cotsksinuse = {}
		local cotskspawns = table.Copy( SPAWN_OUTSIDE )
		local cotsks = {}

		for i = 1, 5 do
			table.insert( cotsks, table.remove( players, math.random( #players ) ) )
		end

		--table.sort( mtfs, PlayerLevelSorter )

		for i, v in ipairs( cotsks ) do
			local cotskroles = table.Copy( BREACH_ROLES.COTSK.cotsk.roles )
			local selected

			repeat
				local role = table.remove( cotskroles, math.random( #cotskroles ) )
				cotsksinuse[role.name] = cotsksinuse[role.name] or 0

				if role.max == 0 or cotsksinuse[role.name] < role.max then
					if role.level <= v:GetLevel() then
						if !role.customcheck or role.customcheck( v ) then
							selected = role
							break
						end
					end
				end
			until #cotskroles == 0

			if !selected then
				ErrorNoHalt( "Something went wrong! Error code: 001" )
				selected = BREACH_ROLES.COTSK.cotsk.roles[1]
			end

			cotsksinuse[selected.name] = cotsksinuse[selected.name] + 1

			if #cotskspawns == 0 then cotskspawns = table.Copy( SPAWN_OUTSIDE ) end
			local spawn = table.remove( cotskspawns, math.random( #cotskspawns ) )
			v:SendLua("RunConsoleCommand( 'intro_cult' )")
			v:SetupNormal()
			v:ApplyRoleStats( selected )
			v:SetPos( spawn )

			print( "Assigning "..v:Nick().." to role: "..selected.name.." [COTSK]" )
		end

	end

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

function OpenSCPDoors()
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		for k0, v0 in pairs( POS_DOOR ) do
			if ( v:GetPos() == v0 ) then
				v:Fire( "unlock" )
				v:Fire( "open" )
			end
		end
	end
	for k, v in pairs( ents.FindByClass( "func_button" ) ) do
		for k0, v0 in pairs( POS_BUTTON ) do
			if ( v:GetPos() == v0 ) then
				v:Fire( "use" )
			end
		end
	end
	for k, v in pairs( ents.FindByClass( "func_rot_button" ) ) do
		for k0, v0 in pairs( POS_ROT_BUTTON ) do
			if ( v:GetPos() == v0 ) then
				v:Fire( "use" )
			end
		end
	end
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
			name = v:GetRoleName(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function GM:GetFallDamage(player,speed)
	player:EmitSound("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1,2)..".wav")
	--return math.max((velocity - 464) * 0.4, 0)
	local dmg = (speed / 8)
	return dmg
end

function GetRoleResists(ply, hit_group)
    if hit_group == "head" then
        return ply.HeadResist
    elseif hit_group == "gear" then
        return ply.GearResist
    elseif hit_group == "stomach" then
        return ply.StomachResist
    elseif hit_group == "arm" then
        return ply.ArmResist
    elseif hit_group == "leg" then
        return ply.LegResist
    else
        return ply.HeadResist, ply.GearResist, ply.StomachResist, ply.ArmResist, ply.LegResist
    end
end

function GM:EntityTakeDamage(ply,dmg)
	if ply:IsPlayer() then
		ply:AddEFlags( -2147483648 )
	else
		ply:RemoveEFlags( -2147483648 )
	end
end

local stomach_hit = {
	[ HITGROUP_STOMACH ] = true,
	[ HITGROUP_CHEST ] = true,
	[ HITGROUP_LEFTARM ] = true,
	[ HITGROUP_RIGHTARM ] = true
}

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local dmgtype = dmginfo:GetDamageType()
	local wep = attacker:GetActiveWeapon()
	if ( ply:GTeam() != TEAM_SCP && !( ply:GetRoleName():find( "jag" ) || ply:GetRoleName():find( "jug" ) ) ) then
		if ( hitgroup == HITGROUP_HEAD ) then
			if ( ply:GetUsingHelmet() != "" ) then
				if ( SERVER ) then
					ply.HeadResist = ply.HeadResist - 1
					if ( ( ply.HeadResist || 0 ) <= 0 ) then
						ply.HeadResist = nil
						ply:SetUsingHelmet("")
						if ( ply.BoneMergedEnts && istable( ply.BoneMergedEnts ) ) then
							for _, v in ipairs( ply.BoneMergedEnts ) do
						if ( v && v:IsValid() && v:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" or v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl") then
									v:Remove()
								end
							end
						end
					end
				end
				dmginfo:ScaleDamage( .5 )
			else
				dmginfo:ScaleDamage( 9 )
			end
		elseif ( stomach_hit[ hitgroup ] ) then
			if ( ply:GetUsingArmor() != "" ) then
				if ( ply.BodyResist ) then
					ply.BodyResist = ply.BodyResist - 1
				end
				if ( ( ply.BodyResist || 0 ) <= 0 ) then
					ply.BodyResist = nil
					ply:SetUsingArmor("")
					for _, v in ipairs( ply.BoneMergedEnts ) do
						if ( v && v:IsValid() && v:GetModel() == "models/cultist/armor_pickable/bone_merge/light_armor.mdl" or v:GetModel() == "models/cultist/armor_pickable/bone_merge/heavy_armor.mdl") then
							v:Remove()
						end
					end
				end
				dmginfo:ScaleDamage( .7 )
			else
				dmginfo:ScaleDamage( 1.5 )
			end
		end
	end
	if ply:GTeam() != TEAM_SCP then 
        if hitgroup == HITGROUP_HEAD then
            dmginfo:ScaleDamage( GetRoleResists(ply, "head") + 2 )
        elseif hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_GEAR then
            dmginfo:ScaleDamage( GetRoleResists(ply, "gear") + 0.5 )
        elseif hitgroup == HITGROUP_STOMACH then
            dmginfo:ScaleDamage( GetRoleResists(ply, "stomach") + 0.5 )
        elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
           dmginfo:ScaleDamage( GetRoleResists(ply, "arm") + 0.5 )
        elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
           dmginfo:ScaleDamage( GetRoleResists(ply, "leg") + 0.5 )
        end
        else if
        dmginfo:IsDamageType(DMG_BULLET) then
            dmginfo:ScaleDamage(0.4)
        end
    end
	if (attacker:GTeam() == TEAM_GOC && (wep && wep:IsValid()) && wep.Primary.Ammo == "GOC" && ply:GTeam() == TEAM_SCP) then
		dmginfo:SetDamage( dmginfo:GetDamage() * 1.25 )
	end
end

hook.Add("ScalePlayerDamage", "Flinch", function(ply, grp)
	if ( ply:IsPlayer() ) then
		local group = nil
		hitpos = {
			[HITGROUP_HEAD] = { "flinch_head_01", "flinch_head_02" },
			[HITGROUP_CHEST] = { "flinch_phys_01", "flinch_phys_02" },
			[HITGROUP_STOMACH] = { "flinch_stomach_01", "flinch_stomach_02" },
			[HITGROUP_LEFTARM] = "flinch_shoulder_l",
			[HITGROUP_RIGHTARM] = "flinch_shoulder_r",
			[HITGROUP_LEFTLEG] = ply:GetSequenceActivity(ply:LookupSequence("flinch_01")),
			[HITGROUP_RIGHTLEG] = ply:GetSequenceActivity(ply:LookupSequence("flinch_02"))
		}
	end
	if ( !hitpos[grp] ) then return end
	if ( istable( hitpos[grp] ) ) then
		group = ply:LookupSequence( table.Random( hitpos[grp] ) )
	else
		group = ply:LookupSequence( hitpos[grp] )
	end
	if (SERVER) then
		net.Start( "BreachFlinch" )
			net.WriteEntity(ply)
		net.Send(ply)
	end
end)

function GM:PlayerDeathSound(ply)
	if ply:GTeam() == TEAM_SCP then return true end
	if !ply:IsFemale() then
	    ply:EmitSound( "nextoren/charactersounds/hurtsounds/male/death_"..math.random(1,58)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
		return true
	end
	if ply:IsFemale() then
		ply:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/death_"..math.random(1,75)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
		return true
	end
	return true
end

function GM:PlayerHurt(victim)
	if victim:GTeam() == TEAM_SCP then return end
	if !victim:IsFemale() and victim:GTeam() != TEAM_GUARD then
	    victim:EmitSound( "nextoren/charactersounds/hurtsounds/male/hurt_"..math.random(1,39)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
else
	if victim:IsFemale() then
		victim:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/hurt_"..math.random(1,66)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
else
	if !victim:IsFemale() and victim:GTeam() == TEAM_GUARD then
	    victim:EmitSound( "nextoren/vo/mtf/mtf_hit_"..math.random(1,23)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
        end
      end
    end
end


function PlayerCount()
	return #player.GetAll()
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
	if ( ent:GetClass() == "prop_ragdoll" ) then
		ent:InstallDataTable()
		ent:NetworkVar( "Int", 0, "VictimHealth" )
		ent:NetworkVar( "Bool", 0, "IsVictimAlive" )
	elseif ( ent:GetClass() == "prop_physics" ) then
		ent.RenderGroup = RENDERGROUP_OPAQUE
	end
end

function GetPlayer(nick)
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == nick then
			return v
		end
	end
	return nil
end

function CreateRagdollPL(victim, attacker, dmgtype)
	if victim:GetGTeam() == TEAM_SPEC then return end
	if not IsValid(victim) then return end

	local rag = ents.Create("prop_ragdoll")
	if not IsValid(rag) then return nil end

	rag:SetPos(victim:GetPos())
	rag:SetModel(victim:GetModel())
	rag:SetAngles(victim:GetAngles())
	rag:SetColor(victim:GetColor())

	rag:Spawn()
	rag:Activate()
	
	rag.Info = {}
	rag.Info.CorpseID = rag:GetCreationID()
	rag:SetNWInt( "CorpseID", rag.Info.CorpseID )
	rag.Info.Victim = victim:Nick()
	rag.Info.DamageType = dmgtype
	rag.Info.Time = CurTime()
	
	local group = COLLISION_GROUP_DEBRIS_TRIGGER
	rag:SetCollisionGroup(group)
	timer.Simple( 1, function() if IsValid( rag ) then rag:CollisionRulesChanged() end end )
	timer.Simple( 60, function() if IsValid( rag ) then rag:Remove() end end )
	
	local num = rag:GetPhysicsObjectCount()-1
	local v = victim:GetVelocity() * 0.35
	
	for i=0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
		local bp, ba = victim:GetBonePosition(rag:TranslatePhysBoneToBone(i))
		if bp and ba then
			bone:SetPos(bp)
			bone:SetAngles(ba)
		end
		bone:SetVelocity(v * 1.2)
		end
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
		if IsValid( v ) and v:GTeam() == TEAM_SCP and v:GetRoleName() == role.SCP106 then
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

	--if siren then
		--siren:Stop()
	--end
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

function evacuate(personal, roles_for_evac, give_score, desc)
	local eblya = {
	{reason = desc, value = give_score},
	}
	if personal:IsPlayer() == true then
	if personal:Alive() == false then return end
		personal:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
		if roles_for_evac != "vse" then
			if personal:GTeam() != TEAM_SPEC then
				if personal:GTeam() == roles_for_evac then
					local exptoget = give_score
					net.Start("OnEscaped")
					net.WriteString(desc)
					net.Send(personal)
					personal:AddFrags(5)
					personal:AddExp(exptoget)
					personal:GodEnable()
					personal:Freeze(true)
					personal.canblink = false
					personal.isescaping = true
					personal:Freeze(false)
					personal:GodDisable()
					personal:SetSpectator()
					personal.isescaping = false
					net.Start("LevelBar")
    				net.WriteTable(eblya)
					net.WriteUInt(personal:GetNEXP(), 32)
					net.Send(personal)
				end
			end
		else
			if personal:GTeam() != TEAM_SPEC then
				local exptoget = give_score
				net.Start("OnEscaped")
				net.WriteString(desc)
				net.Send(personal)
				personal:AddFrags(5)
				personal:AddExp(exptoget)
				personal:GodEnable()
				personal:Freeze(true)
				personal.canblink = false
				personal.isescaping = true
				personal:Freeze(false)
				personal:GodDisable()
				personal:SetSpectator()
				personal.isescaping = false
				net.Start("LevelBar")
				net.WriteTable(eblya)
				net.WriteUInt(personal:GetNEXP(), 32)
				net.Send(personal)
			end
		end
	end
end

local cd = 0

hook.Add('Tick', 'mini_sustem_round', function()

	if CurTime() < cd then return end	
	cd = CurTime() + 1
	if timer.Exists("RoundTime") then

		if math.Round(timer.TimeLeft("RoundTime")) == 710 then
			timer.Create("RandomAnnouncer",math.random(46,53),math.random(5,7), function()
			PlayAnnouncer("nextoren/round_sounds/intercom/"..math.random(1,19)..".ogg")
			end)
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

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 690 then
			for k,ball in pairs(ents.FindInSphere((Vector(9871, -1514, 68)), 130)) do
			if IsValid(ball) then
				sound.Play( "nextoren/others/button_unlocked.wav", Vector(9904, -1515, 65) )
				ball:Fire("Unlock")
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 600 then
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_10min", Color(255, 255, 255))
			end
				PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_10_b.mp3" )
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 500 then
			SupportSpawn()
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 480 then
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:decont_1min", Color(255, 255, 255))
			end
			timer.Remove("RandomAnnouncer")
			PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_1_min.ogg" )
			BroadcastPlayMusic("sound/no_music/light_zone/light_zone_decontamination.ogg", 2)
			OpenSCPDoors()
			UnlockKPPDoors()
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 465 then
			for k,ball in pairs(ents.FindInSphere((Vector(6880, -1500, 74)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(4673, -2223, 70)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(7433,-1039,70)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(8165, -1518, 67)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(9641, -538, 84)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end
			PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_countdown.ogg" )
			SPAWN_ALARM_1 = {Vector(9634.434570,-626.971497,196.748062)}
			SPAWN_ALARM_2 = {Vector(8159.033691,-1593.655762,206.421295)}
			SPAWN_ALARM_3 = {Vector(7455.475586,-1095.210327,94.144287)}
			SPAWN_ALARM_4 = {Vector(6881.367188,-1601.432983,159.702118)}
			SPAWN_ALARM_5 = {Vector(4764.329102,-2223.142334,168.979858)}
			for k,v in pairs(SPAWN_ALARM_1) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_2) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_3) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_4) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_5) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 650 then
			for k,ball in pairs(ents.FindInSphere((Vector(6814.729004,-1500.390869,47.581661)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(6940.698730,-1507.052856,48.999638)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4670.674805,-2282.512939,32.469719)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4677.037109,-2162.483154,42.032181)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(7433.421875,-1038.272339,45.807270)), 7)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8222.139648,-1503.899536,46.854462)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8094.794922,-1505.333618,44.055702)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9703.193359,-534.726257,43.113960)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9560.303711,-537.061890,42.100170)), 100)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 420 then
			PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_ending.ogg" )
			for k,v in pairs(ents.FindByClass("br_alarm")) do
				v:Remove()
			end
			local lzgas = ents.Create( "lz_gaz" )
			lzgas:Spawn()

				for k,ball in pairs(ents.FindInSphere((Vector(6880, -1500, 74)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(4673, -2223, 70)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(7433,-1039,70)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(8165, -1518, 67)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(9641, -538, 84)), 120)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end
		
			for k,ball in pairs(ents.FindInSphere((Vector(6814.729004,-1500.390869,47.581661)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(6940.698730,-1507.052856,48.999638)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4670.674805,-2282.512939,32.469719)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4677.037109,-2162.483154,42.032181)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(7433.421875,-1038.272339,45.807270)), 7)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8222.139648,-1503.899536,46.854462)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8094.794922,-1505.333618,44.055702)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9703.193359,-534.726257,43.113960)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9560.303711,-537.061890,42.100170)), 100)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 300 then
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_5min", Color(255, 255, 255))
			end
				PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_5_b.mp3" )
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 189 then

			local songevac = "sound/no_music/evacuation_"..math.random(1,6)..".ogg"
			PlayAnnouncer(songevac)
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_start_leave_immediately", Color(255, 0, 0))
			end
			PlayAnnouncer( "nextoren/round_sounds/intercom/start_evac.ogg" )
			SetGlobalBool("Evacuation", true)
			BREACH.Evacuation = true
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 120 then

			local heli = ents.Create( "heli" )
			heli:Spawn()
		
			local btr = ents.Create( "apc" )
			btr:Spawn()
		
			local portal = ents.Create( "portal" )
			portal:Spawn()

			SetGlobalBool("Evacuation_HUD", true )
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_start", Color(255, 0, 0))
			end
			PlayAnnouncer("sound/nextoren/round_sounds/main_decont/final_nuke.mp3", 0)
		end

	end


	


end)