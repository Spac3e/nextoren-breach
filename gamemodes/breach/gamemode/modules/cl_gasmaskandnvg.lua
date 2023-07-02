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
util.PrecacheModel( "models/gmod4phun/c_contagion_gasmask.mdl" )

local meta = FindMetaTable( "Player" )

function meta:GASMASK_PlayAnim( anim, rate )
  local mask = self.GASMASK_HudModel

  if ( mask && mask:IsValid() ) then

    mask:ResetSequence( anim )
    if !rate then
    mask:SetCycle(0)
    mask:SetPlaybackRate(1)
  else
    mask:SetCycle(0)
    mask:SetPlaybackRate(-1)
  end

  end

end

function meta:GASMASK_DelayedFunc( time, func )

  timer.Simple( time, function() if ( !IsValid( self ) || !self:Alive() ) then return end func( self ) end )

end

net.Receive( "GASMASK_RequestToggle", function()

  local ply = LocalPlayer()
  local state = net.ReadBool()

  if ( state ) then

    ply:GASMASK_PlayAnim( "draw" )
    ply:EmitSound( "GASMASK_DrawHolster" )
    ply:GASMASK_DelayedFunc( .3, function() ply:GASMASK_PlayAnim( "put_on" ) ply:EmitSound( "GASMASK_Foley" ) end )
    ply:GASMASK_DelayedFunc( .6, function() ply:EmitSound( "GASMASK_Inhale" ) end )
    ply:GASMASK_DelayedFunc( 1.2, function() ply:EmitSound( "GASMASK_OnOff" ) end )
    ply:GASMASK_DelayedFunc( 1.79, function() ply:GASMASK_PlayAnim( "idle_on" ) end )

  else

    --ply:EmitSound( "GASMASK_DrawHolster" )
    --ply:GASMASK_DelayedFunc( .3, function() ply:GASMASK_PlayAnim( "take_off" ) ply:EmitSound( "GASMASK_Foley" ) end )
   ply:EmitSound( "GASMASK_Exhale" )
   -- ply:GASMASK_DelayedFunc( 1.2, function() ply:EmitSound( "GASMASK_OnOff" ) end )
   -- ply:GASMASK_DelayedFunc( 1.79, function() ply:GASMASK_PlayAnim( "idle_on" ) end )

  end

end)

net.Receive( "GASMASK_SendEquippedStatus", function()

  LocalPlayer().GASMASK_Equiped = net.ReadBool()

end)


local function GASMASK_CalcHorizontalFromVerticalFOV( num )

  local r = ScrW() / ScrH()
  r = r / ( 4 / 3 )
  local tan, atan, deg, rad = math.tan, math.atan, math.deg, math.rad

  local vFov = rad( num )
  local hFov = deg( 2 * atan( tan( vFov / 2 ) * r ) )

  return hFov

end

local function GASMASK_CopyBodyGroups( source, target )

  for num, _ in pairs( source:GetBodyGroups() ) do

    target:SetBodygroup( num - 1, source:GetBodygroup( num - 1 ) )
    target:SetSkin( source:GetSkin() )

  end

end

local function GASMASK_DrawInHud()

  --[[]]

  local ply = LocalPlayer()
  local team = ply:GTeam()

  if ( !IsValid( ply ) || team == TEAM_SPEC || team == TEAM_SCP ) then return end
  --
  if ply:GetViewEntity() != ply then return end

  if ( !ply.GASMASK_HudModel || !IsValid( ply.GASMASK_HudModel ) ) then

    ply.GASMASK_HudModel = ClientsideModel( "models/gmod4phun/c_contagion_gasmask.mdl", RENDERGROUP_BOTH )
    ply.GASMASK_HudModel:SetNoDraw( true )
    ply:GASMASK_PlayAnim( "idle_holstered" )

  end

  local mask = ply.GASMASK_HudModel

  if ( !IsValid( mask ) ) then return end

  if ( !ply.GASMASK_HandsModel || !IsValid( ply.GASMASK_HandsModel ) ) then

    local gmhands = ply:GetHands()

    if ( gmhands && gmhands:IsValid() ) then

      ply.GASMASK_HandsModel = ClientsideModel( gmhands:GetModel(), RENDERGROUP_BOTH )
      ply.GASMASK_HandsModel:SetNoDraw( true )
      ply.GASMASK_HandsModel:SetParent( mask )
      ply.GASMASK_HandsModel:AddEffects( bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL) )
      GASMASK_CopyBodyGroups( gmhands, ply.GASMASK_HandsModel )

    end

  end

  if ( !ply:Alive() ) then

    ply:GASMASK_PlayAnim( "idle_holstered" )

  end

  local pos, ang = EyePos(), EyeAngles()
  local maskwep = weapons.GetStored( "gasmask" )
  local camFOV = GASMASK_CalcHorizontalFromVerticalFOV( maskwep.ViewModelFOV )
  local scrw = ScrW()
  local scrh = ScrH()
  local FT = FrameTime()
  mask:Remove()
  ply.GASMASK_HandsModel:Remove()
  --
  --[[
  cam.Start3D( pos, ang, camFOV, 0, 0, scrw, scrh, 1, 100 )

    cam.IgnoreZ( false )

      render.SuppressEngineLighting( false )

        mask:SetPos( pos )
        mask:SetAngles( ang )
        mask:FrameAdvance( FT )
        mask:SetupBones()

        if ( ply:GetViewEntity() == ply ) and !ply:ShouldDrawLocalPlayer() then

          mask:DrawModel()

          if ( hands && hands:IsValid() ) then

            hands:DrawModel()

          end

        end

      render.SuppressEngineLighting( false )

    cam.IgnoreZ( false )

  cam.End3D()]]

end

hook.Add( "HUDPaintBackground", "GASMASK_HUDPaintDrawing", function()

  if ( !LocalPlayer():Alive() ) then return end

  local team = LocalPlayer():GTeam()

  if !LocalPlayer().GASMASK_Equiped then return end


  if ( team == TEAM_SPEC || team == TEAM_SCP ) then return end

  --GASMASK_DrawInHud()

end )

local maskbreathsounds = {

  [1] = "GASMASK_BreathingLoop",
  [2] = "GASMASK_BreathingLoop2"

}

local function GASMASK_BreathThink()

  local ply = LocalPlayer()
  if ( !IsValid( ply ) ) then return end

  local mask = ply.GASMASK_HudModel

  if ( !IsValid( mask ) ) then return end

  local sndtype = 1

  if ( !ply.GASMASK_BreathSound ) then

    ply.GASMASK_BreathSound = CreateSound( ply, maskbreathsounds[sndtype] )

  end

  local shouldplay = mask:GetSequenceName( mask:GetSequence() ) == "idle_on"

  local snd = ply.GASMASK_BreathSound

  if ( snd ) then

    snd:ChangePitch( snd:GetPitch() + 0.01 )
    snd:ChangePitch( math.Clamp( game.GetTimeScale()  * 100, 75, 120 ) )
    snd:ChangeVolume( shouldplay && 1 || 0, 0.5 )

    if ( !snd:IsPlaying() && shouldplay ) then

      snd:Play()

    end

  end

end

--[[hook.Add( "Think", "GASMASK_BreathSoundThink", function()

  GASMASK_BreathThink()

end)]]
