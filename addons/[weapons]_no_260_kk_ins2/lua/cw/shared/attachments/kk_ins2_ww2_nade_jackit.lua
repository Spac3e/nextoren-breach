--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_ww2_nade_jackit.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_ww2_nade_jackit"
att.displayNameShort = "Jacket"
att.displayName = "Frag Jacket"

att.statModifiers = {
	-- VelocitySensitivityMult = -0.3,
	-- // OverallMouseSensMult = -0.15,
	-- RecoilMult = -0.2,
}

att.activeVM = "models/weapons/v_splintering_stielhandgranate.mdl"
att.activeWM = "models/weapons/w_splintering_stielhandgranate.mdl"
att.origVM = "models/weapons/v_stielhandgranate.mdl"
att.origWM = "models/weapons/w_stielhandgranate.mdl"

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Causes grenade to create more shrapnels upon detonation.", c = CustomizableWeaponry.textColors.VPOSITIVE},
		[2] = {t = "LOL, no, it does not. Not yet. Enjoy model changes for now.", c = CustomizableWeaponry.textColors.VNEGATIVE}
	}

	att.SelectIconOverride = surface.GetTextureID("vgui/inventory/weapon_splintering")
end

function att:attachFunc()
	self.WorldModel = att.activeWM
end

function att:detachFunc()
	self.WorldModel = att.origWM
end

CustomizableWeaponry:registerAttachment(att)
