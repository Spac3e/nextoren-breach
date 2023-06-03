--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_scp_1499.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/1499.png" )

end

SWEP.ViewModel = "models/cultist/scp_items/1499/v_1499.mdl"
SWEP.WorldModel = "models/cultist/scp_items/1499/w_1499.mdl"
SWEP.Category = "NextOren"
SWEP.Spawnable = true
SWEP.PrintName = "SCP-1499"
SWEP.Slot = 3
SWEP.UseHands = true
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.HoldType = "normal"
SWEP.droppable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

function SWEP:Think()

  if ( ( self.tNextThink || 0 ) <= CurTime() && !self.Equipped ) then

    self:SendWeaponAnim( ACT_VM_IDLE )

  end

end

function SWEP:Deploy()

  self.tNextThink = CurTime() + 1.2
  self:SendWeaponAnim( ACT_VM_DEPLOY )

end

function SWEP:PrimaryAttack()

  if ( self.Equipped ) then return end

  if ( ( self.NextAttackt || 0 ) >= CurTime() ) then return end

  self.NextAttackt = CurTime() + 2
  self.Equipped = true

  self.tNextThink = CurTime() + 1.2
  self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

end

function SWEP:SecondaryAttack()

  if ( !self.Equipped ) then return end

  if ( ( self.NextAttackt || 0 ) >= CurTime() ) then return end

  self.NextAttackt = CurTime() + 2
  self.Equipped = false

  self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

end
