local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player


/* *****************************************************************************
 *  Name: Music && Panic system
 *
 *  Description:  Here are the main functions for playing music
 *                and effects.
 *
 *******************************************************************************/

BREACH = BREACH || {}

BREACH.EF = {}
NextActionMusicTime = NextActionMusicTime || 0;
SongEnd = SongEnd || 0;
NextSeeSCPs = NextSeeSCPs || 0;
VOLUME_MODIFY = VOLUME_MODIFY || 0;
BREACH.Dead = BREACH.Dead || false;
BREACH.DieStart = BREACH.DieStart || 0;
BREACH.NTFEnter = BREACH.NTFEnter || 0

function GetGenericSongs(name)
  local files = file.Find(name, "GAME")

  for k, v in pairs(files) do
    if (v:find("action") or v:find("decont")) then
      files[k] = nil
    end
  end

  return #files
end

function GetActionSongs(name)
  local files = file.Find(name, "GAME")

  for k, v in pairs(files) do
    if !v:find("action") then
      files[k] = nil
    end
  end

  return #files
end

function GetOtherSongs(name)
  local files = file.Find(name, "GAME")

  return #files
end
local lightzonegeneric = GetGenericSongs("sound/no_new_music/lightzone*.ogg")
local entrancegeneric = GetGenericSongs("sound/no_new_music/entrance*.ogg")
local hardzonegeneric = GetGenericSongs("sound/no_new_music/hardzone*.ogg")
local outsidegeneric = GetGenericSongs("sound/no_new_music/outside*.ogg")
local startambient = GetGenericSongs("sound/no_music/start_round_ambient/start_ambience*.ogg")

local lightzoneaction = GetActionSongs("sound/no_new_music/lightzone_action*.ogg")
local entranceaction = GetActionSongs("sound/no_new_music/entrance_action*.ogg")
local outsideaction = GetActionSongs("sound/no_new_music/outside_action*.ogg")
local hardzoneaction = GetActionSongs("sound/no_new_music/hardzone_action*.ogg")

local nukemusic = GetOtherSongs("sound/no_new_music/nuke_music*.ogg")
local decontmusic = GetOtherSongs("sound/no_new_music/decont_music*.ogg")

function PlayMusic( str, fadelen, volume )

  if ( !fadelen ) then fadelen = 1 end
  if !volume then volume = 1 end

  VOLUME_MODIFY = volume

  NextMusic = str
  if ( fadelen == 0 ) then

    StopMusic();

  end

  if ( CurMusicPatch ) then

    NextMusicTime = CurTime() + fadelen

  else

    NextMusicTime = CurTime()

  end

end

function FadeMusic( fadelen )

  if (!fadelen) then fadelen = 1 end

  if ( CurMusicPatch && CurMusicPatch:IsValid() ) then

    local fade = CurMusicPatch:GetVolume()

    timer.Create( "FadeMusic", 0, 0, function()

      fade = math.Approach( fade, 0, FrameTime() * .1 )

      if ( !( CurMusicPatch && CurMusicPatch:IsValid() ) ) then

        timer.Remove( "FadeMusic" )

        return
      end

      CurMusicPatch:SetVolume( fade )

      if ( fade == 0 ) then

        timer.Remove( "FadeMusic" )
        CurMusicPatch:Stop()
        SongEnd = CurTime() + 20

      end

    end )

  end

end

function StopMusic()

  if ( CurMusicPatch && CurMusicPatch:IsValid() ) then

    CurMusicPatch:Stop();
    NextMusicTime = CurTime()

  end

end

function CanPlayMusic()

  local client = LocalPlayer()

  --if ( client:Health() <= 0 ) then return false end
  --if ( client:GTeam() == TEAM_SPEC ) then return false end
  --if ( postround ) then return false end
  if ( client.NoMusic ) then return false end
  if GetGlobalBool("DisableMusic", false) then return false end
  return true;

end

function CanPlayGenericMusic()

  local client = LocalPlayer()

  if client:Health() <= 0 then return false end
  if client:GTeam() == TEAM_SPEC then return false end
  if GetGlobalBool("Evacuation", false) then return false end

  return true
end

local action_banned = {
  [ TEAM_SCP ] = true,
  [ TEAM_DZ ] = true,
  [ TEAM_SPEC ] = true
}

function Chuj()

  local client = LocalPlayer()

  if ( NextMusicTime && CurTime() >= NextMusicTime ) then

    CurMusic = NextMusic;

    if ( !( CurMusicPatch && CurMusicPatch:IsValid() ) ) then

      if ( isstring( CurMusic ) ) then

        sound.PlayFile( CurMusic, "noplay", function( station )

          if ( IsValid( station ) ) then

            station:Play()
            if tonumber(GetConVar("breach_config_music_volume"):GetFloat()) != nil then
              station:SetVolume( (GetConVar("breach_config_music_volume"):GetFloat() / 100) * VOLUME_MODIFY )
            else
              station:SetVolume(0)
            end
            cvars.AddChangeCallback("breach_config_music_volume", function(convar, old, new)
              if tonumber(new) == nil then
                station:SetVolume(0)
                return
              end
              if IsValid(station) then
                station:SetVolume((new / 100) * VOLUME_MODIFY)
              end
            end)
            CurMusicPatch = station
            SongEnd = CurTime() + CurMusicPatch:GetLength() + 40

          end

        end )

      end

    end

    if ( CurMusicPatch && CurMusicPatch:IsValid() ) then

      SongEnd = CurTime() + CurMusicPatch:GetLength() + 40

    end

    NextMusic = nil;
    NextMusicTime = nil;

  end

  if ( !CurMusicPatch || ( CurMusicPatch && CurTime() > SongEnd ) || CurMusicPatch && MusicAction && NextSeeSCPs < CurTime() ) then

    if ( MusicAction ) then

      if ( !( #SCPsNearMe( 240 ) >= 1 ) ) then

        MusicAction = nil
        FadeMusic( 1 )
        NextMusicTime = CurTime() + 5

        return
      end
    end
    if ( CanPlayMusic() ) and CanPlayGenericMusic() then
      if ( !( client:GTeam() != TEAM_SPEC && client:GTeam() != TEAM_SCP ) ) then return end
      PickGenericSong();
    end
  end

  if NextSeeSCPs > CurTime() then return end

  if (action_banned[client:GTeam()] or GetGlobalBool("Evacuation", false) or client:Health() <= 0) then return end

  for _, v in ipairs( ents.FindInSphere( client:GetPos(), 550 ) ) do
    if ( !v:IsPlayer() ) then continue end
    if ( v == client || v:GetNoDraw() || !v:GetModel():find( "/scp/" ) ) then continue end
    if v:GetRoleName() == SCP999 then continue end
    if v:GTeam() != TEAM_SCP then continue end
    local tr = util.TraceLine({
      start = client:EyePos(),
      endpos = v:EyePos(),
      filter = {client, v}
    }
    )
    if ( tr.Fraction !=  1) then continue end

    local aim_vector = client:GetAimVector()
    local ent_vector = v:GetPos() - client:GetShootPos()

    if ( aim_vector:Dot( ent_vector ) / ent_vector:Length() > .5235987755983 ) then -- math.pi / 6 ( 30 degrees )
      if ( !MusicAction ) then
        Panic()
        PickupActionSong()
      end

      NextSeeSCPs = CurTime() + math.random( 30, 40 )

      break
    end

  end
end

local function playambience()
  local client = LocalPlayer()
  return client:GTeam() != TEAM_GUARD && client:GTeam() != TEAM_NAZI && client:GTeam() != TEAM_USA
end

function PickGenericSong()

  local client = LocalPlayer()
  if !preparing then
  
    if ( client:IsLZ() ) then

      local song = "sound/no_new_music/lightzone" .. math.random( 1, lightzonegeneric ) .. ".ogg"
      PlayMusic( song, 0, 0.45 )

    elseif ( client:IsEntrance() ) then

      local song = "sound/no_new_music/entrance" .. math.random( 1, entrancegeneric ) .. ".ogg"
      PlayMusic( song, 0, 0.45 )

    elseif ( client:IsHardZone() ) then

      local song = "sound/no_new_music/hardzone" .. math.random( 1, hardzonegeneric ) .. ".ogg"
      PlayMusic( song, 0, 0.45 )
    
    elseif ( client:Outside() ) then

      local song = "sound/no_new_music/outside" .. math.random( 1, outsidegeneric ) .. ".ogg"
      PlayMusic( song, 0, 0.45 )

    else


      local song = "sound/no_new_music/hardzone" .. math.random( 1, hardzonegeneric ) .. ".ogg"
      PlayMusic( song, 0, 0.45 )

    end

  end

end

function PickupActionSong()
  local client = LocalPlayer()

  MusicAction = true

  if BREACH.Evacuation then
    StopMusic()
    local song = "sound/no_new_music/nuke_music" .. math.random( 1, nukemusic ) .. ".ogg"
    PlayMusic( song,  0 )

  elseif BREACH.Decontamination and client:IsLZ() then
    StopMusic()
    local song = "sound/no_new_music/decont_music" .. math.random( 1, decontmusic ) .. ".ogg"
    PlayMusic( song,  0 )

  elseif ( client:IsHardZone() ) then

    local song = "sound/no_new_music/hardzone_action" .. math.random( 1, hardzoneaction ) .. ".ogg"
    PlayMusic( song,  0 )
  
  --elseif ( client:GetNWString("niebo2", 0) == 1 ) then
  
     --local song = "sound/doommuza.ogg"  
      --PlayMusic( song,  0 ) 
  

  elseif preparing then

    local song = "sound/no_music/start_round_ambient/start_ambience" .. math.random( 1, startambient) .. ".ogg"  
      PlayMusic( song,  0 )
  
  --elseif ( client:IsLZ() and GetGlobalBool("lzzamkniecie")  ) then
     --local song = "sound/no_new_music/lightzone_decont_1.ogg"

    --PlayMusic( song, 0 )
  elseif ( client:IsLZ() ) then

    local song = "sound/no_new_music/lightzone_action" .. math.random( 1, lightzoneaction ) .. ".ogg"
    PlayMusic( song, 0 )
  
  elseif ( client:IsEntrance() ) then


    local song = "sound/no_new_music/entrance_action" .. math.random( 1, entranceaction ) .. ".ogg"

  PlayMusic( song, 0 )
  elseif ( client:Outside() ) then

    local song = "sound/no_new_music/outside_action" .. math.random( 1, outsideaction ) .. ".ogg"
    PlayMusic( song, 0 )
  
  else

    local song = "sound/no_new_music/hardzone_action" .. math.random( 1, hardzoneaction ) .. ".ogg"
    PlayMusic( song, 0 )

  end

  

end

function Panic()

  surface.PlaySound( "nextoren/charactersounds/panic.mp3" )

end

function nextNuked(len)

  BREACH.NukeStart = CurTime();
  BREACH.Nuked = true;

  local client = LocalPlayer()
  client:EmitSound( "nextoren/ending/nuke.mp3", 511 );

  timer.Simple( 8, function()

    if ( BREACH.Nuked ) then

      client:ConCommand( "stopsound" )

    end

  end )

end

net.Receive( "nextNuke", nextNuked );

MatBlur = Material("pp/blurscreen");

function DrawDead()

  if ( BREACH.Dead ) then

    local scrw, scrh = ScrW(), ScrH()
    local frac = math.Clamp( ( CurTime() - BREACH.DieStart ) / 1.8, 0, 5 ) / 2;

    surface.SetMaterial( MatBlur )
    surface.SetDrawColor( 255, 255, 255, 255 )

    for i = 0.33, 1, 0.33 do

      MatBlur:SetFloat( "$blur", frac * 5 * i )
      render.UpdateScreenEffectTexture()
      surface.DrawTexturedRect(0, 0, scrw, scrh )

    end

    surface.SetDrawColor( 10, 10, 10, 200 * frac );
    surface.DrawRect( 0, 0, scrw, scrh )

  end

end

local function StartMusic()

  local s_time = net.ReadFloat()

  local s_music = net.ReadString()

  StopMusic()

  PlayMusic( s_music, s_time )

end
net.Receive( "ClientPlayMusic", StartMusic )

local function FadeeMusic()

  local s_time = net.ReadFloat()

  FadeMusic( s_time )

end
net.Receive( "ClientFadeMusic", FadeeMusic )

local function StopeMusic()

  StopMusic()

end
net.Receive( "ClientStopMusic", StopeMusic )

function SCPsNearMe( r )

  local n = {};

  local client = LocalPlayer()

  local all_players = player.GetAll()

  local max_distance = r * r

  for i = 1, #all_players do

    local player = all_players[ i ]

    if ( player:GTeam() == TEAM_SCP && client:GetPos():DistToSqr( player:GetPos() ) < max_distance ) then

      n[ #n + 1 ] = player

    end

  end

  return n;

end


local BreachNextThink = 0

local thinkRate = 1 * .150


hook.Add("Think", "music_think", function()

  if ( CurTime() >= BreachNextThink ) then 

    Chuj()

    BreachNextThink = CurTime() + thinkRate

  end

end)


