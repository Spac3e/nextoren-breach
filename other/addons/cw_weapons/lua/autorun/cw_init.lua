--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/autorun/cw_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

-- convenience function which calls AddCSLuaFile and include on the specified file
function loadFile(path)
	AddCSLuaFile(path)
	include(path)
end

-- load client files
AddCSLuaFile("autorun/client/cw_cl_init.lua")
AddCSLuaFile("cw/client/cw_clientmenu.lua")
AddCSLuaFile("cw/client/cw_hud.lua")
AddCSLuaFile("cw/client/cw_umsgs.lua")
AddCSLuaFile("cw/client/cw_hooks.lua")
AddCSLuaFile("cw/client/cw_statdisplay.lua")

-- main table
CustomizableWeaponry = {}
CustomizableWeaponry.baseFolder = "cw2_0"

-- load all necessary files
-- do not change the load order
include("cw/shared/cw_callbacks.lua")
include("cw/shared/cw_originalvaluesaving.lua")
include("cw/shared/cw_sounds.lua")
include("cw/shared/cw_shells.lua")
include("cw/shared/cw_particles.lua")
include("cw/shared/cw_colorableparts.lua")
include("cw/shared/cw_grenadetypes.lua")
include("cw/shared/cw_attachments.lua")
include("cw/shared/cw_ammo.lua")
include("cw/shared/cw_quickgrenade.lua")
include("cw/shared/cw_actionsequences.lua")
include("cw/shared/cw_preset.lua")
include("cw/shared/cw_attachmentpossession.lua")
include("cw/shared/cw_interactionmenuhandler.lua")
include("cw/shared/cw_cmodel_management.lua")
include("cw/shared/cw_sight_position_adjustment.lua")
include("cw/shared/cw_firemodes.lua")
include("cw/shared/cw_physical_bullets.lua")

if SERVER then
	-- load server files
	include("cw/server/cw_hooks.lua")
	include("cw/server/cw_concommands.lua")
	include("cw/server/cw_weapondrop.lua")
end

-- create base folder to store various CW 2.0 related stuff in
-- OH LOOK AT THAT, I AM GOING TO STORE ATTACHMENT PRESETS IN THE 'DATA' FOLDER
-- ACCORDING TO MAGENTA, DELETING THE 'DATA' FOLDER ON COMPUTERS OF SOME PEOPLE IS NOT A BIG DEAL, SINCE, YOU KNOW, THERE IS NOTHING IMPORTANT IN THERE
-- fuck off cunt
file.CreateDir("cw2_0")