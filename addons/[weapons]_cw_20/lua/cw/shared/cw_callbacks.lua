--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/cw_callbacks.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

CustomizableWeaponry.callbacks = {}
CustomizableWeaponry.callbacks.categories = {}

-- adds a new callback function to an EXISTING callback category
function CustomizableWeaponry.callbacks:addNew(category, callbackName, func)
	-- don't add nil callbacks to a category, silly!
	if not func then
		return
	end
	
	if not self.categories[category] then
		self.categories[category] = {}
	end
	
	local cat = self.categories[category]
	
	if cat then
		cat[callbackName] = func
		--table.insert(cat, func)
	end
end

-- processes all callback functions within a certain category
-- allows to pass on a maximum of 4 args
function CustomizableWeaponry.callbacks:processCategory(category, a1, a2, a3, a4, a5)
	local cat = CustomizableWeaponry.callbacks.categories[category]
	
	local res1, res2, res3, res4, res5 = nil, nil, nil, nil, nil
	
	if cat then
		for callbackName, func in pairs(cat) do
			local r1, r2, r3, r4, r5 = func(self, a1, a2, a3, a4, a5)
			
			res1 = res1 or r1
			res2 = res2 or r2
			res3 = res3 or r3
			res4 = res4 or r4
			res5 = res5 or r5
		end
	end
	
	return res1, res2, res3, res4, res5
end