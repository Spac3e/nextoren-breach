local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "adminphysgun")
	else
		return GAS:PhraseFormat(phrase, "adminphysgun", ...)
	end
end

GAS.AdminPhysgun = {}

--## FREEZE PLAYER ##--

GAS:hook("PlayerBindPress", "adminphysgun:PlayerBindPress", function(ply, bind)
	if (bind == "+attack2") then
		if (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "weapon_physgun") then
			GAS:netStart("adminphysgun:FreezePlayer")
			net.SendToServer()
		end
	end
end)

GAS:netReceive("adminphysgun:FreezePlayer", function()
	GAS:PlaySound("flash")
	notification.AddLegacy(L"frozen_player", NOTIFY_GENERIC, 4)
end)

--## RAINBOW PHYSGUN ##--

function GAS.AdminPhysgun:RainbowPhysgunInit(enabled)
	if (not enabled) then
		GAS:untimer("adminphysgun:RainbowRefresh")
		GAS:unhook("HUDPaint", "adminphysgun:Rainbow")
		for _,ply in ipairs(player.GetHumans()) do
			if (ply.GAS_OriginalPhysgunColor) then
				ply:SetWeaponColor(ply.GAS_OriginalPhysgunColor)
				ply.GAS_OriginalPhysgunColor = nil
			end
		end
	else
		local permitted = {}
		local function GetPermitted()
			permitted[NULL] = nil
			for _,ply in ipairs(player.GetHumans()) do
				if (OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/rainbow_physgun")) then
					permitted[ply] = true
				else
					permitted[ply] = nil
				end
			end
		end
		GAS:timer("adminphysgun:RainbowRefresh", 120, 0, GetPermitted)
		GetPermitted()

		GAS:hook("HUDPaint", "adminphysgun:Rainbow", function()
			local col = HSVToColor(CurTime() % 6 * 60, 1, 1)
			col = Vector(col.r / 255, col.g / 255, col.b / 255)
			for ply in pairs(permitted) do
				if (not IsValid(ply)) then continue end
				if (ply ~= LocalPlayer() and ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > 500000) then continue end
				if (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "weapon_physgun") then
					if (not ply.GAS_OriginalPhysgunColor) then
						ply.GAS_OriginalPhysgunColor = ply:GetWeaponColor()
					end
					ply:SetWeaponColor(col)
				end
			end
		end)
	end
end
GAS:netReceive("adminphysgun:RainbowPhysgunInit", function()
	GAS.AdminPhysgun:RainbowPhysgunInit(net.ReadBool())
end)
GAS:InitPostEntity(function()
	GAS:netStart("adminphysgun:RainbowPhysgunInit")
	net.SendToServer()
end)

--## MENU ##--

GAS:hook("gmodadminsuite:ModuleSize:adminphysgun", "adminphysgun:framesize", function()
	return 450,495
end)

GAS:hook("gmodadminsuite:ModuleFrame:adminphysgun", "adminphysgun:menu", function(ModuleFrame)
	local LoadingPanel = vgui.Create("bVGUI.LoadingPanel", ModuleFrame)
	LoadingPanel:Dock(FILL)
	LoadingPanel:SetLoading(true)

	GAS:GetConfig("adminphysgun", function(config)
		if (not IsValid(ModuleFrame)) then return end
		LoadingPanel:SetLoading(false)

		local Permissions = vgui.Create("bVGUI.ButtonContainer", LoadingPanel)
		Permissions:Dock(TOP)
		Permissions:DockMargin(10,10,10,0)
		Permissions:SetTall(25)
		Permissions.Button:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
		Permissions.Button:SetText(L"permissions")
		Permissions.Button:SetSize(150,25)
		function Permissions.Button:DoClick()
			GAS:PlaySound("flash")
			RunConsoleCommand("openpermissions", "gmodadminsuite_adminphysgun")
		end

		local PermissionsTip = vgui.Create("DLabel", LoadingPanel)
		PermissionsTip:Dock(TOP)
		PermissionsTip:DockMargin(10,10,10,10)
		PermissionsTip:SetContentAlignment(5)
		PermissionsTip:SetText(L"PermissionsTip")
		PermissionsTip:SetTextColor(bVGUI.COLOR_WHITE)
		PermissionsTip:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
		PermissionsTip:SetWrap(true)
		PermissionsTip:SetAutoStretchVertical(true)
		PermissionsTip:SizeToContents()

		local EnableRainbowPhysgun = vgui.Create("bVGUI.Switch", LoadingPanel)
		EnableRainbowPhysgun:Dock(TOP)
		EnableRainbowPhysgun:SetChecked(config.RainbowPhysgun)
		EnableRainbowPhysgun:SetText(L"EnableRainbowPhysgun")
		EnableRainbowPhysgun:DockMargin(10,10,10,0)
		function EnableRainbowPhysgun:OnChange()
			GAS:netStart("adminphysgun:SetSetting")
				net.WriteString("RainbowPhysgun")
				net.WriteBool(self:GetChecked())
			net.SendToServer()
		end

		local NegateFallDamage = vgui.Create("bVGUI.Switch", LoadingPanel)
		NegateFallDamage:Dock(TOP)
		NegateFallDamage:SetChecked(config.NegateFallDamage)
		NegateFallDamage:SetText(L"NegateFallDamage")
		NegateFallDamage:SetHelpText(L"NegateFallDamage_help")
		NegateFallDamage:DockMargin(10,10,10,0)
		function NegateFallDamage:OnChange()
			GAS:netStart("adminphysgun:SetSetting")
				net.WriteString("NegateFallDamage")
				net.WriteBool(self:GetChecked())
			net.SendToServer()
		end

		local QuickFreeze = vgui.Create("bVGUI.Switch", LoadingPanel)
		QuickFreeze:Dock(TOP)
		QuickFreeze:SetChecked(config.QuickFreeze)
		QuickFreeze:SetText(L"QuickFreeze")
		QuickFreeze:SetHelpText(L"QuickFreeze_help")
		QuickFreeze:DockMargin(10,10,10,0)
		function QuickFreeze:OnChange()
			GAS:netStart("adminphysgun:SetSetting")
				net.WriteString("QuickFreeze")
				net.WriteBool(self:GetChecked())
			net.SendToServer()
		end

		local StripWeapons = vgui.Create("bVGUI.Switch", LoadingPanel)
		StripWeapons:Dock(TOP)
		StripWeapons:SetChecked(config.StripWeapons)
		StripWeapons:SetText(L"StripWeapons")
		StripWeapons:SetHelpText(L"StripWeapons_help")
		StripWeapons:DockMargin(10,10,10,0)
		function StripWeapons:OnChange()
			GAS:netStart("adminphysgun:SetSetting")
				net.WriteString("StripWeapons")
				net.WriteBool(self:GetChecked())
			net.SendToServer()
		end

		local GodPickup = vgui.Create("bVGUI.Switch", LoadingPanel)
		GodPickup:Dock(TOP)
		GodPickup:SetChecked(config.GodPickup)
		GodPickup:SetText(L"GodPickup")
		GodPickup:SetHelpText(L"GodPickup_help")
		GodPickup:DockMargin(10,10,10,0)
		function GodPickup:OnChange()
			GAS:netStart("adminphysgun:SetSetting")
				net.WriteString("GodPickup")
				net.WriteBool(self:GetChecked())
			net.SendToServer()
		end

		local ResetVelocity = vgui.Create("bVGUI.Switch", LoadingPanel)
		ResetVelocity:Dock(TOP)
		ResetVelocity:SetChecked(config.ResetVelocity)
		ResetVelocity:SetText(L"ResetVelocity")
		ResetVelocity:SetHelpText(L"ResetVelocity_help")
		ResetVelocity:DockMargin(10,10,10,0)
		function ResetVelocity:OnChange()
			GAS:netStart("adminphysgun:SetSetting")
				net.WriteString("ResetVelocity")
				net.WriteBool(self:GetChecked())
			net.SendToServer()
		end
	end)
	
	--[[
	local SuperadminRainbowPhysgun = vgui.Create("bVGUI.Switch", LoadingPanel)
	GAS.AdminPhysgun.Menu.SuperadminRainbowPhysgun = SuperadminRainbowPhysgun
	SuperadminRainbowPhysgun:Dock(TOP)
	SuperadminRainbowPhysgun:SetText(L"SuperadminRainbowPhysgun")
	SuperadminRainbowPhysgun:DockMargin(10,10,10,0)
	SuperadminRainbowPhysgun:SetVisible(false)
	function SuperadminRainbowPhysgun:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("SuperadminRainbowPhysgun")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end
	
	local AdminRainbowPhysgun = vgui.Create("bVGUI.Switch", LoadingPanel)
	GAS.AdminPhysgun.Menu.AdminRainbowPhysgun = AdminRainbowPhysgun
	AdminRainbowPhysgun:Dock(TOP)
	AdminRainbowPhysgun:SetText(L"AdminRainbowPhysgun")
	AdminRainbowPhysgun:DockMargin(10,10,10,0)
	AdminRainbowPhysgun:SetVisible(false)
	function AdminRainbowPhysgun:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("AdminRainbowPhysgun")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end

	local PlayerDropNoFallDamage = vgui.Create("bVGUI.Switch", LoadingPanel) 
	GAS.AdminPhysgun.Menu.PlayerDropNoFallDamage = PlayerDropNoFallDamage
	PlayerDropNoFallDamage:Dock(TOP)
	PlayerDropNoFallDamage:SetText(L"PlayerDropNoFallDamage")
	PlayerDropNoFallDamage:SetHelpText(L"PlayerDropNoFallDamage_help")
	PlayerDropNoFallDamage:DockMargin(10,10,10,0)
	PlayerDropNoFallDamage:SetVisible(false)
	function PlayerDropNoFallDamage:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("PlayerDropNoFallDamage")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end
	
	local PlayerRightClickFreeze = vgui.Create("bVGUI.Switch", LoadingPanel)
	GAS.AdminPhysgun.Menu.PlayerRightClickFreeze = PlayerRightClickFreeze
	PlayerRightClickFreeze:Dock(TOP)
	PlayerRightClickFreeze:SetText(L"PlayerRightClickFreeze")
	PlayerRightClickFreeze:SetHelpText(L"PlayerRightClickFreeze_help")
	PlayerRightClickFreeze:DockMargin(10,10,10,0)
	PlayerRightClickFreeze:SetVisible(false)
	function PlayerRightClickFreeze:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("PlayerRightClickFreeze")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end
	
	local PlayerPickupGod = vgui.Create("bVGUI.Switch", LoadingPanel)
	GAS.AdminPhysgun.Menu.PlayerPickupGod = PlayerPickupGod
	PlayerPickupGod:Dock(TOP)
	PlayerPickupGod:SetText(L"PlayerPickupGod")
	PlayerPickupGod:DockMargin(10,10,10,0)
	PlayerPickupGod:SetVisible(false)
	function PlayerPickupGod:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("PlayerPickupGod")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end
	
	local PlayerPickupNonLethal = vgui.Create("bVGUI.Switch", LoadingPanel)
	GAS.AdminPhysgun.Menu.PlayerPickupNonLethal = PlayerPickupNonLethal
	PlayerPickupNonLethal:Dock(TOP)
	PlayerPickupNonLethal:SetText(L"PlayerPickupNonLethal")
	PlayerPickupNonLethal:DockMargin(10,10,10,0)
	PlayerPickupNonLethal:SetVisible(false)
	function PlayerPickupNonLethal:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("PlayerPickupNonLethal")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end
	
	local PlayerPickupResetVelocity = vgui.Create("bVGUI.Switch", LoadingPanel)
	GAS.AdminPhysgun.Menu.PlayerPickupResetVelocity = PlayerPickupResetVelocity
	PlayerPickupResetVelocity:Dock(TOP)
	PlayerPickupResetVelocity:SetText(L"PlayerPickupResetVelocity")
	PlayerPickupResetVelocity:DockMargin(10,10,10,0)
	PlayerPickupResetVelocity:SetVisible(false)
	function PlayerPickupResetVelocity:OnChange()
		GAS:netStart("adminphysgun:SetSetting")
			net.WriteString("PlayerPickupResetVelocity")
			net.WriteBool(self:GetChecked())
		net.SendToServer()
	end

	GAS:netStart("adminphysgun:GetSettings")
	net.SendToServer()]]
end)