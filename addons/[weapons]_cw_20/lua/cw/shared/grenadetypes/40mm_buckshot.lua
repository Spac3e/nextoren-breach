--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/grenadetypes/40mm_buckshot.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local gren = {}
gren.name = "40mm_buckshot"
gren.display = " - 40MM BUCK"
gren.pelletCount = 20
gren.pelletDamage = 12
gren.spread = 0.03
gren.clumpSpread = 0.04
gren.fireSound = "CW_M203_FIRE_BUCK"
gren.allowSights = true

function gren:fireFunc()
	if self:filterPrediction() then
		self:FireBullet(gren.pelletDamage, gren.spread, gren.clumpSpread, gren.pelletCount)
	end
end

CustomizableWeaponry.grenadeTypes:addNew(gren)