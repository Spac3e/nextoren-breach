--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_gl_m7.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_gl_m7"
att.displayNameShort = "GL"
att.displayName = "M7 Grenade Launcher"
att.isGrenadeLauncher = true
att.ww2GrenadeLauncher = true
att.KK_INS2_playIdle = true

att.statModifiers = {
	DrawSpeedMult = -0.2,
	HolsterSpeedMult = -0.2,
	// OverallMouseSensMult = -0.2,
	RecoilMult = -0.1
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Allows the user to fire 40MM rounds.", c = CustomizableWeaponry.textColors.POSITIVE},
	}

	local nadeTypes = CustomizableWeaponry.grenadeTypes.registered

	-- function att:elementRender()
	-- end
end

local function resetGL(self)
	-- if CLIENT then
		-- self.CW_VM:SetModel(self.ViewModel)
		-- self._vmCamAttach = self.CW_VM:LookupAttachment("camera")
		-- self:buildBoneTable()
	-- end

	if self.M203Chamber then
		if SERVER then
			self.Owner:GiveAmmo(1, "40MM", true)
		end
		self.M203Chamber = false
	end

	self.dt.INS2GLActive = false
end

function att:attachFunc()
	-- if CLIENT then
		-- self.ViewModel = "models/weapons/v_cw_kk_doi_enfield.mdl"
	-- end

	resetGL(self)
end

function att:detachFunc()
	-- if CLIENT then
		-- self.ViewModel = "models/weapons/v_springfield.mdl"
	-- end

	resetGL(self)
end

CustomizableWeaponry:registerAttachment(att)
