--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   gamemodes/breach/gamemode/modules/anim_base/sh_anims.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local tblGestureAnimsToPlay = {

  1223,
  1457,
  1453,
  1219,
  1144

}

local animationstabletest = animationstabletest || {}
local animgesture_NextThink = animgesture_NextThink || 0

local bannedTeams = {

  [ TEAM_SPEC ] = true,
  [ TEAM_SCP ] = true

}

function BREACH.AnimGestureThink()

  if ( ( animgesture_NextThink || 0 ) >= CurTime() ) then return end

  animgesture_NextThink = CurTime() + 10

  local players = player.GetAll()

  for i = 1, #players do

    local v = players[ i ]

    if ( !( v && v:IsValid() ) || v:IsBot() ) then continue end

    if ( !timer.Exists( "LookAround" .. v:EntIndex() ) && !bannedTeams[ v:GTeam() ] ) then

      timer.Create( "LookAround" .. v:EntIndex(), math.random( 80, 120 ), 1, function()

        if ( v && v:IsValid() && v:Health() > 0 && !bannedTeams[ v:GTeam() ] ) then

          if ( !animationstabletest || #animationstabletest == 0 ) then

            animationstabletest = table.Copy( tblGestureAnimsToPlay )

          end

          local randomanimation = math.random( 1, #animationstabletest )
          local seqid = animationstabletest[ randomanimation ]

          table.remove( animationstabletest, randomanimation )

          v:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, seqid, 0, true )

        end

      end )

    end

  end

end

BREACH.ChatGestures = {

  1006, -- hg_headshake
  998, -- hg_nod_left
  1395, -- hg_nod_no
  994, -- hg_nod_right
  1391 -- hg_nod_yes

}

function GM:DoChatGesture( ply, cmd, text )

  local t = utf8.len( text )

  if ( !isnumber( t ) ) then return end

  t = t / 10

  if ( ( ply.SpeechEndTime || 0 ) > CurTime() ) then return end

  ply.SpeechEndTime = CurTime() + t
  ply.SpeechTab = BREACH.ChatGestures

  local random_speechid = ply.SpeechTab[ math.random( 1, #ply.SpeechTab ) ]

  ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, random_speechid, 0, true )

  if ( CLIENT ) then return end

  net.Start( "GestureClientNetworking" )

    net.WriteEntity( ply )
    net.WriteUInt( random_speechid, 13 )
    net.WriteUInt( GESTURE_SLOT_VCD, 3 )
    net.WriteBool( true )

  net.SendPVS( ply:GetPos() )

end
