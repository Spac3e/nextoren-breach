--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/attachments/bg_bipod.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "bg_bipod"
att.displayName = "Bipod"
att.displayNameShort = "Bipod"
att.isBG = true

att.statModifiers = {OverallMouseSensMult = -0.1,
DrawSpeedMult = -0.15}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/bipod")
	att.description = {[1] = {t = "When deployed:", c = CustomizableWeaponry.textColors.REGULAR},
	[2] = {t = "Decreases recoil by 70%", c = CustomizableWeaponry.textColors.POSITIVE},
	[3] = {t = "Greatly increases hip fire accuracy", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.BipodBGs.main, self.BipodBGs.on)
	self.BipodInstalled = true
end

function att:detachFunc()
	self:setBodygroup(self.BipodBGs.main, self.BipodBGs.off)
	self.BipodInstalled = false
end

CustomizableWeaponry:registerAttachment(att)