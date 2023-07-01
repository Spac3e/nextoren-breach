--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/attachments/bg_magpulhandguard.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "bg_magpulhandguard"
att.displayName = "Magpul handguard"
att.displayNameShort = "Magpul"
att.isBG = true

att.statModifiers = {RecoilMult = 0.05,
	OverallMouseSensMult = 0.1,
	DrawSpeedMult = 0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/ar15magpul")
	att.description = {[1] = {t = "A comfortable, lightweight handguard.", c = CustomizableWeaponry.textColors.REGULAR}}
end

function att:attachFunc()
	self:setBodygroup(self.BarrelBGs.main, self.BarrelBGs.magpul)
end

function att:detachFunc()
	self:setBodygroup(self.BarrelBGs.main, self.BarrelBGs.regular)
end

CustomizableWeaponry:registerAttachment(att)