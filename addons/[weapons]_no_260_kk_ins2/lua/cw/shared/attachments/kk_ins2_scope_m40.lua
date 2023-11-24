--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_scope_m40.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_scope_m40"
att.displayNameShort = "M40"
att.displayName = "M40 Scope"
att.aimPos = {"KKINS2ScopeM40Pos", "KKINS2ScopeM40Ang"}
att.FOVModifier = 0
att.AimViewModelFOV = 25
att.isSight = true

-- att.colorType = CustomizableWeaponry.colorableParts.COLOR_TYPE_SIGHT

att.statModifiers = {
	// OverallMouseSensMult = -0.1
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Provides 8x magnification.", c = CustomizableWeaponry.textColors.POSITIVE},
		[2] = {t = "Narrow scope reduces awareness.", c = CustomizableWeaponry.textColors.NEGATIVE},
		[3] = {t = "Can be very disorienting at close range.", c = CustomizableWeaponry.textColors.NEGATIVE}
	}

	-- local path = ""
	local path = "models/weapons/optics/mk4_crosshair"

	att.zoomTextures = {
		{tex = surface.GetTextureID(path), offset = {0, 1}},
	}

	att._rtFov = 6
	att._rtReticle = surface.GetTextureID(path)
	att._reticleMat = Material(path)

	att.zoomDesired = 8

	function att:drawRenderTarget()
		local scopeEnt = self.AttachmentModelsVM[att.name].ent
		if self:isAiming() then
			scopeEnt:SetSequence(1)
		else
			scopeEnt:SetSequence(2)
		end

		CustomizableWeaponry_KK.ins2.rtSight:renderTarget(self, att)
	end

	function att:elementRender()
		CustomizableWeaponry_KK.ins2.rtSight:stencil(self, att)
	end
end

function att:attachFunc()
	self.OverrideAimMouseSens = 0.1
	self.SimpleTelescopicsFOV = 70
	self.AimViewModelFOV = 50
	self.BlurOnAim = true
	self.ZoomTextures = att.zoomTextures
end

function att:detachFunc()
	self.OverrideAimMouseSens = nil
	self.SimpleTelescopicsFOV = nil
	self.AimViewModelFOV = self.AimViewModelFOV_Orig
	self.BlurOnAim = false
end

CustomizableWeaponry:registerAttachment(att)
