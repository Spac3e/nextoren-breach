--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_ballistic_shields/lua/ballistic_shields/sh_bs_lang.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include( "ballistic_shields/sh_bs_util.lua" )

bshields.lang = {
	["English"] = {
		["sec"] = "[RMB] VISIBILITY",
		["dshieldprim"] = "[LMB] DEPLOY",
		["hshieldprim"] = "[LMB] BREACH DOOR",
		["rshieldprim"] = "[LMB] ATTACK",
		["hshieldcd1"] = "Wait ",
		["hshieldcd2"] = " seconds to breach next door!"	
	},
	["German"] = {
		["sec"] = "[RMB] SICHTBARKEIT",
		["dshieldprim"] = "[LMB] PLAZIEREN",
		["hshieldprim"] = "[LMB] TÜR AUFBRECHEN",
		["rshieldprim"] = "[LMB] ANGREIFEN",
		["hshieldcd1"] = "Warte ",
		["hshieldcd2"] = " Sekunden für das Aufbrechen der nächsten Tür!"	
	},
	["French"] = {
		["sec"] = "[RMB] VISIBILITÉ",
		["dshieldprim"] = "[LMB] DÉPLOYER",
		["hshieldprim"] = "[LMB] FORCER LA PORTE",
		["rshieldprim"] = "[LMB] ATTAQUER",
		["hshieldcd1"] = "Attendez ",
		["hshieldcd2"] = " secondes pour forcer la porte !"	
	},
	["Danish"] = {
		["sec"] = "[RMB] SIGTBARHED",
		["dshieldprim"] = "[LMB] SÆT",
		["hshieldprim"] = "[LMB] BREACH DØR",
		["rshieldprim"] = "[LMB] ANGRIB",
		["hshieldcd1"] = "Vent ",
		["hshieldcd2"] = " sekunder at bryde ved siden af!"   
	},
	["Turkish"] = {
		["sec"] = "[RMB] GORUNURLUK",
		["dshieldprim"] = "[LMB] YERLESTIR",
		["hshieldprim"] = "[LMB] BREACH DOOR",
		["rshieldprim"] = "[LMB] SALDIR",
		["hshieldcd1"] = "Bekle ",
		["hshieldcd2"] = " bir sonraki kapıyı kırmaya saniye kaldı!"   
	}
}  

if(bshields.lang[bshields.config.language]==nil) then bshields.config.language = "English" end