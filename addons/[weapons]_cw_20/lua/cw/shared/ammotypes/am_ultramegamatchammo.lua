--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/ammotypes/am_ultramegamatchammo.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "am_ultramegamatchammo"
att.displayName = "Ultra Mega Match grade rounds"
att.displayNameShort = "UMGMatch"

att.statModifiers = {AimSpreadMult = -0.99}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")
	att.description = {
		{t = "ur gay lol", c = CustomizableWeaponry.textColors.VNEGATIVE},
		{t = "i kiss you on the lips", c = CustomizableWeaponry.textColors.VPOSITIVE},
		{t = "i love you", c = CustomizableWeaponry.textColors.VPOSITIVE},
		{t = "oh god im gonna cum", c = CustomizableWeaponry.textColors.VPOSITIVE},
		{t = "hello buy Intravenous :)", c = CustomizableWeaponry.textColors.VPOSITIVE},
	}
end

function att:attachFunc()
	self:unloadWeapon()
end

function att:detachFunc()
	self:unloadWeapon()
end

CustomizableWeaponry:registerAttachment(att)