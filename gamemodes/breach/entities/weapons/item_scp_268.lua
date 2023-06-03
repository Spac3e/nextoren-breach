--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/item_scp_268.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/268.png" )

end

SWEP.PrintName = "SCP-268"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.WorldModel = "models/scp_items/scp268/scp268.mdl"
SWEP.ViewModel = ""
SWEP.HoldType = "normal"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.UseHands = true

SWEP.Pos = Vector( -2, 6, 1 )
SWEP.Ang = Angle( 60, 90, 240 )

function SWEP:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Active" )
  self:NetworkVar( "Int", 0, "NextEffect" )

end

function SWEP:Deploy()

  if ( self:GetNextEffect() - CurTime() < 0 ) then

    self:SetNextEffect( CurTime() + 45 )
    self:ActivateEffect()

  else

    if ( SERVER ) then

      BREACH.Players:ChatPrint( self.Owner, true, true, "Подождите, СЦП-Объект перезаряжается." )
      BREACH.Players:ChatPrint( self.Owner, true, true, "Эффект невидимости будет доступен через " .. math.Round( self:GetNextEffect() - CurTime() ) .. " секунд. Способность активируется автоматически, не меняйте оружие." )

    end

  end

end

function SWEP:ActivateEffect()

  if ( SERVER ) then

    if ( !self.Player_Tip || self.Player_Tip != self.Owner:Nick() ) then

      self.Player_Tip = self.Owner:Nick()

      BREACH.Players:ChatPrint( self.Owner, true, true, "Невидимость активирована. Попытайтесь избегать физического взаимодействия с другими людьми, поскольку эффект невидимость пропадёт." )
      BREACH.Players:ChatPrint( self.Owner, true, true, "Если Вы смените оружие, то произойдёт то же самое; Ваша невидимость пропадёт через 20 секунд." )

    else

      BREACH.Players:ChatPrint( self.Owner, true, true, "Невидимость активирована. Длительность - 20 секунд." )

    end

  end

  self.unique_id = "InvisibleChange" .. self.Owner:SteamID64()

  timer.Create( self.unique_id, 20, 1, function()

    if ( self && self:IsValid() ) then

      self:DeactivateEffect()

    end

  end )

  self:SetActive( true )

  self.Owner:SetNoDraw( true )
  self.Owner:DrawShadow( false )

  self.droppable = false

end

function SWEP:DeactivateEffect()

  if ( SERVER ) then

    if ( self && self:IsValid() && self.Owner:Health() > 0 ) then

      BREACH.Players:ChatPrint( self.Owner, true, true, "Эффект невидимости снят." )

    end

  end

  if ( self.unique_id && isstring( self.unique_id ) ) then

    timer.Remove( self.unique_id )

  end

  self:SetActive( false )

  if ( self.Owner && self.Owner:IsValid() && self.Owner:GTeam() != TEAM_SPEC && self.Owner:Health() > 0 ) then

    self.Owner:SetNoDraw( false )
    self.Owner:DrawShadow( true )

  end

  self.droppable = true

end

function SWEP:Holster()

  if ( self:GetActive() ) then

    self:DeactivateEffect()

    self.UnDroppable = nil

  end

  return true

end

function SWEP:Initialize()

  self:SetHoldType( "normal" )

end

function SWEP:Think()

  if ( self.Owner && self.Owner:IsValid() && self:GetNextEffect() - CurTime() < 0 ) then

    self:SetNextEffect( CurTime() + 45 )
    self:ActivateEffect()

  end

  if ( CLIENT ) then

    if ( self:GetActive() && !self.UnDroppable ) then

      self.UnDroppable = true

    elseif ( !self:GetActive() && self.UnDroppable ) then

      self.UnDroppable = nil

    end

  end

  if ( self.Owner && self.Owner:IsValid() ) then

    if ( self:GetActive() ) then

      for _, v in ipairs( ents.FindInSphere( self:GetPos(), 30 ) ) do

        if ( v:IsPlayer() && v:IsSolid() && v != self.Owner ) then

          self:DeactivateEffect()

        end

      end

    end

  end

end

function SWEP:PrimaryAttack() end

function SWEP:DrawWorldModel()

  if ( !( self.Owner && self.Owner:IsValid() ) ) then

    self:DrawModel()

  end

end

function SWEP:SecondaryAttack()

  self:PrimaryAttack()

end

function SWEP:CanPrimaryAttack()

  return true

end
