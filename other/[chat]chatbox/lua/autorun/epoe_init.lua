--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   addons/[chat]_sh_lounge_chatbox/lua/autorun/epoe_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if epoe then -- Implements reloading it all
	-- Prevent hooks from calling


	if SERVER then
		pcall(function() --  in case it's something very weird
			epoe.InEPOE=true -- Disables EPOE functionality
			epoe.DisableTick()
		end)
		epoe=nil
		package.loaded.epoe=nil

	else -- TODO

		pcall(function()
			epoe.InEPOE=true
			e.GUI:Remove()
		end)
	end

end

include('epoe/shared.lua')


if SERVER then

	AddCSLuaFile("autorun/epoe_init.lua")

	AddCSLuaFile("epoe/client.lua")
	AddCSLuaFile("epoe/client_ui.lua")
	AddCSLuaFile("epoe/client_gui.lua")
	AddCSLuaFile("epoe/client_filter.lua")
	AddCSLuaFile("epoe/shared.lua")
	AddCSLuaFile("epoe/autoplace.lua")

	include('epoe/server.lua')

else
	include('epoe/client.lua')
	include('epoe/client_ui.lua')
	include("epoe/client_gui.lua")
	include('epoe/autoplace.lua')
	include("epoe/client_filter.lua")
end
