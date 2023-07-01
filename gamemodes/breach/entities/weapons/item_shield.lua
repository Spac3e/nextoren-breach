--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/item_shield.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/shield.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel = "models/weapons/shield/w_shield.mdl"
SWEP.PrintName = "Баллистический щит"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "shield"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands = true

SWEP.Pos = Vector( 0, -2, 4 )
SWEP.Ang = Angle( 60, -180, 240 )

function SWEP:Deploy()

  self.Owner:DrawViewModel( false )

  if SERVER then
	  local shield = ents.Create("entity_item_shield")
	  self.Shield = shield
	  shield:SetOwner(self.Owner)
	  shield.ActiveWeapon = self
	  shield:Spawn()
	end

end

function SWEP:PrimaryAttack()

end

function SWEP:DrawWorldModel()

	if !IsValid(self.Owner) then
		self:DrawModel()
	end

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:Think() end
