--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_cstm_scar_skin.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_cstm_scar_skin"
att.displayName = "Tan $CAR-H Finish"
att.displayNameShort = "Tan"
att.isBG = true
att.KK_INS2_playIdle = true

att.statModifiers = {
	RecoilMult = -0.2
}

att.activeVM = "models/weapons/v_cw_kk_ins2_cstm_scar_tan.mdl"
att.activeWM = "models/weapons/w_cw_kk_ins2_cstm_scar_tan.mdl"
att.origVM = "models/weapons/v_cw_kk_ins2_cstm_scar.mdl"
att.origWM = "models/weapons/w_cw_kk_ins2_cstm_scar.mdl"

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Ever played Payday 2?.", c = CustomizableWeaponry.textColors.NEUTRAL},
		[2] = {t = "Retextures alter stats.", c = CustomizableWeaponry.textColors.VNEGATIVE},
	}

	att.SelectIconOverride = surface.GetTextureID("vgui/inventory/cw_kk_ins2_cstm_scar_skin")
end

function att:attachFunc()
	-- self.ViewModel = att.activeVM
	self.WorldModel = att.activeWM

	-- if CLIENT then
		-- self.CW_VM:SetModel(self.ViewModel)
	-- end
end

function att:detachFunc()
	-- self.ViewModel = att.origVM
	self.WorldModel = att.origWM

	-- if CLIENT then
		-- self.CW_VM:SetModel(self.ViewModel)
	-- end
end

CustomizableWeaponry:registerAttachment(att)
