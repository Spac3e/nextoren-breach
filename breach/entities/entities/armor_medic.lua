--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_medic.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "Костюм Врача"
ENT.InvIcon = Material( "nextoren/gui/icons/medic_uniform.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 0
ENT.BodygroupModel = 3

ENT.ArmorType = "Clothes"

ENT.MultiGender = true
ENT.ArmorModel 			= "models/cultist/humans/sci/scientist.mdl"
ENT.ArmorModelFem 			= "models/cultist/humans/sci/scientist_female.mdl"

ENT.HideBonemergeEnt = "models/cultist/humans/class_d/head_gear/hacker_hat.mdl"

ENT.Team = TEAM_CLASSD

ENT.Bodygroups = {

  [0] = "1", -- тело
  [1] = "0",
  [2] = "1", -- рубашка
  [3] = "1",  -- штаны
  [4] = "1",  -- шапка
  [5] = "0",
  [6] = "0"

}
ENT.MultipliersType = {}
