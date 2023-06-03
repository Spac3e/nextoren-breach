--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_cqc.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/disarm.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.PrintName		= "Действие: Обезоруживание"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.UnDroppable				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands = true

SWEP.Pos = Vector( 1, 3, -2 )
SWEP.Ang = Angle( 240, -90, 240 )

function SWEP:Deploy()

  if ( SERVER ) then

    self.Owner:DrawWorldModel( false )

  end

  self.Owner:DrawViewModel( false )

end

function SWEP:PrimaryAttack()

  if ( CLIENT ) then return end

  local tr = self.Owner:GetEyeTrace()

	local ent = tr.Entity

  if ( !ent:IsPlayer() ) then return end

  if !self.Owner:IsSuperAdmin() then
    if ( ent:GTeam() == TEAM_SCP || !( ent:GTeam() == TEAM_CLASSD && ent:GetModel() != "models/cultist/humans/mog/mog.mdl" || ent:GTeam() == TEAM_SCI && ent:GetModel() != "models/cultist/humans/mog/mog.mdl" || ent:GTeam() == TEAM_GOC && ent:GetNClass() == "ClassD_GOCSpy" && ent:GetModel() != "models/cultist/humans/mog/mog.mdl"
    || ent:GTeam() == TEAM_DZ && ent:GetNClass() == "SCI_SpyDZ" && ent:GetModel() != "models/cultist/humans/mog/mog.mdl" ) ) then return end
  end

	local wep = ent:GetActiveWeapon()

  if ( wep && wep != NULL && !wep.UnDroppable ) then

    self.Owner:BrProgressBar( "Разоружение...", 2, "nextoren/gui/icons/disarm.png", ent, true, function()

      if ( ent && ent:IsValid() ) then

        ent:DropWeapon( wep )

      end

    end )

  end

end

function SWEP:CanPrimaryAttack()

  return true

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:Think() end
