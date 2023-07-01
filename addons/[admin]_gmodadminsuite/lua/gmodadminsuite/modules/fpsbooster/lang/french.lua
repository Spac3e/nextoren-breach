--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/fpsbooster/lang/french.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

return {
	Name = "French",
	Flag = "flags16/fr.png",
	Phrases = function() return {

		module_name = "FPS Booster",

		--####################### UI PHRASES #######################--

		fps_booster          = "Booster de FPS",
		never_show_again     = "Ne plus afficher",
		never_show_again_tip = "Vous perdrez les avantages de ce menu ! Tapez \"gmodadminsuite fpsbooster\" dans votre console pour ouvrir ce menu dans le futur.",

		--####################### SETTING PHRASES #######################--

		show_fps                 = "Afficher FPS",
		multicore_rendering      = "Afficher le rendu Multi-Coeur",
		multicore_rendering_help = "C'est une fonctionnalité expérimentale de GMod qui permet d'augmenter les FPS en faisant un rendu des images sur plusieurs coeurs de votre processeur.",
		hardware_acceleration    = "Activer l'Accélération Matérielle",
		shadows                  = "Désactiver les Ombres",
		disable_skybox           = "Désactiver Skybox",
		sprays                   = "Désactiver les Sprays des Joueurs",
		gibs                     = "Désactiver Gibs",
		gibs_help                = "\"Gibs\" Sont des particules qui volent hors des cadavres et des ragdolls.",

} end }