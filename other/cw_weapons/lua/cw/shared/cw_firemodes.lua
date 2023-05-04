--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/cw_firemodes.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

CustomizableWeaponry.firemodes = {}
CustomizableWeaponry.firemodes.registered = {}
CustomizableWeaponry.firemodes.registeredByID = {}

-- id - the ID of the firemode
-- display - the text to display when the firemode is active
-- automatic - whether it is a full-auto firemode
-- burstAmount - amount of rounds to fire, pass 0 to make it not have a burst system
-- bulletDisplay - amount of rounds to display on the HUD
function CustomizableWeaponry.firemodes:registerFiremode(id, display, automatic, burstAmount, bulletDisplay)
	local fireModeData = {id = id, display = display, auto = automatic, burstamt = burstAmount, buldis = bulletDisplay}
	
	table.insert(self.registered, fireModeData)
	self.registeredByID[id] = fireModeData
end

CustomizableWeaponry.firemodes:registerFiremode("auto", "FULL-AUTO", true, 0, 5)
CustomizableWeaponry.firemodes:registerFiremode("semi", "SEMI-AUTO", false, 0, 1)
CustomizableWeaponry.firemodes:registerFiremode("double", "DOUBLE-ACTION", false, 0, 1)
CustomizableWeaponry.firemodes:registerFiremode("bolt", "BOLT-ACTION", false, 0, 1)
CustomizableWeaponry.firemodes:registerFiremode("pump", "PUMP-ACTION", false, 0, 1)
CustomizableWeaponry.firemodes:registerFiremode("break", "BREAK-ACTION", false, 0, 1)
CustomizableWeaponry.firemodes:registerFiremode("2burst", "2-ROUND BURST", true, 2, 2)
CustomizableWeaponry.firemodes:registerFiremode("3burst", "3-ROUND BURST", true, 3, 3)
CustomizableWeaponry.firemodes:registerFiremode("safe", "SAFE", false, 0, 0)