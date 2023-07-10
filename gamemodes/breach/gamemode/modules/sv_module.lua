local mply = FindMetaTable( "Player" )

function spawn_ents()
end

concommand.Add("loot", spawn_ents)

function test1()
	SetGlobalInt("EnoughPlayersCountDownStart", 11)
	SetGlobalBool("EnoughPlayersCountDown", true)
end
concommand.Add("test", test1)
function test2()
	SetGlobalBool("EnoughPlayersCountDown", false)
end
concommand.Add("test2", test2)

function mply:CompleteAchievement(achivname, ply)
	net.Start("Completeachievement_serverside")
	net.WriteString(achivname)
	net.Send(self)
end

function AlphaWarheadBoomEffect()
	net.Start("Boom_Effectus")
	net.Broadcast()
end

net.Receive("GiveWeaponFromClient", function()
	net.ReadString()
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
	WakeEntity( wep )
end
local wep = ents.Create( "obr_call" )
if IsValid( wep ) then
	wep:Spawn()
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

for k, v in pairs( SPAWN_WEAPONSTATION ) do
	local wep = ents.Create( "ent_weaponstation" )
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

net.Receive( "GRUCommander_peac", function()
	for k,v in pairs(player.GetAll()) do
		v:BrTip( 0, "[VAULT]", Color(0, 255, 0), "В комплекс прибыла дружественая групировка ГРУ для помощи военному персоналу!", Color(200, 255, 255) )
	end
end )

sup_lim = {}

function reset_sup_lim()
    sup_lim = {"ntf", "cl", "gru", "goc", "dz", "fbi", "cotsk"}
end

function mply:support_freeze(ply)
	ply:Freeze(true)
	ply.cantopeninventory = true
end

net.Receive("ProceedUnfreezeSUP", function(ply)
	ply:Freeze(false)
	ply.cantopeninventory = true
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
		v:support_freeze()
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

		for i = 1, 5 do
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

function GetAlivePlayers()
	local plys = {}
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() or v:GetRoleName() == role.SCP076 then
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
			name = v:GetRoleName(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function GM:GetFallDamage( ply, speed )
	ply:EmitSound("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1,2)..".wav")
	return ( speed / 6.4 )
end

function GM:EntityTakeDamage(target,dmginfo)
	if target:IsPlayer() then
	   target:AddEFlags( -2147483648 )
	else
	   target:RemoveEFlags( -2147483648 )
	end
end

function GM:PlayerDeathSound(ply)
	if ply:GTeam() == TEAM_SCP or ply:GetRoleName() == role.Spectator then return end
	if !ply:IsFemale() then
	    ply:EmitSound( "nextoren/charactersounds/hurtsounds/male/death_"..math.random(1,58)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
	end
	if ply:IsFemale() then
		ply:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/death_"..math.random(1,75)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
	end
	return true
end

function GM:PlayerHurt(victim)
	if victim:GTeam() == TEAM_SCP or victim:GetRoleName() == role.Spectator then return end
	if !victim:IsFemale() then
	    victim:EmitSound( "nextoren/charactersounds/hurtsounds/male/hurt_"..math.random(1,39)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
	end
	if victim:IsFemale() then
		victim:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/hurt_"..math.random(1,66)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
	end
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

CreateConVar("sv_manualweaponpickup", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Is manual weapon pickup enabled?")
CreateConVar("sv_manualweaponpickup_aim", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Must the player be aiming at the weapon?")
CreateConVar("sv_manualweaponpickup_auto", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Holding use key picks up weapons automatically.")
CreateConVar("sv_manualweaponpickup_autodraw", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Player will automatically draw a given weapon.")
CreateConVar("sv_manualweaponpickup_weaponlimit", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "How many weapons a player can hold at once.  (0 = No Limit)")
CreateConVar("sv_manualweaponpickup_weaponlimitswap", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Drop current weapon to pick up another if player is holding too many.")

local clr_red = Color( 255, 0, 0 )
local mply = FindMetaTable'Player'

function mply:Give(classname)
	local ent = ents.Create(classname)
	if (!IsValid(ent)) then return end
	ent:SetPos(self:GetPos())
	ent.GiveTo = self
	ent:Spawn()
	timer.Simple(0.1, function() self:SelectWeapon(classname) end)
end

function mply:BreachGive(classname)
	local ent = ents.Create(classname)
	if (!IsValid(ent)) then return end
	ent:SetPos(self:GetPos())
	ent.GiveTo = self
	ent:Spawn()
	timer.Simple(0.1, function() self:SelectWeapon(classname) end)
end
mply._DropWeapon = mply.DropWeapon

function mply:DropWeapon(weapon)
	if (IsValid(weapon)) then
		self:_DropWeapon(weapon)
		weapon.GiveTo = nil
	end
end

local function canCarryWeapon(pl, weapon)
	local limit = GetConVar("sv_manualweaponpickup_weaponlimit"):GetInt()
	if (limit != 0 && #pl:GetWeapons() >= limit) then
		if (GetConVar("sv_manualweaponpickup_weaponlimitswap"):GetBool()) then
			if (pl.PressedUse) then
				pl.PressedUse = false
				pl:DropWeapon(pl:GetActiveWeapon())
				pl.DrawWeapon = weapon:GetClass()
				timer.Simple(0.1, function() pl:SelectWeapon(pl.DrawWeapon) end)
				return true
			end
		end
		return false
	end
	return true
end

hook.Add("PlayerCanPickupWeapon", "ManualWeaponPickup_CanPickup", function(pl, ent, key)
	if (pl.ManualWeaponPickupSpawn) then
		if (CurTime() > pl.ManualWeaponPickupSpawn) then
			if (IsValid(ent.GiveTo)) then
				if (ent.GiveTo == pl) then
					return true
				end
			end
			if (GetConVar("sv_manualweaponpickup"):GetBool()) then
				local tr = pl:GetEyeTrace()
				local wepent = tr.Entity
				if ( wepent:IsWeapon() && wepent:GetPos():DistToSqr( pl:GetPos() ) <= 6400 ) then
					local ent_class = wepent:GetClass()
				if (key == IN_USE) then
					local trent = pl:GetEyeTrace().Entity
                    if !pl:HasWeapon(trent:GetClass()) then
					pl:BrProgressBar("l:progress_wait", 1, "nextoren/gui/icons/hand.png", wepent, false)
					timer.Simple( 1, function()
					pl:EmitSound( "nextoren/charactersounds/inventory/nextoren_inventory_itemreceived.wav", 75, math.random( 98, 105 ), 1, CHAN_STATIC )
					pl.PressedUse = true
					end)
				  end
				end
					if (GetConVar("sv_manualweaponpickup_aim"):GetBool()) then
						if (pl:GetEyeTrace().Entity == ent) then
							if (!GetConVar("sv_manualweaponpickup_auto"):GetBool()) then
								if (pl.PressedUse) then
									local c = canCarryWeapon(pl, ent)
									pl.PressedUse = false
									return c
								else
									return false
								end
							else
								return canCarryWeapon(pl, ent)
							end
						else
							return false
						end
					else
						if (!GetConVar("sv_manualweaponpickup_auto"):GetBool()) then
							if (pl.PressedUse) then
								pl.PressedUse = false
								return canCarryWeapon(pl, ent)
							else
								return false
							end
						else
							return canCarryWeapon(pl, ent)
						end
					end
				else
					return false
				end
			end
		end
	end
end)

hook.Add("KeyPress", "ManualWeaponPickup_KeyPress", function(pl, key)
	local tr = pl:GetEyeTrace()
	local wepent = tr.Entity
	if ( wepent:IsWeapon() && wepent:GetPos():DistToSqr( pl:GetPos() ) <= 6400 ) then
	if (key == IN_USE) then
		local trent = pl:GetEyeTrace().Entity
		if (pl:GetMaxSlots() - pl:GetPrimaryWeaponAmount()) == 0 then pl:RXSENDNotify( "l:inventory_full" ) return end
		if pl:HasWeapon(trent:GetClass()) then pl:RXSENDNotify( "У Вас уже есть этот предмет." ) return end
		pl:BrProgressBar("l:progress_wait", 1, "nextoren/gui/icons/hand.png")
		timer.Simple( 1, function()
	    pl:EmitSound( "nextoren/charactersounds/inventory/nextoren_inventory_itemreceived.wav", 75, math.random( 98, 105 ), 1, CHAN_STATIC )
		pl.PressedUse = true
		end)
	end
end
end)

hook.Add("PlayerSpawn", "ManualWeaponPickup_PlayerSpawn", function(pl)
	pl.ManualWeaponPickupSpawn = CurTime()
end)

function evacuate(personal, roles_for_evac, give_score)
	if personal:IsPlayer() == true then
	if personal:Alive() == false then return end
	if personal:GTeam() != TEAM_SPEC then
		if personal:GTeam() == roles_for_evac then
			local exptoget = give_score
			net.Start("OnEscaped")
			net.Send(personal)
			personal:AddFrags(5)
			personal:AddExp(exptoget, true)
			personal:GodEnable()
			personal:Freeze(true)
			personal.canblink = false
			personal.isescaping = true
			personal:Freeze(false)
			personal:GodDisable()
			personal:SetSpectator()
			personal.isescaping = false
		end
	end
	end
end