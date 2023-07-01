--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/fpsbooster/lang/english.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

return {
	Name = "English",
	Flag = "flags16/gb.png",
	Phrases = function() return {

		module_name = "FPS Booster",

		--####################### UI PHRASES #######################--

		fps_booster          = "FPS Booster",
		never_show_again     = "Never Show Again",
		never_show_again_tip = "You'll lose the benefits of this menu! Type \"gmodadminsuite fpsbooster\" in your console to open this menu in future.",

		--####################### SETTING PHRASES #######################--

		show_fps                 = "Show FPS",
		multicore_rendering      = "Enable Multicore Rendering",
		multicore_rendering_help = "This is an experimental feature of GMod which boosts FPS by rendering frames using more than a single CPU core.",
		hardware_acceleration    = "Enable Hardware Acceleration",
		shadows                  = "Disable Shadows",
		disable_skybox           = "Disable Skybox",
		sprays                   = "Disable Player Sprays",
		gibs                     = "Disable Gibs",
		gibs_help                = "\"Gibs\" are particles and objects that can fly off of corpses and ragdolls.",

} end }