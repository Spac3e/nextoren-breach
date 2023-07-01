--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/breach_keycard_2.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/card_2.png" )

end

SWEP.Base = "breach_keycard_base"

SWEP.PrintName = "Ключ-Карта 2-го уровня"
SWEP.Skin = 1

SWEP.KeyCategory = "CLevel"
SWEP.CLevels = {

  CLevel = 2,
  CLevelSCI = 1,
  CLevelGuard = 1,
  CLevelMTF = 1,
  CLevelSUP = 1

}
