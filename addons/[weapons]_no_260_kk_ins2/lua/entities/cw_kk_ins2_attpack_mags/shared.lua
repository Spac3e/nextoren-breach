--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_attpack_mags/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "cw_attpack_base"
ENT.PrintName = "[INS2] Magazines"
ENT.PackageText = "Extended Magazines"
ENT.Category = "CW 2.0 Attachments"
ENT.Author = "Spy"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.attachments = {
	"kk_ins2_revolver_mag",
	"kk_ins2_mag_galil_75",
	"kk_ins2_mag_thom_50",
	"kk_ins2_mag_thom_30",
	"kk_ins2_mag_fal_30",
	"kk_ins2_mag_m1a1_30",
	"kk_ins2_mag_makarov_15",
	"kk_ins2_mag_m1911_15",
	"kk_ins2_mag_m45_15",
}
