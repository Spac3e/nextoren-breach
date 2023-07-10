local Player = FindMetaTable( "Player" )
util.AddNetworkString("BreachAnnouncer")
util.AddNetworkString("camera_enter")
util.AddNetworkString("camera_swap")
util.AddNetworkString("camera_exit")
util.AddNetworkString("FirstPerson")
util.AddNetworkString("BreachAnnouncerLoud")
util.AddNetworkString("FirstPerson_Remove")
util.AddNetworkString("DropAdditionalArmor")
util.AddNetworkString("NTF_Intro")

net.Receive("DropAdditionalArmor", function(ply)
	local suka_snimi = net.ReadString()
	if suka_snimi == "armor_big_bag" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingBag() != "" then
				ply:SetMaxSlots(8)
				ply:UnUseBag()
			end
		end
	end
	if suka_snimi == "armor_small_bag" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingBag() != "" then
				ply:SetMaxSlots(8)
				ply:UnUseBag()
			end
		end
	end
	if suka_snimi == "armor_light_armor" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingHelmet() != "" then
				ply:UnUseHat()
			end
		end
	end
	if suka_snimi == "armor_light_hat" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingArmor() != "" then
				ply:UnUseBro()
			end
		end
	end
    if suka_snimi == "armor_heavy_armor" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingArmor() != "" then
				ply:UnUseBro()
			end
		end
	end
	if suka_snimi == "armor_heavy_hat" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingHelmet() != "" then
				ply:UnUseHat()
			end
		end
	end
end)

function Player:SetBottomMessage( msg )
    net.Start( "SetBottomMessage" )
        net.WriteString( msg )
    net.Send( self )
end

function Player:BrEventMessage( msg )
    net.Start( "Eventmessage" )
        net.WriteString( msg )
    net.Send( self )
end

function PlayAnnouncer( soundname )
    net.Start( "BreachAnnouncer" )
        net.WriteString( soundname )
	net.Broadcast()
end

function PlayAnnouncerLoud( soundname )
	net.Start("ClientStopMusic")
	net.Broadcast()
    net.Start( "BreachAnnouncerLoud" )
        net.WriteString( soundname )
	net.Broadcast()
end

net.Receive("NTF_Special_1", function(ply,caller)
	PlayAnnouncer( "nextoren/vo/ntf/camera_receive.ogg" )
	caller:SetSpecialCD(CurTime() + 80)
	timer.Simple( 15, function()
	
	net.Start("BreachAnnouncer")
	net.WriteString("nextoren/vo/ntf/camera_found_1.ogg")
	net.Broadcast()
	net.Start( "NTF_Special_1" )
	net.WriteUInt( 8, 12 )
	net.Broadcast()
	end )
end)

function IsPremium( ply, silent )
	ply:SetNPremium( false )
	ply.Premium = false
	if CheckULXPremium( ply, silent ) == true then return end
	if GetConVar("br_premium_url"):GetString() == "" or GetConVar("br_premium_url"):GetString() == "none" then return end
	http.Fetch( GetConVar("br_premium_url"):GetString(), function( body, size, headers, code )
		if ( body == nil ) then return end
		local ID = string.find( tostring(body), "<ID64>"..ply:SteamID64().."</ID64>" )
			if ID != nil then
				ply.Premium = true
				ply:SetNPremium( true )
				if GetConVar("br_premium_display"):GetString() != "" and GetConVar("br_premium_display"):GetString() != "none" and !silent then
					print("Premium member "..ply:GetName().." has joined")
					PrintMessage(HUD_PRINTCENTER, string.format(GetConVar("br_premium_display"):GetString(), ply:GetName()))
				end
			end
	end,
	function( error )
		print("HTTP ERROR")
		print(error)
	end )
end

function CheckULXPremium( ply, silent )
	if GetConVar("br_ulx_premiumgroup_name"):GetString() == "" or GetConVar("br_ulx_premiumgroup_name"):GetString() == "none" then return end
	if !ply.CheckGroup then
		print( "To use br_ulx_premiumgroup_name you have to install ULX!" )
		return
	end
	local pgroups = string.Split( GetConVar("br_ulx_premiumgroup_name"):GetString(), "," )
	local ispremium
	for k,v in pairs( pgroups ) do
		if ply:CheckGroup( v ) then
			ispremium = true
			break
		end
	end
	if ispremium then
		ply.Premium = true
		ply:SetNPremium( true )
		if GetConVar("br_premium_display"):GetString() != "" and GetConVar("br_premium_display"):GetString() != "none" and !silent then
			print("Premium member "..ply:GetName().." has joined")
			PrintMessage(HUD_PRINTCENTER, string.format(GetConVar("br_premium_display"):GetString(), ply:GetName()))
		end
		return true
	end
end

function CheckStart()
	MINPLAYERS = GetConVar("br_min_players"):GetInt()
	if gamestarted == false and #GetActivePlayers() >= 10 then
		RoundRestart()
	end
	if #GetActivePlayers() == 10 and #GetActivePlayers() == #player.GetAll() then
		RoundRestart()
	end
	if gamestarted then
		BroadcastLua( 'gamestarted = true' )
	end
end

function GM:PlayerInitialSpawn( ply )
	ply:SetCanZoom( false )
	ply:SetNoDraw(true)
	ply.Active = false
	ply.freshspawn = true
	ply.isblinking = false
	ply.Premium = false
	if timer.Exists( "RoundTime" ) == true then
		net.Start("UpdateTime")
			net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
		net.Send(ply)
	end
	player_manager.SetPlayerClass( ply, "class_breach" )
	player_manager.RunClass( ply, "SetupDataTables" )
	IsPremium(ply)
	ply:SetActive( false )
	if ply:IsBot() then
		ply:SetNWBool("Player_IsPlaying", true)
		ply:SetActive( true )
	end
	--print( ply.ActivePlayer, ply:GetNActive() )
	CheckStart()
	if gamestarted then
		ply:SendLua( 'gamestarted = true' )
	end
end
/*
function GM:PlayerAuthed( ply, steamid, uniqueid )
	ply.Active = false
	ply.Leaver = "none"
	if prepring then
		ply:SetClassD()
	else
		ply:SetSpectator()
	end
end
*/
function GM:PlayerSpawn( ply )
	//ply:SetupHands()
	ply:SetTeam(1)
	ply:SetNoCollideWithTeammates(false)
	//ply:SetCustomCollisionCheck( true )
	if ply.freshspawn then
		ply:SetSpectator()
		ply.freshspawn = false
	end
	//ply:SetupHands()
end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		if ply.handsmodel != nil then
			info.model = ply.handsmodel
		end
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

util.AddNetworkString("LevelBar")

local stolik = {Suka = 20}

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:RXSENDNotify("l:your_current_exp "..ply:GetNEXP())
	ply:SetupHands()
	ply:AddDeaths(1)
end

function GM:PlayerDeathThink( ply )
	if !ply:IsBot() and ply:GTeam() != TEAM_SPEC then
		ply:SetGTeam(TEAM_SPEC)
	end
	if ( ply:IsBot() || ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) || postround ) then
		ply:Spawn()
		ply:SetSpectator()
	end
end

function GM:PlayerNoClip( ply, desiredState )
	if ply:GTeam() == TEAM_SPEC and desiredState == true then return true end
end

function GM:PlayerDeath( victim, inflictor, attacker, ply )
	victim:StripAmmo()
	victim:SetUsingBag("")
	victim:SetUsingCloth("")
	victim:SetUsingArmor("")
	victim:SetUsingHelmet("")
	victim:SetSpecialMax(0)
	victim:SetupHands()
	victim:SetNWString("AbilityName", "")
	victim.AbilityTAB = nil
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", victim ) || {}
	if victim:GTeam() != TEAM_SCP or victim:GetRoleName() != TEAM_SPEC or !victim:tbl_bonemerged() then
	for i = 1, #tbl_bonemerged do
		local bonemerge = tbl_bonemerged[ i ]
			bonemerge:Remove()
	    end
	end
	victim:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")
	net.Start("Death_Scene")
	net.WriteBool(true)
	net.WriteEntity(self)
	net.Send(victim)
	net.Start("LevelBar")
    net.WriteTable(stolik)
	net.WriteUInt(32, 16)
	net.Send(victim)
	net.Start( "Effect" )
		net.WriteBool( false )
	net.Send( victim )
	net.Start( "957Effect" )
		net.WriteBool( false )
	net.Send( victim )
	if victim:GTeam() == TEAM_SCP and victim.basestats.death_sound != "" then PlayAnnouncer(victim.basestats.death_sound) end
	victim:SetModelScale( 1 )
	if attacker != victim and postround == false and attacker:IsPlayer() then
		if victim:GTeam() == attacker:GTeam() then
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , " ", "l:teamkill_report_if_rulebreaker")
		
		elseif (attacker:GTeam() == TEAM_SECURITY and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SECURITY and attacker:GTeam() == TEAM_GUARD) or (attacker:GTeam() == TEAM_CLASSD and victim:GTeam() == TEAM_CHAOS) or (victim:GTeam() == TEAM_CLASSD and attacker:GTeam() == TEAM_CHAOS) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_SPECIAL) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_SPECIAL) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_SECURITY) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_SECURITY) or (attacker:GTeam() == TEAM_SPECIAL and victim:GTeam() == TEAM_SECURITY) or (victim:GTeam() == TEAM_SPECIAL and attacker:GTeam() == TEAM_SECURITY) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_GUARD) or (attacker:GTeam() == TEAM_SPECIAL and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SPECIAL and attacker:GTeam() == TEAM_GUARD) then
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , "")
		else
			BREACH.Players:ChatPrint( victim, true, true, "l:you_have_been_killed " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , " l:teamkill_report_if_rulebreaker")
		end
	end
	victim:SetRoleName(role.Spectator)
	local wasteam = victim:GTeam()
	victim:SetTeam(TEAM_SPEC)
	victim:SetGTeam(TEAM_SPEC)
end


function GM:PlayerDisconnected( ply )
	 ply:SetTeam(TEAM_SPEC)
	 if #player.GetAll() < 2 then
		BroadcastLua('gamestarted = false')
		gamestarted = false
	 end
	 WinCheck()
end

function HaveRadio(pl1, pl2)
	if pl1:HasWeapon("item_radio") then
		if pl2:HasWeapon("item_radio") then
			local r1 = pl1:GetWeapon("item_radio")
			local r2 = pl2:GetWeapon("item_radio")
			if !IsValid(r1) or !IsValid(r2) then return false end
			/*
			print(pl1:Nick() .. " - " .. pl2:Nick())
			print(r1.Enabled)
			print(r1.Channel)
			print(r2.Enabled)
			print(r2.Channel)
			*/
			if r1.Enabled == true then
				if r2.Enabled == true then
					if r1.Channel == r2.Channel then
						if r1.Channel > 4 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if talker:Alive() == false then return false end
	if listener:Alive() == false then return false end

	if !talker.GetRoleName then
		player_manager.SetPlayerClass( talker, "class_breach" )
		player_manager.RunClass( talker, "SetupDataTables" )
	end

	if !listener.GetRoleName then
		player_manager.SetPlayerClass( listener, "class_breach" )
		player_manager.RunClass( listener, "SetupDataTables" )
	end

	if talker:GetRoleName() == role.SCP957 or listener:GetRoleName() == role.SCP9571 then
		if talker:GetRoleName() == role.SCP9571 or listener:GetRoleName() == role.SCP9571 then
			return true
		end
	end

	if talker:GTeam() == TEAM_SCP and talker:GetRoleName() != role.SCP9571 then
		local omit = false

		if talker:GetRoleName() == role.SCP939 then
			local wep = talker:GetWeapon("weapon_scp_939")
			if IsValid( wep ) then
				if wep.Channel == "ALL" then
					omit = true
				end
			end
		end

		if !omit and GetConVar( "br_allow_scptovoicechat" ):GetInt() == 0 then
			if listener:GTeam() != TEAM_SCP then
				return false
			end
		end
	end
	if talker:GTeam() == TEAM_SPEC then
		if listener:GTeam() == TEAM_SPEC then
			return true
		else
			return false
		end
	end
	if HaveRadio(listener, talker) == true then
		return true
	end
	if talker:GetPos():Distance(listener:GetPos()) < 750 then
		return true, true
	else
		return false
	end
end

function GM:PlayerCanSeePlayersChat( text, teamOnly, listener, talker )
	if activevote and ( text == "!forgive" or text == "!punish" ) then
		local votemsg = false
		if talker.voted == true or talker:SteamID64() == activesuspect then
			if !talker.timeout then talker.timeout = 0 end
			if talker.timeout < CurTime() then
				talker.timeout = CurTime() + 0.5
				net.Start( "ShowText" )
					net.WriteString( "vote_fail" )
				net.Send( talker )
			end
			return
		end
		if text == "!forgive" then
			if talker:SteamID64() == activevictim then
				voteforgive = voteforgive + 5
			elseif talker:GTeam() == TEAM_SPEC then
				specforgive = specforgive + 1
			else
				voteforgive = voteforgive + 1
			end
			talker.voted = true
			votemsg = true
			talker.timeout = CurTime() + 0.5
		elseif text == "!punish" then
			if talker:SteamID64() == activevictim then
				votepunish = votepunish + 5
			elseif talker:GTeam() == TEAM_SPEC then
				specpunish = specpunish + 1
			else
				votepunish = votepunish + 1
			end
			talker.voted = true
			votemsg = true
			talker.timeout = CurTime() + 0.5
		end
		if votemsg then
			if listener:IsSuperAdmin() then
				return true
			else
				return false
			end
		end
	end

	if !talker.GetRoleName or !listener.GetRoleName then
		player_manager.SetPlayerClass( ply, "class_breach" )
		player_manager.RunClass( ply, "SetupDataTables" )
	end

	if talker:GetRoleName() == role.SCP957 or listener:GetRoleName() == role.SCP957 then
		if talker:GetRoleName() == role.SCP9571 or listener:GetRoleName() == role.SCP9571 then
			return true
		end
	end

	if talker:GetRoleName() == role.ADMIN or listener:GetRoleName() == role.ADMIN then return true end
	if talker:Alive() == false then return false end
	if listener:Alive() == false then return false end
	if teamOnly then
		if talker:GetPos():Distance(listener:GetPos()) < 750 then
			return (listener:GTeam() == talker:GTeam())
		else
			return false
		end
	end
	if talker:GTeam() == TEAM_SPEC then
		if listener:GTeam() == TEAM_SPEC then
			return true
		else
			return false
		end
	end
	if HaveRadio(listener, talker) == true then
		return true
	end
	return (talker:GetPos():Distance(listener:GetPos()) < 750)
end

hook.Add( "PlayerSay", "SCPPenaltyShow", function( ply, msg, teamonly )
	if string.lower( msg ) == "!scp" then
		if !ply.nscpcmdcheck or ply.nscpcmdcheck < CurTime() then
			ply.nscpcmdcheck = CurTime() + 10

			local r = tonumber( ply:GetPData( "scp_penalty", 0 ) ) - 1
			r = math.max( r, 0 )

			if r == 0 then
				ply:PrintTranslatedMessage( "scpready#50,200,50" )
			else
				ply:PrintTranslatedMessage( "scpwait".."$"..r.."#200,50,50" )
			end
		end

		return ""
	end
end )

local mply = FindMetaTable('Player')

do
	mply.BrGive = mply.BrGive or mply.Give

	function mply:Give(className, bNoAmmo)
		local weapon

		self.BrWeaponGive = true
			weapon = self:BrGive(className, bNoAmmo)
		self.BrWeaponGive = nil

		return weapon
	end
end

do
function mply:BreachGive(classname)
	self:Give(classname)
    timer.Simple(0.1, function() self:SelectWeapon(classname) end)
end
end

function GM:PlayerCanPickupWeapon( ply, wep )
	local data = {}
		data.start = ply:GetShootPos()
		data.endpos = data.start + ply:GetAimVector() * 96
		data.filter = ply
	local trace = util.TraceLine(data)

	if ply:GTeam() != TEAM_SPEC then
		if wep.teams then
			local canuse = false
			for k,v in pairs(wep.teams) do
				if v == ply:GTeam() then
					canuse = true
				end
			end

			if canuse == false then
				return false
			end
		end
    end

	if string.Left( wep:GetClass(), 3 ) == "cw_" then
		for k, v in pairs( ply:GetWeapons() ) do
			if string.Left( v:GetClass(), 3 ) == "cw_" then return false end
		end
	end

	if table.Count( ply:GetWeapons() ) >= 8 then
		return false
	end

	ply.gettingammo = wep.SavedAmmo

	if (trace.Entity == wep and ply:KeyDown(IN_USE)) and ply:GTeam() != TEAM_SCP then
		ply:BrProgressBar("l:progress_wait", 0.5, "nextoren/gui/icons/hand.png", trace.Entity, false, function()
        ply:Give(trace.Entity:GetClass())
		ply:EmitSound( "nextoren/charactersounds/inventory/nextoren_inventory_itemreceived.wav", 75, math.random( 98, 105 ), 1, CHAN_STATIC )
		trace.Entity:Remove()
		end)
	end
	return ply.BrWeaponGive
end

function GM:PlayerCanPickupItem( ply, item )
	return ply:GTeam() != TEAM_SPEC
end

function GM:AllowPlayerPickup( ply, ent )
    return false
end

// usesounds = true,
function IsInTolerance( spos, dpos, tolerance )
	if spos == dpos then return true end

	if isnumber( tolerance ) then
		tolerance = { x = tolerance, y = tolerance, z = tolerance }
	end

	local allaxes = { "x", "y", "z" }
	for k, v in pairs( allaxes ) do
		if spos[v] != dpos[v] then
			if tolerance[v] then
				if math.abs( dpos[v] - spos[v] ) > tolerance[v] then
					return false
				end
			else
				return false
			end
		end
	end

	return true
end

function GM:PlayerUse( ply, ent, key )
	if ply:GTeam() == TEAM_SPEC and ply:GetRoleName() != role.ADMIN then return false end
	if ply:GetRoleName() == role.ADMIN then return true end
	if ply.lastuse == nil then ply.lastuse = 0 end
	if ply.lastuse > CurTime() then return false end
	local trent = ply:GetEyeTrace().Entity
	local valid_to_use_musor = {"nigga.mdl"}
	-- SCP OPEN UP!
	local scp_opendelay = 5
    if (ply:GTeam() == TEAM_SCP) and (trent:GetClass() == "func_button" ) then
    timer.Simple( 1, function()
    scp_opendelay = 0
    if (scp_opendelay == 0) then
        if trent:GetClass() != "func_button" then
        else
            ply:BrProgressBar("Выламываю...", 10, "nextoren/gui/icons/notifications/breachiconfortips.png", trent, false, function()
                ply:EmitSound( "nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO ) -- Same as below
                trent:Fire("use")
            end)
        end
    end
    end)
    end
    -- Cleaner Loot
	if ply:GetRoleName() == role.SCI_Cleaner and ply:KeyDown(KEY_E) and trent:GetModel() == valid_to_use_musor then
		ply:BrProgressBar("Обыскиваю...", 10, "nextoren/gui/icons/hand.png", ent, false, function()
		 end)
       end

		for k, v in pairs( BUTTONS ) do
			if v.pos == ent:GetPos() or v.tolerance then
		if v.tolerance and !IsInTolerance( v.pos, ent:GetPos(), v.tolerance ) then
			continue
		end

		ply.lastuse = CurTime() + 1

		if v.access != nil then
			if OMEGADoors then
				return true
			end

			if v.levelOverride and v.levelOverride( ply ) then
				return true
			end

			local hui = ply:GetActiveWeapon():GetClass() or {}
			local wep = string.sub( hui, 1, 14 ) or {}
			if hui == "breach_keycard_7" then
				if v.access.CLevelO5 != nil then
				if ((ply:GetActiveWeapon().CLevels.CLevelO5) >= (v.access.CLevelO5)) then

					ply:SetBottomMessage("l:access_granted")	

					return true	

				end	
				end			

			end
			if wep == "breach_keycard" then
				--ply:SetBottomMessage(v.access.CLevelSCI)
				local keycard = wep
					--ply:SetBottomMessage(v.access.CLevel)
					if ((ply:GetActiveWeapon().CLevels.CLevel) >= (v.access.CLevel)) and ((v.access.CLevel) != 0) then
						if !v.nosound then
							ply:EmitSound( "nextoren/weapons/keycard/keycarduse_1.ogg" )
						end

						ply:SetBottomMessage("l:access_granted")	

						return true
						

					elseif ((ply:GetActiveWeapon().CLevels.CLevelSUP) >= (v.access.CLevelSUP)) and ((v.access.CLevelSUP) != 0) then
						if !v.nosound then
							ply:EmitSound( "nextoren/weapons/keycard/keycarduse_1.ogg" )
						end

						ply:SetBottomMessage("l:access_granted")	

						return true

					elseif ((ply:GetActiveWeapon().CLevels.CLevelSCI) >= (v.access.CLevelSCI)) and ((v.access.CLevelSCI) != 0) then
						if !v.nosound then
							ply:EmitSound( "nextoren/weapons/keycard/keycarduse_1.ogg" )
						end

						ply:SetBottomMessage("l:access_granted")	

						return true

					elseif ((ply:GetActiveWeapon().CLevels.CLevelMTF) >= (v.access.CLevelMTF)) and ((v.access.CLevelMTF) != 0) then
						if !v.nosound then
							ply:EmitSound( "nextoren/weapons/keycard/keycarduse_1.ogg" )
						end

						ply:SetBottomMessage("l:access_granted")	

						return true

					elseif ((ply:GetActiveWeapon().CLevels.CLevelGuard) >= (v.access.CLevelGuard)) and ((v.access.CLevelGuard) != 0) then
						if !v.nosound then
							ply:EmitSound( "nextoren/weapons/keycard/keycarduse_1.ogg" )
						end

						ply:SetBottomMessage("l:access_granted")	

						return true
					else
						if !v.nosound then
							ply:EmitSound( "nextoren/weapons/keycard/keycarduse_2.ogg" )
						end

						ply:SetBottomMessage("l:access_denied")	

						return false
					end
			else
				ply:SetBottomMessage("l:keycard_needed")
				return false
			end
		end

		if v.canactivate == nil or v.canactivate( ply, ent ) then
			if !v.nosound then
				ply:EmitSound( "nextoren/weapons/keycard/keycarduse_1.ogg" )
			end

			if v.customaccessmsg then
				ply:PrintMessage( HUD_PRINTCENTER, v.customaccessmsg )
			else
				--ply:SetBottomMessage("Access Granted")

			end

			return true
		else
			if !v.nosound then
				ply:EmitSound( "nextoren/weapons/keycard/keycarduse_2.ogg" )
			end

			if v.customdenymsg then
				ply:SetBottomMessage( v.customdenymsg )
			else
				ply:SetBottomMessage("l:access_denied")	
			end

			return false
		end
	end
end
end

function GM:CanPlayerSuicide( ply )
	return false
end

function string.starts( String, Start )
   return string.sub( String, 1, string.len( Start ) ) == Start
end