util.AddNetworkString("PlayerBlink")
util.AddNetworkString("DropWeapon")
util.AddNetworkString("DropCurWeapon")
util.AddNetworkString("Change_player_settings_id")
util.AddNetworkString("RequestEscorting")
util.AddNetworkString("PrepStart")
util.AddNetworkString("RoundStart")
util.AddNetworkString("PostStart")
util.AddNetworkString("RolesSelected")
util.AddNetworkString("SendRoundInfo")
util.AddNetworkString("Sound_Random")
util.AddNetworkString("Sound_Searching")
util.AddNetworkString("Sound_Classd")
util.AddNetworkString("Sound_Stop")
util.AddNetworkString("Sound_Lost")
util.AddNetworkString("UpdateRoundType")
util.AddNetworkString("ForcePlaySound")
util.AddNetworkString("OnEscaped")
util.AddNetworkString("SlowPlayerBlink")
util.AddNetworkString("DropCurrentVest")
util.AddNetworkString("RoundRestart")
util.AddNetworkString("SpectateMode")
util.AddNetworkString("UpdateTime")
util.AddNetworkString("NameColor")
util.AddNetworkString("Effect")
util.AddNetworkString("catch_breath")
util.AddNetworkString("NTFRequest")
util.AddNetworkString("ExplodeRequest")
util.AddNetworkString("ForcePlayerSpeed")
util.AddNetworkString("ClearData")
util.AddNetworkString("Restart")
util.AddNetworkString("AdminMode")
util.AddNetworkString("ShowText")
util.AddNetworkString("PlayerReady")
util.AddNetworkString("RecheckPremium")
util.AddNetworkString("CancelPunish")
util.AddNetworkString("689")
util.AddNetworkString( "UpdateKeycard" )
util.AddNetworkString( "SendSound" )
util.AddNetworkString( "957Effect" )
util.AddNetworkString( "SCPList" )
util.AddNetworkString( "TranslatedMessage" )
util.AddNetworkString( "CameraDetect" )
util.AddNetworkString("send_country")
util.AddNetworkString("ProceedUnfreezeSUP")
util.AddNetworkString("SpecialSCIHUD")
util.AddNetworkString("Load_player_data")
util.AddNetworkString("NightvisionOn")
util.AddNetworkString("NightvisionOff")
util.AddNetworkString("CreateParticleAtPos")
util.AddNetworkString("CreateClientParticleSystem")
util.AddNetworkString("NTF_Special_1")
util.AddNetworkString("Death_Scene")
util.AddNetworkString("Breach:RunStringOnServer")
util.AddNetworkString("TargetsToNTFs")
util.AddNetworkString("GestureClientNetworking")
util.AddNetworkString("Boom_Effectus")
util.AddNetworkString("boom_round")
util.AddNetworkString("DrawMuzzleFlash")
util.AddNetworkString("BreachFlinch")
util.AddNetworkString("BreachAnnouncer")
util.AddNetworkString("SetBottomMessage")
util.AddNetworkString("ChangeRunAnimation")
util.AddNetworkString("DropAdditionalArmor")
util.AddNetworkString("Chaos_SpyAbility")
util.AddNetworkString("CreateHelicopterScene")
util.AddNetworkString("StartDeathAnimation")
util.AddNetworkString("New_SHAKYROUNDSTAT")
util.AddNetworkString("GetAchievementTable")
util.AddNetworkString("CompleteAchievement_Clientside")
util.AddNetworkString("DropBag")
util.AddNetworkString("fbi_commanderabillity")
util.AddNetworkString("IntercomStatus")
util.AddNetworkString("GiveWeaponFromClient")
util.AddNetworkString( "edit_icon_goc" )
util.AddNetworkString( "base_icon_goc" )
util.AddNetworkString( "get_icon_goc" )
util.AddNetworkString("DropBro")
util.AddNetworkString("DropHat")
util.AddNetworkString("GRUCommander")
util.AddNetworkString("GRUCommander_peac")
util.AddNetworkString("проверкаслуха:БазарНачался")
util.AddNetworkString("BreachAnnouncer")
util.AddNetworkString("camera_enter")
util.AddNetworkString("camera_swap")
util.AddNetworkString("camera_exit")
util.AddNetworkString("FirstPerson")
util.AddNetworkString("SHAKY_EndForcedAnimSync")
util.AddNetworkString("SHAKY_SetForcedAnimSync")
util.AddNetworkString("BreachAnnouncerLoud")
-- Achievements
util.AddNetworkString("GetAchievementTable")
util.AddNetworkString("OpenAchievementMenu")
util.AddNetworkString("CompleteAchievement_Clientside")
util.AddNetworkString("Completeachievement_serverside")
-- Abilities
util.AddNetworkString("Cult_SpecialistAbility")
util.AddNetworkString("GRU_CommanderAbility")
-- Utils
util.AddNetworkString("ThirdPersonCutscene2")
util.AddNetworkString("SendPrefixData")
util.AddNetworkString("Player_FullyLoadMenu")
util.AddNetworkString("Change_player_settings_id")
util.AddNetworkString("Change_player_settings")
util.AddNetworkString("111roq")

net.Receive("Load_player_data", function()
	net.ReadTable(tab)
end)

net.Receive("111roq", function()
end)

net.Receive("ProceedUnfreezeSUP", function()
end)

net.Receive("Change_player_settings_id", function(id, bool)
	net.ReadUInt(12)
	net.ReadBool(bool)
end)

local banned_sounds = {
	[ "player/pl_drown1.wav" ] = true,
	[ "player/pl_drown2.wav" ] = true,
	[ "player/pl_drown3.wav" ] = true
}

function GM:EntityEmitSound( s_table )
	if ( CLIENT ) then
		local client = LocalPlayer()
		if ( !client:GetActive() && s_table.Entity:IsPlayer() || client.NoDesc ) then return false end
	end
	if ( banned_sounds[ s_table.SoundName ] ) then return false end
end

net.Receive("Change_player_settings", function(id, int)
	net.ReadUInt(id, 12)
	net.ReadUInt(int, 32)
end)

net.Receive("SendPrefixData", function(data)
	net.ReadString(prefix)
	net.ReadBool(enabled)
	net.ReadString(color)
	net.ReadBool(rainbow)
end)

function LogTeamChangeFromBreach()
end

net.Receive( "DropWeapon", function( len, ply )
	local class = net.ReadString()
	if class then
		ply:ForceDropWeapon( class )
	end
end )

net.Receive( "CancelPunish", function( len, ply )
	if ply:IsSuperAdmin() then
		CancelVote()
	end
end )

net.Receive( "PlayerReady", function( len, ply )
	ply:SetActive( true )
	net.Start( "PlayerReady" )
		net.WriteTable( { sR, sL } )
	net.Send( ply )
	SendSCPList( ply )
end )

net.Receive( "RecheckPremium", function( len, ply )
	if ply:IsSuperAdmin() then
		for k, v in pairs( player.GetAll() ) do
			IsPremium( v, true )
		end
	end
end )

net.Receive( "SpectateMode", function( len, ply )
	/*
	if ply.ActivePlayer == true then
		if ply:Alive() and ply:Team() != TEAM_SPEC then
			ply:SetSpectator()
		end
		ply.SetActive( false )
		ply:PrintMessage(HUD_PRINTTALK, "Changed mode to spectator")
	elseif ply.ActivePlayer == false then
		ply.SetActive( true )
		ply:PrintMessage(HUD_PRINTTALK, "Changed mode to player")
	end
	CheckStart()
	*/
end)

net.Receive( "AdminMode", function( len, ply )
	if ply:IsSuperAdmin() then
		ply:ToggleAdminModePref()
	end
end)

net.Receive( "RoundRestart", function( len, ply )
	if ply:IsSuperAdmin() then
		RoundRestart()
	end
end)

net.Receive( "Restart", function( len, ply )
	if ply:IsSuperAdmin() then
		RestartGame()
	end
end)

net.Receive( "Sound_Random", function( len, ply )
	PlayerNTFSound("Random"..math.random(1,4)..".ogg", ply)
end)

net.Receive( "Sound_Searching", function( len, ply )
	PlayerNTFSound("Searching"..math.random(1,6)..".ogg", ply)
end)

net.Receive( "Sound_Classd", function( len, ply )
	PlayerNTFSound("ClassD"..math.random(1,4)..".ogg", ply)
end)

net.Receive( "Sound_Stop", function( len, ply )
	PlayerNTFSound("Stop"..math.random(2,6)..".ogg", ply)
end)

net.Receive( "Sound_Lost", function( len, ply )
	PlayerNTFSound("TargetLost"..math.random(1,3)..".ogg", ply)
end)

net.Receive( "DropCurrentVest", function( len, ply )
	if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP or ply:GetRoleName() == role.SCP9571 ) and ply:Alive() then
		if ply.UsingArmor != nil then
			ply:UnUseArmor()
		end
	end
end)

net.Receive( "RequestEscorting", function( len, ply )
	if ply:GTeam() == TEAM_GUARD then
		CheckEscortMTF(ply)
	elseif ply:GTeam() == TEAM_CHAOS then
		CheckEscortChaos(ply)
	end
end)

net.Receive( "ClearData", function( len, ply )
	if not(ply:IsSuperAdmin()) then return end
	local com = net.ReadString()
	if com == "&ALL" then
		for k, v in pairs( player:GetAll() ) do
			clearData( v )
		end
	else
		for k, v in pairs( player:GetAll() ) do
			if v:GetName() == com then
				clearData( v )
				return
			end
		end
		if IsValidSteamID( com ) then
			clearDataID( com )
		end
	end
end)

function clearData( ply )
	ply:SetPData( "breach_exp", 0 )
	ply:SetNEXP( 0 )
	ply:SetPData( "breach_level", 0 )
	ply:SetNLevel( 0 )
end

function clearDataID( id64 )
	util.RemovePData( id64, "breach_exp" )
	util.RemovePData( id64, "breach_level" )
end

function IsValidSteamID( id )
	if tonumber( id ) then
		return true
	end
	return false
end

function GM:PlayerDeathSound(ply)
	ply:EmitSound( "beams/beamstart5.wav", SNDLVL_NORM, math.random( 70, 126 ) ) -- plays the sound with normal sound levels, and a random pitch between 70 and 126
	return true -- we don't want the default sound!
end

function GM:PlayerHurt(victim, attacker)
    if ( attacker:IsPlayer() ) then
        victim:ChatPrint("You were attacked by : " .. attacker:Nick())
    end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if ( hitgroup == HITGROUP_HEAD ) then
	   dmginfo:ScaleDamage( 2 ) // More damage when we're shot in the head
	 else
	   dmginfo:ScaleDamage( 0.50 )  // Less damage when shot anywhere else
	end
end

--net.Receive( "RequestGateA", function( len, ply )
--	RequestOpenGateA(ply)
--end)

net.Receive( "NTFRequest" , function( len, ply )
	if ply:IsSuperAdmin() then
		SpawnNTFS()
	end
end )

net.Receive( "ExplodeRequest", function( len, ply )
	if ply:GetRoleName() == role.MTFNTF or ply:GetRoleName() == role.CHAOS then
		explodeGateA( ply )
	end
end )

net.Receive( "DropCurWeapon", function( len, ply )
	local wep = ply:GetActiveWeapon()
	if ply:GTeam() == TEAM_SPEC then return end
	if IsValid(wep) and wep != nil and IsValid(ply) then
		local atype = wep:GetPrimaryAmmoType()
		if atype > 0 then
			wep.SavedAmmo = wep:Clip1()
		end
		
		if wep:GetClass() == nil then return end
		if wep.droppable != nil then
			if wep.droppable == false then return end
		end
		ply:DropWeapon( wep )
		ply:ConCommand( "lastinv" )
	end
end )

/*function dofloor(num, yes)
	if yes then
		return math.floor(num)
	end
	return num
end*/

/*function GetRoleTable(all)
	local classds = 0
	local mtfs = 0
	local researchers = 0
	local scps = 0
	if all < 8 then
		scps = 1
		all = all - 1
	elseif all > 7 and all < 16 then
		scps = 2
		all = all - 2
	elseif all > 15 then
		scps = 3
		all = all - 3
	end
	//mtfs = math.Round(all * 0.299)
	local mtfmul = 0.33
	if all > 12 then
		mtfmul = 0.3
	elseif all > 22 then
		mtfmul = 0.28
	end
	mtfs = math.Round(all * mtfmul)
	all = all - mtfs
	researchers = math.floor(all * 0.42)
	all = all - researchers
	classds = all
	//print(scps .. "," .. mtfs .. "," .. classds .. "," .. researchers .. "," .. chaosinsurgency)
	/*
	print("scps: " .. scps)
	print("mtfs: " .. mtfs)
	print("classds: " .. classds)
	print("researchers: " .. researchers)
	print("chaosinsurgency: " .. chaosinsurgency)
	*/
	/*return {scps, mtfs, classds, researchers}
end*/

function GetRoleTableCustom(all, scps, p_mtf, p_res)
	local classds = 0
	local mtfs = 0
	local researchers = 0
	all = all - scps
	mtfs = math.Round(all * p_mtf)
	all = all - mtfs
	researchers = math.floor(all * p_res)
	all = all - researchers
	classds = all
	return {scps, mtfs, classds, researchers}
end

cvars.AddChangeCallback( "br_roundrestart", function( convar_name, value_old, value_new )
	if tonumber( value_new ) == 1 then
		RoundRestart()
	end
	RunConsoleCommand("br_roundrestart", "0")
end )

function SetupAdmins( players )
	for k, v in pairs( players ) do
		if v.admpref then
			if !v.AdminMode then
				v:ToggleAdminMode()
			end
			v:SetupAdmin()
		elseif v.AdminMode then
			v:ToggleAdminMode()
		end
	end
end

function GiveExp()
	for k, v in pairs( player.GetAll() ) do
		local exptogive = v:Frags() * 50
		v:SetFrags( 0 )
		if exptogive > 0 then
			v:AddExp( exptogive, true )
			v:PrintMessage( HUD_PRINTTALK, "You have recived "..exptogive.." experience for "..(exptogive / 50).." points" )
		end
	end
end

activevote = false
suspectname = ""
activesuspect = nil
activevictim = nil
votepunish = 0
voteforgive = 0
specpunish = 0
specforgive = 0

function PunishVote( ply, victim )
	if GetConVar( "br_allow_punish" ):GetInt() == 0 then return end
	if ply == victim then return end
	if activevote then
		EndPunishVote()
		timer.Destroy( "PunishEnd" )
	end
	net.Start( "ShowText" )
		net.WriteString( "text_punish" )
		net.WriteString( ply:GetName() )
	net.Broadcast()
	activevote = true
	votepunish = 0
	voteforgive = 0
	specpunish = 0
	specforgive = 0
	suspectname = ply:GetName()
	activesuspect = ply:SteamID64()
	activevictim = victim:SteamID64()
	timer.Create( "PunishEnd", GetConVar( "br_punishvote_time" ):GetInt(), 1, function()
		EndPunishVote()
	end )
end

function EndPunishVote()
	local specvotedforgive = math.Round( 3 * specforgive / ( specpunish + specforgive ) )
	if tostring( specvotedforgive ) != "nan" then
		voteforgive = voteforgive + specvotedforgive
		votepunish = votepunish + ( 3 - specvotedforgive )
	end
	print( "Player: "..suspectname, " Forgive: "..voteforgive, "Punish: "..votepunish )
	activevote = false
	for k,v in pairs( player.GetAll() ) do
		v.voted = false
	end
	local result = {
		punish = votepunish > voteforgive,
		punishvotes = votepunish,
		forgivevotes = voteforgive,
		punished = suspectname
	}
	net.Start( "ShowText" )
		net.WriteString( "text_punish_end" )
		net.WriteTable( result )
	net.Broadcast()
	if votepunish > voteforgive then
		for k,v in pairs( player.GetAll() ) do
			if v:SteamID64() == activesuspect then
				if v.warn then
					v:Kill()
				else
					v.warn = true
				end
				break
			end
		end
	end
	suspectname = ""
	activesuspect = nil
	activevictim = nil
end

function CancelVote()
	timer.Destroy( "PunishEnd" )
	net.Start( "ShowText" )
		net.WriteString( "text_punish_cancel" )
	net.Broadcast()
	activevote = false
	suspectname = ""
	activesuspect = nil
	activevictim = nil
	votepunish = 0
	voteforgive = 0
	specpunish = 0
	specforgive = 0
end