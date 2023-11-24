--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_m45/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_m45/shared.lua
--]]
if not CustomizableWeaponry then return end



AddCSLuaFile()

AddCSLuaFile("sh_sounds.lua")

AddCSLuaFile("sh_soundscript.lua")

include("sh_sounds.lua")

include("sh_soundscript.lua")



SWEP.magType = "pistolMag"



if CLIENT then

	SWEP.DrawCrosshair = false

	SWEP.PrintName = "M45"

	SWEP.CSMuzzleFlashes = true



	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/m45")



	SWEP.Shell = "KK_INS2_45apc"

	SWEP.ShellDelay = 0.06



	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = 180}



	SWEP.AttachmentModelsVM = {

		["kk_ins2_mag_m45_8"] = {model = "models/weapons/upgrades/a_magazine_m45_8.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_mag_m45_15"] = {model = "models/weapons/upgrades/a_magazine_m45_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_suppressor_pistol"] = {model = "models/weapons/upgrades/a_suppressor_pistol.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/a_laser_mak.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/a_flashlight_mak.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_m6x"] = {model = "models/weapons/attachments/v_cw_kk_ins2_cstm_m6x.mdl", bone = "Weapon", pos = Vector(0.004, 1.105, -1.175), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8)},



		["kk_ins2_m6x_rail"] = {model = "models/cw2/attachments/lowerpistolrail.mdl", bone = "Weapon", pos = Vector(0.006, 0.765, -0.561), angle = Angle(0, 90, 0), size = Vector(0.105, 0.105, 0.105),

			material = "models/weapons/attachments/cw_kk_ins2_cstm_m6x/rail_gy",

		},



		["kk_counter"] = {model = "models/weapons/stattrack_cut.mdl", bone = "Slide", pos = Vector(0.451, 0, 0.028), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8), adjustment = {axis = "y", min = 0, max = 1.6, inverse = false, inverseOffsetCalc = false}},

	}



	SWEP.AttachmentModelsWM = {

		["kk_ins2_suppressor_pistol"] = {model = "models/weapons/upgrades/w_sil_pistol.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_mag_m45_8"] = {model = "models/weapons/upgrades/w_magazine_m45_8.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, active = true},

		["kk_ins2_mag_m45_15"] = {model = "models/weapons/upgrades/w_magazine_m45_15.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},



		["kk_ins2_lam"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), merge = true},

		["kk_ins2_flashlight"] = {model = "models/weapons/upgrades/w_laser_sec.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true},

	}



	SWEP.IronsightPos = Vector(-1.859, 0, 0.3468)

	SWEP.IronsightAng = Vector(0.3062, -0.0054, 0)



	SWEP.CustomizationMenuScale = 0.01

	SWEP.ReloadViewBobEnabled = false

	SWEP.DisableSprintViewSimulation = true

end



SWEP.MuzzleEffect = "muzzleflash_m9_1p_core"

SWEP.MuzzleEffectWorld = "muzzleflash_m9_3rd"



SWEP.Attachments = {

	{header = "Lasers", offset = {500, -400}, atts = {"kk_ins2_lam", "kk_ins2_flashlight", "kk_ins2_m6x"}},

	{header = "Barrel", offset = {-500, -400}, atts = {"kk_ins2_suppressor_pistol"}},

	{header = "Magazine", offset = {-500, 150}, atts = {"kk_ins2_mag_m45_15"}},

	--["+reload"] = {header = "Ammo", offset = {500, 150}, atts = {"am_magnum", "am_matchgrade"}}

}



if CustomizableWeaponry_KK.HOME then

	table.insert(SWEP.Attachments, {header = "CSGO", offset = {1500, -400}, atts = {"kk_counter"}})

end



SWEP.Animations = {

	base_pickup = "base_ready",

	base_draw = "base_draw",

	base_draw_empty = "empty_draw",

	base_fire = {"base_fire","base_fire2","base_fire3"},

	base_fire_aim = {"iron_fire_1","iron_fire_2","iron_fire_3"},

	base_fire_last = "base_firelast",

	base_fire_last_aim = "iron_firelast",

	base_fire_empty = "base_dryfire",

	base_fire_empty_aim = "iron_dryfire",

	base_reload = "base_reload",

	base_reload_mm = "base_reload_extmag",

	base_reload_empty = "base_reloadempty",

	base_reload_empty_mm = "base_reloadempty_extmag",

	base_idle = "base_idle",

	base_idle_empty = "empty_idle",

	base_holster = "base_holster",

	base_holster_empty = "empty_holster",

	base_sprint = "base_sprint",

	base_sprint_empty = "empty_sprint",

	base_safe = "base_down",

	base_safe_empty = "empty_down",

	base_safe_aim = "iron_down",

	base_safe_empty_aim = "empty_iron_down",

	base_crawl = "base_crawl",

	base_crawl_empty = "empty_crawl",

}



SWEP.SpeedDec = 10



SWEP.Slot = 1

SWEP.SlotPos = 0

SWEP.NormalHoldType = "revolver"

SWEP.RunHoldType = "normal"

SWEP.FireModes = {"semi"}

SWEP.Base = "cw_kk_ins2_base"

SWEP.Category = "CW 2.0 KK INS2"



SWEP.Author			= "Spy"

SWEP.Contact		= ""

SWEP.Purpose		= ""

SWEP.Instructions	= ""



SWEP.ViewModelFOV	= 80

SWEP.ViewModelFlip	= false

SWEP.ViewModel		= "models/weapons/v_m45.mdl"

SWEP.WorldModel		= "models/weapons/w_m45.mdl"



SWEP.WMPos = Vector(5.309, 1.623, -1.616)

SWEP.WMAng = Vector(-3, -5, 180)



SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)



SWEP.Primary.ClipSize		= 7

SWEP.Primary.DefaultClip = 0 --	= 0

SWEP.Primary.Automatic		= false

SWEP.Primary.Ammo			= "Pistol"


SWEP.FireDelay = 0.22


SWEP.FireSound = "CW_KK_INS2_M45_FIRE"

SWEP.FireSoundSuppressed = "CW_KK_INS2_M45_FIRE_SUPPRESSED"

SWEP.Recoil = 2.50

SWEP.HipSpread = 0.034

SWEP.AimSpread = 0.012

SWEP.VelocitySensitivity = 1.2

SWEP.MaxSpreadInc = 0.04

SWEP.SpreadPerShot = 0.01

SWEP.SpreadCooldown = 0.22

SWEP.Shots = 1

SWEP.Damage = 45



SWEP.FirstDeployTime = 1.3

SWEP.DeployTime = 0.4

SWEP.HolsterTime = 0.4



SWEP.CanRestOnObjects = false

SWEP.WeaponLength = 16



SWEP.KK_INS2_EmptyIdle = true



SWEP.MuzzleVelocity = 244



SWEP.ReloadTimes = {

	base_reload = {2, 2.6},

	base_reloadempty = {2, 2.8},

	base_reload_extmag = {2, 2.6},

	base_reloadempty_extmag = {2, 2.8},

}



if CLIENT then

	function SWEP:updateStandardParts()

		self:setElementActive("kk_ins2_mag_m45_8", !self.ActiveAttachments.kk_ins2_mag_m45_15)

	end

end



