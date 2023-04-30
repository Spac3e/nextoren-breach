--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/ent_weaponstation.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

if ( CLIENT ) then

  net.Receive( "WeaponStation_RedactMessage", function()

    local bool = net.ReadBool()

    if ( bool ) then

      BREACH.Player:ChatPrint( true, true, "Доступно редактирование вооружения! Нажмите клавишу \"" .. input.LookupBinding( "+menu_context" ):upper() || "none" .. "\" для модификации Вашего оружия." )

    else

      BREACH.Player:ChatPrint( true, true, "Вы покинули зону редактирования вооружения." )

      local survivor = LocalPlayer()

      local wep = survivor:GetActiveWeapon()

      if ( IsValid(wep) && wep.dt && wep.dt.State == CW_CUSTOMIZE ) then

        survivor:ConCommand( "cw_customize" )

      end

    end

  end )

end

if ( SERVER ) then

  util.AddNetworkString( "WeaponStation_RedactMessage" )

end

ENT.Base        = "base_gmodentity"

ENT.Category    = "Breach"

ENT.Model       = Model( "models/cult_props/entity/workbench.mdl" )
ENT.Angles      = Angle( 0, 180, 0 )
ENT.Pos         = {

  Vector( 7520.312012, -4175.750000, 0.031254 ),
  Vector( -1765.097412, 1982.283203, 0.031254 )

}

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_NONE )

  self:SetSolid( SOLID_BBOX )
  self:PhysicsInit( SOLID_BBOX )
  self:SetMoveType(MOVETYPE_NONE)


  if ( !self.n_Type ) then return end

  self:SetPos( self.Pos[ self.n_Type ] )
  self:SetAngles( self.Angles * ( -1 + self.n_Type ) )

end

if ( SERVER ) then

  ENT.AllSurvivors = {}

  function ENT:Think()

    if ( #self.AllSurvivors != 0 ) then

      local allsurvivors = self.AllSurvivors

      for i = 1, #allsurvivors do

        local survivor = allsurvivors[ i ]

        if ( survivor && survivor:IsValid() && survivor:GetPos():DistToSqr( self:GetPos() ) > 10000 && ( self.NextCanAttach || 0 ) < CurTime() ) then

          self.NextCanAttach = CurTime() + 2

          net.Start( "WeaponStation_RedactMessage" )

            net.WriteBool( false )

          net.Send( survivor )

          table.RemoveByValue( self.AllSurvivors, survivor )

          survivor.CanAttach = nil

        end

      end

    end

  end

  function ENT:Use( survivor )

    if ( survivor.CanAttach ) then return end
    if ( survivor:GTeam() == TEAM_SCP ) then return end
    if ( survivor:GetPos():DistToSqr( self:GetPos() ) > 10000 ) then return end

    net.Start( "WeaponStation_RedactMessage" )

      net.WriteBool( true )

    net.Send( survivor )

    survivor.CanAttach = true

    self.AllSurvivors[ #self.AllSurvivors + 1 ] = survivor

  end

  function ENT:OnRemove()

    local allsurvivors = self.AllSurvivors

    for i = 1, #allsurvivors do

      local survivor = allsurvivors[ i ]

      if ( survivor && survivor:IsValid() ) then

        survivor.CanAttach = nil

      end

    end

  end

end


function ENT:Draw()

  self:DrawModel()

end
