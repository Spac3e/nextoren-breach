--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/scp294cup/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
addons/294/lua/entities/scp294cup/shared.lua
--]]
ENT.Type = "anim"

ENT.Base = "base_gmodentity"

ENT.PrintName = "SCP-294 Cup"

ENT.Category = "SCP Pack"

ENT.Spawnable = false

 

function ENT:Initialize()

	self.FluidColor = Color(0,0,0,0)

	timer.Simple(0.25, function()

		local Drink = SCP294.Drinks[self:GetNWString("Drink")];

		if Drink then

			self.FluidColor = SCP294.Drinks[self:GetNWString("Drink")].color

		else

			self.FluidColor = Color(40,30,20)

		end

	end)

end