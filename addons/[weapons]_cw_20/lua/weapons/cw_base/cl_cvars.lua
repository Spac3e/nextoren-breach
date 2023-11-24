--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/weapons/cw_base/cl_cvars.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CreateClientConVar("cw_blur_reload", 0, true, true) -- reload blur
CreateClientConVar("cw_blur_customize", 0, true, true) -- customization menu blur
CreateClientConVar("cw_blur_aim_telescopic", 0, true, true)
CreateClientConVar("cw_simple_telescopics", 0, true, true) -- whether to use a scope overlay rather than RT-based scopes; used either for personal preferences or in case it's bugged for people
CreateClientConVar("cw_crosshair", 1, true, true)
CreateClientConVar("cw_customhud", 0, true, true)
CreateClientConVar("cw_customhud_ammo", 0, true, true)
CreateClientConVar("cw_laser_quality", 1, true, true)
CreateClientConVar("cw_laser_blur", 1, true, true)
CreateClientConVar("cw_alternative_vm_pos", 0, true, true)
CreateClientConVar("cw_freeaim", 0, true, true)
CreateClientConVar("cw_freeaim_autocenter", 0, true, true)
CreateClientConVar("cw_freeaim_autocenter_aim", 0, true, true)
CreateClientConVar("cw_freeaim_lazyaim", 0, true, true)

CreateClientConVar("cw_freeaim_yawlimit", 20, true, true)
CreateClientConVar("cw_freeaim_pitchlimit", 10, true, true)

CreateClientConVar("cw_freeaim_autocenter_time", 0.65, true, true)

CreateClientConVar("cw_freeaim_center_mouse_impendance", 0.7, true, true)

CreateClientConVar("cw_rt_scope_quality", 2, true, true)