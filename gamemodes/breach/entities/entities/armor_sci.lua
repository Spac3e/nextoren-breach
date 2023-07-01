--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_sci.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_sci"
ENT.InvIcon = Material( "nextoren/gui/icons/sci_uniform.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 1
ENT.BodygroupModel = 3

ENT.ArmorType = "Clothes"
ENT.MultiGender = true
ENT.ArmorModel 			= "models/cultist/humans/sci/scientist.mdl"
ENT.ArmorModelFem 			= "models/cultist/humans/sci/scientist_female.mdl"

ENT.Team = TEAM_CLASSD

ENT.Bodygroups = {

  [1] = "0", -- тело
  [2] = "0",
  [3] = "0",
  [4] = "0",
  [5] = "0",
  [6] = "0"

}
ENT.MultipliersType = {}
