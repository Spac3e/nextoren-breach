--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/menutabs/weaponstats.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local tab = {}
tab.name = "TAB_WEPSTATS"
tab.id = 3
tab.text = "WEAPON STATS"
tab.switchToKey = "gm_showspare2"
tab.descOfStat = 1

if CLIENT then
	tab.callback = function(self)
		tab.descOfStat = 1
	end
	
	function tab:processKey(key, press)
		if key == "+attack" then
			if tab.descOfStat >= CustomizableWeaponry.statDisplay.totalCount then
				tab.descOfStat = 1
			else
				tab.descOfStat = math.Clamp(tab.descOfStat + 1, 1, CustomizableWeaponry.statDisplay.totalCount)
			end
			return true
		elseif key == "+attack2" then
			if tab.descOfStat == 1 then
				tab.descOfStat = CustomizableWeaponry.statDisplay.totalCount
			else	
				tab.descOfStat = math.Clamp(tab.descOfStat - 1, 1, CustomizableWeaponry.statDisplay.totalCount)
			end
			
			return true
		end
		
		return nil
	end
	
	function tab:drawFunc()
		CustomizableWeaponry.statDisplay:draw(wep, tab)
	end
end

CustomizableWeaponry.interactionMenu:addTab(tab)