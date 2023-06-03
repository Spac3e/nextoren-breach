--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
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

  return false

end

function SWEP:Eat()

  self.Owner:ChatPrint( "Вы чувствуете себя полностью здоровым" )
  self.Owner.InfectedName = "SCP-500"
  self.Owner:SetHealth( self.Owner:GetMaxHealth() )

  self.Amount = self.Amount - 1

  self:Remove()

end

function SWEP:PrimaryAttack()

  self:Eat()

end
