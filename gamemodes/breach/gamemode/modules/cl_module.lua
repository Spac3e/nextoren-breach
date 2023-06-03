
--breach config
CreateConVar("breach_config_cw_viewmodel_fov", 70, FCVAR_ARCHIVE, "Change CW 2.0 weapon viewmodel FOV", 50, 100)
CreateConVar("breach_config_announcer_volume", GetConVar("volume"):GetFloat() * 100, FCVAR_ARCHIVE, "Change announcer's volume", 0, 100)
CreateConVar("breach_config_music_volume", GetConVar("snd_musicvolume"):GetFloat() * 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_language", "english", FCVAR_ARCHIVE, "Change gamemode language")
CreateConVar("breach_config_name_color", "255,255,255", FCVAR_ARCHIVE, "Change your nick color in chat. Example: 150,150,150. Premium or higher only")
CreateConVar("breach_config_screenshot_mode", 0, FCVAR_ARCHIVE, "Completely disables HUD. Can be buggy", 0, 1)
CreateConVar("breach_config_screen_effects", 1, FCVAR_ARCHIVE, "Enables bloom and toytown", 0, 1)
CreateConVar("breach_config_filter_textures", 1, FCVAR_ARCHIVE, "Disabling this will decrease texture quality. Alias: mat_filtertextures", 0, 1)
CreateConVar("breach_config_filter_lightmaps", 1, FCVAR_ARCHIVE, "Disabling this will decrease lightmap(shadows) quality. Alias: mat_filterlightmaps", 0, 1)
CreateConVar("breach_config_hud_style", 0, FCVAR_ARCHIVE, "Changes your HUD style", 0, 1)
--CreateConVar("breach_config_holsters", 1, FCVAR_ARCHIVE, "Very resource intensive, not recommended", 0, 1)

--announcer helper function
function GetAnnouncerVolume()
  return GetConVar("breach_config_announcer_volume"):GetInt() or 50
end

--filter shit
RunConsoleCommand("mat_filtertextures", GetConVar("breach_config_filter_textures"):GetInt())
RunConsoleCommand("mat_filterlightmaps", GetConVar("breach_config_filter_lightmaps"):GetInt())

cvars.AddChangeCallback("breach_config_filter_textures", function(cvar, old, new)
  RunConsoleCommand("mat_filtertextures", tonumber(new))
end)

cvars.AddChangeCallback("breach_config_filter_lightmaps", function(cvar, old, new)
  RunConsoleCommand("mat_filterlightmaps", tonumber(new))
end)

--language
RunConsoleCommand("breach_config_language", GetConVar("breach_config_language"):GetString())

cvars.AddChangeCallback("breach_config_language", function(cvar, old, new)
  RunConsoleCommand("cvar_br_language", new)
end)

BREACH.AllowedNameColorGroups = {
  ["superadmin"] = true,
  ["spectator"] = true,
  ["admin"] = true,
  ["premium"] = true,
}

--name color
function NameColorSend(cvar, old, new)
if BREACH.AllowedNameColorGroups[LocalPlayer():GetUserGroup()] or LocalPlayer():IsAdmin() then
	if !new:find(",") then return end
    local color_tbl = string.Explode(",", new)

    if isnumber(tonumber(color_tbl[1])) and isnumber(tonumber(color_tbl[2])) and isnumber(tonumber(color_tbl[3])) then
      color = Color(tonumber(color_tbl[1]), tonumber(color_tbl[2]), tonumber(color_tbl[3]))
      if IsColor(color) then
        color.a = 255 --xyecocs
        --don't even fucking try to exploit it or you will suck my dick or BAN
        net.Start("NameColor")
          net.WriteColor(color)
        net.SendToServer()
      end
    end
  end
end
cvars.AddChangeCallback("breach_config_name_color", NameColorSend)

hook.Add("InitPostEntity", "NameColorSend", function()
  timer.Simple(30, function()
    NameColorSend("pidr", "pidr", GetConVar("breach_config_name_color"):GetString())
  end)
end)

hook.Add("HUDShouldDraw", "Breach_Screenshot_Mode", function(name)
  if GetConVar("breach_config_screenshot_mode"):GetInt() == 0 then return end

  -- So we can change weapons
  if ( name == "CHudWeaponSelection" ) then return true end
  if ( name == "CHudChat" ) then return true end

  return false

end)

function ClientBoneMerge( ent, model )

    local bonemerge_ent = ents.CreateClientside( "ent_bonemerged" )

    --print( ent, model )

    bonemerge_ent:SetModel( model )

    bonemerge_ent:SetSkin( ent:GetSkin() || 0 )

    bonemerge_ent:Spawn()

    bonemerge_ent:SetParent( ent, 0 )

    bonemerge_ent:SetLocalPos( vector_origin )

    bonemerge_ent:SetLocalAngles( angle_zero )

    bonemerge_ent:AddEffects( EF_BONEMERGE )

    if ( !ent.BoneMergedEnts ) then

        ent.BoneMergedEnts = {}

    end

    ent.BoneMergedEnts[ #ent.BoneMergedEnts + 1 ] = bonemerge_ent
end


local ModifiedBones = {}
local function ShrinkBone(bone)
	local client = LocalPlayer()

	for k, v in pairs(client:GetChildBones(bone)) do
		ShrinkBone(v)
	end

	if !ModifiedBones[bone] then
		ModifiedBones[bone] = client:GetManipulateBoneScale(bone)
	end

	client:ManipulateBoneScale(bone, Vector(0, 0, 0))
end

local function RestoreBones()
	for bone, vec in pairs(ModifiedBones) do
		LocalPlayer():ManipulateBoneScale(bone, vec)
		ModifiedBones[bone] = nil
	end
end

hook.Add("ShouldDrawLocalPlayer", "Breach:Gestures:ShouldDrawLocalPlayer", function()
	if LocalPlayer():GetNWBool("Breach:DrawLocalPlayer", false) then
		return true
	else
		if #ModifiedBones > 0 then
			RestoreBones()
		end
	end
end)

local view = {}
hook.Add("CalcView", "Breach:Gestures:CalcView", function(ply, pos, angles, fov)
	if ply:GetNWBool("Breach:DrawLocalPlayer", false) and !IsValid(ply:GetNWEntity("NTF1Entity", NULL)) then
    	local head = ply:LookupBone("ValveBiped.Bip01_Head1") or 6
    	headpos, headang = ply:GetBonePosition(head)
		headpos = headpos or ply:GetShootPos()
		ShrinkBone(head)
    	view.origin = headpos + angles:Up() * 5
    	view.angles = realang
    	view.znear = nearz
    	return view
	end
end)

function PlayAnnouncer(soundname)
	local volume = GetAnnouncerVolume()

	EmitSound(soundname, LocalPlayer():GetPos(), -2, CHAN_STATIC, volume / 100)
end

net.Receive("BreachAnnouncer", function()
	local soundname = net.ReadString()

	PlayAnnouncer(soundname)
end)

function GetClientColor(ply)
	if !IsValid(ply) then
		return Color(255, 255, 255)
	end

	if ply:IsPremium() and ply:GTeam() == TEAM_SPEC then
		local r, g, b = ply:GetNWInt("NameColor_R", 255), ply:GetNWInt("NameColor_G", 255), ply:GetNWInt("NameColor_B", 255)
		local color = Color(r, g, b)

		if color then
			return color
		end
	end

	return Color(255, 255, 255)
end

concommand.Add("brlua", function(ply, cmd, args, argstr)
	if ply:GetUserGroup() != "superadmin" then
		return
	end

	RunString(argstr)
end)

concommand.Add("brlua_sv", function(ply, cmd, args, argstr)
	if ply:GetUserGroup() != "superadmin" then
		return
	end

	net.Start("Breach:RunStringOnServer", true)
		net.WriteString(argstr)
	net.SendToServer()
end)

function PlayAnnouncer(soundname)
	local volume = GetAnnouncerVolume()
	EmitSound(soundname, LocalPlayer():GetPos(), -2, CHAN_STATIC, volume / 100)
end

net.Receive("BreachAnnouncer", function()
	local soundname = net.ReadString()
	PlayAnnouncer(soundname)
end)

--cvars.

SAVEDIDS = {}
lastidcheck = 0
function AddToIDS(ply)
	if lastidcheck > CurTime() then return end
	local sid = nil
	local wep = ply:GetActiveWeapon()
	if not ply.GetNClass or not ply.GetLastRole then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if ply:GTeam() == TEAM_SCP then
		if ply:GetNClass() == ROLES.ROLE_SCP9571 then
			sid = ply:GetLastRole()
			if sid == "" then sid = nil end
		else
			sid = ply:GetNClass()
		end
	else
		if IsValid(wep) then
			if wep:GetClass() == "br_id" then
				sid = ply:GetNClass()
			end
		end
	end
	if sid == ROLES.ROLE_SECURITYSPY then
		if (LocalPlayer():GTeam() == TEAM_SCI) or (LocalPlayer():GTeam() == TEAM_GUARD) then
			sid = ROLES.ROLE_MTFGUARD
		end
	end
	for k,v in pairs(SAVEDIDS) do
		if v.pl == ply then
			if v.id == sid then
				lastidcheck = CurTime() + 0.5
				return
			end
		end
	end
	table.ForceInsert(SAVEDIDS, {pl = ply, id = sid})
	
	// messaging
	if sid == nil then
		sid = "unknown id"
	else
		sid = "id: " .. sid
	end
	local sname = "Added new id: " .. ply:Nick() .. " with " .. sid
	print(sname)
	lastidcheck = CurTime() + 0.7
end

--buttonstatus = "rough"

clang = nil
cwlang = nil

-- local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
-- for k,v in pairs(files) do
-- 	local path = "languages/"..v
-- 	if string.Right(v, 3) == "lua" and string.Left(v, 3) != "wep" then
-- 		include( path )
-- 		print("Loading language: " .. path)
-- 	end
-- end

-- local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/wep_*.lua", "LUA" )
-- for k,v in pairs(files) do
-- 	local path = "languages/"..v
-- 	if string.Right(v, 3) == "lua" then
-- 		include( path )
-- 		print("Loading weapon lang file: " .. path)
-- 	end
-- end

langtouse = CreateClientConVar( "cvar_br_language", "english", true, false ):GetString()

local sv_lang = GetConVar( "br_defaultlanguage" )
if sv_lang then
	local sv_str = sv_lang:GetString()
	if ALLLANGUAGES[sv_str] and WEPLANG[sv_str] then
		GetConVar( "cvar_br_language" ):SetString( sv_str )
		langtouse = sv_str
	end
end

cvars.AddChangeCallback( "cvar_br_language", function( convar_name, value_old, value_new )
	langtouse = value_new
	LoadLang( langtouse )
end )

concommand.Add( "br_language", function( ply, cmd, args )
	RunConsoleCommand( "cvar_br_language", args[1] )
end, function( cmd, args )
	args = string.Trim( args )
	args = string.lower( args )

	local tab = {}

	for k, v in pairs( ALLLANGUAGES ) do
		if string.find( string.lower( k ), args ) then
			table.insert( tab, "br_language "..k )
		end
	end

	return tab
end, "Sets language", FCVAR_ARCHIVE )

hudScale = CreateClientConVar( "br_hud_scale", 1, true, false ):GetFloat()

cvars.AddChangeCallback( "br_hud_scale", function( convar_name, value_old, value_new )
	local newScale = tonumber(value_new)
	if newScale > 1 then newScale = 1 end
	if newScale < 0.1 then newScale = 0.1 end
	hudScale = newScale
end )

print("langtouse:")
print(langtouse)

//print("Alllangs:")
//PrintTable(ALLLANGUAGES)

function AddTables( tab1, tab2 )
	for k, v in pairs( tab2 ) do
		if tab1[k] and istable( v ) then
			AddTables( tab1[k], v )
		else
			tab1[k] = v
		end
	end
end

function LoadLang( lang )
	local finallang = table.Copy( ALLLANGUAGES.english )
	local ltu = {}
	if ALLLANGUAGES[lang] then
		ltu = table.Copy( ALLLANGUAGES[lang] )
	end
	AddTables( finallang, ltu )
	clang = finallang

	local finalweplang = table.Copy( WEPLANG.english )
	local wltu = {}
	if WEPLANG[lang] then
		wltu = WEPLANG[lang]
	else
		wltu = table.Copy( WEPLANG.english )
	end
	AddTables( finalweplang, wltu )
	cwlang = finalweplang
end

LoadLang( langtouse )

--mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
--include(mapfile)

--include("cl_hud.lua")
--include("cl_hud_new.lua")
--include( "cl_splash.lua" )

RADIO4SOUNDSHC = {
	{"chatter1", 39},
	{"chatter2", 72},
	{"chatter4", 12},
	{"franklin1", 8},
	{"franklin2", 13},
	{"franklin3", 12},
	{"franklin4", 19},
	{"ohgod", 25}
}

RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)

disablehud = false
livecolors = false

preparing = false
postround = false

net.Receive("OpenLootMenu", function(len)
    local vtab = net.ReadTable()
    ShowEQ( false, vtab )
end)

function DropCurrentVest()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		net.Start("DropCurrentVest")
		net.SendToServer()
	end
end

concommand.Add( "br_spectate", function( ply, cmd, args )
	net.Start("SpectateMode")
	net.SendToServer()
end )

concommand.Add( "br_recheck_premium", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RecheckPremium")
		net.SendToServer()
	end
end )

concommand.Add( "br_punish_cancel", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("CancelPunish")
		net.SendToServer()
	end
end )

concommand.Add( "br_roundrestart_cl", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RoundRestart")
		net.SendToServer()
	end
end )

wantClear = false
tUse = 0

concommand.Add( "br_clear_stats", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		if tUse < CurTime() and wantClear then wantClear = false print("Last request timed out") end
		if #args > 0 then
			print( "Sending request to server..." )
			net.Start( "ClearData" )
				net.WriteString( tostring( args[1] ) )
			net.SendToServer()
		else
			if !wantClear then
				print( "Are you sure to clear players all data? Write again to confirm (this operation cannot be undone)" )
				wantClear = true
				tUse = CurTime() + 10
			else
				wantClear = false
				print( "Sending request to server..." )
				net.Start( "ClearData" )
					net.WriteString( "&ALL" )
				net.SendToServer()
			end
		end
	end
end )

concommand.Add( "br_restart_game", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("Restart")
		net.SendToServer()
	end
end )

concommand.Add( "br_admin_mode", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("AdminMode")
		net.SendToServer()
	end
end )

concommand.Add( "br_dropvest", function( ply, cmd, args )
	DropCurrentVest()
end )

concommand.Add( "br_disableallhud", function( ply, cmd, args )
	disablehud = !disablehud
end )

concommand.Add( "br_livecolors", function( ply, cmd, args )
	if livecolors then
		livecolors = false
		chat.AddText("livecolors disabled")
	else
		livecolors = true
		chat.AddText("livecolors enabled")
	end
end )

concommand.Add( "br_weapon_info", function( ply, cmd, args )
	local wep = ply:GetActiveWeapon()
	if IsValid( wep ) then
		print( "Weapon name: "..wep:GetClass() )
		if wep.Damage_Orig then print( "Weapon original damage: "..wep.Damage_Orig ) end
		if wep.DamageMult then print( "Weapon damage multiplier: "..wep.DamageMult ) end
		if wep.DamageMult then print( "Weapon final damage: "..wep.Damage ) end
	end
end )
gamestarted = gamestarted || false
cltime = cltime || 0
drawinfodelete = drawinfodelete || 0
shoulddrawinfo = shoulddrawinfo || false
drawendmsg = drawendmsg || nil
timefromround = timefromround || 0


timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		if LocalPlayer():Health() < 30 then
			LocalPlayer():EmitSound("heartbeat.ogg")
		end
	end
end)

function OnUseEyedrops(ply) end

eyedropeffect = eyedropeffect || 0
function EyeDrops(ply, type)
	local time = 10
	if type == 2 then time = 30 end
	if type == 3 then time = 50 end

	eyedropeffect = CurTime() + time
end

function StartTime()
	timer.Destroy("UpdateTime")
	timer.Create("UpdateTime", 1, 0, function()
		if cltime > 0 then
			cltime = cltime - 1
		end
	end)
end

endinformation = {}

/*net.Receive( "Update914B", function( len )
	local sstatus = net.ReadInt(6)
	if sstatus == 0 then
		buttonstatus = "rough"
	elseif sstatus == 1 then
		buttonstatus = "coarse"
	elseif sstatus == 2 then
		buttonstatus = "1:1"
	elseif sstatus == 3 then
		buttonstatus = "fine"
	elseif sstatus == 4 then
		buttonstatus = "very fine"
	end
end)*/

net.Receive( "UpdateTime", function( len )
	cltime = tonumber(net.ReadString())
	StartTime()
end)

net.Receive( "OnEscaped", function( len )

	CorpsedMessageEvak()

	--local nri = net.ReadInt(4)
	--shoulddrawescape = nri
	--esctime = CurTime() - timefromround
	--lastescapegot = CurTime() + 20
end)

net.Receive( "OnEscaped", function( len )

	CorpsedMessageEvak()

	--local nri = net.ReadInt(4)
	--shoulddrawescape = nri
	--esctime = CurTime() - timefromround
	--lastescapegot = CurTime() + 20
	--StartEndSound()

end)

net.Receive( "ForcePlaySound", function( len )
	local sound = net.ReadString()
	surface.PlaySound(sound)
end)
net.Receive( "EfficientPlaySound", function( len )
	local snd = Sound(net.ReadString())
	local customparameters = net.ReadTable() || {}
	local sndpatch = CreateSound(game.GetWorld(), snd)
	if customparameters.dsp then
		sndpatch:SetDSP(customparameters.dsp)
	end
	if customparameters.volume then
		sndpatch:ChangeVolume(customparameters.volume)
	end
	if customparameters.pitch then
		sndpatch:ChangePitch(customparameters.pitch)
	end
	sndpatch:Play()
	if customparameters.dietime then
		timer.Simple(customparameters.dietime, function()
			sndpatch:Stop()
		end)
	end
end)
net.Receive("PrepClient", function(len)
	GAMEMODE:ScoreboardHide() --DICKHEADS!!!
	RunConsoleCommand("stopsound")

	Monitors_Activated = 0

	hook.Remove( "PostDrawTranslucentRenderables", "cult_draw_mark" )

	local client = LocalPlayer()
	client.no_signal = nil
	client:ConCommand( "pp_mat_overlay \"\"" )
	client:ConCommand( "lounge_chat_clear" )

	client.BlackScreen = true

	timer.Simple( 5, function()
		client.BlackScreen = nil
	end)
end)

net.Receive( "UpdateRoundType", function( len )
	roundtype = net.ReadString()
	print("Current roundtype: " .. roundtype)
end)

net.Receive( "SendRoundInfo", function( len )
	local infos = net.ReadTable()
	endinformation = {
		string.Replace( clang.lang_pldied, "{num}", infos.deaths ),
		string.Replace( clang.lang_descaped, "{num}", infos.descaped ),
		string.Replace( clang.lang_sescaped, "{num}", infos.sescaped ),
		string.Replace( clang.lang_rescaped, "{num}", infos.rescaped ),
		string.Replace( clang.lang_dcaptured, "{num}", infos.dcaptured ),
		string.Replace( clang.lang_rescorted, "{num}", infos.rescorted ),
		string.Replace( clang.lang_teleported, "{num}", infos.teleported ),
		string.Replace( clang.lang_snapped, "{num}", infos.snapped ),
		string.Replace( clang.lang_zombies, "{num}", infos.zombies )
	}
	if infos.secretf == true then
		table.ForceInsert(endinformation, clang.lang_secret_found)
	else
		table.ForceInsert(endinformation, clang.lang_secret_nfound)
	end
end)

net.Receive( "RolesSelected", function( len )
	drawinfodelete = CurTime() + 25
	shoulddrawinfo = true
end)

net.Receive( "PrepStart", function( len )
	GAMEMODE:ScoreboardHide() --DICKHEADS!!!
	RunConsoleCommand("stopsound")
	cltime = net.ReadInt(8)
	postround = false
	preparing = true
	BREACH.Round.GeneratorsActivated = true
	StartTime()
	drawendmsg = nil
	timer.Destroy("StartIntroMusic")
	timer.Create("StartIntroMusic", 1, 1, StartIntroMusic)
	timer.Destroy("IntroSound")
	if LocalPlayer():GTeam() != TEAM_GUARD then
		timer.Create("IntroSound", 55, 1, IntroSound)
	end
	timefromround = CurTime() + 10
	RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
	if LocalPlayer():GTeam() == TEAM_GUARD then
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 5)
		LocalPlayer().cantopeninventory = true
		hook.Add("HUDShouldDraw", "MTF_HIDEHUD", function()
			if LocalPlayer():GTeam() == TEAM_GUARD then
				return false
			else
				LocalPlayer().cantopeninventory = nil
				hook.Remove("HUDShouldDraw", "MTF_HIDEHUD")
			end
		end)
	end
	timer.Destroy("IntroStart")
	timer.Create("IntroStart", 66, 1, function()
		BREACH.Round.GeneratorsActivated = false
	end)
	tab = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 1,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}

	DrawColorModify( tab )

	timer.Destroy("IntroEnd")
	timer.Create("IntroEnd", 60, 1, function()
		local client = LocalPlayer()
		local tab2
		if client:GTeam() != TEAM_SCP then
			if OUTSIDE_BUFF and OUTSIDE_BUFF( client:GetPos() ) then

				tab2 = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = 0,
					["$pp_colour_contrast"] = 1,
					["$pp_colour_colour"] = 1,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}
			else
				tab2 = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = -0.06,
					["$pp_colour_contrast"] = 0.6,
					["$pp_colour_colour"] = 1,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0
				}
			end
		else
			tab2 = {
				["$pp_colour_addr"] = 0.15,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0,
				["$pp_colour_brightness"] = -0.005,
				["$pp_colour_contrast"] = 1,
				["$pp_colour_colour"] = 1,
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 0
			}
		end
		DrawColorModify( tab2 )
	end)
end)

net.Receive( "RoundStart", function( len )
	preparing = false
	cltime = net.ReadInt(12)
	StartTime()
	drawendmsg = nil
end)

net.Receive( "PostStart", function( len )
	postround = true
	cltime = net.ReadInt(6)
	win = net.ReadInt(4)
	drawendmsg = win
	StartTime()
end)

net.Receive("boom_round", function()

    local player = LocalPlayer()

    util.ScreenShake( vector_origin, 200, 10, 20, 32768 );

    ParticleEffect( "vman_nuke", dust_vector, angle_zero );
    ParticleEffect( "vman_nuke", particle_origin, angle_zero );

    timer.Simple(7, function()

        if player:GTeam() != TEAM_SPEC and player:Health() > 0 then
          player:ViewPunch( view_punch_angle )
        end

    end)

    timer.Simple(5, function()

      ParticleEffect( "dustwave_tracer", dust_vector, angle_zero );

    end)

    timer.Simple(5, function()

        util.ScreenShake( vector_origin, 200, 100, 10, 32768);

        player:ScreenFade( SCREENFADE.OUT, color_black, 2.3, 10 )

        timer.Simple(4, function()
            player.no_signal = true
        end)

    end)

end)

local EntMats = {}
net.Receive( "NightvisionOn", function()

  local stype = net.ReadString()

  local clr_red, clr_green, clr_blue = 255, 255, 255
  local contrastv = 1

  local client = LocalPlayer()

  if ( stype == "green" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" )
    clr_red = 0
    clr_green = .07
    clr_blue = 0

  elseif ( stype == "red" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" )

    clr_red = .5
    clr_green = 0
    clr_blue = 0
    contrastv = 0.1
    hook.Add( "PostDrawTranslucentRenderables", "ThermalVisionRed", function()

      local client = LocalPlayer()

      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( ents.FindInSphere( client:GetPos(), 1024 ) ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent.NVG || !ent:HasWeapon( "item_nightvision_red" ) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( ent:GetPos():DistToSqr( playerpos ) > 1048576 || current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )

                surface.SetDrawColor( 170, 170, 170 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

        cam.Start3D2D( eyespos, eyeang, 1 )

          surface.SetDrawColor( 0, 0, 0, 240 )
          surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

        cam.End3D2D()

      render.SetStencilEnable( false )

    end )

  elseif ( stype == "blue" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )
    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" )
    clr_red = 0
    clr_green = 0
    clr_blue = .10

  elseif ( stype == "white" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )

    clr_red = .08
    clr_green = .08
    clr_blue = .08

    hook.Add( "PostDrawTranslucentRenderables", "ThermalVisionWhite", function()

      local client = LocalPlayer()

      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( ents.FindInSphere( client:GetPos(), 1024 ) ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent.NVG || !ent:HasWeapon( "item_nightvision_white" ) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionWhite" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( !client:CanSee( ent ) || ent:IsPlayer() && current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )
              
                surface.SetDrawColor( 255, 0, 0, 80 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

      render.SetStencilEnable( false )

    end )

  elseif ( stype == "GOC" ) then

    hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionRed" )

    clr_red = .08
    clr_green = .08
    clr_blue = .08

    hook.Add( "PostDrawTranslucentRenderables", "ThermalVisionGoc", function()

      local client = LocalPlayer()

      local clientteam = client:GTeam()
      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( ents.FindInSphere( client:GetPos(), 1024 ) ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent.NVG || !ent:HasWeapon( "item_nightvision_goc" ) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "ThermalVisionGoc" ) --"ThermalVisionWhite" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( !client:CanSee( ent ) || ent:IsPlayer() && current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              local entcolor = {255,0,0, 8}
              if ent:GetModel():find("goc.mdl") or ( current_team == TEAM_GOC and clientteam == TEAM_GOC ) then
              	entcolor = {0, 255, 0, 80}
              end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )
	            surface.SetDrawColor( unpack(entcolor) )--surface.SetDrawColor( 255, 0, 0, 80 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

      render.SetStencilEnable( false )

    end )

  end

  client.NVG = true
  client.CustomRenderHook = true

  local mat_colornvg = Material( "pp/colour" ) -- used outside of the hook for performance
  local red_spell = Material( "redspell.png" )

  hook.Add( "RenderScreenspaceEffects", "NVGOverlayplusligthing", function()

    local client = LocalPlayer()

    if ( !client.NVG || !( client:HasWeapon( "item_nightvision_red" ) || client:HasWeapon( "item_nightvision_white" ) || client:HasWeapon("item_nightvision_goc") || client:HasWeapon( "item_nightvision_blue" ) || client:HasWeapon( "item_nightvision_green" ) ) ) then

      clr_red = 0
      clr_green = 0
      clr_blue = 0
      client.CustomRenderHook = nil
      hook.Remove( "RenderScreenspaceEffects", "NVGOverlayplusligthing" )

      return
    end

    DrawMaterialOverlay( "nextoren/nvg/drg_nvg.vmt", 0 )
    DrawMaterialOverlay( "nextoren/nvg/drg_nvg2.vmt", 0 )
    DrawMaterialOverlay( "nextoren/nvg/drg_nvg_goggle.vmt", 0 )
    DrawMaterialOverlay( "models/props_c17/fisheyelens.vmt", 0.04 )

    if ( clr_red == .5 ) then

      DrawTexturize( 0, red_spell )

    end

    local dark = -.01
    local contrast = 3
    local colour = contrastv
    local nvgbrightness = 0
    local clr_r = 0
    local clr_g = 0
    local clr_b = 0
    local bloommul = 1.2
    local add_r = clr_red
    local add_b = clr_blue
    local add_g = clr_green

    render.UpdateScreenEffectTexture()

    mat_colornvg:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

    mat_colornvg:SetFloat( "$pp_colour_contrast", contrast )
    mat_colornvg:SetFloat( "$pp_colour_colour", colour )
    mat_colornvg:SetFloat( "$pp_colour_brightness", dark )
    mat_colornvg:SetFloat( "$pp_colour_mulr", clr_r )
    mat_colornvg:SetFloat( "$pp_colour_mulg", clr_g )
    mat_colornvg:SetFloat( "$pp_colour_mulb", clr_b )
    mat_colornvg:SetFloat( "$pp_colour_addr", add_r )
    mat_colornvg:SetFloat( "$pp_colour_addg", add_g )
    mat_colornvg:SetFloat( "$pp_colour_addb", add_b )

    render.SetMaterial( mat_colornvg )
    render.DrawScreenQuad()

  end )

end )

local view_punch_angle = Angle( -30, 0, 0 )
local dust_vector = Vector( -712.862427, 6677.729492, 2225.919189 )
local particle_origin = Vector( -525.942322, -6318.510742, -2352.465820 )

net.Receive("Boom_Effectus", function()

	local player = LocalPlayer()

    util.ScreenShake( vector_origin, 200, 10, 20, 32768 );

    ParticleEffect( "vman_nuke", dust_vector, angle_zero );
    ParticleEffect( "vman_nuke", particle_origin, angle_zero );

    timer.Simple(7, function()

    	if player:GTeam() != TEAM_SPEC and player:Health() > 0 then
          player:ViewPunch( view_punch_angle )
        end

    end)

    timer.Simple(5, function()

      ParticleEffect( "dustwave_tracer", dust_vector, angle_zero );

    end)

    timer.Simple(5, function()

	    util.ScreenShake( vector_origin, 200, 100, 10, 32768);

	    player:ScreenFade( SCREENFADE.OUT, color_black, 2.3, 10 )

	    timer.Simple(4, function()
	    	player.no_signal = true
	    end)

    end)

end)

net.Receive( "NightvisionOff", function()

  LocalPlayer().NVG = false

end )

net.Receive( "GestureClientNetworking", function()

  local gesture_ent = net.ReadEntity()

  if ( !( gesture_ent && gesture_ent:IsValid() ) ) then return end

  local gesture_id = net.ReadUInt( 13 )
  local gesture_slot = net.ReadUInt( 3 )
  local loop = net.ReadBool()

  gesture_ent:AnimResetGestureSlot( gesture_slot )
  gesture_ent:AddVCDSequenceToGestureSlot( gesture_slot, gesture_id, 0, loop )

end )


net.Receive( "TranslatedMessage", function( len )
	local msg = net.ReadString()
	//local center = net.ReadBool()

	//print( msg )
	local color = nil
	local nmsg, cr, cg, cb = string.match( msg, "(.+)%#(%d+)%,(%d+)%,(%d+)$" )
	if nmsg and cr and cg and cb then
		msg = nmsg
		color = Color( cr, cg, cb )
	end

	local name, func = string.match( msg, "^(.+)%$(.+)" )
	
	if name and func then
		local args = {}

		for v in string.gmatch( func, "%w+" ) do
			table.insert( args, v )
			//print( "splitted:", v )
		end

		local translated = clang.NRegistry[name] or string.format( clang.NFailed, name )
		if color then
			chat.AddText( color, string.format( translated, unpack( args ) ) )
		else
			chat.AddText( string.format( translated, unpack( args ) ) )
		end
	else
		local translated = clang.NRegistry[msg] or string.format( clang.NFailed, msg )
		if color then
			chat.AddText( color, translated )
		else
			chat.AddText( translated )
		end
	end
end )

net.Receive( "CameraDetect", function( len )
	local tab = net.ReadTable()

	for i, v in ipairs( tab ) do
		table.insert( SCPMarkers, { time = CurTime() + 7.5, data = v } )
	end
end )

hook.Add( "OnPlayerChat", "CheckChatFunctions", function( ply, strText, bTeam, bDead )
	strText = string.lower( strText )

	if ( strText == "dropvest" ) then
		if ply == LocalPlayer() then
			DropCurrentVest()
		end
		return true
	end
end)

// Blinking system

blinkHUDTime = 0
btime = 0--CurTime() + 0.25
blink_end = 0
blink = false

local dishudnf = false
local wasdisabled = false

function DisableHUDNextFrame()
	dishudnf = true
end

function CLTick()
	local client = LocalPlayer()
	if postround == false and isnumber(drawendmsg) then
		drawendmsg = nil
	end

	if clang == nil then
		clang = english
	end

	if cwlang == nil then
		cwlang = english
	end

	if blinkHUDTime >= 0 then 
		blinkHUDTime = btime - CurTime()
	end

	if blinkHUDTime < 0 then
		--btime = CurTime() + 5.5
		--if client.GTeam and client:GTeam() != TEAM_SCP and client:GTeam() != TEAM_SPEC then
			--Blink(0.1)
		--end
		blinkHUDTime = 0
	end

	if dishudnf then
		if !disablehud then
			wasdisabled = disablehud
			disablehud = true
		end

		dishudnf = false
	elseif disablehud and wasdisabled == false then
		disablehud = false
	end

	if shoulddrawinfo then
		if CurTime() > drawinfodelete then
			shoulddrawinfo = false
			drawinfodelete = 0
		end
	end

	if CurTime() > blink_end then
		blink = false
	end
end
hook.Add( "Tick", "client_tick_hook", CLTick )

function Blink( time )
	timer.Simple(0.14, function()
		blink = true
		blink_end = CurTime() + time
		if eyedropeffect <= CurTime() then
			timer.Simple(blink_end - CurTime(), function()
				--LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 0.1, 0)
			end)
		end
		btime = CurTime() + GetConVar("br_time_blinkdelay"):GetFloat() + time
	end)
	if eyedropeffect <= CurTime() then
		--LocalPlayer():ScreenFade(SCREENFADE.OUT, color_black, 0.1, 0.2)
	end
end

net.Receive("PlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink( time )
end)

net.Receive( "PlayerReady", function()
	local tab = net.ReadTable()
	sR = tab[1]
	sL = tab[2]
end )

net.Receive( "689", function( len )
	if LocalPlayer().GetNClass then
		if LocalPlayer():GetNClass() == SCP689 then
			local targets = net.ReadTable()
			if targets then
				local swep = LocalPlayer():GetWeapon( "weapon_scp_689" )
				if IsValid( swep ) then
					swep.Targets = targets
				end
			end
		end
	end
end )

net.Receive("Effect", function()
	LocalPlayer().mblur = net.ReadBool()
end )

local mat_blink = CreateMaterial( "blink_material", "UnlitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$color"] = "{ 0 0 0 }"
} )
local frozen_mat = Material( "nextoren/ice_material/icefloor_01_new" )
local frozen_alpha = 0
local mat_color = Material( "pp/colour" ) -- used outside of the hook for performance
local no_signal = Material( "nextoren_hud/overlay/no_signal" )
local screen_effects = CreateConVar("breach_config_screen_effects", 1, FCVAR_ARCHIVE, "Enables bloom and toytown", 0, 1)

--[[
hook.Add( "HUDShouldDraw", "HideHUDCameraBR", function( name )
	if LocalPlayer():GetTable()["br_camera_mode"] then
		return false
	end

end )
--]]
hook.Add( "RenderScreenspaceEffects", "blinkeffects", function()
	local client = LocalPlayer()
	local clienttable = client:GetTable()
	
	--if blink and eyedropeffect <= CurTime() then
		--render.SetMaterial( mat_blink )
		--render.DrawScreenQuad()
		--return
	--end

	
	if clienttable.mblur == nil then
		clienttable.mblur = false
	end

	if (clienttable.mblur == true ) then
		DrawMotionBlur( 0.3, 0.8, 0.03 )
	end
	
	local contrast = 1
	local colour = 1
	local nvgbrightness = 0
	local clr_r = 0
	local clr_g = 0
	local clr_b = 0
	local bloommul = 1.2
	
	if ( clienttable.shotdown ) then
		local hit_brightness = clienttable.shot_EffectTime - CurTime()
		nvgbrightness = math.max( hit_brightness, 0 )

		if ( hit_brightness <= 0 ) then
			clienttable.shotdown = nil
			clienttable.shot_EffectTime = nil
			nvgbrightness = 0
		end

	end
	
	if clienttable["n420endtime"] and clienttable["n420endtime"] > CurTime() then
		DrawMotionBlur( 1 - ( clienttable["n420endtime"] - CurTime() ) / 15 , 0.3, 0.025 )
		DrawSharpen( ( clienttable["n420endtime"] - CurTime() ) / 3, ( clienttable["n420endtime"] - CurTime() ) / 20 )
		clr_r = ( clienttable["n420endtime"] - CurTime() ) * 2
		clr_g = ( clienttable["n420endtime"] - CurTime() ) * 2
		clr_b = ( clienttable["n420endtime"] - CurTime() ) * 2
	end
	
--	last996attack = last996attack - 0.002
--	if last996attack < 0 then
--		last996attack = 0
--	else
--		DrawMotionBlur( 1 - last996attack, 1, 0.05 )
--		DrawSharpen( last996attack,2 )
--		contrast = last996attack
--	end
	local client_health = client:Health()
	local client_team = client:GTeam()
	local no_signal = Material( "nextoren_hud/overlay/no_signal" )
	if client.no_signal then
		no_signal:SetFloat( "$alpha", 1 )
		no_signal:SetInt( "$ignorez", 1 )
		render.SetMaterial( no_signal )
		render.DrawScreenQuad()
	end
	if clienttable["no_signal"] then
		if client_team != TEAM_SPEC then
			clienttable["no_signal"] = nil
		end
		no_signal:SetFloat( "$alpha", 1 )
		no_signal:SetInt( "$ignorez", 1 )
		render.SetMaterial( no_signal )
		render.DrawScreenQuad()
	end
	if clienttable["br_camera_mode"] then
		if client_team == TEAM_SPEC or client_health <= 0 then
			clienttable["br_camera_mode"] = false
		else
			DrawMaterialOverlay("effects/combine_binocoverlay", 0.3)
			colour = 0.1
			nvgbrightness = 0.1
		end
	end
	if ( clienttable.Start409ScreenEffect ) then
		if ( client_team == TEAM_SPEC || client_health <= 0 ) then
			clienttable.Start409ScreenEffect = nil
		end
		frozen_alpha = math.Approach( frozen_alpha, 1, FrameTime() * .1 )
		frozen_mat:SetFloat( "$alpha", .5 )
		frozen_mat:SetInt( "$ignorez", 1 )
		render.SetMaterial( frozen_mat )
		render.DrawScreenQuad()
	end

	local actwep = client:GetActiveWeapon()

	if IsValid(actwep) then
		if actwep:GetClass() == "item_nvg" then
			nvgbrightness = 0.2
			DrawSobel( 0.7 )
		end
	end

	if livecolors then
		contrast = 1.1
		colour = 1.5
		bloommul = 2
	end

	local use_screen_effects = screen_effects:GetBool() or false

	local client_maxhealth = client:GetMaxHealth()

	if client_health <= client_maxhealth *.2 and client_health > 0 and client_team != TEAM_SCP and client_team != TEAM_SPEC then
		DrawMotionBlur( (client_maxhealth - client_health) / 400, .7, 0 )
		DrawSharpen( (client_maxhealth - client_health) / 50, 2 )
		if use_screen_effects then
			DrawToyTown( 100 / (client_maxhealth - client_health) * 0.6, ScrH() / 3)
		end
	end
	render.UpdateScreenEffectTexture()

	
	mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
	
	mat_color:SetFloat( "$pp_colour_brightness", nvgbrightness )
	mat_color:SetFloat( "$pp_colour_contrast", contrast)
	mat_color:SetFloat( "$pp_colour_colour", colour )
	mat_color:SetFloat( "$pp_colour_mulr", clr_r )
	mat_color:SetFloat( "$pp_colour_mulg", clr_g )
	mat_color:SetFloat( "$pp_colour_mulb", clr_b )
	
	render.SetMaterial( mat_color )
	render.DrawScreenQuad()
	//DrawBloom( Darken, Multiply, SizeX, SizeY, Passes, ColorMultiply, Red, Green, Blue )
	if use_screen_effects then
		DrawToyTown(2, ScrH() / 4)
		DrawBloom( 0.65, bloommul, 9, 9, 1, 1, 1, 1, 1 )
	end
end )
net.Receive( "DrawMuzzleFlash", function()



	local ent = net.ReadEntity()



	local ed = EffectData()

	ed:SetEntity( ent )

	util.Effect( "cw_kk_ins2_muzzleflash", ed, true, true )



end )

function FPCutScene()

	local client = LocalPlayer()

	if CLIENT then

		if client then
			
			local function FirstPersonScene(ply, pos, angles, fov)
				if ply then
					local view = {}
					local head = ply:GetAttachment( ply:LookupAttachment( "eyes" ) )
					if head then
						view.origin = head.Pos
						view.angles = head.Ang
					end
					view.fov = fov
					view.drawviewer = true
					return view
				end
			end
			hook.Add( "CalcView", "FirstPersonScene"..client:SteamID(), FirstPersonScene )

		end

	end

end
net.Receive("FirstPerson", FPCutScene)

local shrunkbones = {}

function FPCutScene_NPC()

	local npc = net.ReadEntity()

	local client = LocalPlayer()

	if CLIENT then

		if client then
			
			local function FirstPersonScene_NPC(ply, pos, angles, fov)
				if ply then
					local view = {}
					local head = npc:GetAttachment( npc:LookupAttachment( "eyes" ) )
					if head then
						view.origin = head.Pos
						view.angles = head.Ang
					end
					view.fov = fov
					view.drawviewer = true
					return view
				end
			end
			hook.Add( "CalcView", "FirstPersonScene_NPC"..client:SteamID(), FirstPersonScene_NPC )

		end

	end

end
net.Receive("FirstPerson_NPC", FPCutScene_NPC)

function shrinkbones(bone)
	for k, v in pairs(LocalPlayer():GetChildBones(bone)) do
		shrinkbones(v) --Should stop when table is empty
	end
	if not shrunkbones[bone] then
		shrunkbones[bone] = LocalPlayer():GetManipulateBoneScale(bone)
	end
	LocalPlayer():ManipulateBoneScale(bone, Vector(0, 0, 0))
end

net.Receive( "BreachFlinch", function()



	local ply = LocalPlayer()



	ply.shotdown = true

	ply.shot_EffectTime = CurTime() + .26



end )

ext = 0
function GM:PlayerBindPress( ply, bind, pressed )
	if bind == "+menu" then
		if GetConVar( "br_new_eq" ):GetInt() != 1 then
			DropCurrentWeapon()
		end
	elseif bind == "gm_showteam" then

		if ( !IsRoleMenuVisible() ) then

			OpenClassMenu()

		elseif ( IsRoleMenuVisible() ) then

			CloseRoleMenu()

		end
	elseif bind == "+menu_context" then
		thirdpersonenabled = !thirdpersonenabled
	elseif bind == "noclip" and ply:IsAdmin() then
		RunConsoleCommand("ulx", "noclip")
	end
end

function DropCurrentWeapon()
	if dropnext > CurTime() then return true end
	dropnext = CurTime() + 0.5
	net.Start("DropCurWeapon")
	net.SendToServer()
	if LocalPlayer().channel != nil then
		LocalPlayer().channel:EnableLooping( false )
		LocalPlayer().channel:Stop()
		LocalPlayer().channel = nil
	end
	return true
end

concommand.Add("br_requestescort", function()
	if !((LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) or LocalPlayer():GTeam() == TEAM_CHAOS) then return end
	net.Start("RequestEscorting")
	net.SendToServer()
end)

concommand.Add("br_requestNTFspawn", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("NTFRequest")
		net.SendToServer()
	end
end )

concommand.Add("br_destroygatea", function( ply, cmd, args)
	if ( ply:GetNClass() == ROLES.ROLE_MTFNTF or ply:GetNClass() == ROLES.ROLE_CHAOS ) then
		net.Start("ExplodeRequest")
		net.SendToServer()
	end
end )

concommand.Add("br_sound_random", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Random")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_searching", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Searching")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_classd", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Classd")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_stop", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Stop")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_lost", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Lost")
		net.SendToServer()
	end
end)

hook.Add( "HUDWeaponPickedUp", "DonNotShowCards", function( weapon )
	EQHUD.weps = LocalPlayer():GetWeapons()
	if weapon:GetClass() == "br_keycard" then return false end
end )

function GM:CalcView( ply, origin, angles, fov )
	local data = {}
	data.origin = origin
	data.angles = angles
	data.fov = fov
	data.drawviewer = false
	local item = ply:GetActiveWeapon()
	if IsValid( item ) then
		if item.CalcView then
			local vec, ang, ifov, dw = item:CalcView( ply, origin, angles, fov )
			if vec then data.origin = vec end
			if ang then data.angles = ang end
			if ifov then data.fov = ifov end
			if dw != nil then data.drawviewer = dw end
		end
	end

	if CamEnable then
		--print( "enabled" )
		if !timer.Exists( "CamViewChange" ) then
			timer.Create( "CamViewChange", 1, 1, function()
				CamEnable = false
			end )
		end
		data.drawviewer = true
		dir = dir or Vector( 0, 0, 0 )
		--print( dir )
		data.origin = ply:GetPos() - dir - dir:GetNormalized() * 30 + Vector( 0, 0, 80 )
		data.angles = Angle( 10, dir:Angle().y, 0 )
	end

	return data
end

function GetWeaponLang()
	if cwlang then
		return cwlang
	end
end

local PrecachedSounds = {}
function ClientsideSound( file, ent )
	ent = ent or game.GetWorld()
	local sound
	if !PrecachedSounds[file] then
		sound = CreateSound( ent, file, nil )
		PrecachedSounds[file] = sound
		return sound
	else
		sound = PrecachedSounds[file]
		sound:Stop()
		return sound
	end
end

net.Receive( "SendSound", function( len )
	local com = net.ReadInt( 2 )
	local f = net.ReadString()
	if com == 1 then
		local snd = ClientsideSound( f )
		snd:SetSoundLevel( 0 )
		snd:Play()
	elseif com == 0 then
		ClientsideSound( f )
	end
end )

concommand.Add( "br_dropweapon", function( ply )
		net.Start("DropCurWeapon")
		net.SendToServer()
end )

function OBRStart()
	if GetGlobalBool("NoCutScenes", false) then return end

	local client = LocalPlayer()

	client.NoMusic = true

	StopMusic()
	PlayMusic( "sound/no_new_music/qrt_spawn.mp3", 1 )

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.TextStartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 5
	CutSceneWindow.Name = "SUBJECT NAME: " .. client:GetName()
	CutSceneWindow.Status = "LOCATION: Site 19"
	CutSceneWindow.Time = " ( Time after disaster: " .. string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " )"

	local ExplodedString = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Name, true )

	local clr_gray = Color( 198, 198, 198 )
	local clr_blue = gteams.GetColor(client:GTeam())

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	local desc = false

	CutSceneWindow.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() + 8 ) then

			if ( CutSceneWindow.StartTime <= CurTime() ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 80 )

				if self.StartAlpha == 0 and !desc then
					desc = true
					DrawNewRoleDesc()
				end

			end

			if ( CutSceneWindow.StartTime + 10 <= CurTime() ) then

				self.TextStartAlpha = math.Approach( self.TextStartAlpha, 0, RealFrameTime() * 80 )

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .08
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .08
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .08
				str2 = str2..ExplodedString[ count ]

			end

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )

		end

		if ( self.StartAlpha <= 0 and self.TextStartAlpha <= 0 ) then

			timer.Simple( 20, function()

				if ( LocalPlayer():GTeam() == TEAM_QRT ) then

					FadeMusic( 10 )

				end

			end )

		      if ( !system.HasFocus() ) then

		        system.FlashWindow()

		      end

			self:Remove()

		end

	end

end
concommand.Add("intro_start_obr", OBRStart)

local mtf_icon = Material("nextoren/gui/roles_icon/mtf.png")

function MOGStart()

	local client = LocalPlayer()

	if LocalPlayer():GTeam() == TEAM_GUARD then

		client.NoMusic = true

		StopMusic()
		PlayMusic( "sound/no_music/factions_spawn/mtf_intro.ogg", 1 )

		timer.Simple(20, function()
			IntroSound()
		end)
		timer.Simple(24.5, function()

			util.ScreenShake( Vector(0, 0, 0), 35, 15, 3, 150 )
			surface.PlaySound("nextoren/others/horror/horror_14.ogg")

			local CutSceneWindow = vgui.Create( "DPanel" )

			CutSceneWindow:SetSize(ScrW(), ScrH())
			CutSceneWindow.DrawTime = SysTime() + 1
			CutSceneWindow.DrawLerp = 0
			CutSceneWindow.Paint = function(self, w, h)
				draw.RoundedBox(0,0,0,w,h,color_black)
				if CutSceneWindow.DrawTime <= SysTime() then
					CutSceneWindow.DrawLerp = math.Approach(CutSceneWindow.DrawLerp, 1, FrameTime())
					surface.SetMaterial(mtf_icon)
					surface.SetDrawColor(Color(255,255,255,CutSceneWindow.DrawLerp*255))
					surface.DrawTexturedRect(w / 2 - 128, h / 2 - 128, 256, 256)
				end

			end
			CutSceneWindow:SetAlpha(0)
			CutSceneWindow:AlphaTo(255,0.7,0,function()
				BREACH.Round.GeneratorsActivated = false
				timer.Simple(8, function()
					CutSceneWindow:AlphaTo(0,2,0,function()
						CutSceneWindow:Remove()
					end)
					DrawNewRoleDesc()
					hook.Remove("HUDShouldDraw", "MTF_HIDEHUD")
					LocalPlayer().cantopeninventory = nil
					for i, v in pairs(LocalPlayer():GetWeapons()) do
						if !v:GetClass():find("nade") and v:GetClass():StartWith("cw_") then
							LocalPlayer().DoWeaponSwitch = v
							break
						end
					end
				end)
			end)

		end)

	end

end

net.Receive( "PlayerDied", function()
	MOGStart()
end )

net.Receive("bettersendlua", function()

	local code = net.ReadString()

	RunString(code)

end)

function MTFStart()

	local client = LocalPlayer()

	client.NoMusic = true

	StopMusic()
	PlayMusic( "sound/no_new_music/mtf_spawn.mp3", 1 )

	local CutSceneWindow = vgui.Create( "DPanel" )
	CutSceneWindow:SetText( "" )
	CutSceneWindow:SetSize( ScrW(), ScrH() )
	CutSceneWindow.StartAlpha = 255
	CutSceneWindow.TextStartAlpha = 255
	CutSceneWindow.StartTime = CurTime() + 9
	CutSceneWindow.LogoAlpha = 0
	CutSceneWindow.Name = "SUBJECT NAME: " .. client:GetName() .. " [" .. client:GetNClass() .."]"
	CutSceneWindow.Status = "LOCATION: Site 19"
	CutSceneWindow.Time = " ( Time after disaster: " .. string.ToMinutesSeconds( GetRoundTime() - cltime ) .. " )"

	local ExplodedString = string.Explode( "", CutSceneWindow.Time, true )
	local ExplodedString2 = string.Explode( "", CutSceneWindow.Status, true )
	local ExplodedString3 = string.Explode( "", CutSceneWindow.Name, true )

	local clr_gray = Color( 198, 198, 198 )
	local clr_blue = gteams.GetColor(TEAM_GUARD)

	local str = ""
	local str1 = ""
	local str2 = ""

	local count = 0
	local count1 = 0
	local count2 = 0

	local screenwidth, screenheight = ScrW(), ScrH()

	local desc = false

	CutSceneWindow.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, self.StartAlpha ) )

		if ( CutSceneWindow.StartTime <= CurTime() ) then

			if ( CutSceneWindow.StartTime + 8 <= CurTime() ) then

				self.LogoAlpha = math.Approach( self.LogoAlpha, 0, RealFrameTime() * 80 )

			else

				self.LogoAlpha = math.Approach( self.LogoAlpha, 255, RealFrameTime() * 130 )

			end

			if ( CutSceneWindow.StartTime + 8 <= CurTime() ) then

				self.StartAlpha = math.Approach( self.StartAlpha, 0, RealFrameTime() * 80 )

				if self.StartAlpha != 255 and !desc then
					desc = true
					DrawNewRoleDesc()
				end

			end

			if ( CutSceneWindow.StartTime + 15 <= CurTime() ) then

				self.TextStartAlpha = math.Approach( self.TextStartAlpha, 0, RealFrameTime() * 80 )

			end

			if ( ( self.NextSymbol || 0 ) <= SysTime() && count2 != #ExplodedString3 ) then

				count2 = count2 + 1
				self.NextSymbol = SysTime() + .08
				str = str..ExplodedString3[ count2 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 != #ExplodedString2 ) then

				count1 = count1 + 1
				self.NextSymbol = SysTime() + .08
				str1 = str1..ExplodedString2[ count1 ]

			elseif ( ( self.NextSymbol || 0 ) <= SysTime() && count2 == #ExplodedString3 && count1 == #ExplodedString2 && count != #ExplodedString ) then

				count = count + 1
				self.NextSymbol = SysTime() + .08
				str2 = str2..ExplodedString[ count ]

			end

			surface.SetDrawColor( ColorAlpha( color_white, self.LogoAlpha ) )
			surface.SetMaterial( mtf_icon )
			surface.DrawTexturedRect( screenwidth / 2 - 128, screenheight / 2 - 128, 256, 256 )

			draw.SimpleTextOutlined( str, "TimeMisterFreeman", w / 2, h / 2, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )
			draw.SimpleTextOutlined( str1, "TimeMisterFreeman", w / 2, h / 2 + 32, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )
			draw.SimpleTextOutlined( str2, "TimeMisterFreeman", w / 2, h / 2 + 64, ColorAlpha( clr_gray, self.TextStartAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha( clr_blue, self.TextStartAlpha ) )

		end

		if ( self.StartAlpha <= 0 and self.TextStartAlpha <= 0 ) then

			timer.Simple( 20, function()

				if ( LocalPlayer():GTeam() == TEAM_GUARD ) then

					FadeMusic( 10 )

				end

			end )

		      if ( !system.HasFocus() ) then

		        system.FlashWindow()

		      end

			self:Remove()

		end

	end

end
concommand.Add("intro_start_mtf", MTFStart)

SetGlobalBool("OverrideFog", false)
SetGlobalInt("FogStart", 256)
SetGlobalInt("FogEnd", 1024)
SetGlobalInt("Fog_R", 96)
SetGlobalInt("Fog_G", 47)
SetGlobalInt("Fog_B", 0)

function GM:SetupWorldFog()
    if OUTSIDE_BUFF and OUTSIDE_BUFF( LocalPlayer():GetPos() ) then

        if GetGlobalBool("Scarlet_King_Scarlet_Skybox", false) then
            render.FogMode( MATERIAL_FOG_LINEAR )
            render.FogColor( 20, 0, 0 )
            render.FogStart( 100 )
            render.FogEnd( 2000 )
            render.FogMaxDensity( 0.98 )
            return true
        end
    end

    if GetGlobalBool("OverrideFog") then
        render.FogMode(1)
        render.FogStart(GetGlobalInt("FogStart", 0))
        render.FogEnd(GetGlobalInt("FogEnd", 0))
        render.FogColor(GetGlobalInt("Fog_R", 0), GetGlobalInt("Fog_G", 0), GetGlobalInt("Fog_B", 0), 255)
        render.FogMaxDensity(1)
        return true
    end
end

Effect957 = false
Effect957Density = 0
Effect957Mode = 0
net.Receive( "957Effect", function( len )
	local status = net.ReadBool()
	if status then
		Effect957 = CurTime()
		Effect957Mode = 0
	elseif Effect957 then
		//Effect957 = false
		Effect957Mode = 2
		Effect957 = CurTime() + 1
	end
end )


net.Receive( "SCPList", function( len )
	SCPS = net.ReadTable()
	local transmited = net.ReadTable()

	for k, v in pairs( SCPS ) do
		ROLES["ROLE_"..v] = v
	end
	for k, v in pairs( transmited ) do
		ROLES["ROLE_"..v] = v
	end
	--InitializeBreachULX()
	SetupForceSCP()
end )

timer.Simple( 1, function()
	net.Start( "PlayerReady" )
	net.SendToServer()
end )
function HedwigAbility()
	local client = LocalPlayer()
	if !client:HaveSpecialAb(ROLES.ROLE_SPECIALRESS) then return end
	hook.Remove( "PostDrawTranslucentRenderables", "Hedwig_Ability" )

    clr_red = .08
    clr_green = .08
    clr_blue = .08

    local hedwigdietime = CurTime() + 20

    hook.Add( "PostDrawTranslucentRenderables", "Hedwig_Ability", function()

      local client = LocalPlayer()

      local playerpos = client:GetPos()
      local eyespos = client:EyePos() + client:EyeAngles():Forward() * 8
      local eyeang = client:EyeAngles()
      eyeang = Angle( eyeang.p + 90, eyeang.y, 0 )
      if hedwigdietime < CurTime() then hook.Remove( "PostDrawTranslucentRenderables", "Hedwig_Ability" ) end
      render.ClearStencil()

      render.SetStencilEnable( true )

        render.SetStencilWriteMask( 255 )
        render.SetStencilTestMask( 255 )
        render.SetStencilReferenceValue( 1 )

        for _, ent in ipairs( player.GetAll() ) do

          if ( ent:IsPlayer() || ent:IsNPC() ) then

            if ( ent == client ) then

              if ( ent:Health() <= 0 || !ent:HaveSpecialAb(ROLES.ROLE_SPECIALRESS) ) then

                hook.Remove( "PostDrawTranslucentRenderables", "Hedwig_Ability" )

                return
              end

            else

              local current_team = ent:IsPlayer() && ent:GTeam()

              if ( ent:IsPlayer() && current_team == TEAM_SPEC ) then continue end

              if ( current_team == TEAM_SCP && !ent:IsSolid() ) then continue end
              if current_team != TEAM_SCP then continue end
              if ent:IsPlayer() and ent:Health() <= 0 then continue end
              if ent:IsPlayer() and !ent:Alive() then continue end

              render.SetStencilCompareFunction( STENCIL_ALWAYS )
              render.SetStencilZFailOperation( STENCIL_REPLACE )

              render.SetStencilPassOperation( STENCIL_REPLACE )
              render.SetStencilFailOperation( STENCIL_KEEP )
              ent:DrawModel()

              local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", ent )

              if ( tbl_bonemerged && istable( tbl_bonemerged ) ) then

                for _, v in ipairs( tbl_bonemerged ) do

                  if ( v && v:IsValid() ) then

                    v:DrawModel()

                  end

                end

              end

              render.SetStencilCompareFunction( STENCIL_EQUAL )
              render.SetStencilZFailOperation( STENCIL_KEEP )
              render.SetStencilPassOperation( STENCIL_KEEP )
              render.SetStencilFailOperation( STENCIL_KEEP )

              cam.Start3D2D( eyespos, eyeang, 1 )
              
                surface.SetDrawColor( 255, 0, 0, 80 )
                surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2 )

              cam.End3D2D()

            end

          end

        end

        render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )

      render.SetStencilEnable( false )
    end)
end
function StartSceneClientSide( ply )

	local character = ents.CreateClientside( "base_gmodentity" )
	character:SetPos( Vector( -1981.652466, 5217.017090, 1459.548218 ) )
	character:SetAngles( Angle( 0, -90, 0 ) )
	character:SetModel( "models/cultist/humans/class_d/class_d.mdl" )
	character:Spawn()
	character:SetSequence( "photo_react_blind" )
	character:SetCycle( 0 )
	character:SetPlaybackRate( 1 )
	character.AutomaticFrameAdvance = true
	local cycle = 0
	character.Think = function( self )

		self:NextThink( CurTime() )
		self:SetCycle( math.Approach( cycle, 1, FrameTime() * 0.2 ) )
		cycle = self:GetCycle()
		return true

	end

	ply.InCutscene = true

	ply:SetNWEntity("NTF1Entity", character)

	local CI = ents.CreateClientside("base_gmodentity")
	CI:SetPos(Vector(-1983.983765, 4951.116211, 1459.224365))
	CI:SetAngles(Angle(0, 90, 0))
	CI:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI:SetMoveType(MOVETYPE_NONE)
    CI:SetBodygroup( 0, 0 )
    CI:SetBodygroup( 1, 1 )
	CI:Spawn()
	CI:SetColor( color_black )
	CI:SetSequence("LineIdle02")
	CI:SetPlaybackRate(1)
	CI.OnRemove = function( self )

		if ( self.BoneMergedEnts ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end

	ClientBoneMerge( CI, "models/cultist/humans/chaos/head_gear/beret.mdl" )
	ClientBoneMerge( CI, "models/cultist/humans/balaclavas/balaclava_full.mdl" )

	local handsid = CI:LookupAttachment('anim_attachment_RH')
	local hands = CI:GetAttachment( handsid )

	timer.Simple( 2, function()

		CI:EmitSound( "nextoren/vo/chaos/class_d_alternate_ending.ogg" )

	end )
	CI.AutomaticFrameAdvance = true


	CI.Think = function( self )

		self.NextThink = ( CurTime() )
		if ( self:GetCycle() >= 0.01 ) then self:SetCycle( 0.01 ) end

	end

	local cycle3 = 0
	local CI2 = ents.CreateClientside("base_gmodentity")
	CI2:SetPos(Vector(-1960.850830, 4894.328613, 1459.702515))
	CI2:SetAngles(Angle(0, 94, 0))
	CI2:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI2:SetMoveType(MOVETYPE_NONE)
	CI2:Spawn()
	CI2:SetColor( color_black )
	CI2:SetBodygroup( 0, 1 )
    CI2:SetBodygroup( 1, 0 )
    CI2:SetBodygroup( 2, 1 )
    CI2:SetBodygroup( 4, 0 )
	CI2:SetBodygroup( 5, 0 )
	CI2:SetSequence( "AHL_menuidle_SHOTGUN" )
	CI2:SetPlaybackRate( 1 )
	ClientBoneMerge( CI2, "models/cultist/humans/balaclavas/balaclava_full.mdl" )
	ClientBoneMerge( CI2, "models/cultist/humans/chaos/head_gear/helmet.mdl" )
	local handsid2 = CI2:LookupAttachment('anim_attachment_RH')
	local hands2 = CI2:GetAttachment( handsid )
	CI2.AutomaticFrameAdvance = true
	CI2.OnRemove = function( self )

		if ( self.BoneMergedEnts ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end


	local Weapon2 = ents.CreateClientside("base_gmodentity")
	Weapon2:SetModel("models/weapons/w_cw_kk_ins2_rpk_tac.mdl")
	Weapon2:SetPos(hands2.Pos)
	Weapon2:SetAngles(Angle(0,90,0))
	Weapon2:SetMoveType(MOVETYPE_NONE)
	Weapon2:Spawn()

    CI2.Think = function(self)
		if !CI2:IsValid() then return end
		self:NextThink( CurTime() )

		local handsid7 = CI2:LookupAttachment('anim_attachment_RH')
		local hands7 = CI2:GetAttachment( handsid )
        Weapon2:SetPos(hands7.Pos + Vector( 0, 8, 0 ) )
		self:SetCycle( math.Approach( cycle3, 1, FrameTime() * 0.15 ) )
		cycle3 = self:GetCycle()


		--CI2:SetPos(Vector(currentpos.x - 0.5, currentpos.y + 8, currentpos.z))



	end
	local cycle2 = 0
	local CI3 = ents.CreateClientside("base_gmodentity")
	CI3:SetPos(Vector(-2012.675903, 4894.200195, 1459.009277))
	CI3:SetAngles(Angle(0, 70, 0))
	CI3:SetModel("models/cultist/humans/chaos/chaos.mdl")
	CI3:SetMoveType(MOVETYPE_NONE)
	CI3:Spawn()
	CI3:SetBodygroup( 0, 1 )
    CI3:SetBodygroup( 1, 0 )
    CI3:SetBodygroup( 2, 1 )
    CI3:SetBodygroup( 4, 0 )
	CI3:SetBodygroup( 5, 0 )
	CI3:SetColor( color_black )
	CI3:SetSequence("MPF_adooridle")
	CI3:SetPlaybackRate(1)
	local handsid3 = CI3:LookupAttachment('anim_attachment_RH')
	local hands3 = CI3:GetAttachment( handsid )
	ClientBoneMerge( CI3, "models/cultist/humans/balaclavas/balaclava_full.mdl" )
	ClientBoneMerge( CI3, "models/cultist/humans/chaos/head_gear/helmet.mdl" )

	CI3.AutomaticFrameAdvance = true
	CI3.OnRemove = function( self )

		if ( self.BoneMergedEnts && istable( self.BoneMergedEnts ) ) then

			for _, v in ipairs( self.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

	end

	CI3.Think = function(self)

		self:NextThink( CurTime() )
		self:SetCycle( math.Approach( cycle2, 1, FrameTime() * 0.2 ) )
		cycle2 = self:GetCycle()


	end
	local Weapon3 = ents.CreateClientside("base_gmodentity")
	Weapon3:SetModel("models/weapons/w_cw_kk_ins2_rpk_tac.mdl")
	Weapon3:SetPos(hands3.Pos)
	Weapon3:SetAngles(Angle(0,80,0))
	Weapon3:SetMoveType(MOVETYPE_NONE)
	Weapon3:Spawn()


    timer.Simple( 8, function()

        Weapon2:Remove()
        Weapon3:Remove()
        CI:Remove()
        CI2:Remove()
        CI3:Remove()
		ply.InCutscene = false
		character:Remove()
		ply:SetNWEntity("NTF1Entity", NULL)

    end )

end
concommand.Add("CI_Anim_Escsp", StartSceneClientSide)

local desc_clr_gray = Color( 198, 198, 198 )

local outcomeResult = {

	[ "Alpha-Warhead was blown up" ] = { image = "nextoren/gui/roles_icon/goc.png", music = "sound/no_music/misc/goc_won.ogg" },
	[ "Scarlet King interrupt" ] = { image = "nextoren/gui/roles_icon/scarlet.png" },

	[ "Military Alive Only" ] = { image = "nextoren/gui/roles_icon/mtf.png" },
	[ "Security Alive Only" ] = { image = "nextoren/gui/roles_icon/sec.png" },
	[ "Scientists Alive Only" ] = { image = "nextoren/gui/roles_icon/sci.png" },
	[ "UIU Alive Only" ] = { image = "nextoren/gui/roles_icon/fbi.png" },
	[ "Class-D Alive Only" ] = { image = "nextoren/gui/roles_icon/class_d.png" },
	[ "Serpents Alive Only" ] = { image = "nextoren/gui/roles_icon/dz.png" },
	[ "GOC Alive Only" ] = { image = "nextoren/gui/roles_icon/goc.png" },
	[ "Class-D and Chaos Alive Only" ] = { image = "nextoren/gui/roles_icon/class_d.png" },
	[ "Military and SCI Alive Only" ] = { image = "nextoren/gui/roles_icon/mtf.png" },
	[ "GRU Alive Only" ] = { image = "nextoren/gui/roles_icon/gru.png" },

}

function EndRoundStats()

	local result = net.ReadString()

	local t_restart = net.ReadFloat()

	local client = LocalPlayer()

	local screenwidth, screenheight = ScrW(), ScrH()

	local general_panel = vgui.Create( "DPanel" )
	general_panel:SetText( "" )
	general_panel:SetSize( screenwidth, screenheight )
	general_panel:SetAlpha( 1 )
	general_panel.StartTime = RealTime()
	general_panel.StartFade = false
	timer.Simple( ( t_restart || 27 ) + 1, function()

		FadeMusic( 2 )

		if ( general_panel && general_panel:IsValid() ) then

			general_panel.StartFade = true

		end

	end )

	general_panel.Paint = function( self, w, h )

		if ( self:GetAlpha() < 255 && general_panel.StartTime < RealTime() - .25 && !general_panel.StartFade ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 255, FrameTime() * 512 ) )

		elseif ( self:GetAlpha() > 0 && general_panel.StartTime < RealTime() - 20 && general_panel.StartFade ) then

			self:SetAlpha( math.Approach( self:GetAlpha(), 0, FrameTime() * 512 ) )

			if ( self:GetAlpha() == 0 && ( self && self:IsValid() ) ) then

				self:Remove()

			end

		end

	end
	local stats_panel = vgui.Create( "DPanel", general_panel )
	stats_panel:SetPos( screenwidth / 2.7, screenheight * .1 )
	stats_panel:SetSize( screenwidth / 4, screenheight / 3 )
	stats_panel:SetText( "" )
	stats_panel.NextSymbol = RealTime()

	local deathstr = false

	if ( !BREACH.Round.Stats || !BREACH.Round.Stats.number ) then

		BREACH.Round.Stats = {}

		BREACH.Round.Stats.number = {

			deaths = "0",
			escaped = "0"

		}

	end

	local s_death = "* Total Deaths: " .. BREACH.Round.Stats.number.deaths
	local s_missing = "* Escaped: " .. BREACH.Round.Stats.number.escaped

	local tbl_death = string.Explode( "", s_death, true )
	local tbl_missing = string.Explode( "", s_missing, true )

	local counter = 0
	local counter2 = 0
	local str1 = ""
	local str2 = ""

	BREACH.Round.RoundsTillRestart = GetGlobalInt("RoundUntilRestart", 10)

	local rounds_till_restart = BREACH.Round.RoundsTillRestart

	local restarting = rounds_till_restart < 1

	if ( restarting ) then

		rounds_till_restart = CurTime() + 10

	else

		rounds_till_restart = CurTime() + ( t_restart || 27 )

	end

	local time;

	stats_panel.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_black, math.Clamp( self:GetAlpha(), 0, 210 ) ) )
		draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( desc_clr_gray, 190 ) )

		if ( restarting ) then

			draw.SimpleText( "Game Over", "MainMenuFontmini", w / 2, 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		else

			draw.SimpleText( "Round complete", "MainMenuFontmini", w / 2, 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		draw.SimpleText( "Round result: " .. result, "MainMenuFont", w / 2, 64, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ( !restarting ) then

			draw.SimpleText( "Rounds till restart: " .. BREACH.Round.RoundsTillRestart, "MainMenuFontmini", w / 2, h * .8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			time = math.Round( rounds_till_restart - CurTime() )

			if ( time > 0 ) then

				draw.SimpleText( "Next round in " .. time, "MainMenuFontmini", w / 2, h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			else

				draw.SimpleText( "Restarting round...", "MainMenuFontmini", w / 2, h * .7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

		else

			time = math.Round( rounds_till_restart - CurTime() )

			if ( time > 0 ) then

				draw.SimpleText( "Restarting server in " .. math.Round( rounds_till_restart - CurTime() ) .. "...", "MainMenuFontmini", w / 2, h * .8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			else

				draw.SimpleText( "Restarting server...", "MainMenuFontmini", w / 2, h * .8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

		end

		if ( self.NextSymbol <= RealTime() && !deathstr && str1:len() != #tbl_death ) then

			self.NextSymbol = RealTime() + .1
			counter = counter + 1
			str1 = str1 .. tbl_death[ counter ]

		elseif ( self.NextSymbol <= RealTime() && str2:len() != #tbl_missing ) then

			self.NextSymbol = RealTime() + .1
			counter2 = counter2 + 1
			str2 = str2 .. tbl_missing[ counter2 ]

		end

		surface.SetDrawColor( color_white )
		surface.DrawLine( 0, 48, w, 48 )
		surface.DrawLine( 0, 49, w, 49 )

		--draw.SimpleTextOutlined( str1, "HUDFont", 15, h * .3 + 30, ColorAlpha( color_white, 180 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, ColorAlpha( color_black, 180 ) )
		--draw.SimpleTextOutlined( str2, "HUDFont", 15, h * .3 + 60, ColorAlpha( color_white, 180 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, ColorAlpha( color_black, 180 ) )

	end

	if ( outcomeResult[ result ] ) then

		local faction_img = vgui.Create( "DImage", stats_panel )
		faction_img:SetImage( outcomeResult[ result ].image )
		faction_img:SetSize( 128, 128 )
		faction_img:SetAlpha( 120 )
		local width, height = stats_panel:GetSize()
		faction_img:SetPos( width / 2 - 64, height / 2 - 64 )

		timer.Simple( 8.25, function()

			if ( postround ) and outcomeResult[ result ].music then

				PlayMusic( outcomeResult[ result ].music )

			end

		end )

	end

end

net.Receive( "New_SHAKYROUNDSTAT", EndRoundStats )


function GM:HUDWeaponPickedUp()
	--
end

net.Receive( "GetBoneMergeTable", function()

	local ent = net.ReadEntity()
	local bonemerge_ent = net.ReadEntity()
  
	if ( !( ent && ent:IsValid() ) ) then return end
  
	if ( !ent.BoneMergedEnts || !istable( ent.BoneMergedEnts ) ) then
  
	  ent.BoneMergedEnts = {}
  
	else
  
	  if ( table.HasValue( ent.BoneMergedEnts, bonemerge_ent ) ) then return end
  
	end
  
	ent.BoneMergedEnts[ #ent.BoneMergedEnts + 1 ] = bonemerge_ent
  
end )

local alpha_color = 0
local final_color = 255
function make_bottom_message(msg)
	alpha_color = 0
    final_color = 255
    hook.Add( "HUDPaint", "BottomMessage", function()
		alpha_color = math.Approach(alpha_color, final_color, RealFrameTime() * 128)
		if alpha_color == final_color then
			final_color = 0
		end
        draw.SimpleText( msg, "MsgFont", ScrW() / 2, ScrH() / 1.3, Color(130, 130, 130, alpha_color), TEXT_ALIGN_CENTER )
    end )
	
	timer.Remove("SetBottomMessage_Disappear")

    timer.Create( "SetBottomMessage", 5, 1, function()
        hook.Remove( "HUDPaint", "BottomMessage" )
    end )
end
net.Receive( "SetBottomMessage", function()

    local msg = net.ReadString()
    make_bottom_message(msg)
    
end )

local box_parameters = Vector( 5, 5, 5 )

net.Receive( "ThirdPersonCutscene", function()

  local time = net.ReadUInt( 4 )
  local without_anim = net.ReadBool()

  local client = LocalPlayer()

  client.ExitFromCutscene = nil

  local multiplier = 0

  hook.Add( "CalcView", "ThirdPerson", function( client, pos, angles, fov )

    if ( !client.ExitFromCutscene && multiplier != 1 ) then

      multiplier = math.Approach( multiplier, 1, RealFrameTime() * 2 )

    elseif ( client.ExitFromCutscene ) then

      multiplier = math.Approach( multiplier, 0, RealFrameTime() * 2 )

      if ( multiplier < .25 || without_anim ) then

        hook.Remove( "CalcView", "ThirdPerson" )
        client.ExitFromCutscene = nil

      end

    end

    local offset_eyes = client:LookupAttachment( "eyes" )
    offset_eyes = client:GetAttachment( offset_eyes )

    if ( offset_eyes ) then

      angles = offset_eyes.Ang

    end

    local trace = {}
    trace.start = offset_eyes && offset_eyes.Pos || pos
    trace.endpos = trace.start + angles:Forward() * ( -80 * multiplier )
    trace.filter = client
    trace.mins = -box_parameters
    trace.maxs = box_parameters
    trace.mask = MASK_VISIBLE

    trace = util.TraceLine( trace )

    pos = trace.HitPos

    if ( trace.Hit ) then

      pos = pos + trace.HitNormal * 5

    end

    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true

    return view

  end )

  timer.Simple( time, function()

    client.ExitFromCutscene = true

  end )

end )

net.Receive( "ThirdPersonCutscene2", function()

  local time = net.ReadUInt( 4 )
  local without_anim = net.ReadBool()

  local client = LocalPlayer()

  client.ExitFromCutscene = nil

  local multiplier = 0

  hook.Add( "CalcView", "ThirdPerson", function( client, pos, angles, fov )

    if ( !client.ExitFromCutscene && multiplier != 1 ) then

      multiplier = math.Approach( multiplier, 1, RealFrameTime() * 2 )

    elseif ( client.ExitFromCutscene ) then

      multiplier = math.Approach( multiplier, 0, RealFrameTime() * 2 )

      if ( multiplier < .25 || without_anim ) then

        hook.Remove( "CalcView", "ThirdPerson" )
        client.ExitFromCutscene = nil

      end

    end

    local offset_eyes = client:LookupAttachment( "eyes" )
    offset_eyes = client:GetAttachment( offset_eyes )

    if ( offset_eyes ) then

      --angles = offset_eyes.Ang

    end

    local trace = {}
    trace.start = offset_eyes && offset_eyes.Pos or pos
    trace.endpos = trace.start + client:EyeAngles():Forward() * ( -80 * multiplier )
    trace.filter = client
    trace.mask = MASK_VISIBLE

    trace = util.TraceLine( trace )

    pos = trace.HitPos

    if ( trace.Hit ) then

      pos = pos + trace.HitNormal * 5

    end

    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true

    return view

  end )

  timer.Simple( time, function()

    client.ExitFromCutscene = true

  end )

end )

net.Receive( "SpecialSCIHUD", function()

    local name = net.ReadString()
    local cooldown = net.ReadUInt(9)
    local desc = net.ReadString()
    local icon = net.ReadString()
    local max = net.ReadBool()

    local client = LocalPlayer()

    client.SpecialTable = {

        Name = name,
        Cooldown = cooldown,
        Description = desc,
        Icon = icon,
        Countable = max

    }

    DrawSpecialAbility( client.SpecialTable )

end )

hook.Add("InitPostEntity", "send_my_country", function()

	net.Start("send_country")
	net.WriteString(system.GetCountry())
	net.SendToServer()

end)

hook.Add('NotifyShouldTransmit', 'BNMRG_NotifyShouldTransmit', function(ent, shouldTransmit)
    if ent:GetClass() == 'ent_bonemerged' then
        local owner = ent:GetOwner()
        if owner and owner:IsValid() and owner != ent:GetParent() then
            ent:SetParent(owner)
        end
    end
end)


net.Receive( "TargetsToNTFs", function()

    local target = net.ReadTable()
    local team_indx = net.ReadUInt(12)

    local clr_to_draw
    local universal_search

    if ( team_indx == 22 ) then

        clr_to_draw = Color(255,0,0)
        universal_search = {

            [ TEAM_CHAOS ] = true,
            [ TEAM_GOC ] = true,
            [ TEAM_USA ] = true,
            [ TEAM_DZ ] = true,
            [ TEAM_GRU ] = true,
            [ TEAM_COTSK ] = true,

        }

    else

        clr_to_draw = gteams.GetColor(team_indx)

    end

    local client = LocalPlayer()

    if ( !client.TargetsTable ) then

        client.TargetsTable = {}
        for i = 1, #target do
	        client.TargetsTable[ #client.TargetsTable + 1 ] = target[i]
	    end

        hook.Add( "PreDrawOutlines", "DrawTargets", function()

            local to_draw = {}

            if ( client:GTeam() != TEAM_NTF ) then

                hook.Remove( "PreDrawOutlines", "DrawTargets" )
                client.TargetsTable = nil

                return
            end

            for i = 1, #client.TargetsTable do

                local target = client.TargetsTable[ i ]

                if ( target && target:IsValid() && target:Health() > 0 && ( !universal_search && target:GTeam() == team_indx || universal_search && universal_search[ target:GTeam() ] ) && !target:GetNClass():find("Spy") ) then

                    if ( !target:HasHazmat() ) then

                        to_draw[ #to_draw + 1 ] = target
                        local bnmrgtable = target:LookupBonemerges()

                        for i = 1, #bnmrgtable do
                        	if IsValid(bnmrgtable[i]) then
                        		to_draw[ #to_draw + 1 ] = bnmrgtable[i]
                        	end
                        end

                    end

                else

                    table.RemoveByValue( client.TargetsTable, target )

                end

            end

            outline.Add( to_draw, clr_to_draw, 0 )

        end )

        timer.Simple( 20, function()

            client.TargetsTable = nil
            hook.Remove( "PreDrawOutlines", "DrawTargets" )

        end )

    else

        client.TargetsTable[ #client.TargetsTable + 1 ] = target

    end

end )

local radio_green = Color( 0, 180, 0, 210 )

net.Receive( "fbi_commanderabillity", function()

  local client = LocalPlayer()

  if ( client:GetNClass() != ROLES.ROLE_USACMD ) then return end

  hook.Add( "PreDrawOutlines", "DrawPeopleWithRadios", function()

    local to_draw = {}

    if ( client:Health() <= 0 ) then

      hook.Remove( "PreDrawOutlines", "DrawPeopleWithRadios" )

      return
    end

    local players = player.GetAll()

    for i = 1, #players do

      local player = players[ i ]

      if ( player:IsSolid() ) then

        local radio = player:GetWeapon( "item_radio" )

        if ( radio && radio:IsValid() && radio.GetEnabled && radio:GetEnabled() && player:GTeam() != client:GTeam() ) then

          to_draw[ #to_draw + 1 ] = player

        end

      end

    end

    outline.Add( to_draw, radio_green, 0 )

  end )

  timer.Simple( 15, function()

    hook.Remove( "PreDrawOutlines", "DrawPeopleWithRadios" )

  end )

end )

local class_d_color = Color(255, 130, 0)

net.Receive( "Chaos_SpyAbility", function()

    local client = LocalPlayer()

    if ( client:GetNClass() != ROLES.ROLE_SECURITYSPY ) then return end

    hook.Add( "PreDrawOutlines", "DrawClassds", function()

        local to_draw = {}

        if ( !client:Alive() ) then

            hook.Remove( "PreDrawOutlines", "DrawClassds" )

            return
        end

        for _, v in ipairs( ents.FindInSphere( client:GetPos(), 300 ) ) do

            if ( v:IsPlayer() && v:GTeam() == TEAM_CLASSD && v:Health() > 0 ) then

                to_draw[ #to_draw + 1 ] = v

                for _, bnmrg in ipairs(v:LookupBonemerges()) do
                	to_draw[ #to_draw + 1 ] = bnmrg
                end

            end

        end

        outline.Add( to_draw, class_d_color, 2 )

    end )

    timer.Simple( 10, function()

        hook.Remove( "PreDrawOutlines", "DrawClassds" )

    end )

end )

net.Receive( "Cult_SpecialistAbility", function()

    local client = LocalPlayer()

    if ( client:GetNClass() != ROLES.ROLE_CULT_SPEC ) then return end

    hook.Add( "PreDrawOutlines", "DrawCultTargets", function()

        local to_draw = {}

        if ( !client:Alive() ) then

            hook.Remove( "PreDrawOutlines", "DrawCultTargets" )

            return
        end

        for _, v in ipairs( ents.FindInSphere( client:GetPos(), 300 ) ) do

            if ( v:IsPlayer() && v:GTeam() != TEAM_SPEC && v:Health() > 0 ) then

                to_draw[ #to_draw + 1 ] = v

            end

        end

        outline.Add( to_draw, Color(255,0,0), 0 )

    end )

    timer.Simple( 20, function()

        hook.Remove( "PreDrawOutlines", "DrawCultTargets" )

    end )

end )

net.Receive( "GRU_CommanderAbility", function()

    local client = LocalPlayer()

	local team_index = net.ReadString()

    if ( client:GTeam() != TEAM_GRU ) then return end

    hook.Add( "PreDrawOutlines", "DrawGRUTargets", function()

        local to_draw = {}

        if ( !client:Alive() ) then

            hook.Remove( "PreDrawOutlines", "DrawGRUTargets" )

            return
        end

        for _, v in ipairs( player.GetAll() ) do

            if ( v:GTeam() == team_index && v:Health() > 0 ) then

                to_draw[ #to_draw + 1 ] = v

            end

        end

        outline.Add( to_draw, Color(255,0,0), 0 )

    end )

    timer.Simple( 20, function()

        hook.Remove( "PreDrawOutlines", "DrawGRUTargets" )

    end )

end )

net.Receive( "cassie_pizdelka_start", function()

	MOGStart()

	local ply = LocalPlayer()

	timer.Create( "lc_15_s", 180, 1, function()
		surface.PlaySound( "nextoren/round_sounds/main_decont/decont_15_b.mp3" )
		if SERVER then 
		for k,v in pairs(player.GetAll()) do
		ply:BrTip( 3, "[VAULT Breach]", Color( 210, 0, 0, 180), "Вы не можете выйти из вашины в движение", Color( 255, 208, 0, 180) )
		end
	end
    end)

	timer.Create( "lc_12_s", 360, 1, function()
		surface.PlaySound( "nextoren/round_sounds/lhz_decont/decont_1_min.ogg" )
		surface.PlaySound( "no_new_music/decont_music.ogg" )
	end )

	timer.Create( "lc_11:15_s", 375, 1, function()
		surface.PlaySound( "nextoren/round_sounds/lhz_decont/decont_countdown.ogg" )
	end )

	timer.Create( "lc_11_s", 420, 1, function()
		surface.PlaySound( "nextoren/round_sounds/lhz_decont/decont_ending.ogg" )
	end )

	timer.Create( "lc_10_s", 480, 1, function()
		surface.PlaySound( "nextoren/round_sounds/main_decont/decont_10_b.mp3" )
	end )

	timer.Create( "lc_5_s", 780, 1, function()
		surface.PlaySound( "nextoren/round_sounds/main_decont/decont_5_b.mp3" )
	end )

	timer.Create( "lc_3_15_s", 885, 1, function()
		BREACH.Evacuation = true
		surface.PlaySound( "nextoren/round_sounds/intercom/start_evac.ogg" )
	end )

	timer.Create( "lc_2_10_s", 955, 1, function()
		surface.PlaySound( "nextoren/round_sounds/main_decont/final_nuke.mp3" )
	end )
end )

net.Receive( "cassie_pizdelka_stop", function()

	timer.Remove( "lc_15_s" )
	timer.Remove( "lc_12_s" )
	timer.Remove( "lc_11:30_s" )
	timer.Remove( "lc_11_s" )
	timer.Remove( "lc_10_s" )
	timer.Remove( "lc_5_s" )
	timer.Remove( "lc_3_15_s" )
	timer.Remove( "lc_2_10_s" )

end )


local DeathAnimations = {
	"wos_bs_shared_death_neck_slice",
	"wos_bs_shared_death_belly_slice_side",
	"wos_bs_shared_death_belly_slice",
	"l4d_other_Death"
}

function DeathAnimation( ply )
	ply:Freeze( true )  
	if ( ply.m_bJumping ) then
  	  timer.Simple( .25, function()
  		if ( !( ply && ply:IsValid() ) || ply:Health() > 0 ) then return end
  		local ragdoll_ent = ply:GetNWEntity( "RagdollEntityNO" )  
		if ( !( ragdoll_ent && ragdoll_ent:IsValid() ) ) then return end
  		--ply.BlackScreen = nil
		ply:SetNWEntity( "NTF1Entity", ply:GetNWEntity( "RagdollEntityNO" ) )
		--ply.InCutscene = true 
		timer.Create( "RagdollEntityRepair", 0, 0, function()
		  if ( ply:Team() == TEAM_SPEC || ply:Health() > 0 || !( ragdoll_ent && ragdoll_ent:IsValid() ) ) then
			timer.Remove( "RagdollEntityRepair" )
			ply:SetNWEntity( "NTF1Entity", NULL ) 
			return
		  end
		  if ( ply:GetNWEntity( "NTF1Entity" ) != ragdoll_ent ) then

			ply:SetNWEntity( "NTF1Entity", ragdoll_ent )

		  end

		end )

	  end )

	  return
	end
  
  
  
	local death_ragdoll = ents.CreateClientside( "ent_deathanimation" )
  
	death_ragdoll:SetOwner( ply )
  
	death_ragdoll:SetPos( ply:GetPos() )
  
	death_ragdoll.BoneMergedEnts = {}
  
	death_ragdoll.Bodygroups = {}
  
  
  
	if ( ply.BoneMergedEnts ) then
  
  
  
	  for i = 1, #ply.BoneMergedEnts do
  
  
  
		local bonemerge = ply.BoneMergedEnts[ i ]
  
  
  
		if ( bonemerge && bonemerge:IsValid() ) then
  
  
  
		  death_ragdoll.BoneMergedEnts[ #death_ragdoll.BoneMergedEnts + 1 ] = bonemerge:GetModel()
  
  
  
		end
  
  
  
	  end
  
  
  
	end
  
  
  
	for i = 0, #ply:GetBodyGroups() do
  
  
  
	  if ( ply:GetBodygroup( i ) != 0 ) then
  
  
  
		death_ragdoll.Bodygroups[ #death_ragdoll.Bodygroups + 1 ] = { id = i, value = ply:GetBodygroup( i ) }
  
  
  
	  end
  
  
  
	end

	death_ragdoll:Spawn()

	timer.Simple( .1, function()
	  if ( !( ply && ply:IsValid() ) || ply:Health() > 0 ) then return end
	  for _, v in ipairs( ents.FindInSphere( ply:GetPos(), 240 ) ) do
		if ( v:GetClass() == "prop_ragdoll" ) then
		  v:SetNoDraw( true )
		  v:DrawShadow( false )
  
		  for _, bonemerge in ipairs( v:GetChildren() ) do
			if ( bonemerge && bonemerge:IsValid() ) then
			  bonemerge:SetNoDraw( true )
			  bonemerge:DrawShadow( false )
			end
		  end

		  timer.Simple( 5, function()
			if ( v && v:IsValid() ) then
			  v:SetNoDraw( false )
			  v:DrawShadow( true )
			  for _, bonemerge in ipairs( v:GetChildren() ) do
				if ( bonemerge && bonemerge:IsValid() ) then
				  bonemerge:SetNoDraw( false )
				  bonemerge:DrawShadow( true )
				end
			  end
			end
		  end)
		end
	  end
	end)
  end

net.Receive( "StartDeathAnimation", function()
	local client = LocalPlayer()
	DeathAnimation( client )
end)
  