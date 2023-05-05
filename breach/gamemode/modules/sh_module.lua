// Shared file
GM.Name 	= "Breach"
GM.Author 	= "VAULT"
GM.Email 	= ""
GM.Website 	= ""

VERSION = "2.6.9"
DATE = "03.05.2023"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

TEAM_SCP = 1
TEAM_GUARD = 2
TEAM_CLASSD = 3
TEAM_SCI = 5
TEAM_CHAOS = 6
TEAM_SECURITY = 7
TEAM_GRU = 8
TEAM_NTF = 9
TEAM_DZ = 10
TEAM_GOC = 11
TEAM_USA = 12
TEAM_QRT = 13
TEAM_COTSK = 14
TEAM_SPECIAL = 15
TEAM_OSN = 16
TEAM_NAZI = 17
TEAM_AMERICA = 18
TEAM_ARENA = 19
TEAM_SPEC = 20

MINPLAYERS = 5
// Team setup
team.SetUp(1, "Oh you got an ass on you alright. See, thats what he's talking about. Spread your ass open dude. You could do the rump shaker huh, the thug shaker, give me the thug shaker dude shake your ass. Take your hands off it and shake that shit, pull your shirt up I know you can shake it, shake it! Yeah that's some thug ass right there. Oh yeah, that'll work. You got the booty dude. God damn. It look good bro? Yeah. Yeah, nice huh. Alright that'll work for him. Put that condom on, you ready to sit on that shit? You got- Lets just get it over with. Alright lets get it over with, you- your alright.", Color(0, 255, 0))

game.AddDecal( "Decal106", "decals/decal106" )

function GetLangRole(rl)
	if clang == nil then return rl end
	local rolef = nil
	for k,v in pairs(ROLES) do
		if rl == v then
			rolef = k
		end
	end
	if rolef != nil then
		return clang.ROLES[rolef]
	else
		return rl
	end
end
function GetLangWeapon(rl)
	if clang == nil then clang = english end

	if isstring(clang.weaponry[rl]) and clang.LangName != "Русский" then
		return clang.weaponry[rl]
	else
		local weptable = weapons.Get(rl)
		if !istable(weptable) then
			local enttable = scripted_ents.Get(rl)
			if !istable(enttable) then
				return rl
			end
			return enttable.PrintName
		end
		return weptable.PrintName
	end
end
Radio_RandChannelList = Radio_RandChannelList || {



	{
		teams = {TEAM_GUARD, TEAM_SECURITY, TEAM_QRT, TEAM_NTF},
		allowedroles = {"CI Spy"},
		blockedroles = {},
		chan = 101.1,
	},

	{
		teams = {TEAM_DZ},
		allowedroles = {},
		blockedroles = {},
		chan = 102.1,
	},

	{
		teams = {TEAM_CHAOS},
		allowedroles = {},
		blockedroles = {"CI Spy"},
		chan = 103.1,
	},

	{
		teams = {TEAM_GRU},
		allowedroles = {},
		blockedroles = {},
		chan = 104.1,
	},

	{
		teams = {TEAM_COTSK},
		allowedroles = {},
		blockedroles = {},
		chan = 105.1,
	},

	{
		teams = {TEAM_GOC},
		allowedroles = {},
		blockedroles = {},
		chan = 106.1,
	},

	{
		teams = {TEAM_USA},
		allowedroles = {},
		blockedroles = {},
		chan = 107.1,
	},


}

function Radio_RandomizeChannels()

	for _, tab in pairs(Radio_RandChannelList) do
		local num1 = tostring(math.random(100, 999))
		local num2 = tostring(math.random(1, 9))

		local Ranchannel = tonumber(num1.."."..num2)

		tab.chan = Ranchannel
	end

end

function Radio_GetChannel(team, rolename)
	for _, tab in pairs(Radio_RandChannelList) do
		if ( table.HasValue(tab.teams, team) and !table.HasValue(tab.blockedroles, rolename) ) or table.HasValue(tab.allowedroles, rolename) then return tab.chan end
	end
	
	return 100.1
end


SCPS = {}

ROLES = {}
ROLES.ROLE_SCP173 = "SCP-173"

ROLES.ROLE_SCP106 = "SCP-106"

ROLES.ROLE_SCP1048AB = "SCP-1048"

ROLES.ROLE_SCP966 = "SCP-966"

ROLES.ROLE_SCP050 = "SCP-050"

ROLES.ROLE_SCP023 = "SCP-023"

ROLES.ROLE_SCP638 = "SCP-638"

ROLES.ROLE_SCP096 = "SCP-096"

ROLES.ROLE_SCP542 = "SCP-542"



ROLES.ROLE_SCP076 = "SCP-076"

ROLES.ROLE_SCP8602 = "SCP-860-2"

ROLES.ROLE_SCP062DE = "SCP-062-DE"

ROLES.ROLE_SCP973 = "SCP-973"

ROLES.ROLE_SCP082 = "SCP-082"

ROLES.ROLE_SPEEED = "Lomao"

ROLES.ROLE_SCP9992 = "SCP-999-2"

ROLES.ROLE_SCP035 = "SCP-035"

ROLES.ROLE_SCP1903 = "SCP-1903"

ROLES.ROLE_SPECIALRES = "Matilda Moore"

ROLES.ROLE_SPECIALRESS = "Hedwig Kirchmaier"

ROLES.ROLE_SPECIALRESSSS = "Spedwaun"

ROLES.ROLE_SPECIALRESSS = "Kelen"

ROLES.ROLE_DZDD = "SH Spy"

ROLES.ROLE_SCP1027 = "SCP-1027"

ROLES.ROLE_CHAOSDESTROYER = "Chaos Destroyer"

ROLES.ROLE_LESSION = "Feelon"

ROLES.ROLE_SCP939 = "SCP-939"

ROLES.ROLE_SCP049 = "SCP-049"

ROLES.ROLE_SCP811 = "SCP-811"

ROLES.ROLE_GOCSPY = "GOC Spy"

ROLES.ROLE_SCP457 = "SCP-457"

ROLES.ROLE_SCP682 = "SCP-682"

ROLES.ROLE_SCP062 = "SCP-062"

ROLES.ROLE_SHIELD = "Shieldmeh"

ROLES.ROLE_SCP0492 = "SCP-049-2"

ROLES.ROLE_SCP1048 = "SCP-1048-A"

ROLES.ROLE_SCP0082 = "SCP-008-2"



// Researchers

ROLES.ROLE_RES = "Researcher"

ROLES.ROLE_RESS = "Tester"

ROLES.ROLE_GuardSci = "Science Guard"

ROLES.ROLE_LEL = "Head of Science Personnel"

ROLES.ROLE_MEDIC = "Medic"



// Quick Response Team

--ROLES.ROLE_FOCKYOU = "Quick Response Member"



// Class D Personell

ROLES.ROLE_CLASSD = "Class D Personnel"

ROLES.ROLE_FARTINHALER = "Class D Fart Inhaler"

ROLES.ROLE_Killer = "Class D Killer"

ROLES.ClassD_Bor = "Class D Strong"

ROLES.ROLE_hacker = "Class D Hacker"

ROLES.ROLE_FAT = "Class D Fat"

ROLES.ROLE_Can = "Class D Cannibal"

ROLES.ROLE_Sport = "Class D Sportsman"

ROLES.ROLE_VOR = "Class D Thief"

ROLES.ClassD_Probitiy = "Class D Secondhand"

ROLES.ClassD_Pron = "Class D Pron"

ROLES.ROLE_VETERAN = "Veteran"



// Security

ROLES.ROLE_SECURITY = "Security Officer"

ROLES.ROLE_HOF = "Head of Foundation"

ROLES.ROLE_SPECIALIST = "MTF Specialist"

ROLES.ROLE_MTFJAG = "MTF Juggernaut"

ROLES.ROLE_MTFGUARD = "MTF Guard"

ROLES.ROLE_MTFMEDIC = "MTF Medic"

ROLES.ROLE_Engi = "MTF Engineer"

ROLES.ROLE_MTFL = "MTF Lieutenant"

ROLES.ROLE_MTFCHEMIST = "MTF Chemist"

ROLES.ROLE_MTFNTF = "MTF Nine Tailed Fox"

ROLES.ROLE_MTFNTF_SNIPER = "MTF Nine Tailed Fox Sniper"

ROLES.ROLE_CSECURITY = "Security Chief"

ROLES.ROLE_MTFCOM = "MTF Commander"

ROLES.ROLE_MTFSHOCK= "MTF Shocktroop"

ROLES.ROLE_SD = "Site Director"



// Chaos Insurgency

ROLES.ROLE_CHAOSSPY = "Chaos Insurgency Spy"

ROLES.ROLE_CHAOS = "Chaos Insurgency"

ROLES.ROLE_CHAOSCMD = "CI Commander"



ROLES.ROLE_NTFCMD = "NTF Commander"



// Global Occult C

ROLES.ROLE_GoP = "Global Occult Coalition"

ROLES.ROLE_GoPCMD = "GOC Commander"

// ONP

ROLES.ROLE_USA = "Unusual Incidents Unit"

ROLES.ROLE_USACMD = "UIU Commander"

// DZ

ROLES.ROLE_DZ = "SH Soldier"
ROLES.ROLE_DZCMD = "SH Commander"

// Other

ROLES.ROLE_SPEC = "Spectator"



ROLES.ROLE_USSR = "Red Army soldier"

ROLES.ROLE_NAZI = "Nazi soldier"

--Keycard access help
ACCESS_SAFE = bit.lshift( 1, 0 )
ACCESS_EUCLID = bit.lshift( 1, 1 )
ACCESS_KETER = bit.lshift( 1, 2 )
ACCESS_CHECKPOINT = bit.lshift( 1, 3 )
ACCESS_OMEGA = bit.lshift( 1, 4 )
ACCESS_GENERAL = bit.lshift( 1, 5 )
ACCESS_GATEA = bit.lshift( 1, 6 )
ACCESS_GATEB = bit.lshift( 1, 7 )
ACCESS_ARMORY = bit.lshift( 1, 8 )
ACCESS_FEMUR = bit.lshift( 1, 9 )
ACCESS_EC = bit.lshift( 1, 10 )

--include( "sh_playersetups.lua" )

if !ConVarExists("br_roundrestart") then CreateConVar( "br_roundrestart", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Restart the round" ) end
if !ConVarExists("br_time_preparing") then CreateConVar( "br_time_preparing", "60", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set preparing time" ) end
if !ConVarExists("br_time_round") then CreateConVar( "br_time_round", "780", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set round time" ) end
if !ConVarExists("br_time_postround") then CreateConVar( "br_time_postround", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Set postround time" ) end
if !ConVarExists("br_time_ntfenter") then CreateConVar( "br_time_ntfenter", "360", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that NTF units will enter the facility" ) end
if !ConVarExists("br_time_blink") then CreateConVar( "br_time_blink", "0.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Blink timer" ) end
if !ConVarExists("br_time_blinkdelay") then CreateConVar( "br_time_blinkdelay", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Delay between blinks" ) end
if !ConVarExists("br_spawnzombies") then CreateConVar( "br_spawnzombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do you want zombies?" ) end
if !ConVarExists("br_scoreboardranks") then CreateConVar( "br_scoreboardranks", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "" ) end
if !ConVarExists("br_defaultlanguage") then CreateConVar( "br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_expscale") then CreateConVar( "br_expscale", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scp_cars") then CreateConVar( "br_scp_cars", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow SCPs to drive cars?" ) end
if !ConVarExists("br_allow_vehicle") then CreateConVar( "br_allow_vehicle", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Allow vehicle spawn?" ) end
if !ConVarExists("br_dclass_keycards") then CreateConVar( "br_dclass_keycards", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is D class supposed to have keycards? (D Class Weterans have keycard anyway)" ) end
if !ConVarExists("br_time_explode") then CreateConVar( "br_time_explode", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time from call br_destroygatea to explode" ) end
if !ConVarExists("br_ci_percentage") then CreateConVar("br_ci_percentage", "25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_i4_min_mtf") then CreateConVar("br_i4_min_mtf", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percentage of CI spawn" ) end
if !ConVarExists("br_premium_url") then CreateConVar("br_premium_url", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Link to premium members list" ) end
if !ConVarExists("br_premium_mult") then CreateConVar("br_premium_mult", "1.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Premium members exp multiplier" ) end
if !ConVarExists("br_premium_display") then CreateConVar("br_premium_display", "Premium player %s has joined!", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Text shown to all players when premium member joins" ) end
if !ConVarExists("br_stamina_enable") then CreateConVar("br_stamina_enable", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is stamina allowed?" ) end
if !ConVarExists("br_stamina_scale") then CreateConVar("br_stamina_scale", "1, 1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Stamina regen and use. ('x, y') where x is how many stamina you will receive, and y how many stamina you will lose" ) end
if !ConVarExists("br_rounds") then CreateConVar("br_rounds", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "How many round before map restart? 0 - dont restart" ) end
if !ConVarExists("br_min_players") then CreateConVar("br_min_players", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum players to start round" ) end
if !ConVarExists("br_firstround_debug") then CreateConVar("br_firstround_debug", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_force_specialround") then CreateConVar("br_force_specialround", "", {FCVAR_SERVER_CAN_EXECUTE}, "Available special rounds [ infect, multi ]" ) end
if !ConVarExists("br_specialround_pct") then CreateConVar("br_specialround_pct", "10", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Skip first round" ) end
if !ConVarExists("br_punishvote_time") then CreateConVar("br_punishvote_time", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How much time players have to vote" ) end
if !ConVarExists("br_allow_punish") then CreateConVar("br_allow_punish", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Is punish system allowed?" ) end
if !ConVarExists("br_cars_ammount") then CreateConVar("br_cars_ammount", "2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How many cars should spawn?" ) end
if !ConVarExists("br_dropvestondeath") then CreateConVar("br_dropvestondeath", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Do players drop vests on death?" ) end
if !ConVarExists("br_force_showupdates") then CreateConVar("br_force_showupdates", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should players see update logs any time they join to server?" ) end
if !ConVarExists("br_allow_scptovoicechat") then CreateConVar("br_allow_scptovoicechat", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Can SCPs talk with humans?" ) end
if !ConVarExists("br_ulx_premiumgroup_name") then CreateConVar("br_ulx_premiumgroup_name", "", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Name of ULX premium group" ) end
if !ConVarExists("br_experimental_bulletdamage_system") then CreateConVar("br_experimental_bulletdamage_system", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problems with bullets" ) end
if !ConVarExists("br_experimental_antiknockback_force") then CreateConVar("br_experimental_antiknockback_force", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn it off when you see any problems with bullets" ) end
if !ConVarExists("br_allow_ineye_spectate") then CreateConVar("br_allow_ineye_spectate", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_allow_roaming_spectate") then CreateConVar("br_allow_roaming_spectate", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" ) end
if !ConVarExists("br_scale_bullet_damage") then CreateConVar("br_scale_bullet_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Bullet damage scale" ) end
if !ConVarExists("br_new_eq") then CreateConVar("br_new_eq", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables new EQ" ) end
if !ConVarExists("br_enable_warhead") then CreateConVar("br_enable_warhead", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Enables OMEGA Warhead" ) end
if !ConVarExists("br_scale_human_damage") then CreateConVar("br_scale_human_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Scales damage dealt by humans" ) end
if !ConVarExists("br_scale_scp_damage") then CreateConVar("br_scale_scp_damage", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "Scales damage dealt by SCP" ) end
if !ConVarExists("br_scp_penalty") then CreateConVar("br_scp_penalty", "3", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" ) end
if !ConVarExists("br_premium_penalty") then CreateConVar("br_premium_penalty", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" ) end


MINPLAYERS = GetConVar("br_min_players"):GetInt()

function GetPrepTime()
	return GetConVar("br_time_preparing"):GetInt()
end

function GetRoundTime()
	if GetGlobalBool("BigRound", false) then
		return 1020
	end
	return 720--GetConVar("br_time_round"):GetInt()
end

function GetPostTime()
	return GetConVar("br_time_postround"):GetInt()
end

function GetGateOpenTime()
	return GetConVar("br_time_gateopen"):GetInt()
end

function GetNTFEnterTime()
	return GetConVar("br_time_ntfenter"):GetInt()
end

function GM:PlayerButtonDown( ply, button )
	if CLIENT and IsFirstTimePredicted() then
		//local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) or "q" ) ] or 
		local key = input.LookupBinding( "+menu" )

		if key then
			if input.GetKeyCode( key ) == button then
				if CanShowEQ() then
					ShowEQ()
				end
			end
		end
	end
end

function GM:PlayerButtonUp( ply, button )
	if CLIENT and IsFirstTimePredicted() then
		//local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) ) ] or KEY_Q
		local key = input.LookupBinding( "+menu" )

		if key then
			if input.GetKeyCode( key ) == button and IsEQVisible() then
				HideEQ()
			end
		end
	end
end


function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	local at = dmginfo:GetAttacker()

	local mul = 1
	local armormul = 1

	if at:IsPlayer() then
		if at:GTeam() == TEAM_SCP then
			local scale = GetConVar( "br_scale_scp_damage" ):GetFloat()
			if scale == 0 then scale = 1 end
			scale = math.Clamp( scale, 0.1, 5 )
			dmginfo:ScaleDamage( scale )
		elseif at:GTeam() != TEAM_SPEC then
			local scale = GetConVar( "br_scale_human_damage" ):GetFloat()
			if scale == 0 then scale = 1 end
			scale = math.Clamp( scale, 0.1, 5 )
			dmginfo:ScaleDamage( scale )
		end

		if at.GetActiveWeapon then
			local wep = at:GetActiveWeapon()
			if IsValid(wep) then
				if wep:GetClass() == "weapon_crowbar" then
					dmginfo:ScaleDamage(0.3)
				elseif wep:GetClass() == "weapon_stunstick" then
					dmginfo:ScaleDamage(0.5)
				end
			end
		end

		if SERVER then
			local rdm = false
			if at != ply then
				if at:IsPlayer() then
					if dmginfo:IsDamageType( DMG_BULLET ) then
						if ply.UsingArmor != nil then
							if ply.UsingArmor != "armor_fireproof" and ply.UsingArmor != "armor_electroproof" then
								armormul = 0.5
							end
						end
					end
					if postround == false and at.GTeam and ply.GTeam then
						if at:GTeam() == TEAM_GUARD then
							if ply:GTeam() == TEAM_GUARD then 
								rdm = true
							elseif ply:GTeam() == TEAM_SCI then
								rdm = true
							end
						elseif at:GTeam() == TEAM_CHAOS then
							if ply:GTeam() == TEAM_CHAOS or ply:GTeam() == TEAM_CLASSD then
								rdm = true
							end
						elseif at:GTeam() == TEAM_SCP then
							if ply:GTeam() == TEAM_SCP then
								rdm = true
							end
						elseif at:GTeam() == TEAM_CLASSD then
							if ply:GTeam() == TEAM_CLASSD or ply:GTeam() == TEAM_CHAOS then
								rdm = true
							end
						elseif at:GTeam() == TEAM_SCI then
							if ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_SCI then 
								rdm = true
							end
						end
					end
					if postround == false then
						if !rdm then
							at:AddExp( math.Round(dmginfo:GetDamage() / 2) )
						end
					end
				end
			end
		end
	end
	
	/*
	if SERVER then
		print("DMG to "..ply:GetName().."["..ply:GetClass().."]", "DMG: "..dmginfo:GetDamage(), "TYPE: "..dmginfo:GetDamageType())
	end
	*/
	
	if hitgroup == HITGROUP_HEAD then
		mul = 3
	elseif hitgroup == HITGROUP_CHEST then
		mul = 1
	elseif hitgroup == HITGROUP_STOMACH then
		mul = 1
	elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
		mul = 0.9
	elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
		mul = 0.8
	end

	if SERVER then
		mul = mul * armormul
		dmginfo:ScaleDamage(mul)
		if ply:GTeam() == TEAM_SCP and OUTSIDE_BUFF( ply:GetPos() ) then
			dmginfo:ScaleDamage( 0.75 )
		end
		local scale = math.Clamp( GetConVar( "br_scale_bullet_damage" ):GetFloat(), 0.1, 2 )
		dmginfo:ScaleDamage( scale )

		if ply:GetNClass() == ROLES.ROLE_SCP957 then
			local wep = ply:GetActiveWeapon()
			if wep and wep:BuffEnabled() then
				dmginfo:ScaleDamage( 0.1 )
			end
		end

		if at:IsPlayer() then
			if at:GetNClass() == ROLES.ROLE_SCP9571 then
				dmginfo:ScaleDamage( 0.2 )
			end

			if at:GetNClass() == ROLES.ROLE_SCP9571 and ply:GTeam() == TEAM_SCP then
				return true
			end
		end
	end
end

local random, GetKeys = math.random, table.GetKeys

function table.Random(tab, issequential)
    local keys = issequential and tab or GetKeys(tab)
    local rand = keys[random(1, #keys)]
    return tab[rand], rand 
end

function BREACH.GroundPos( pos )

	local trace = { }
	trace.start = pos;
	trace.endpos = trace.start - vec_up
	trace.mask = MASK_BLOCKLOS

	local tr = util.TraceLine( trace )

	if ( tr.Hit ) then

		return tr.HitPos

	end

	return pos

end


local AllowedModels = {



	["models/cultist/humans/mog/mog.mdl"] = true,

	["models/cultist/humans/chaos/chaos.mdl"] = true,

	["models/cultist/humans/ntf/ntf.mdl"] = true,

	["models/cultist/humans/goc/goc.mdl"] = true,

	["models/cultist/humans/fbi/fbi.mdl"] = true,

	["models/cultist/humans/mog/mog_hazmat.mdl"] = true,

	["models/cultist/humans/mog/mog_jagger.mdl"] = true,

	["models/cultist/humans/russian/russians.mdl"] = true,



}

hook.Add("SetupMove", "OverrideMovement", function(ply, mv, cmd)
local pl = ply:GetTable()
if ply:GetMoveType() == MOVETYPE_OBSERVER then
	if mv:KeyDown(IN_DUCK) then
		mv:SetButtons(mv:GetButtons() - IN_DUCK)
	end
end
if ( mv:KeyDown(IN_SPEED) ) and mv:KeyDown(IN_JUMP) and ply:GTeam() != TEAM_SPEC then mv:SetButtons(mv:GetButtons() - IN_JUMP) end
if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_OBSERVER then return end

if SERVER then
	ply:SetBreachCrouch(ply.Ducking == true)
else
	ply.Ducking = ply:GetBreachCrouch()
end

	--[[
	if mv:GetVelocity():Length2DSqr() > 100 and mv:KeyDown(IN_JUMP) and ply:IsOnGround() then
		mv:SetButtons(mv:GetButtons() - IN_JUMP)
	end
	--]]

	if ply:GTeam() != TEAM_SCP then

		if IsValid(ply:GetActiveWeapon()) then
			if ply:GetActiveWeapon():GetClass() == "heavy_shield" then
				pl.Ducking = false
			end
		end

		if ply:KeyPressed(IN_DUCK) and IsFirstTimePredicted() then
			if !IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass() != "heavy_shield" then
				pl.Ducking = !pl.Ducking
				if AllowedModels[ply:GetModel()] then
					if pl.Ducking then
						ply:EmitSound( "nextoren/charactersounds/foley/posechange_" .. math.random( 1, 6 ) .. ".wav", 75, math.random( 100, 105 ), 1, CHAN_STATIC )
					else
						ply:EmitSound( "nextoren/charactersounds/foley/posechange_" .. math.random( 1, 6 ) .. ".wav", 75, math.random( 90, 95 ), 1, CHAN_STATIC )
					end
				end
			end
		end

		if mv:KeyDown(IN_DUCK) then
			mv:SetButtons(mv:GetButtons() - IN_DUCK)
		end

		if pl.Ducking then
			ply:SetDuckSpeed(0.1)
			ply:SetUnDuckSpeed(0.1)
			mv:SetButtons(mv:GetButtons() + IN_DUCK)
			if mv:KeyDown(IN_JUMP) then
				mv:SetButtons(mv:GetButtons() - IN_JUMP)
			end
		end

	else

		if mv:KeyDown(IN_JUMP) then
			mv:SetButtons(mv:GetButtons() - IN_JUMP)
		end

		if mv:KeyDown(IN_DUCK) then
			mv:SetButtons(mv:GetButtons() - IN_DUCK)
		end

	end

end)

BREACH = BREACH || {}

local mply = FindMetaTable("Player")

-- FORCED ANIM (COCK) --

function mply:SetForcedAnimation(sequence, endtime, startcallback, finishcallback, stopcallback)

if sequence == false then
	self:StopForcedAnimation()
	return
end

  if SERVER then
  
    if isstring(sequence) then sequence = self:LookupSequence(sequence) end
  	self:SetCycle(0)
      self.ForceAnimSequence = sequence
      
      time = endtime
      
      if endtime == nil then
        time = self:SequenceDuration(sequence)
      end
      
      
      
      net.Start("SHAKY_SetForcedAnimSync")
      net.WriteEntity(self)
      net.WriteUInt(sequence, 20) -- seq cock
      net.Broadcast()
      
      if isfunction(startcallback) then startcallback() end
      
      self.StopFAnimCallback = stopcallback
      
        timer.Create("SeqF"..self:EntIndex(), time, 1, function()
          if (IsValid(self)) then
          
            self.ForceAnimSequence = nil
            
            net.Start("SHAKY_EndForcedAnimSync")
            net.WriteEntity(self)
            net.Broadcast()
            
            self.StopFAnimCallback = nil
            
            if isfunction(finishcallback) then
                finishcallback()
            end
            
          end
          
        end)
      
    end
    
end

function mply:StopForcedAnimation()
    if CLIENT then return end
    timer.Remove("SeqF"..self:EntIndex())
    if isfunction(self.StopFAnimCallback) then self.StopFAnimCallback() self.StopFAnimCallback = nil end
    
    self.ForceAnimSequence = nil        
    net.Start("SHAKY_EndForcedAnimSync")
    net.WriteEntity(self)
    net.Broadcast()
end

if CLIENT then
    net.Receive("SHAKY_EndForcedAnimSync", function(len)
        local ply = net.ReadEntity()
        if IsValid(ply) then
            ply.ForceAnimSequence = nil
        end
    end)
    
    net.Receive("SHAKY_SetForcedAnimSync", function(len)
        local ply = net.ReadEntity()
        local sequence = net.ReadUInt(20)
        ply:SetCycle(0)
        ply.ForceAnimSequence = sequence
    end)
end

function BREACH.GroundPos( pos )

	local trace = { }
	trace.start = pos;
	trace.endpos = trace.start - vec_up
	trace.mask = MASK_BLOCKLOS

	local tr = util.TraceLine( trace )

	if ( tr.Hit ) then

		return tr.HitPos

	end

	return pos

end

function InGas(ply)
	if GAS_AREAS == nil then return false end
	for k,v in pairs(GAS_AREAS) do
		local pos1 = v.pos1
		local pos2 = v.pos2
		OrderVectors(pos1, pos2)
		if ply:GetPos():WithinAABox( pos1, pos2 ) then
			return true
		end
	end
	return false
end
function GM:GrabEarAnimation(ply)
	return false
end

function GM:EntityFireBullets( ent, data )
end

local mply = FindMetaTable( "Player" )

function mply:ToPD()
	local client = LocalPlayer()
	client:SetPos( Vector(3674.955811, -14796.375000, -2991.968750) )
end

local AllowedModels = {

	["models/cultist/humans/mog/mog.mdl"] = true,
	["models/cultist/humans/chaos/chaos.mdl"] = true,
	["models/cultist/humans/chaos/fat/chaos_fat.mdl"] = true,
	["models/cultist/humans/ntf/ntf.mdl"] = true,
	["models/cultist/humans/goc/goc.mdl"] = true,
	["models/cultist/humans/fbi/fbi.mdl"] = true,
    ["models/cultist/humans/nazi/nazi.mdl"] = true,
    ["models/cultist/humans/russian/russians.mdl"] = true,
	["models/cultist/humans/mog/mog_hazmat.mdl"] = true,
	[ "models/cultist/humans/obr/obr.mdl" ] = true,
	["models/cultist/humans/mog/mog_jagger.mdl"] = true

}

local silencedwalkroles = {
	["SCP457"] = true,
	["SCP096"] = true,
	["SCP062DE"] = true,
	["SCP973"] = true,
	["SCP811"] = true,
	["SCP062FR"] = true,
	["SCP1903"] = true,
}

SCPFOOTSTEP = SCPFOOTSTEP || {
	["SCP682"] = true,
	["SCP939"] = true,
	["SCP082"] = true,
}

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
--[[
--Clientside footsteps to optimize server
	if SERVER then
		return true
	end
--]]

local pl = ply:GetTable()

	local vel = ply:GetVelocity():Length2DSqr()
	local wep = ply:GetActiveWeapon()
	if not pl.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if not pl.GetNClass then return end

	if ply:GetNoDraw() then return true end

	if silencedwalkroles[ply:GetNClass()] then
		if ply:GetNClass() == "SCP062DE" and ply:KeyDown(IN_SPEED) and ply:HasWeapon("cw_kk_ins2_doi_mp40") then
			ply:EmitSound( "nextoren/charactersounds/foley/sprint/sprint_"..math.random( 1, 52 )..".wav", 75, 45, volume * .5)
		end
		return true
	end

	if ply:GetNClass() == "SCP173" then
		if pl.steps == nil then pl.steps = 0 end
		pl.steps = pl.steps + 1
		if pl.steps > 6 then
			pl.steps = 1
			if SERVER then
				ply:EmitSound( "173sound"..math.random(1,3)..".ogg", 75, math.random( 100, 120 ), volume * .8 )
			end
		end
		return true
	elseif ply:GetNClass() == "SCP2012" then

		if SERVER then ply:EmitSound( "nextoren/scp/2012/footsteps/footstep_"..math.random(1,8)..".wav", 75, math.random( 100, 120 ), volume * .8 ) end
		return true

	elseif ( SCPFOOTSTEP[ply:GetNClass()] ) then

		if SERVER then ply:EmitSound( "nextoren/scp/682/scp_682_footstep_"..math.random(1,4)..".ogg", 75, math.random( 100, 120 ), volume * .8 ) end
		return true

	elseif ( AllowedModels[ ply:GetModel() ] ) then

		if ( vel > 22500 ) then
			if IsValid(ply:GetActiveWeapon()) then
				if ply:GetActiveWeapon():GetClass() == "heavy_shield" then
					ply:EmitSound( "player/footstepsnew/shield_step_0"..math.random(1,10)..".wav", 300, math.random( 100, 120 ), 2 * .5 )
					ply:EmitSound( "nextoren/charactersounds/foley/sprint/sprint_"..math.random( 1, 52 )..".wav", 75, math.random( 100, 120 ), volume * .5)
				else
					ply:EmitSound( "nextoren/charactersounds/foley/sprint/sprint_"..math.random( 1, 52 )..".wav", 75, math.random( 100, 120 ), volume * .5)
				end
			else
				ply:EmitSound( "nextoren/charactersounds/foley/sprint/sprint_"..math.random( 1, 52 )..".wav", 75, math.random( 100, 120 ), volume * .5 )
			end

		else

			if IsValid(ply:GetActiveWeapon()) then
				if ply:GetActiveWeapon():GetClass() == "heavy_shield" then
					ply:EmitSound( "player/footstepsnew/shield_step_0"..math.random(1,10)..".wav", 300, math.random( 100, 120 ), 2 * .8)
					ply:EmitSound( "nextoren/charactersounds/foley/run/run_"..math.random( 1, 40 )..".wav", 75, math.random( 100, 120 ), volume * .8)
				else
					ply:EmitSound( "nextoren/charactersounds/foley/run/run_"..math.random( 1, 40 )..".wav", 75, math.random( 100, 120 ), volume * .8)
				end
			else
				ply:EmitSound( "nextoren/charactersounds/foley/sprint/sprint_"..math.random( 1, 52 )..".wav", 75, math.random( 100, 120 ), volume * .5 )
			end

		end

		return false

	elseif ply:GetNClass() == "SCP049" then

		if SERVER then

			ply:EmitSound( "nextoren/scp/049/step"..math.random(1,3)..".ogg", 75, math.random( 100, 120 ), volume * .8 )

		end

		return true

	elseif ply:GetNClass() == "SCP638" then

		if SERVER then

			ply:EmitSound( "nextoren/charactersounds/zombie/foot"..math.random(1,3)..".wav", 75, math.random( 100, 120 ), volume * .8 )
		
		end

		return true

	end
	return false
end

local meta = FindMetaTable("Player");
local ent = FindMetaTable( "Entity" )

function meta:IsLZ()

	local pos = self:GetPos()
  
	if ( pos.x > 4600 && pos.y > -7003 && pos.y < -1200 && pos.z < 880 || pos.x > 8550 && pos.y < -440 && pos.y > -7000 || ( pos.x > -1000 && pos.x < 1680 ) && pos.y < -3600 && pos.y > -5800 && pos.z < -1000 ) then
  
	  return true
  
	end
  
	if ( pos.x > 7283 && pos.x < 7680 && pos.y < -1075 && pos.y > -1240 ) then
  
	  return true
  
	end
  
	return false
  
end
  
function ent:Outside()



	if ( self:GetPos().z > 880 ) then
  
  
  
	  return true;
  
  
  
	end
  
  
  
	return false
  
  
  
end
  
function meta:Outside()



	if ( self:GetPos().z > 880 ) then
  
  
  
	  return true;
  
  
  
	end
  
  
  
	return false
  
  
  
end
  
  
  
function meta:IsEntrance()
  
	local pos = self:GetPos()
  
	if ( pos.x < 1767 && pos.x > -3120 && pos.y > 1944 && pos.y < 6600 && pos.z < 880 ) then
  
	  return true
  
	end
  
	return false
  
end



function meta:IsBlack()
	for i, v in pairs(ents.FindByClassAndParent("ent_bonemerged", self)) do
		if IsValid(v) and v:GetModel():find("head_main_1") then
			return NextOren_HEADS_BLACKHEADS[v:GetSubMaterial(0)]
		end
	end
	return false
end
  
function meta:IsHardZone()
  
	local pos = self:GetPos()
  
	if ( pos.x < 8320 && pos.x > 1200 && pos.y > -1200 && pos.z < 880 ) then
  
	  return true
  
	end
  
	return false
  
end

local blockeddoors_scp = {
	Vector(-321, 4784, 53),
	Vector(-2046.5, 6181.5, 181),
	Vector(-3790.4899902344, 2472.5100097656, 53.25),
	Vector(-5028.9702148438, 3993.5, -1947),
}


function GM:ShouldCollide( ent1, ent2 )
	/*local ply = ent1:IsPlayer() and ent1 or ent2:IsPlayer() and ent2
	local ent
	if ply then
		if ent1 == ply then
			ent = ent2
		else
			ent = ent1
		end
		if ply:GetNClass() == SCP106 then
			if ent.ignorecollide106 then
				return false
			end
		end
	end*/
	if ent1:IsPlayer() and ent1:GetNClass() == "SCP106" or ent2:IsPlayer() and ent2:GetNClass() == "SCP106" then
		if ent1:GetClass() == "func_door" or ent2:GetClass() == "func_door" or ent2:GetClass() == "prop_dynamic" or ent1:GetClass() == "prop_dynamic" then
			--if table.HasValue(blockeddoors_scp, ent1:GetPos()) then return true end
			--if table.HasValue(blockeddoors_scp, ent2:GetPos()) then return true end
			if SERVER then
				return SCPLockDownHasStarted != true
			else
				return false
			end
		end
	end	
	return true
end

function GM:Move( ply, mv )
end
if CLIENT then

	hook.Add('HUDShouldDraw', 'DisableStandartDMGScreen', function(name) 
		if name == "CHudDamageIndicator" then 
			return false 
		end 
	end )

else

	hook.Add( "PlayerHurt", "Brech_dmgeffect", function( ply, attacker, healthRemaining )
		if attacker and IsValid(attacker) and attacker:IsPlayer() then
			local wep = attacker:GetActiveWeapon()
			if wep and IsValid(wep) and wep:GetClass() == 'br_holster' then return end
		end
		if healthRemaining > 1 then
			ply:ScreenFade( SCREENFADE.IN, Color( 95, 19, 19, 253), 0.6, 0.4 )
		end
	end )

end

