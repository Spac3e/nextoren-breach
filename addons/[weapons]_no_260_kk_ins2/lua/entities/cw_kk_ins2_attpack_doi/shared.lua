--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_attpack_doi/shared.lua
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
ENT.PrintName = "[INS2] DOI Pack"
ENT.PackageText = "World War 2"
ENT.Category = "CW 2.0 Attachments"
ENT.Author = "Spy"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.attachments = {
	"kk_ins2_scope_u8x",
	"kk_ins2_scope_m82",
	"kk_ins2_scope_zf4",
	"kk_ins2_scope_k98",
	"kk_ins2_scope_m73",
	"kk_ins2_scope_enfield",
	"kk_ins2_gl_m7",
	"kk_ins2_gl_ggg",
	"kk_ins2_gl_enfield",
	"kk_ins2_ww2_nade_jackit",
	"kk_ins2_ww2_stripper",
	"kk_ins2_mag_c96_40",
	"kk_ins2_c96_barrel_lng",
	"kk_ins2_ww2_sling",
	"kk_ins2_ww2_knife_fat",
	"kk_ins2_ww2_knife",
}
