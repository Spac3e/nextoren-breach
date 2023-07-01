--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/menutabs/sight_adjustment.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
local tab = {}
tab.name = "TAB_ATTACHMENT_ADJUSTMENT"
tab.id = 4
tab.text = "ATTACHMENT ADJUSTMENT"
tab.switchToKey = "gm_showspare2"

tab.selectedAttachment = nil

if CLIENT then
	function tab:processKey(key, isPressed)
		if not isPressed then
			return nil
		end
		
		if not CustomizableWeaponry.sightAdjustment:getCurrentAttachment() then -- attempt to select a category of sights to adjust in case we haven't selected one yet
			local category = nil
			
			if key:find("slot") then -- if it starts with 'slot', that means we're pressing 1-9 keys, therefore strip it of the 'slot' part and turn it into a number
				category = tonumber(string.Right(key, 1))
			else -- otherwise just use the key as the category
				category = key
			end
			
			-- attempt to find an attachment category with this name
			return CustomizableWeaponry.sightAdjustment:attemptSetAttachment(self, category)
		else
			if key == "+reload" then
				CustomizableWeaponry.sightAdjustment:setDefaultOffset(self)
				return true
			elseif key == "+attack2" then -- deselect category
				CustomizableWeaponry.sightAdjustment:setCurrentAttachment(nil, nil)
				return true
			end
		end
	end
	
	function tab:callback() -- when we open the tab, we deselect the current category
		CustomizableWeaponry.sightAdjustment:setCurrentAttachment(nil, nil)
	end
	
	function tab:drawFunc()
		CustomizableWeaponry.sightAdjustment:draw(self)
	end
end

CustomizableWeaponry.interactionMenu:addTab(tab)
--]]