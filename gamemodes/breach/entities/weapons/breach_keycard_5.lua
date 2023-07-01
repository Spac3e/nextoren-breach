--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/breach_keycard_5.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/card_5.png" )

end

SWEP.Base = "breach_keycard_base"

SWEP.PrintName = "Ключ-Карта 5-го уровня"
SWEP.Skin = 4

SWEP.KeyCategory = "CLevel"
SWEP.CLevels = {

  CLevel = 5,
  CLevelSCI = 4,
  CLevelGuard = 4,
  CLevelMTF = 4,
  CLevelSUP = 4

}
