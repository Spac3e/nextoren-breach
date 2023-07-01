--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/breach_keycard_sci_4.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/card_sci_4.png" )

end

SWEP.Base = "breach_keycard_base"

SWEP.PrintName = "Ключ-Карта 4-го уровня ( Научный отдел )"
SWEP.Skin = 10

SWEP.KeyCategory = "CLevelSCI"
SWEP.CLevels = {

  CLevel = 3,
  CLevelSCI = 4,
  CLevelGuard = 0,
  CLevelMTF = 0,
  CLevelSUP = 0

}
