--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_mtf.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "Костюм МОГ"
ENT.InvIcon = Material( "nextoren/gui/icons/guard_uniform.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 0
ENT.BodygroupModel = 0
ENT.HideBoneMerge = true

ENT.ArmorType = "Clothes"
ENT.ArmorSkin = 0
ENT.ArmorModel 			= "models/cultist/humans/mog/mog.mdl"
ENT.Bodygroups = {

  [0] = "1", -- шлем
  [1] = "1", -- разгрузка
  [7] = "1"  -- маска

}
ENT.Bonemerge = {

  "models/cultist/humans/mog/head_gear/mog_helmet.mdl",
  "models/cultist/humans/balaclavas_new/balaclava_full.mdl"

}

ENT.MultipliersType = {

	[ DMG_BULLET ] = .6,
	[ DMG_BLAST ] = .95,
	[ 268435464 ] = .95,
	[ DMG_SHOCK ] = .95,
	[ DMG_ACID ] = .95

}
