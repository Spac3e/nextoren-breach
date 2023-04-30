--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_attpack_misc/shared.lua
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
ENT.PrintName = "[INS2] Various Atts"
ENT.PackageText = "Barrel and under"
ENT.Category = "CW 2.0 Attachments"
ENT.Author = "Spy"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.attachments = {
	"kk_ins2_gp25_ammo",
	"kk_ins2_gl_gp25",
	"kk_ins2_gl_m203",
	"kk_ins2_vertgrip",
	"kk_ins2_bipod",
	"kk_ins2_hoovy",
}
