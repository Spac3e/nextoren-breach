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
	net.Start("LevelBar")
    net.WriteTable(eblya)
	net.WriteUInt(66, 32)
	net.Send(ply)
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

function mply:BroadcastPlayMusic( soundname, vsrf_flot )
    net.Start( "ClientPlayMusic" )
	    net.WriteFloat( vsrf_flot )
        net.WriteString( soundname )
	net.Send(self)
end

net.Receive("NTF_Special_1", function(len, ply)
    local team_id = net.ReadUInt(12)

	PlayAnnouncer( "nextoren/vo/ntf/camera_receive.ogg" )

    ntf_scan = {} 
    niga_teams = {TEAM_CHAOS,TEAM_GOC,TEAM_GRU,TEAM_USA,TEAM_COTSK,TEAM_DZ}

    for _, v in pairs(gteams.GetPlayers(team_id)) do
		if team_id == 22 then
			table.insert(ntf_scan, niga_teams)
		end
        table.insert(ntf_scan, v)
	end

	ply:SetSpecialCD(CurTime() + 65)
	timer.Simple( 15, function()
	if #ntf_scan == 0 or #ntf_scan < 0 then
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

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:RXSENDNotify("l:your_current_exp "..ply:GetNEXP())
	ply:SetupHands()
	ply:AddDeaths(1)
	ply.force = dmginfo:GetDamageForce() * math.random( 2, 4 )
	ply.type = dmginfo:GetDamageType()

	if ( attacker && attacker:IsValid() && attacker:IsPlayer() && attacker:GTeam() == TEAM_SCP ) then
		ply.type = attacker:GetRoleName()
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
	if attacker != victim and postround == false and attacker:IsPlayer() then
		if victim:GTeam() == attacker:GTeam() then
			print(attacker:GetRoleName())
			print(victim:GetRoleName())
			attacker.teamkills = 1 + attacker.teamkills
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , " ", "l:teamkill_report_if_rulebreaker")
		
		elseif (attacker:GTeam() == TEAM_SECURITY and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SECURITY and attacker:GTeam() == TEAM_GUARD) or (attacker:GTeam() == TEAM_CLASSD and victim:GTeam() == TEAM_CHAOS) or (victim:GTeam() == TEAM_CLASSD and attacker:GTeam() == TEAM_CHAOS) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_SPECIAL) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_SPECIAL) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_SECURITY) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_SECURITY) or (attacker:GTeam() == TEAM_SPECIAL and victim:GTeam() == TEAM_SECURITY) or (victim:GTeam() == TEAM_SPECIAL and attacker:GTeam() == TEAM_SECURITY) or (attacker:GTeam() == TEAM_SCI and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SCI and attacker:GTeam() == TEAM_GUARD) or (attacker:GTeam() == TEAM_SPECIAL and victim:GTeam() == TEAM_GUARD) or (victim:GTeam() == TEAM_SPECIAL and attacker:GTeam() == TEAM_GUARD) then
			print(attacker:GetRoleName())
			print(victim:GetRoleName())
			BREACH.Players:ChatPrint( attacker, true, true, "l:teamkill_you_teamkilled " , victim:Nick() , " " , gteams.GetColor(victim:GTeam()) ,victim:GetRoleName() , " " , Color(255,255,255), " " , victim:SteamID() , "")
			BREACH.Players:ChatPrint( victim, true, true, "l:teamkill_you_have_been_teamkilled " , attacker:Nick() , " " , gteams.GetColor(attacker:GTeam()) ,attacker:GetRoleName() , " " , Color(255,255,255), " " , attacker:SteamID() , "")
			attacker.teamkills = 1 + attacker.kills
		else

			print(attacker:GetRoleName())
			print(victim:GetRoleName())
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
	victim:SetRoleName(role.Spectator)
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

local дистанциябазара = 550 * 550
local можетслушать = {}
local этаж = math.floor
local вставить_в_таблицу = table.insert
local сетка = {}
local игрок_к_сетке = {
    {},
    {}
}

local voiceCheckTimeDelay = 0.3
timer.Create("Брич.СлухБазарилка", voiceCheckTimeDelay, 0, function()
    local игроки = player.GetHumans()

    for x, ряд in pairs(сетка) do
        for y, _ in pairs(ряд) do
            сетка[x][y] = nil
        end
    end
	
    for игрок, _ in pairs(можетслушать) do
        можетслушать[игрок] = {}
    end

    for _, игрок in ipairs(игроки) do
        if not игрок:Alive() then continue end

        local позиция = игрок:GetPos()
        local глазаПоцизия = игрок:EyePos()
        local x = этаж(позиция.x / дистанциябазара)
        local y = этаж(позиция.y / дистанциябазара)

        сетка[x] = сетка[x] or {}
        сетка[x][y] = сетка[x][y] or {}
        вставить_в_таблицу(сетка[x][y], игрок)
        игрок_к_сетке[1][игрок] = x
        игрок_к_сетке[2][игрок] = y

        можетслушать[игрок] = {}
    end

    for _, игрок1 in ipairs(игроки) do
        if not игрок1:Alive() then continue end
        local сеткаХ = игрок_к_сетке[1][игрок1]
        local сеткаY = игрок_к_сетке[2][игрок1]

        for i = 0, 3 do
            local xОффсет = 1 - ((i >= 3) and 1 or 0)
            local vОффсет = -(i % 3 - 1)
            local x = сеткаХ + xОффсет
            local y = сеткаY + vОффсет

            local ряд = сетка[x]
            if not ряд then continue end

            local ячейка = ряд[y]
            if not ячейка then continue end

            for _, игрок2 in ipairs(ячейка) do
                if not игрок2:Alive() then continue end
                local можетбазарить = игрок1:GetPos():DistToSqr(игрок2:GetPos()) < дистанциябазара

                можетслушать[игрок1][игрок2] = можетбазарить
                можетслушать[игрок2][игрок1] = можетбазарить
            end
        end
    end
end)

hook.Add("PlayerDisconnect", "CanHear", function(ply)
    можетслушать[ply] = nil
end)

local говорливыесцп = {
	"SCP049",
	"SCP076"
}

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if not talker:Alive() or not listener:Alive() then
        return false
    end

    if not talker.GetRoleName then
        player_manager.SetPlayerClass(talker, "class_breach")
        player_manager.RunClass(talker, "SetupDataTables")
    end

    if not listener.GetRoleName then
        player_manager.SetPlayerClass(listener, "class_breach")
        player_manager.RunClass(listener, "SetupDataTables")
    end

    if talker:GTeam() == TEAM_SCP and listener:GTeam() != TEAM_SCP and listener:GTeam()	!= TEAM_DZ and !говорливыесцп[talker:GetRoleName()] then
        return false
    end

	if talker:GTeam() == TEAM_SPEC then
        return listener:GTeam() == TEAM_SPEC
    end

	if talker.supported == true then
		return false
	end

    if talker:GetPos():Distance(listener:GetPos()) < 750 then
        return true, true
    end

    return можетслушать[listener][talker] == true, true
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


function GM:PlayerSay(ply)
end

hook.Add("PlayerSay", "Radio_thing", function(ply, text, teamChat)
	if !IsValid(ply) and !ply:GTeam() == TEAM_SPEC then return end
    if not ply:Alive() then return end
    local radio = ply:HasWeapon("item_radio")
	if !radio then return end
    local getradioen = ply:GetWeapon("item_radio"):GetEnabled()
	local getradio = ply:GetWeapon("item_radio")
    local survname = ply:GetNamesurvivor() or ""
	local check1 = string.find(text, "/r") or string.find(text, "!r") or string.find(text, "/R") or string.find(text, "!R")
    local check2 = text == "/r" or text == "!r" or text == "" or string.find(text, "/R") or string.find(text, "!R") 
	local freq = tonumber( string.sub( tostring( freq ), 1, 5 ) )
	
    if check1 then
        if !radio then
            ply:RXSENDNotify("l:no_radio")
            return ""
        end

        if getradioen != true then
            ply:RXSENDNotify("l:turn_up_the_radio")
            return ""
        end

        if check2 then
            ply:RXSENDNotify("l:no_text_radio")
            return ""
        end

        text = string.gsub(text, "[/!]r%s*", "")

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


local mply = FindMetaTable("Player")

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
	
		--if wepent and wepent:GetClass("weapon_special_gaus") then
			--if wepent.CanCharge != true then
			--	weapon.CanCharge = false
			--	weapon.Shooting = false
			--end
			--return false
		--end

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
				timer.Simple(1, function()
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

    -- SCP OPEN UP!
    if ply:GTeam() == TEAM_SCP and ent:GetClass() == "func_button" then
        local время = 7
        local падажжи = 2.5
        
        if IsValid(ent) and ent:GetClass() == "func_button" and ent == ply:GetEyeTrace().Entity then
            ply:BrProgressBar("Выламываю...", время, "nextoren/gui/icons/notifications/breachiconfortips.png", ent, false, function()
                local звуктаймер = 0
                local звукнаигрался = false

                timer.Create("BreakDoorSound", падажжи, math.floor(время / падажжи), function()
                    звуктаймер = звуктаймер + падажжи
                    if !звукнаигрался then
                        ply:EmitSound("nextoren/doors/door_jam.mp3", 75, 100, 1, CHAN_AUTO)
                        звукнаигрался = true
                    end
                end)

                timer.Simple(время, function()
                    timer.Remove("BreakDoorSound")
                    ply:EmitSound("nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO)
                    ent:Fire("use")
                end)
            end)
        end
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
        if ply:GetRoleName() == role.Nazi or ply:GetRoleName() == role.USA then
            ply.lastuse = CurTime() + 1
            ply:EmitSound("nextoren/others/access_denied.wav")
            ply:SetBottomMessage("l:menu_no")
            return false
        end

        if ent:GetClass() == "func_door" and v.name == "Комната Д-Блока" then
            ply.lastuse = CurTime() + 1
            if not preparing then
                ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                ply:SetBottomMessage("l:access_granted")
                return true
            else
                ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg")
                ply:SetBottomMessage("l:access_denied")
                return false
            end
        end

        if v.pos == ent:GetPos() or v.tolerance then
            if v.tolerance and not IsInTolerance(v.pos, ent:GetPos(), v.tolerance) then
                continue
            end

            ply.lastuse = CurTime() + 1

            if v.locked then
                ply:SetBottomMessage("l:access_denied")
                return false
            end

            if v.evac then
                return true
            end

            local activeWepClass = ply:GetActiveWeapon():GetClass() or ""
            local wep = string.sub(activeWepClass, 1, 14) or ""

            if v.access != nil and v.custom_access_granted != nil then
                if wep != "breach_keycard" then
                    ply:SetBottomMessage("l:keycard_needed")
                    return false
                end

                if (v.name == "Ворота A" or v.name == "Ворота B" or v.name == "Ворота C" or v.name == "Ворота D") and timer.Exists("RoundTime") and timer.TimeLeft("RoundTime") < 180 then
                    --ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                    ply:SetBottomMessage("l:access_granted")
                    return true
                else
                    if v.levelOverride and v.levelOverride(ply) then
                        return true
                    end

                    if activeWepClass == "" then
                        ply:SetBottomMessage("l:keycard_needed")
                        return false
                    end

                    if wep == "breach_keycard" then
                        local keycard = wep

                        if ((ply:GetActiveWeapon().CLevels.CLevel or 0) >= (v.access.CLevel or 0) and (v.access.CLevel or 0) != 0) and v.custom_access_granted(ply, ent) != false then
                            ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                            ply:SetBottomMessage("l:access_granted")
                            return true
                        elseif ((ply:GetActiveWeapon().CLevels.CLevelSUP or 0) >= (v.access.CLevelSUP or 0) and (v.access.CLevelSUP or 0) != 0) and v.custom_access_granted(ply, ent) != false then
                            ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                            ply:SetBottomMessage("l:access_granted")
                            return true
                        elseif ((ply:GetActiveWeapon().CLevels.CLevelSCI or 0) >= (v.access.CLevelSCI or 0) and (v.access.CLevelSCI or 0) != 0) and v.custom_access_granted(ply, ent) != false then
                            ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                            ply:SetBottomMessage("l:access_granted")
                            return true
                        elseif ((ply:GetActiveWeapon().CLevels.CLevelMTF or 0) >= (v.access.CLevelMTF or 0) and (v.access.CLevelMTF or 0) != 0) and v.custom_access_granted(ply, ent) != false then
                            ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                            ply:SetBottomMessage("l:access_granted")
                            return true
                        elseif ((ply:GetActiveWeapon().CLevels.CLevelGuard or 0) >= (v.access.CLevelGuard or 0) and (v.access.CLevelGuard or 0) != 0) and v.custom_access_granted(ply, ent) != false then
                            ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                            ply:SetBottomMessage("l:access_granted")
                            return true
                        else
                            ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg")
                            ply:SetBottomMessage("l:access_denied")
                            return false
                        end
                    else
                        ply:SetBottomMessage("l:keycard_needed")
                        return false
                    end
                end
            elseif v.access != nil and v.custom_access_granted == nil then
                if wep != "breach_keycard" then
                    ply:SetBottomMessage("l:keycard_needed")
                    return false
                else
                    if (v.name == "Ворота A" or v.name == "Ворота B" or v.name == "Ворота C" or v.name == "Ворота D") and timer.Exists("RoundTime") and timer.TimeLeft("RoundTime") < 180 then
                       -- ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                        ply:SetBottomMessage("l:access_granted")
                        return true
                    else
                        if v.levelOverride and v.levelOverride(ply) then
                            return true
                        end

                        if activeWepClass == "" then
                            ply:SetBottomMessage("l:keycard_needed")
                            return false
                        end

                        if wep == "breach_keycard" then
                            local keycard = wep

                            if (ply:GetActiveWeapon().CLevels.CLevel or 0) >= (v.access.CLevel or 0) and (v.access.CLevel or 0) != 0 then
                                ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                                ply:SetBottomMessage("l:access_granted")
                                return true
                            elseif (ply:GetActiveWeapon().CLevels.CLevelSUP or 0) >= (v.access.CLevelSUP or 0) and (v.access.CLevelSUP or 0) != 0 then
                                ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                                ply:SetBottomMessage("l:access_granted")
                                return true
                            elseif (ply:GetActiveWeapon().CLevels.CLevelSCI or 0) >= (v.access.CLevelSCI or 0) and (v.access.CLevelSCI or 0) != 0 then
                                ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                                ply:SetBottomMessage("l:access_granted")
                                return true
                            elseif (ply:GetActiveWeapon().CLevels.CLevelMTF or 0) >= (v.access.CLevelMTF or 0) and (v.access.CLevelMTF or 0) != 0 then
                                ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                                ply:SetBottomMessage("l:access_granted")
                                return true
                            elseif (ply:GetActiveWeapon().CLevels.CLevelGuard or 0) >= (v.access.CLevelGuard or 0) and (v.access.CLevelGuard or 0) != 0 then
                                ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                                ply:SetBottomMessage("l:access_granted")
                                return true
                            else
                                ply:EmitSound("nextoren/weapons/keycard/keycarduse_2.ogg")
                                ply:SetBottomMessage("l:access_denied")
                                return false
                            end
                        else
                            ply:SetBottomMessage("l:keycard_needed")
                            return false
                        end
                    end
                end
            elseif v.access == nil and v.custom_access_granted != nil then
                if wep != "breach_keycard" then
                    ply:SetBottomMessage("l:keycard_needed")
                    return false
                else
                    if v.custom_access_granted(ply, ent) then
                        ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                        ply:SetBottomMessage("l:access_granted")
                        return true
                    else
                        ply:EmitSound("nextoren/weapons/keycard/keycarduse_1.ogg")
                        ply:SetBottomMessage("l:access_denied")
                        return false
                    end
                end
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