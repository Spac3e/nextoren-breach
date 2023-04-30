--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw_kk/ins2/shared/flashlight_v7.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 46.174.48.132_27015 ~ 
~ file: addons/all_weapons/lua/cw_kk/ins2/shared/flashlight_v7.lua ~

]]


CustomizableWeaponry_KK.ins2.flashlight.v7 = CustomizableWeaponry_KK.ins2.flashlight.v7 or {}
setmetatable(CustomizableWeaponry_KK.ins2.flashlight.v7, CustomizableWeaponry_KK.ins2.flashlight)

if CLIENT then
	CustomizableWeaponry_KK.ins2.flashlight.v7.white = color_white
	CustomizableWeaponry_KK.ins2.flashlight.v7.texture = "effects/flashlight001"

	--[[function CustomizableWeaponry_KK.ins2.flashlight.v7:Think()
		if true then return end

		--print( "eee" )
		local pt = ProjectedTexture()
		pt:SetTexture(self.texture)
		pt:SetEnableShadows(true)
		pt:SetFarZ(2048)
		pt:SetFOV(60)

	end

	hook.Add("Think", CustomizableWeaponry_KK.ins2.flashlight.v7, CustomizableWeaponry_KK.ins2.flashlight.v7.Think)]]

	function CustomizableWeaponry_KK.ins2.flashlight.v7:elementRender(attBeamSource)
		if not attBeamSource then return end

	end
end

function CustomizableWeaponry_KK.ins2.flashlight.v7:attach(att)
	self:SetNWInt("INS2LAMMode", 0)
end

function CustomizableWeaponry_KK.ins2.flashlight.v7:detach()
end
