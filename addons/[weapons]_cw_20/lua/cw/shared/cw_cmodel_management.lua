--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/cw/shared/cw_cmodel_management.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

if CLIENT then
	-- clientsidemodel manager
	-- removes clientside models that have lost references to their weapon objects since they're not garbage collected anymore (wtf)

	CustomizableWeaponry.cmodels = {}
	CustomizableWeaponry.cmodels.curModels = {}

	function CustomizableWeaponry.cmodels:add(model, wep)
		model.wepParent = wep
		self.curModels[#self.curModels + 1] = model
	end

	function CustomizableWeaponry.cmodels:validate()
		local removalIndex = 1 -- increment the removalIndex value every time we don't remove an index, since table.remove reorganizes the table
		
		for i = 1, #self.curModels do
			local cmodel = self.curModels[removalIndex]
			
			if not IsValid(cmodel.wepParent) then
				SafeRemoveEntity(cmodel)
				table.remove(self.curModels, removalIndex)
			else
				removalIndex = removalIndex + 1
			end
		end
	end

	timer.Create("Customizable Weaponry 2.0 CModel Manager", 5, 0, function()
		CustomizableWeaponry.cmodels:validate()
	end)
end