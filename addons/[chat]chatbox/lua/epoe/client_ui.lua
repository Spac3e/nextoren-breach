--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   addons/[chat]_sh_lounge_chatbox/lua/epoe/client_ui.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local e=epoe -- Why not just module("epoe") like elsewhere?
local TagHuman=e.TagHuman
---------------
-- Clientside Console UI
---------------
local epoe_toconsole=CreateClientConVar("epoe_toconsole", "1", true, false)
local epoe_toconsole_colors=CreateClientConVar("epoe_toconsole_colors", "1", true, false)

hook.Add(TagHuman,TagHuman..'_CLI',function(Text,flags,col)
	flags=flags or 0
	if e.HasFlag(flags,e.IS_EPOE) then
		Msg("[EPOE] ")print(Text)
		return
	end
	
	if not epoe_toconsole:GetBool() then return end
	
	if e.HasFlag(flags,e.IS_MSGC) and epoe_toconsole_colors:GetBool() and col then
		MsgC(col,Text)
		return
	end
	
	Msg(Text)

end)
