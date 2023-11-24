--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   gamemodes/breach/gamemode/modules/sh_mtables.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local BREACH_GM = GM || GAMEMODE
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local mathNormalizeAngle = math.NormalizeAngle;
local mathClamp = math.Clamp;

BREACH.Animations = BREACH.Animations || {}
BREACH.Animations.MainSequenceTable = BREACH.Animations.MainSequenceTable || {}

local function FindSequenceIDFromTable( str )

  return BREACH.Animations.MainSequenceTable[ str ] || -1

end

local function custom_FindSequenceIDFromTable( str, tbl )

  return tbl[ str ] || -1

end

--[[
if SERVER then
  util.AddNetworkString("WeaponChangeGesture")

  --ggitler
  net.Receive("WeaponChangeGesture", function(len, ply)
    ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence("ahl_holster_ar"), 0, true)
  end)
end
--]]

function GenerateSCPTable( holdtype, player )

  local scp_animations_table = BREACH.AnimationTable.SCPS
  local current_holdtype_animations = {}

  local search_method

  local current_list = player:GetSequenceList()

  if ( #current_list > 200 ) then

    search_method = FindSequenceIDFromTable
    current_list = nil

  else

    search_method = custom_FindSequenceIDFromTable
    new_tbl = {}

    for i = 0, #current_list do

      local sequence_name = current_list[ i ]

      new_tbl[ sequence_name:lower() ] = i

    end

    current_list = new_tbl

  end

  for name, animations in pairs( scp_animations_table ) do

    if ( name:find( holdtype .. "_" ) || name:find( "_" .. holdtype ) ) then

      if ( istable( animations ) ) then

        current_holdtype_animations[ holdtype ] = current_holdtype_animations[ holdtype ] || {}

        local current_table

        if ( name:find( holdtype .. "_" ) ) then

          local name_walktype = string.Replace( name, holdtype .. "_", "" )
          current_holdtype_animations[ holdtype ][ name_walktype ] = {}
          current_table = current_holdtype_animations[ holdtype ][ name_walktype ]

        else

          local name_walktype = string.Replace( name, "_" .. holdtype, "" )
          current_holdtype_animations[ holdtype ][ name_walktype ] = {}
          current_table = current_holdtype_animations[ holdtype ][ name_walktype ]

        end

        for _, sequence_name in ipairs( animations ) do

          if ( current_list ) then

            current_table[ #current_table + 1 ] = search_method( sequence_name:lower(), current_list )

          else

            current_table[ #current_table + 1 ] = search_method( sequence_name )

          end

        end

      else

        current_holdtype_animations[ holdtype ] = current_holdtype_animations[ holdtype ] || {}

        local seq_name = scp_animations_table[ name ]

        if ( name:find( holdtype .. "_" ) ) then

          if ( current_list ) then

            current_holdtype_animations[ holdtype ][ string.Replace( name, holdtype .. "_", "" ) ] = search_method( seq_name:lower(), current_list )

          else

            current_holdtype_animations[ holdtype ][ string.Replace( name, holdtype .. "_", "" ) ] = search_method( seq_name )

          end

        else

          if ( current_list ) then

            current_holdtype_animations[ holdtype ][ string.Replace( name, holdtype .. "_", "" ) ] = search_method( seq_name:lower(), current_list )

          else

            current_holdtype_animations[ holdtype ][ string.Replace( name, "_" .. holdtype, "" ) ] = search_method( seq_name, current_list )

          end

        end

      end

    end

  end

  return current_holdtype_animations || false

end

function GetMainSequenceTable()

  local createmethod

  if ( CLIENT ) then

    createmethod = ents.CreateClientside

  else

    createmethod = ents.Create

  end

  local test_entity = createmethod( "base_gmodentity" )
  test_entity:SetModel( "models/cultist/humans/sci/scientist.mdl" )
  test_entity:Spawn()

  local sequence_list = test_entity:GetSequenceList()

  for i = 1, #sequence_list do

    local animation = sequence_list[ i ]

    BREACH.Animations.MainSequenceTable[ animation ] = i

  end

  test_entity:Remove()

end

function CreateTestHoldTypeTables()

  local human_holdtypes = {

    "ar2",
    "smg",
    "rpg",
    "knife",
    "shotgun",
    "zombie",
    "gauss",
    "melee2",
    "crowbar",
    "items",
    "heal",
    "revolver",
    "keycard",
    "pass",
    "slam",
    "normal",
    "physgun"

  }

  BREACH.Animations.HumansAnimations = {}
  BREACH.Animations.GuardAnimations = {}
  BREACH.Animations.SoldiersAnimations = {}

  local tables_to_generate = {

    { original_tbl = BREACH.AnimationTable.Soldiers, tbl_to_use = BREACH.Animations.SoldiersAnimations },
    { original_tbl = BREACH.AnimationTable.Guards, tbl_to_use = BREACH.Animations.GuardAnimations },
    { original_tbl = BREACH.AnimationTable.maleHuman, tbl_to_use = BREACH.Animations.HumansAnimations }

  }

  for _, tables in ipairs( tables_to_generate ) do

    for animation in pairs( tables.original_tbl ) do

      for _, holdtype_name in ipairs( human_holdtypes ) do

        if ( animation:find( holdtype_name ) ) then

          if ( istable( tables.original_tbl[ animation ] ) ) then

            tables.tbl_to_use[ holdtype_name ] = tables.tbl_to_use[ holdtype_name ] || {}

            local current_table

            if ( animation:find( holdtype_name .. "_" ) ) then

              local name_walktype = string.Replace( animation, holdtype_name .. "_", "" )
              tables.tbl_to_use[ holdtype_name ][ name_walktype ] = {}
              current_table = tables.tbl_to_use[ holdtype_name ][ name_walktype ]

            else

              local name_walktype = string.Replace( animation, "_" .. holdtype_name, "" )
              tables.tbl_to_use[ holdtype_name ][ name_walktype ] = {}
              current_table = tables.tbl_to_use[ holdtype_name ][ name_walktype ]

            end

            for _, v in ipairs( tables.original_tbl[ animation ] ) do

              if ( !istable( v ) ) then

                current_table[ #current_table + 1 ] = FindSequenceIDFromTable( v )

              else

                current_table.animation = FindSequenceIDFromTable( v.animation )
                current_table.gesture = FindSequenceIDFromTable( v.gesture )

              end

            end

          else

            tables.tbl_to_use[ holdtype_name ] = tables.tbl_to_use[ holdtype_name ] || {}

            local seq_name = tables.original_tbl[ animation ]

            if ( animation:find( holdtype_name .. "_" ) ) then

              tables.tbl_to_use[ holdtype_name ][ string.Replace( animation, holdtype_name .. "_", "" ) ] = FindSequenceIDFromTable( seq_name )

            else

              tables.tbl_to_use[ holdtype_name ][ string.Replace( animation, "_" .. holdtype_name, "" ) ] = FindSequenceIDFromTable( seq_name )

            end

          end

        end

      end

    end

  end

end

hook.Add( "Initialize", "CreateAnimationsTable", function()

  timer.Simple( 1, function()

    GetMainSequenceTable()
    CreateTestHoldTypeTables()

  end )

end )

function BREACH_GM:HandlePlayerJumping(player)

  if ( player:GetJumpPower() <= 0 ) then return end

  if ( player:GetMoveType() == MOVETYPE_NOCLIP || ( player:GTeam() == TEAM_SPEC || player:Health() <= 0 ) ) then return end

  if ( !player:OnGround() && !player.m_bJumping ) then

    player.m_bJumping = true
    player.m_flJumpStartTime = CurTime()

  end

  if ( player.m_bJumping ) then

    local holdtype = player.AnimationHoldType

    if ( holdtype && player.JumpAnimation ) then

      player.CalcIdeal = player.JumpAnimation
      player.CalcSeqOverride = player.JumpAnimation

    else

      player.CalcIdeal = 108
      player.CalcSeqOverride = 108

    end

    if ( CurTime() - player.m_flJumpStartTime > 0.2 ) then

      if ( player:OnGround() ) then

        player.m_bJumping = false
        player:AnimRestartMainSequence()

      end

    end

    return true

  end

end

function BREACH_GM:HandlePlayerDucking( player, velocity )

	if ( player:Crouching() ) then

		local weapon = player:GetActiveWeapon()
		local velLength = velocity:Length2D()
    local IswepCW = weapon.CW20Weapon

    if ( IswepCW ) then

      local firemode = weapon.FireMode

      if ( velLength > 0.5 ) then

        if ( firemode != "safe" ) then

          animation = player.CrouchWalkAim

        else

          animation = player.CrouchWalkIdle

        end

      else

        if ( firemode != "safe" ) then

          animation = player.CrouchIdleAim

        else

          animation = player.CrouchIdleSafemode

        end

      end

    else

      if ( velLength > .5 ) then

        animation = player.CrouchWalkAim

      else

        animation = player.CrouchWalkIdle

      end

    end

		player.CalcSeqOverride = animation

		return true;
	end

	return false;
end

function BREACH_GM:HandlePlayerDriving(player)

	if ( player:InVehicle() ) then

    local is_driver = player:GetVehicle():GetClass() != "prop_vehicle_prisoner_pod"

		player.CalcIdeal = is_driver && 2538 || 292
    player.CalcSeqOverride = is_driver && 2538 || 292

		return true

	end

	return false
end

function BREACH_GM:UpdateAnimation( player, velocity, maxSeqGroundSpeed )

	local velLength = velocity:Length2D()
	local rate = 1.0

  if ( player:GetNWAngle( "ViewAngles" ) != angle_zero ) then

    player:SetRenderAngles( player:GetNWAngle( "ViewAngles" ) )

  end

	if ( velLength > 0.5 ) then

		rate = ( ( velLength * 0.8 ) / maxSeqGroundSpeed )

	end

  local forcedAnimation = player.ForceAnimSequence

  if ( forcedAnimation && forcedAnimation != 0 ) then

    player:SetPlaybackRate( 1.0 )

  else

    rate = math.min( rate, 2 )
  	player:SetPlaybackRate( rate )

  end

	if ( CLIENT ) then

    if ( player:InVehicle() ) then

  		local vehicle = player:GetVehicle()

  		if ( vehicle && vehicle:IsValid() ) then

  			local velocity = vehicle:GetVelocity()
  			local steer = ( vehicle:GetPoseParameter( "vehicle_steer" ) * 2 ) - 1

  			player:SetPoseParameter( "vertical_velocity", velocity.z * .01 )
  			player:SetPoseParameter( "vehicle_steer", steer )

  		end

    end

    if ( player == LocalPlayer() ) then

      if ( Shaky_LEGS.legEnt && Shaky_LEGS.legEnt:IsValid() ) then

        Shaky_LEGS:LegsWork( player, maxSeqGroundSpeed )

      else

        Shaky_LEGS:CreateLegs()

      end

    end

    self:GrabEarAnimation( player )
    self:MouthMoveAnimation( player )

  end

end

local blink_value = 1
local multiplier = 1

local mouth_banned = {

  [ TEAM_SPEC ] = true,
  [ TEAM_SCP ] = true

}

function BREACH_GM:MouthMoveAnimation( ply )

	if ( mouth_banned[ ply:GTeam() ] ) then return end

  if ( !( ply.HeadEnt && ply.HeadEnt:IsValid() ) ) then return end

	local flex = { ply.HeadEnt:GetFlexIDByName( "Eyes" ), ply.HeadEnt:GetFlexIDByName( "Mounth" ) }

	local weight = ply:IsSpeaking() && !ply.DisableMouthAnimation && math.min( ply:VoiceVolume() * 6, 1 ) || 0

  if ( flex[ 1 ] ) then

    if ( ( ply.NextBlink || 0 ) < CurTime() ) then

      ply.NextBlink = CurTime() + math.random( 2, 8 )

      blink_value = 1

      ply.HeadEnt:SetFlexWeight( flex[ 1 ], blink_value )

    elseif ( blink_value > 0 ) then

      multiplier = 1.25
      if ( RealFrameTime() > 0.01 ) then

        multiplier = 2.5

      end

      blink_value = math.Approach( blink_value, 0, RealFrameTime() * multiplier )
      ply.HeadEnt:SetFlexWeight( flex[ 1 ], blink_value )

    end

  end

  if ( flex[ 2 ] ) then

	  ply.HeadEnt:SetFlexWeight( flex[ 2 ], weight * 1.5 )

  end

end

function BREACH_GM:TranslateActivity(player, act)

  local animations = player.BrAnimTable

  if ( !animations ) then

    return self.BaseClass:TranslateActivity( player, act )

  end

  if ( player:OnGround() ) then

    local weapon = player:GetActiveWeapon()
    local IswepCW = weapon.CW20Weapon
    local IsRaised;

    if ( IswepCW ) then

      IsRaised = weapon.dt.State == CW_AIMING

    end

    if ( animations[ holdtype ] && animations[ holdtype ][ act ] ) then

      local animation = animations[ holdtype ][ act ]

      if ( istable( animation ) ) then

        if ( IsRaised ) then

          animation = animation[ 2 ]

        else

          animation = animation[ 1 ]

        end

      elseif ( isstring( animation ) ) then

        player.CalcSeqOverride = player:LookupSequence( animation )

      end

      return animation

    end


  end

end;

function GM:PlayerWeaponChanged( client, weapon, force )
  local wep = client:GetActiveWeapon()

  if ( client.UsingInvisible ) then

    wep:SetNoDraw( true )

  end

  if ( wep != weapon && !force ) then return end

  local wep_table = istable( weapon )

  if ( !wep_table && !( weapon && weapon:IsValid() ) ) then return end

  local holdType;
  local IswepCW;

  if ( wep_table ) then

    IswepCW = weapon.Base == "cw_kk_ins2_base"

    if ( IswepCW ) then

      holdType = weapon.NormalHoldType

    else

      holdType = weapon.HoldType

    end

  else

    IswepCW = weapon.CW20Weapon || weapons.GetStored( weapon:GetClass() ).Base == "cw_kk_ins2_base"

    holdType = BREACH.AnimationTable:GetWeaponHoldType( client, weapon, IswepCW )

  end

  if ( wep.CW20Weapon && !weapon.CW20Weapon && !force ) then return end

  local is_scp = client:GetModel():find( "/scp/" ) && client:GTeam() == TEAM_SCP
  
  if ( !client.DrawAnimation && !is_scp ) then

    client.DrawAnimation = true
    client:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, 3289, 0, true )

    timer.Simple( client:SequenceDuration( 3289 ) + .5, function()

      if ( client && client:IsValid() ) then

        client.DrawAnimation = nil

      end

    end )

  end
  

  if ( !holdType ) then return end

  if ( client.AnimationHoldType && client.AnimationHoldType == holdType && client.Old_Model == client:GetModel() ) then return end
  --[[

  if SERVER then
      net.Start("GestureClientNetworking")
          net.WriteEntity(client)
          net.WriteUInt(client:LookupSequence("ahl_holster_ar"), 13)
          net.WriteUInt(GESTURE_SLOT_CUSTOM, 3)
          net.WriteBool(true)
        net.Broadcast()
  end]]

  client.AnimationHoldType = holdType

  client.GestureAnimationIdle = nil
  client.GestureAnimationWalk = nil
  client.GestureAnimationRun  = nil

  local animations_table

  if ( !is_scp ) then

    animations_table = AnimationTableGetTable( client, client:GetModel() )[ client.AnimationHoldType ]

  else

    animations_table = GenerateSCPTable( client.AnimationHoldType, client )

    if ( animations_table ) then

      animations_table = animations_table[ client.AnimationHoldType ]

    end

  end

  if ( !animations_table ) then return end

  for k, v in pairs( animations_table ) do

    if ( k:find( "walk" ) ) then

      if ( !v.animation ) then

        client.SafeModeWalk = v[ 1 ]
        client.Walk = v[ 2 ] || 0
        client.AimWalk = v[ 3 ] || 0

      else

        client.SafeModeWalk = v.animation
        client.GestureAnimationWalk = v.gesture

      end

    elseif ( k:find( "run" ) ) then

      if ( !v.animation ) then

        client.SafeRun = v[ 1 ]
        client.Run = v[ 2 ] || 0

      else

        client.SafeRun = v.animation
        client.GestureAnimationRun = v.gesture

      end

    elseif ( k:find( "crouch" ) ) then

      if ( !k:find( "reload" ) ) then

        client.CrouchWalkAim = v[ 1 ]
        client.CrouchWalkIdle = v[ 2 ] || 0
        client.CrouchIdleAim = v[ 3 ] || 0
        client.CrouchIdleSafemode = v[ 4 ] || 0

      else

        if ( !client.ReloadAnimations ) then

          client.ReloadAnimations = {}

        end

        client.ReloadAnimations[ 2 ] = v

      end

    elseif ( k:find( "idle" ) ) then

      if ( !v.animation ) then

        client.IdleSafemode = v[ 1 ]
        client.Idle = v[ 2 ] || 0
        client.IdleAim = v[ 3 ] || 0

      else

        client.IdleSafemode = v.animation
        client.GestureAnimationIdle = v.gesture

      end

    elseif ( k:find( "attack" ) ) then

      client.AttackAnimations = v

    elseif ( k:find( "reload" ) ) then

      if ( !client.ReloadAnimations ) then

        client.ReloadAnimations = {}

      end

      client.ReloadAnimations[ 1 ] = v

    elseif ( k:find( "jump" ) ) then

      client.JumpAnimation = v

    end

  end

  client.Old_Weapon = weapon
  client.Old_Model = client:GetModel()

end

function GM:PlayerSwitchWeapon() end

do

  local vectorAngle = FindMetaTable( "Vector" ).Angle

  local spec_index = TEAM_SPEC

  function BREACH_GM:CalcMainActivity( player, velocity )

  local pl = player:GetTable()

    if ( player:GTeam() == spec_index ) then return end

    local forcedAnimation = pl.ForceAnimSequence

    if ( forcedAnimation && forcedAnimation != 0 ) then

      if ( player:GetSequence() != forcedAnimation ) then

        player:SetCycle( 0 )

      end

      return -1, forcedAnimation

    end

    player:SetPoseParameter( "move_yaw", mathNormalizeAngle( vectorAngle( velocity )[ 2 ] - player:EyeAngles()[ 2 ] ) );

    local wep = player:GetActiveWeapon()
    local wepIsCW = wep.CW20Weapon

    if ( wep != NULL ) then

      if ( !pl.IdleSafemode || pl.IdleSafemode == -1 || ( !wepIsCW && wep.HoldType || wep.NormalHoldType ) != pl.AnimationHoldType ) then

        hook.Run( "PlayerWeaponChanged", player, wep, true )

      end

    end

    if ( wepIsCW ) then

      if ( wep.FireMode != "safe" ) then

        if ( wep.dt.State == CW_AIMING ) then

          pl.CalcSeqOverride  = pl.IdleAim
          pl.CalcIdeal = pl.IdleAim

        else

          pl.CalcSeqOverride  = pl.Idle
          pl.CalcIdeal = pl.Idle

        end

      else

        pl.CalcSeqOverride  = pl.IdleSafemode
        pl.CalcIdeal = pl.IdleSafemode

      end

    else

      if ( pl.GestureAnimationIdle && velocity:Length2DSqr() < .25 && ( pl.GesturePlaying || 0 ) != pl.GestureAnimationIdle ) then

        player:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
        player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, pl.GestureAnimationIdle, 0, false )
        pl.GesturePlaying = pl.GestureAnimationIdle

      end

      pl.CalcSeqOverride = pl.IdleSafemode
      pl.CalcIdeal = pl.IdleSafemode

    end

    local baseClass = self.BaseClass

  	if !( baseClass:HandlePlayerNoClipping( player, velocity ) ||
  	  self:HandlePlayerDriving( player ) ||
  	  baseClass:HandlePlayerVaulting( player, velocity ) ||
  	  self:HandlePlayerJumping( player, velocity ) ||
  	  baseClass:HandlePlayerSwimming( player, velocity ) ||
  	  self:HandlePlayerDucking( player, velocity ) ) then

      local velLength = velocity:Length2DSqr()

      if ( velLength > 22500 ) then

        if ( wepIsCW ) then

          if ( wep.FireMode != "safe" ) then

            pl.CalcSeqOverride = pl.Run
            pl.CalcIdeal = pl.Run

          else

            pl.CalcSeqOverride = pl.SafeRun
            pl.CalcIdeal = pl.SafeRun

          end

        else

          if ( pl.GestureAnimationRun && ( pl.GesturePlaying || 0 ) != pl.GestureAnimationRun ) then

            player:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
            player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, pl.GestureAnimationRun, 0, false )
            pl.GesturePlaying = pl.GestureAnimationRun

          end

          pl.CalcSeqOverride = pl.SafeRun
          pl.CalcIdeal = pl.SafeRun

        end

      elseif ( velLength > .25 ) then

        if ( wepIsCW ) then

          if ( wep.FireMode != "safe" ) then

            if ( wep.dt.State == CW_AIMING ) then

              pl.CalcSeqOverride = pl.AimWalk
              pl.CalcIdeal = pl.AimWalk

            else

              pl.CalcSeqOverride = pl.Walk
              pl.CalcIdeal = pl.Walk

            end

          else

            pl.CalcSeqOverride = pl.SafeModeWalk
            pl.CalcIdeal = pl.SafeModeWalk

          end

        else

          if ( pl.GestureAnimationWalk && ( pl.GesturePlaying || 0 ) != pl.GestureAnimationWalk ) then

            player:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
            player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, pl.GestureAnimationWalk, 0, false )
            pl.GesturePlaying = pl.GestureAnimationWalk

          end

          pl.CalcSeqOverride = pl.SafeModeWalk
          pl.CalcIdeal = pl.SafeModeWalk

        end

      end

  	end

  	if ( isstring( pl.CalcSeqOverride ) ) then

  		pl.CalcSeqOverride = player:LookupSequence( pl.CalcSeqOverride )

  	end;

  	if ( isstring( pl.CalcIdeal ) ) then

  		pl.CalcSeqOverride = player:LookupSequence( pl.CalcIdeal )

  	end;

  	return pl.CalcIdeal, pl.CalcSeqOverride;

  end;

end

function BREACH_GM:DoAnimationEvent(player, event, data)

  if ( event == 20 ) then

    event = 19

  end

	local weapon = player:GetActiveWeapon()
  local IswepCW = weapon.CW20Weapon
  local holdtype = player.AnimationHoldType

	if ( event == PLAYERANIMEVENT_ATTACK_PRIMARY ) then

    if ( !holdtype ) then

      hook.Run( "PlayerWeaponChanged", player, player:GetActiveWeapon(), true )

      return
    end

    if ( CLIENT ) then

      player:SetIK( false )

    end

    local gestureSequence = player.AttackAnimations

    if ( istable( gestureSequence ) ) then

      gestureSequence = table.Random( gestureSequence )

    end

    if ( !gestureSequence ) then return end

		if ( gestureSequence && player.GestureAnimationIdle ) then

			if ( player:Crouching() ) then

        player:AnimSetGestureWeight( GESTURE_SLOT_ATTACK_AND_RELOAD, 1 )
        player:AnimSetGestureWeight( GESTURE_SLOT_CUSTOM, 0 )
				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true )

    	else

        player:AnimSetGestureWeight( GESTURE_SLOT_CUSTOM, .1 )
        player:AnimSetGestureWeight( GESTURE_SLOT_VCD, .9 )

				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, gestureSequence, 0, true )

        timer.Create( "ReturnWeight", player:SequenceDuration( gestureSequence ) - .1, 1, function()

          player:AnimSetGestureWeight( GESTURE_SLOT_CUSTOM, 1 )
          player:AnimSetGestureWeight( GESTURE_SLOT_VCD, 0 )

        end )


    	end

    elseif ( gestureSequence ) then

      player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true )

		end;

    if ( CLIENT ) then

      player:SetIK( false )

    end

		return ACT_VM_PRIMARYATTACK;

	elseif (event == PLAYERANIMEVENT_RELOAD) then

    local gestureSequence

    if ( !holdtype ) then

      hook.Run( "PlayerWeaponChanged", player, player:GetActiveWeapon(), true )

      return
    end

    if ( !player.ReloadAnimations ) then return end

    if ( !player:Crouching() ) then

      gestureSequence = player.ReloadAnimations[ 1 ]

    else

      gestureSequence = player.ReloadAnimations[ 2 ]

    end

    if ( !gestureSequence ) then return end

		if ( gestureSequence ) then

			if ( player:Crouching() ) then

			  player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true )

  		else

				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true )

      end

		end

		return ACT_INVALID

	elseif ( event == PLAYERANIMEVENT_JUMP ) then

		player.m_bJumping = true
		player.m_bFirstJumpFrame = true
		player.m_flJumpStartTime = CurTime()

		player:AnimRestartMainSequence()

		return ACT_INVALID

	elseif ( event == PLAYERANIMEVENT_CANCEL_RELOAD ) then

		player:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

		return ACT_INVALID

  elseif ( event == PLAYERANIMEVENT_HEALTHATTACK ) then

    local gestureSequence = player:LookupSequence( "Attack_BANDAGES" )

		if ( gestureSequence ) then

			if (player:Crouching()) then

				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, gestureSequence, 0, true )

    	else
				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, gestureSequence, 0, true )

    	end

		end

    return ACT_INVALID

  elseif ( event == PLAYERANIMEVENT_MELEEATTACK ) then

    if ( CLIENT ) then

      player:SetIK( false )

    end

    local gestureSequence = player:LookupSequence( "wos_judge_r_s2_t2" )


		if ( gestureSequence ) then

			if ( player:Crouching() ) then

				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true )

			else

				player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true )

			end

		end

    return ACT_INVALID

	end

	return nil

end
