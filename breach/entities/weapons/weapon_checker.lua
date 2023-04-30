--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_checker.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/player_check.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.PrintName		= "Действие: Проверка Класса"
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

SWEP.AlreadyChecked = {}

local Phrases = {

  [ TEAM_CLASSD ] = "Класс-Д",
  [ TEAM_GOC ] = "Класс-Д",
  [ TEAM_SCI ] = "ученый",
  [ TEAM_SPECIAL ] = "учёный",
  [ TEAM_DZ ] = "из неизвестной организации",
  [ TEAM_CHAOS ] = "из неизвестной организации",
  [ TEAM_SECURITY ] = "из Службы Безопасности",
  [ TEAM_QRT ] = "из Отряда Быстрого Реагирования",
  [ TEAM_NTF ] = "из специальной группировки",
  [ TEAM_GUARD ] = "из военного персонала"

}
function SWEP:PrimaryAttack()

  if ( CLIENT ) then return end

  local tr = self.Owner:GetEyeTrace()

  if ( !tr.Entity:IsPlayer() ) then return end

  if ( tr.Entity:GTeam() == TEAM_SCP ) then return end

	for _, v in ipairs( self.AlreadyChecked ) do

		if ( v.name == tr.Entity:GetName() ) then

			self.Owner:ConCommand( "say Я уже проверял этого человека, он "..v.phrase .. "." )

			return
		end

	end

  self.Owner:BrProgressBar( "Проверка класса...", 4, "nextoren/gui/icons/player_check.png", tr.Entity, true, function()

		local tr = self.Owner:GetEyeTrace()

		if ( !( tr.Entity && tr.Entity:IsValid() ) ) then return end
		
		if ( tr.Entity:GTeam() == TEAM_CLASSD || tr.Entity:GTeam() == TEAM_CHAOS || tr.Entity:GTeam() == TEAM_DZ ) then

			self.Owner:AddToStatistics( "Support", 2 )

		end

		self.AlreadyChecked[ #self.AlreadyChecked + 1 ] = { name = tr.Entity:GetName(), phrase = Phrases[ tr.Entity:GTeam() ] }
    self.Owner:ConCommand( "say Этот человек "..Phrases[ tr.Entity:GTeam() ] .. "." )

  end )


end

function SWEP:CanPrimaryAttack()

  return true

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:Think() end
