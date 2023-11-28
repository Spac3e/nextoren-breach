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
util.AddNetworkString("Eventmessage")
util.AddNetworkString("breach_killfeed")
util.AddNetworkString("Shaky_PARTICLEATTACHSYNC")

local mply = FindMetaTable'Player'
local ment = FindMetaTable'Player'

local eblya = {
	{reason = "Ебливый нига", value = 551},
	{reason = "Ебливый нига 2", value = 12 + 5}
}

function BroadcastStopMusic()
	net.Start("ClientStopMusic")
	net.Broadcast()
end

concommand.Add("suk", function(ply)
end)

net.Receive("DropAdditionalArmor", function(len,ply)
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
			if ply:GetUsingArmor() != "" then
				ply:UnUseBro()
			end
		end
	end
	if suka_snimi == "armor_light_hat" then
		if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
			if ply:GetUsingHelmet() != "" then
				ply:UnUseHat()
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


function IsPremium(ply)
	return ply:IsPremium()
end

function Player:SetBottomMessage( msg )
    net.Start( "SetBottomMessage" )
        net.WriteString( msg )
    net.Send( self )
end

function Player:setBottomMessage( msg )
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

function BroadcastPlayMusic( soundname, vsrf_flot )
    net.Start( "ClientPlayMusic" )
	    net.WriteFloat( vsrf_flot )
        net.WriteString( soundname )
	net.Broadcast()
end

function mply:PlayMusic( soundname, vsrf_flot )
    net.Start( "ClientPlayMusic" )
	    net.WriteFloat( vsrf_flot )
        net.WriteString( soundname )
	net.Send(self)
end

net.Receive("NTF_Special_1", function(len, ply)
    local team_id = net.ReadUInt(12)

    PlayAnnouncer("nextoren/vo/ntf/camera_receive.ogg")

    local ntf_scan = {}

    for _, v in ipairs(player.GetAll()) do
        if v:GTeam() == team_id then
            table.insert(ntf_scan, v)
        elseif team_id == 22 then
            local badguyscan = {TEAM_CHAOS, TEAM_GOC, TEAM_GRU, TEAM_USA, TEAM_COTSK, TEAM_DZ}
            for _, team in pairs(badguyscan) do
                for _, inteam in ipairs(gteams.GetPlayers(team)) do
                    table.insert(ntf_scan, inteam)
                end
            end
        end
    end

    ply:SetSpecialCD(CurTime() + 65)
    timer.Simple(15, function()
        if #ntf_scan == 0 then
            PlayAnnouncer("nextoren/vo/ntf/camera_notfound.ogg")
            return
        end
        PlayAnnouncer("nextoren/vo/ntf/camera_found_1.ogg")
        net.Start("TargetsToNTFs")
        net.WriteTable(ntf_scan)
        net.WriteUInt(team_id, 12)
        net.Broadcast()
    end)
end)


function CheckStart()
	if gamestarted == false and #GetActivePlayers() >= 10 and GetGlobalBool("EnoughPlayersCountDown") == false then
		SetGlobalBool("EnoughPlayersCountDown", true)
		SetGlobalInt("EnoughPlayersCountDownStart", CurTime() + 145)
        BroadcastPlayMusic("sound/no_music/preparing_game.ogg", 1)
		timer.Create("SUPERKOSTIL4000000000000000MEGATONNAGOVNA", 144,1,function()
			for k,v in pairs(player.GetAll()) do 
				v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255),2,3.2)
			end
		end)
		timer.Create( "шайлушай", 145, 1, function() 
			SetGlobalBool("EnoughPlayersCountDown", false)
		end)
		timer.Create( "PreStartRound", 145, 1, function() 
			if gamestarted == true or #GetActivePlayers() < 10 then return end
			RoundRestart()
		end)
	end

	if gamestarted == true and #GetActivePlayers() < 10 and (GetGlobalBool("EnoughPlayersCountDown") == true) then
		timer.Remove("шайлушай")
		timer.Remove("PreStartRound")
		timer.Remove("SUPERKOSTIL4000000000000000MEGATONNAGOVNA")
		BroadcastStopMusic()
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
	if timer.Exists( "RoundTime" ) == true then
		net.Start("UpdateTime")
			net.WriteString(tostring(timer.TimeLeft( "RoundTime" )))
		net.Send(ply)
	end
	player_manager.SetPlayerClass( ply, "class_breach" )
	player_manager.RunClass( ply, "SetupDataTables" )
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

concommand.Add("bva",function(ply)
	local tablica = {}

	table.insert(tablica, ply:GetRoleName())

	if ply:GTeam() == TEAM_SPEC then
	net.Start('breach_killfeed')
        net.WriteTable(tablica)
	net.Broadcast()
	end
end)

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:RXSENDNotify("l:your_current_exp "..ply:GetNEXP())
	ply:SetupHands()
	ply:AddDeaths(1)
	ply.force = dmginfo:GetDamageForce() * math.random( 2, 4 )
	ply.type = dmginfo:GetDamageType()

	if ( attacker && attacker:IsValid() && attacker:IsPlayer() && attacker:GTeam() == TEAM_SCP ) then
		ply.type = attacker:GetRoleName()
	end

	local tablica = {
		role = ply:GetRoleName(),
		name = ply:Name(),
		surv = ply:GetNamesurvivor()
	}

	net.Start('breach_killfeed')
        net.WriteTable(tablica)
	net.Broadcast()

	local mozhet_razlet_boshkhi = {
		["models/cultist/humans/security/security.mdl"] = true,
		["models/cultist/humans/class_d/class_d.mdl"] = true,
		["models/cultist/humans/class_d/class_d_female.mdl"] = true,
		["models/cultist/humans/class_d/class_d_bor_new.mdl"] = true,
		["models/cultist/humans/class_d/class_d_cleaner.mdl"] = true,
		["models/cultist/humans/class_d/class_d_fat_new.mdl"] = true,
		["models/cultist/humans/sci/scientist.mdl"] = true,
		["models/cultist/humans/sci/scientist_female.mdl"] = true,
		["models/cultist/humans/goc/goc.mdl"] = true,
		["models/cultist/humans/chaos/chaos.mdl"] = true,
		["models/cultist/humans/chaos/fat/chaos_fat.mdl"] = true,
		["models/cultist/humans/mog/special_security.mdl"] = true,
		["models/cultist/humans/mog/head_site.mdl"] = true,
		["models/cultist/humans/mog/mog.mdl"] = true
	}

	local blocked_bonemerges = {
		["models/cultist/humans/mog/head_gear/mog_helmet.mdl"] = true,
		["models/cultist/humans/mog/head_gear/mog_helmet_2.mdl"] = true,
		["models/cultist/humans/security/head_gear/helmet.mdl"] = true,
		["models/cultist/humans/mog/head_gear/mog_helmet.mdl"] = true
	}
	
	local model = ply:GetModel()
	local role = ply:GetRoleName()
	local dmg = dmginfo
	local random = math.random(1,3) == 1

	if ply:LastHitGroup() == HITGROUP_HEAD and mozhet_razlet_boshkhi[model] and dmg:IsBulletDamage() and IsValid(attacker) and attacker:IsPlayer() then
		local weptab = attacker:GetActiveWeapon()
		if weptab.Primary.Ammo == "Shotgun" or weptab.Primary.Ammo == "Revolver" or weptab.Primary.Ammo == "SCP062Ammo" or weptab.Primary.Ammo == "Sniper" then
		for k,v in pairs(ply:LookupBonemerges()) do
			if blocked_bonemerges[v:GetModel()] then
				return
			end
		end
		if model == "models/cultist/humans/chaos/chaos.mdl" and ply:GTeam() == TEAM_CHAOS then return end
		if model == "models/cultist/humans/mog/mog.mdl" and role != "MTF Engineer" then return end
		if model == "models/cultist/humans/security/security.mdl" and role != "Security Rookie" then return end
		if model == "models/cultist/humans/goc/goc.mdl" and role != "GOC Spy" then return end
		ply.HeadEnt:SetModel("models/cultist/heads/gibs/gib_head.mdl")
		ply.Head_Split = true
	end
	end
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

local scpdeadsounds = {
	SCP106 = "nextoren/round_sounds/intercom/scp_contained/106.ogg",
	SCP049 = "nextoren/round_sounds/intercom/scp_contained/049.ogg",
	SCP638 = "nextoren/round_sounds/intercom/scp_contained/638.ogg",
	SCP8602 = "nextoren/round_sounds/intercom/scp_contained/860.ogg",
	SCP062FR = "nextoren/round_sounds/intercom/scp_contained/062fr.ogg",
	SCP1015RU = "nextoren/round_sounds/intercom/scp_contained/1015ru.ogg",
	SCP035 = "nextoren/round_sounds/intercom/scp_contained/035.ogg",
	SCP062DE = "nextoren/round_sounds/intercom/scp_contained/062de.ogg",
	SCP096 = "nextoren/round_sounds/intercom/scp_contained/096.ogg",
	SCP542 = "nextoren/round_sounds/intercom/scp_contained/542.ogg",
	SCP999 = "nextoren/round_sounds/intercom/scp_contained/999.ogg",
	SCP1903 = "nextoren/round_sounds/intercom/scp_contained/1903.ogg",
	SCP973 = "nextoren/round_sounds/intercom/scp_contained/973.ogg",
	SCP457 = "nextoren/round_sounds/intercom/scp_contained/457.ogg",
	SCP173 = "nextoren/round_sounds/intercom/scp_contained/173.ogg",
	SCP2012 = "nextoren/round_sounds/intercom/scp_contained/2012.ogg",
	SCP082 = "nextoren/round_sounds/intercom/scp_contained/082.ogg",
	SCP939 = "nextoren/round_sounds/intercom/scp_contained/939.ogg",
	SCP811 = "nextoren/round_sounds/intercom/scp_contained/811.ogg",
	SCP682 = "nextoren/round_sounds/intercom/scp_contained/682.ogg",
	SCP076 = "nextoren/round_sounds/intercom/scp_contained/076.ogg",
	SCP912 = "nextoren/round_sounds/intercom/scp_contained/912.ogg"
}

function GM:PlayerDeath( victim, inflictor, attacker, ply )
	if victim:GTeam() == TEAM_SCP then
		if victim:GetRoleName("SCP939") then
			victim.DeathAnimation = 1
		end
	end

	if attacker != victim and postround == false and attacker:IsPlayer() then
		if victim:GTeam() == attacker:GTeam() then
			attacker.teamkills = 1 + attacker.teamkills
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , " ", "l:teamkill_report_if_rulebreaker")
		
		elseif (attacker:GTeam() == TEAM_SECURITY and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SECURITY and attacker:GTeam() == TEAM_GUARD) or (attacker:GTeam() == TEAM_CLASSD and victim:GTeam() == TEAM_CHAOS) or (victim:GTeam() == TEAM_CLASSD and attacker:GTeam() == TEAM_CHAOS) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_SPECIAL) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_SPECIAL) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_SECURITY) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_SECURITY) or (attacker:GTeam() == TEAM_SPECIAL and victim:GTeam() == TEAM_SECURITY) or (victim:GTeam() == TEAM_SPECIAL and attacker:GTeam() == TEAM_SECURITY) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_GUARD) or (attacker:GTeam() == TEAM_SPECIAL and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SPECIAL and attacker:GTeam() == TEAM_GUARD) then
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , "")
			attacker.teamkills = 1 + attacker.kills
		else
			attacker.kills = 1 + attacker.kills
			BREACH.Players:ChatPrint( victim, true, true, "l:you_have_been_killed " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , " l:teamkill_report_if_rulebreaker")
			attacker.kills = 1 + attacker.kills
		end
	end


	if victim:GTeam() == TEAM_SCP then
		print(victim:GetRoleName())
		victim:SetNWBool("megabool3004", victim:GetRoleName())
		timer.Create("SCPDEADLOL"..victim:SteamID(),12,1,function()
		local evgeha = victim:GetNWBool("megabool3004")
		PlayAnnouncer(scpdeadsounds[evgeha])
		timer.Simple(13, function()
		timer.Remove("SCPDEADLOL"..victim:SteamID())
		victim:SetNWBool("megabool3004", nil)
		end)
		end)
	end

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
	--net.Start("LevelBar")
    --net.WriteTable(eblya)
	--net.WriteUInt(victim:GetExp(), 32)
	--net.Send(victim)
	evacuate(victim,"vse",0,"Kia")
	net.Start( "Effect" )
		net.WriteBool( false )
	net.Send( victim )
	net.Start( "957Effect" )
		net.WriteBool( false )
	net.Send( victim )
 	victim:SetModelScale( 1 )

	local wasteam = victim:GTeam()
	victim:SetSpectator()
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

-- Voice Control
local voice_distance = 0x57E40 -- 360000 ( 600^2 )

local function Declare_Value(listener, speaker)
	local isindist = listener:EyePos():DistToSqr( speaker:EyePos() ) < voice_distance

	if speaker:GetNWBool("IntercomTalking") then
        isindist = true
    end

	return isindist, isindist
end

local hear_table = {}

local function CalcVoice( client, players )
	for i = 1, #players do
		local speaker = players[ i ]
		if ( hear_table[ client ][ speaker ] == nil && client != speaker ) then
		      local canhearspeaker, canhearlistener = Declare_Value( client, speaker )
		      hear_table[ client ][ speaker ] = canhearspeaker
		      hear_table[ speaker ][ client ] = canhearlistener
		end
	end
end

local function CreateVoiceTable()
	local clients = {}
	local all_players_table = player.GetAll()

	for i = 1, #all_players_table do
		local speaker = all_players_table[ i ]
		clients[ #clients + 1 ] = speaker
		hear_table[ speaker ] = {}
	end

	for j = 1, #clients do
		CalcVoice( clients[ j ], clients )
	end
end

timer.Create( "CalcVoice", .5, 0, function()
	CreateVoiceTable()
end)

local talkingscp = {
	"SCP049",
	"SCP076"
}

local roleswhitelist = {
	[role.SCP049] = true,
}

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if ( talker:Health() <= 0 or listener:Health() <= 0 ) then return false end

	if !talker:Alive() or !listener:Alive() then return false end
	
	if !talker.GetRoleName then
	player_manager.SetPlayerClass(talker, "class_breach")
	player_manager.RunClass(talker, "SetupDataTables")
	end
	
	if !listener.GetRoleName then
	player_manager.SetPlayerClass(listener, "class_breach")
	player_manager.RunClass(listener, "SetupDataTables")
	end
	

	if talker:GTeam() == TEAM_SCP and listener:GTeam() == TEAM_SCP then return true end
	
	if talker:GTeam() == TEAM_SCP and listener:GTeam() != TEAM_SCP and listener:GTeam() != TEAM_DZ and !talkingscp[talker:GetRoleName()] then return false end
	
	if talker:GTeam() == TEAM_SPEC and listener:GTeam() == TEAM_SPEC then return true end

	if talker:GTeam() == TEAM_SCP and roleswhitelist[listener:GetRoleName()] then return true end
	
	if listener:GetNWBool("Player_IsPlaying") == true then return false end
	
	if talker:GetNWBool("IntercomTalking") == true then return true end
	
	if talker.supported == true then return false end
	
	return hear_table[ listener ] && hear_table[ listener ][ talker ], true
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

hook.Add("PlayerSay", "no_support_chat", function(ply, text, teamChat)
	if ply.supported == true then
		return ""
	end
end)

hook.Add("PlayerSay", "Radio_thing", function(ply, text, teamChat)
	if !IsValid(ply) and !ply:GTeam() == TEAM_SPEC then return end
    if not ply:Alive() then return end
    local radio = ply:HasWeapon("item_radio")
	if !radio then return end
    local survname = ply:GetNamesurvivor() or ""
	local check1 = string.find(text, "/r") or string.find(text, "!r") or string.find(text, "/R") or string.find(text, "!R")
    local check2 = text == "/r" or text == "!r" or text == "" or string.find(text, "/R") or string.find(text, "!R") 
	local freq = tonumber( string.sub( tostring( freq ), 1, 5 ) )
	
    if check1 then
        if !radio then
            ply:RXSENDNotify("l:no_radio")
            return ""
        end

        if ply:GetWeapon("item_radio"):GetEnabled() != true then
            ply:RXSENDNotify("l:turn_up_the_radio")
            return ""
        end

        if check2 then
            ply:RXSENDNotify("l:no_text_radio")
            return ""
        end

        text = string.gsub(text, "[/!]r%s*", "")
		
		if text == "" then
            ply:RXSENDNotify("l:no_text_radio")
            return ""
        end

		ply:EmitSound("nextoren/weapons/radio/squelch.ogg")

        for k, v in pairs(player.GetAll()) do
			if !v:HasWeapon("item_radio") then return false end
			if v:GetWeapon("item_radio"):GetEnabled() != true then return false end
			if v:GetWeapon("item_radio").Channel == ply:GetWeapon("item_radio").Channel then
            v:RXSENDNotify(Color(7, 19, 185, 210), "l:radio_in_chat ", Color(24, 197, 38), "["..survname.."] ", Color(255, 255, 255), '<"'..text..'">')
			end
        end
        return ""
    end
end)


do
    mply.BrGive = mply.BrGive or mply.Give

    function mply:Give(className, bNoAmmo)
        local weapon

        local tr = self:GetEyeTrace()
        local wepent = tr.Entity
        local is_cw = wepent.CW20Weapon

        self.BrWeaponGive = true
        weapon = self:BrGive(className, bNoAmmo)
        self.BrWeaponGive = nil

        local savedammo = wepent.SavedAmmo

        if is_cw and savedammo and savedammo != 0 then
            weapon:SetClip1(savedammo)
        end

		--[[
		if is_cw then
			for key, data in pairs(wepent.Attachments) do
				print("Xxx")
			end
		end
	    --]]

		if wepent and wepent:GetClass("weapon_special_gaus") then
			if wepent.CanCharge != true then
				weapon.CanCharge = false
				weapon.Shooting = false
			end
		end

		if wepent then
			if wepent.Copied == true then
				weapon.Copied = true
			end
		end

		return weapon
    end

    function mply:BreachGive(classname)
        self:Give(classname)
        timer.Simple(0.1,function()
			self:SelectWeapon(classname)
        end)
    end
end

function GM:PlayerCanPickupWeapon(ply, wep)
    local data = {}
    data.start = ply:GetShootPos()
    data.endpos = data.start + ply:GetAimVector() * 96
    data.filter = ply
    local trace = util.TraceLine(data)

    if ply:GTeam() != TEAM_SPEC then
        if wep.teams then
            local canuse = true
            for k, v in pairs(wep.teams) do
                if v == ply:GTeam() then
                    canuse = true
                    break 
                end
            end

            if not canuse then
                return true
            end
        end
    end

    if trace.Entity == wep and ply:KeyDown(IN_USE) then
		if ply:GTeam() == TEAM_SCP then return end
		
        if (ply:GetMaxSlots() - ply:GetPrimaryWeaponAmount()) == 0 then
            return false
        end

        if ply:HasWeapon(trace.Entity:GetClass()) then
            return false
        end

        ply:BrProgressBar("l:progress_wait", 0.5, "nextoren/gui/icons/hand.png", trace.Entity, false, function()
			if trace.Entity:GetClass("breach_keycard") then
				timer.Simple(0, function()
					ply:RemoveAmmo(48, 'pistol')
				end)
	         end
            ply:Give(trace.Entity:GetClass())
            ply:EmitSound("nextoren/charactersounds/inventory/nextoren_inventory_itemreceived.wav", 75, math.random(98, 105), 1, CHAN_STATIC)
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

function GM:PlayerUse(ply, ent, key)
	if ply:GTeam() == TEAM_SPEC and ply:GetRoleName() != role.ADMIN then
        return false
    end

    if ply:GetRoleName() == role.ADMIN then
        return true
    end

    if not ply.lastuse then
        ply.lastuse = 0
    end

    if ply.lastuse > CurTime() then
        return false
    end

    local trent = ply:GetEyeTrace().Entity
    local trmodel = trent:GetModel()

	local blockeddoors_scp = {499,1338,2229,1448,1396}
	
	-- SCP OPEN UP!
	if ply:GTeam() == TEAM_SCP and IsValid(ent) and ent:GetClass() == "func_button" and !table.HasValue(blockeddoors_scp, ent:EntIndex()) then
		timer.Simple(1, function()
			thisisdoor(ply)
		end)
	end
	
    -- Cleaner Loot
    local validToUseMusor = {"nigga.mdl"}

	local cleanerloottable = {
		{weapon = "weapon1", chance = 0.3},
		{weapon = "weapon2", chance = 0.5},
		{weapon = "weapon3", chance = 0.2},
	}

	local trashid = tostring(ent:EntIndex())

    if ply:GetRoleName() == role.SCI_Cleaner and ply:KeyDown(IN_USE) and table.HasValue(validToUseMusor, trmodel) and !trashid == true then
        ply:BrProgressBar("l:looting_trash_can", 10, "nextoren/gui/icons/hand.png", ent, false, function()
            local totalchance = 0

            for _, data in pairs(cleanerloottable) do
                totalchance = totalchance + data.chance
            end

            local randchance = math.random() * totalchance

            local selected = nil
            for _, data in pairs(cleanerloottable) do
                if randchance <= data.chance then
                    selected = data.weapon
                    break
                else
                    randchance = randchance - data.chance
                end
            end

            if selected then
                ply:Give(selected)
                ply:RXSENDNotify("l:trashbin_loot_end")
				trashid.looted = true
            else
                ply:RXSENDNotify("l:trashbin_empty")
            end
        end)
    end
	
	for k, v in pairs(BUTTONS) do
        if v.pos == ent:GetPos() or v.tolerance then
            if v.tolerance and not IsInTolerance(v.pos, ent:GetPos(), v.tolerance) then
                continue
            end

            ply.lastuse = CurTime() + 1
	
			local activeWepClass = ply:GetActiveWeapon():GetClass() or ""
			local wep = string.sub(activeWepClass, 1, 14) or ""

			function AccessGranted(sound,nextorenmoment,changekeypad)
				if nextorenmoment == true or v.name == "SCP-914" then
					ent:EmitSound("nextoren/others/access_granted.wav",65,100,1,CHAN_AUTO,0,1)
					ply.lastuse = CurTime() + 2
				end
				if sound == true and v.name != "SCP-914" then 
					ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
				end
				if changekeypad == true then
					ChangeSkinKeypad(ply,ent,true)
				end
				ply:SetBottomMessage("l:access_granted")
			end
			
			function AccessDenied(sound,nextorenmoment,changekeypad,idinaxuy)
				if nextorenmoment == true or v.name == "SCP-914" then
					ent:EmitSound("nextoren/others/access_denied.wav",75,100,1,CHAN_AUTO,0,1)
					ply.lastuse = CurTime() + 2
				end
				if sound == true and v.name != "SCP-914" then 
					ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg")
				end
				if changekeypad == true then
					ChangeSkinKeypad(ply,ent,false)
				end
		
				if !idinaxuy then
					ply:SetBottomMessage("l:access_denied")
				end
				if idinaxuy then
					ply:SetBottomMessage("l:keycard_needed")
				end
			end

			local function CheckAccess()
				if ply:GetActiveWeapon().CLevels.CLevel >= v.access.CLevel and v.access.CLevel != 0 then
					AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelSCI >= v.access.CLevelSCI and v.access.CLevelSCI != 0 then
						AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelMTF >= v.access.CLevelMTF and v.access.CLevelMTF != 0 then
						AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelGuard >= v.access.CLevelGuard and v.access.CLevelGuard != 0 then
						AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelSUP >= v.access.CLevelSUP and v.access.CLevelSUP != 0 then
						AccessGranted(true, false, true)
						return true
					else
						AccessDenied(true,false,true)
					return false
				end
			end

			if GetGlobalString("RoundName") == "ww2tdm" then
				ply:SetBottomMessage("There's no way back soldier! FIGHT LIKE A MAN!")
				return false	
			end
 
			if v.name == "Комната Д-Блока" and ent:GetClass("func_door") then
				ply.lastuse = CurTime() + 1
				if preparing then
					ply:SetBottomMessage("l:access_denied")
					return false
				else
					return true
				end
			end

			if v.name == "Побег О5" then
				if v.custom_access_granted and v.custom_access_granted(ply, ent) then
					ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
					ply:SetBottomMessage("l:access_granted")
					ChangeSkinKeypad(ply, ent, true)
					return true
				else
					ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg")
					ply:SetBottomMessage("l:access_denied")
					ChangeSkinKeypad(ply, ent, false)
					return false					
				end
			end

			if (v.name == "Ворота A" or v.name == "Ворота B" or v.name == "Ворота C" or v.name == "Ворота D" or v.name == "КПП #1" or v.name == "КПП #2" or v.name == "КПП #3" or v.name == "КПП #4") and GetGlobalBool("Evacuation") == true and !m_UIUCanEscape == true then
				AccessGranted(false,false,true)
				return true
			end

			if (v.name == "Ворота A" or v.name == "Ворота B" or v.name == "Ворота C" or v.name == "Ворота D") and m_UIUCanEscape == true then
				if activeWepClass == "breach_keycard_support" or activeWepClass == "breach_keycard_crack" or ply:GetActiveWeapon():GetClass() == "breach_keycard_usa_spy" and ply.TempValues.FBIHackedTermina then
					AccessGranted(false,false,true)
					return true
				else
					AccessDenied(true,false,true)
					return false
				end	
			end
				
			if v.access then
				if v.locked then
					AccessDenied(false,false,true,true)
					return false
				end
	
				if v.evac then
					AccessGranted(false,false,true)
					return true
				end
                
                if activeWepClass == "" or wep != "breach_keycard" then
					AccessDenied(false,false,false,true)
					return false
				end

				--[[if v.custom_access_granted then
					return v.custom_access_granted( ply, ent ) and CheckAccess() or false
				else
					AccessDenied(false,false,true,true)
					return false
				end--]]

				if v.custom_access_granted then
					if v.custom_access_granted(ply,ent) == true then
						CheckAccess()
					else
						AccessDenied(true,false,true)
						return false
					end
				end

				if ply:GetActiveWeapon().CLevels.CLevel >= v.access.CLevel and v.access.CLevel != 0 then
					AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelSCI >= v.access.CLevelSCI and v.access.CLevelSCI != 0 then
						AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelMTF >= v.access.CLevelMTF and v.access.CLevelMTF != 0 then
						AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelGuard >= v.access.CLevelGuard and v.access.CLevelGuard != 0 then
						AccessGranted(true, false, true)
						return true
					elseif ply:GetActiveWeapon().CLevels.CLevelSUP >= v.access.CLevelSUP and v.access.CLevelSUP != 0 then
						AccessGranted(true, false, true)
						return true
					else
						AccessDenied(true,false,true)
					return false
				end

				if v.allowed_keycards then
				end
			end
		end
	end
	ChangeSkinKeypad(ply, ent, true)
end
	
function GM:CanPlayerSuicide( ply )
	return false
end

function string.starts( String, Start )
   return string.sub( String, 1, string.len( Start ) ) == Start
end
