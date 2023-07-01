--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_hazmat_orange.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_hazmat_orange"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_3.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 5
ENT.BodygroupModel = 1

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_2.mdl"
ENT.ArmorSkin = 0
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

	[ DMG_BULLET ] = .9,
	[ DMG_BLAST ] = .4,
	[ DMG_PLASMA ] = .8,
	[ DMG_SHOCK ] = .95,
	[ DMG_ACID ] = .95,
	[ DMG_POISON ] = .8

}
