if (SERVER) then
	AddCSLuaFile("sh_sit_behaviour.lua")
	AddCSLuaFile("sh_steam.lua")
	AddCSLuaFile("cl_screenshots.lua")
	AddCSLuaFile("cl_networking.lua")
	AddCSLuaFile("cl_sit_ui.lua")
	AddCSLuaFile("cl_menu.lua")
end

local AdminPrisonInstalled = file.Exists("gmodadminsuite/modules/adminsits/sh_adminprison_init.lua", "LUA")
if (AdminPrisonInstalled) then
	include("gmodadminsuite/modules/adminsits/sh_adminprison_init.lua")
end

GAS:hook("gmodadminsuite:LoadModule:adminsits", "LoadModule:adminsits", function(module_info)
	if (CLIENT and GAS.AdminSits) then
		if (IsValid(GAS.AdminSits.SitUI)) then
			GAS.AdminSits.SitUI:Close()
		end
		if (IsValid(GAS.AdminSits.ReloadTip)) then
			GAS.AdminSits.ReloadTip:Remove()
		end
	end
	GAS.AdminSits = {}

	if (AdminPrisonInstalled) then
		include("gmodadminsuite/modules/adminsits/sh_adminprison.lua")
	end

	if (SERVER) then
		include("gmodadminsuite/modules/adminsits/sv_adminsits.lua")
		if (AdminPrisonInstalled) then
			include("gmodadminsuite/modules/adminsits/sv_adminprison.lua")
		end

		-- drm is illegal in china, once again
		include("gmodadminsuite/modules/adminsits/sv_drm.lua")

		--[[GAS.XEON:PostLoad(function()
			XEON:Init("6822", "[GAS] Billy's Admin Sits", "1.0.0", "gmodadminsuite/modules/adminsits/sv_drm.lua", module_info.License)
		end)]]
	else
		include("gmodadminsuite/modules/adminsits/cl_networking.lua")
		include("gmodadminsuite/modules/adminsits/cl_sit_ui.lua")
		include("gmodadminsuite/modules/adminsits/cl_screenshots.lua")
		include("gmodadminsuite/modules/adminsits/cl_menu.lua")

		if (AdminPrisonInstalled) then
			include("gmodadminsuite/modules/adminsits/cl_adminprison.lua")
		end
	end

	include("gmodadminsuite/modules/adminsits/sh_steam.lua")
	include("gmodadminsuite/modules/adminsits/sh_sit_behaviour.lua")
end)