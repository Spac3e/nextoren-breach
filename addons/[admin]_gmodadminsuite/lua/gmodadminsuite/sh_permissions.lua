--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/sh_permissions.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if (SERVER) then AddCSLuaFile() end

if (SERVER) then
	local function OpenPermissions_Init()
		GAS:unhook("OpenPermissions:Ready", "GAS:OpenPermissions")

		GAS.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite", {
			Name = "GmodAdminSuite",
			Color = Color(30,34,42),
			Icon = "icon16/shield.png",
			Logo = {
				Path = "gmodadminsuite/gmodadminsuite.vtf",
				Width = 256,
				Height = 256
			}
		})

		GAS.OpenPermissions:AddToTree({
			Label = "See IP Addresses",
			Icon = "icon16/server_connect.png",
			Value = "see_ip_addresses",
			Default = OpenPermissions.CHECKBOX.CROSSED
		})

		local modules_tree = GAS.OpenPermissions:AddToTree({
			Label = "Modules",
			Icon = "icon16/server.png"
		})

		for module_name, module_data in pairs(GAS.Modules.Info) do
			if (not module_data.OperatorOnly and not module_data.NoMenu and not module_data.Hidden and not module_data.Public) then
				modules_tree:AddToTree({
					Label = module_data.Name,
					Value = module_name,
					Tip = "Can access the menu of " .. module_data.Name .. "?",
					Icon = module_data.Icon
				})
			end
		end
	end
	if (OpenPermissions_Ready == true) then
		OpenPermissions_Init()
	else
		GAS:hook("OpenPermissions:Ready", "GAS:OpenPermissions", OpenPermissions_Init)
	end
end

function GAS:CanAccessMenu(ply)
	if (OpenPermissions:IsOperator(ply)) then return true end
	for module_name in pairs(GAS.Modules.Config.Enabled) do
		if (OpenPermissions:HasPermission(ply, "gmodadminsuite/" .. module_name)) then
			return true
		end
	end
	return false
end