--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw_kk/ins2/client/cw_menu_addio.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


CustomizableWeaponry_KK.ins2.rigTime = 0.15

local cvEp = CreateClientConVar("_cw_kk_add_epilepsy", 0, true, false)

local onceStarted
local nextRig

hook.Add("RenderScene", "CW20_KK_Epilepsy-ator", function()
	if (cvEp:GetInt() == 0) and not onceStarted then return end

	onceStarted = true

	for _,a in pairs(CustomizableWeaponry.registeredAttachments) do
		if a.description then
			for __,line in pairs(a.description) do
				line.c = Color(
					math.random(255),
					math.random(255),
					math.random(255),
					math.random(255) + 155
				)
			end
		end
	end

	if !nextRig or (nextRig < CurTime()) then
		local numRigs = CustomizableWeaponry_KK.ins2.hands.cacheSize

		RunConsoleCommand("cw_kk_ins2_rig", math.random(numRigs) + 1)

		nextRig = CurTime() + CustomizableWeaponry_KK.ins2.rigTime
	end
end)
