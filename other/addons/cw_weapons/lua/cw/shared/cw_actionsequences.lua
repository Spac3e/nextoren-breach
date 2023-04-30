--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/cw_actionsequences.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

-- GMod's stock timers are clunky as all fuck, so I just made my own timer system
-- with less pointless shit and more straight to the point functionality
-- the :process function is called within the SWEP's Think function
-- this is not intended to be used as a replacement for the timer system in garry's mod, but rather to time specific actions that bring a global delay (to all actions) on the weapon
-- the action sequences are unique to each weapon, meaning that the moment the player dies/loses the weapon object, all active action sequences will not be processed
-- this is very useful to not do consistency checks
-- these are designed to be used when the holstering is temporarily disabled (holstering/throwing grenades, etc.)
-- this class is a critical part of CW 2.0, don't remove it

CustomizableWeaponry.actionSequence = {}

function CustomizableWeaponry.actionSequence:new(time, actionDelay, func)
	-- don't insert nil
	if not func or not time then
		return
	end
	
	local CT = UnPredictedCurTime()
	
	table.insert(self._activeSequences, {time = CT + time, func = func})
	
	if actionDelay then
		self:setGlobalDelay(actionDelay)
	end
end

function CustomizableWeaponry.actionSequence:process()
	local CT = UnPredictedCurTime()
	
	for k, v in pairs(self._activeSequences) do
		if CT >= v.time then
			v.func()
			self._activeSequences[k] = nil
		end
	end
	
	table.Sanitise(self._activeSequences)
end