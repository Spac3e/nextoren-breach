--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/weapon_scp_500.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]



SWEP.HoldType = "slam"

if ( CLIENT ) then

  SWEP.Category           = "NextOren Breach"
  SWEP.PrintName          = "SCP-500"
  SWEP.Slot               = 1
  SWEP.ViewModelFOV       = 50
  SWEP.DrawSecondaryAmmo = false
  SWEP.DrawAmmo       = false
  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/500.png" )

end

SWEP.ViewModelFlip      = false

SWEP.Spawnable          = true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = ""
SWEP.WorldModel         = "models/cultist/scp_items/500/scp500.mdl"

SWEP.Amount = 1
SWEP.UseHands = true
SWEP.ShowWorldModel = false
SWEP.HoldType       = "slam"

SWEP.Primary.Delay          = 3.5
SWEP.NextAttack = 0
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.Ammo         = "none"

function SWEP:Initialize() end

function SWEP:Think()

  if ( self && self:IsValid() && self.Amount <= 0 ) then

    self:Remove()

  end

  return true
end

function SWEP:CanSecondaryAttack()

  self:PrimaryAttack()

end

function SWEP:Eat()

  if !IsFirstTimePredicted() then return end

  if SERVER then

    self.Owner:ScreenFade(SCREENFADE.IN, Color(0,255,0, 100), 0.5, 0)
    self.Owner:BrTip(0, "[VAULT]", Color(255,0,0,220), "l:you_feel_healthy", color_white )
    self.Owner.TempValues.Used500 = true
    self.Owner.Infected409 = false
    timer.Remove("SCP409Phase1_"..self.Owner:SteamID64())
    timer.Remove("SCP409Phase2_"..self.Owner:SteamID64())
    timer.Remove("SCP409Phase3_"..self.Owner:SteamID64())
    timer.Remove("SCP1025COLD"..self.Owner:SteamID64())
    if self.Owner.TempValues.diseaseremember then
      for i, v in pairs(self.Owner.TempValues.diseaseremember) do
        if i == "jumppower" then
          self.Owner:SetJumpPower(v)
        elseif i == "staminascale" then
          self.Owner:SetStaminaScale(v)
        end
      end
    end
    if self.Owner:Health() < self.Owner:GetMaxHealth() then
      self.Owner:AnimatedHeal( self.Owner:GetMaxHealth() - self.Owner:Health() )
    end

    self:Remove()

  end

end

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire(CurTime() + 1)
  self:SetNextSecondaryFire(CurTime() + 1)

  self:Eat()

end
