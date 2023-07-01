--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/ritual_paper.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
SWEP.AdminOnly = false -- (Boolean) Admin only spawnable

SWEP.PrintName = "Ритуал" -- (String) Printed name on menu

SWEP.ViewModelFOV = 90 -- (Integer) First-person field of view

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/cult_paper.png" )

end

SWEP.UnDroppable = true
SWEP.UseHands = false

SWEP.ViewModel = Model( "models/jessev92/weapons/unarmed_c.mdl" )
SWEP.WorldModel = ""
SWEP.HoldType = "normal"

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:CanPrimaryAttack()

	return true

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanSecondaryAttack( )

	return false

end

function SWEP:Reload() end

function SWEP:Deploy( )

end

function SWEP:OnDrop( )

end
