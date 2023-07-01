--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/cw_originalvaluesaving.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

-- This is a small module-thing that assigns a specified value a value with _Orig at the end of it
-- and can also, optionally, assign the value with a 'Mult' ending that's always 1, which can be used for attachments that modify a weapon's stats

CustomizableWeaponry.originalValue = {}
CustomizableWeaponry.originalValue.registered = {}

function CustomizableWeaponry.originalValue:add(varName, makeMultiplier, clientOnly)
	if clientOnly and SERVER then
		return
	end
	
	self.registered[varName] = makeMultiplier
end

local orig = "_Orig"
local mult = "Mult"

function CustomizableWeaponry.originalValue:assign()
	for varName, makeMult in pairs(CustomizableWeaponry.originalValue.registered) do
		self[varName .. orig] = self[varName]
		
		if makeMult then
			self[varName .. mult] = 1
		end
	end
end

CustomizableWeaponry.originalValue:add("HipSpread", true)
CustomizableWeaponry.originalValue:add("AimSpread", true)
CustomizableWeaponry.originalValue:add("FireDelay", true)
CustomizableWeaponry.originalValue:add("Damage", true)
CustomizableWeaponry.originalValue:add("VelocitySensitivity", true)
CustomizableWeaponry.originalValue:add("Recoil", true)
CustomizableWeaponry.originalValue:add("ReloadSpeed", true)
CustomizableWeaponry.originalValue:add("MaxSpreadInc", true)
CustomizableWeaponry.originalValue:add("OverallMouseSens", true, true)
CustomizableWeaponry.originalValue:add("DrawSpeed", true)
CustomizableWeaponry.originalValue:add("SpreadPerShot", true)
CustomizableWeaponry.originalValue:add("Shots", false)
CustomizableWeaponry.originalValue:add("ClumpSpread", false)
CustomizableWeaponry.originalValue:add("DeployTime", false)
CustomizableWeaponry.originalValue:add("ReloadHalt", false)
CustomizableWeaponry.originalValue:add("ReloadHalt_Empty", false)