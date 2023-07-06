--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_heavy_hat.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base = "armor_helmet_base"
ENT.PrintName 			= "Heavy Helmet"
ENT.Type 						=	"anim"
ENT.ArmorType = "Hat"
ENT.MaxHitsHelmet = 2
ENT.InvIcon = Material( "nextoren/gui/icons/heavy_helmet.png" )
ENT.Model = Model( "models/cultist/humans/mog/head_gear/mog_helmet.mdl" )
ENT.ArmorModel 			= "models/cultist/humans/mog/head_gear/mog_helmet.mdl"