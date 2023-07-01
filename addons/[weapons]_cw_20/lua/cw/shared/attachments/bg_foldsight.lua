--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/attachments/bg_foldsight.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "bg_foldsight"
att.displayName = "Folding sights"
att.displayNameShort = "Fold"
att.isBG = true
att.isSight = true
att.aimPos = {"FoldSightPos", "FoldSightAng"}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/foldsight")
	att.description = {[1] = {t = "A folding variant of regular ironsights.", c = CustomizableWeaponry.textColors.COSMETIC}}
	
	function att:attachFunc()
		self:setBodygroup(self.SightBGs.main, self.SightBGs.foldsight)
	end
end

CustomizableWeaponry:registerAttachment(att)