--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[chat]_sh_lounge_chatbox/lua/autorun/autorun_lounge_chatbox.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

LOUNGE_CHAT = {}

include("chatbox_config.lua")
include("chatbox/sh_obj_player_extend.lua")
	
if (SERVER) then
	AddCSLuaFile("autorun_lounge_chatbox.lua")
	AddCSLuaFile("chatbox_config.lua")
	AddCSLuaFile("chatbox_emoticons.lua")
	AddCSLuaFile("chatbox_markups.lua")
	AddCSLuaFile("chatbox_tags.lua")
	AddCSLuaFile("chatbox/cl_util.lua")
	AddCSLuaFile("chatbox/cl_markups.lua")
	AddCSLuaFile("chatbox/cl_chatbox.lua")
	AddCSLuaFile("chatbox/cl_colors.lua")
	AddCSLuaFile("chatbox/cl_options.lua")
	AddCSLuaFile("chatbox/sh_obj_player_extend.lua")

	include("chatbox/sv_chatbox.lua")
else
	include("chatbox/cl_util.lua")
	include("chatbox/cl_markups.lua")
	include("chatbox/cl_chatbox.lua")
	include("chatbox/cl_colors.lua")
	include("chatbox/cl_options.lua")

	include("chatbox_emoticons.lua")
	include("chatbox_markups.lua")
	include("chatbox_tags.lua")
end