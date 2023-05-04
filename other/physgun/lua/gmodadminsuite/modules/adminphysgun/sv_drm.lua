-- FILE #1
local function OpenPermissions_Init()
	GAS:unhook("OpenPermissions:Ready", "adminphysgun:OpenPermissions")

	GAS.AdminPhysgun.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_adminphysgun", {
		Name  = "GmodAdminSuite Admin Physgun",
		Color = Color(255,150,0),
		Icon  = "icon16/wrench_orange.png"
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "Pick Up Players",
		Value = "pick_up_players",
		Icon = "icon16/key.png",
		Tip = "Should this group be able to pick up players? (overrides other admin mods)",
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "Rainbow Physgun",
		Value = "rainbow_physgun",
		Icon = "icon16/rainbow.png",
		Tip = "Should this group have a rainbow physgun?",
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "Negate Fall Damage",
		Value = "negate_fall_damage",
		Icon = "icon16/heart.png",
		Default = OpenPermissions.CHECKBOX.TICKED,
		Tip = "Negate fall damage when players are dropped by physgun by this group?",
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "Quick Freeze",
		Value = "quick_freeze",
		Icon = "icon16/heart.png",
		Default = OpenPermissions.CHECKBOX.TICKED,
		Tip = "Allow quick freezing players with physgun right click from this group?",
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "Strip Weapons",
		Value = "strip_weapons",
		Icon = "icon16/weather_snow.png",
		Default = OpenPermissions.CHECKBOX.TICKED,
		Tip = "Strip player's weapons when picked up by this group?",
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "God on Pickup",
		Value = "god_on_pickup",
		Icon = "icon16/wand.png",
		Default = OpenPermissions.CHECKBOX.TICKED,
		Tip = "God players while picked up by this group?",
	})

	GAS.AdminPhysgun.OpenPermissions:AddToTree({
		Label = "Reset Velocity",
		Value = "reset_velocity",
		Icon = "icon16/lightning_delete.png",
		Default = OpenPermissions.CHECKBOX.TICKED,
		Tip = "Reset player's velocity when picked up by this group?",
	})
end
if (OpenPermissions_Ready == true) then
	OpenPermissions_Init()
else
	GAS:hook("OpenPermissions:Ready", "adminphysgun:OpenPermissions", OpenPermissions_Init)
end


-- FILE #2
GAS.AdminPhysgun = {}

GAS.AdminPhysgun.DefaultConfig = {
	RainbowPhysgun = true,
	NegateFallDamage = true,
	QuickFreeze = true,
	GodPickup = true,
	ResetVelocity = true,
	StripWeapons = true,
}

GAS.AdminPhysgun.Config = GAS:GetConfig("adminphysgun", GAS.AdminPhysgun.DefaultConfig)
if (GAS.AdminPhysgun.Config.PlayerDropNoFallDamage ~= nil) then
	-- delete old config
	GAS:DeleteConfig("adminphysgun")
	GAS:SaveConfig("adminphysgun", GAS.AdminPhysgun.DefaultConfig)
end

--######## PlayerPickupResetVelocity ########--

GAS:hook("GAS:PhysgunDropPlayer", "adminphysgun:PlayerDropResetVelocity", function(ply, target_ply)
	if (GAS.AdminPhysgun.Config.ResetVelocity and OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/reset_velocity")) then
		target_ply:SetVelocity(target_ply:GetVelocity() * -1)
		if (IsValid(target_ply:GetPhysicsObject())) then
			target_ply:GetPhysicsObject():SetVelocityInstantaneous(Vector(0,0,0))
		end
	end
end)
GAS:hook("GAS:PhysgunPickupPlayer", "adminphysgun:PlayerPickupResetVelocity", function(ply, target_ply)
	if (GAS.AdminPhysgun.Config.ResetVelocity and OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/reset_velocity")) then
		target_ply:SetVelocity(target_ply:GetVelocity() * -1)
		if (IsValid(target_ply:GetPhysicsObject())) then
			target_ply:GetPhysicsObject():SetVelocityInstantaneous(Vector(0,0,0))
		end
	end
end)

GAS:hook("Think", "adminphysgun:ForceVelocity", function()
	if (GAS.AdminPhysgun.Config.ResetVelocity) then
		for target_ply in pairs(GAS.AdminPhysgun.PickedUpPlayersIndexed) do
			if (IsValid(target_ply)) then
				target_ply:SetVelocity(target_ply:GetVelocity() * -1)
				if (IsValid(target_ply:GetPhysicsObject())) then
					target_ply:GetPhysicsObject():SetVelocityInstantaneous(Vector(0,0,0))
				end
			else
				GAS.AdminPhysgun.PickedUpPlayersIndexed[target_ply] = nil
			end
		end
	end
end)

--######## Freeze ########--

GAS:hook("GAS:PhysgunPickupPlayer", "adminphysgun:Freeze_Pickup", function(ply, target_ply)
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/quick_freeze")) then return end
	if (target_ply.GAS_Freeze_MoveType or target_ply.GAS_Freeze_CollisionCheck or target_ply.GAS_Frozen) then
		target_ply:SetNWBool("GAS_Frozen", false)
	end
	if (target_ply.GAS_Freeze_MoveType) then
		if (target_ply:GetMoveType() == MOVETYPE_NONE) then
			target_ply:SetMoveType(target_ply.GAS_Freeze_MoveType)
		end
		target_ply.GAS_Freeze_MoveType = nil
	end
	if (target_ply.GAS_Freeze_CollisionCheck) then
		if (target_ply:GetCustomCollisionCheck() == true) then
			target_ply:SetCustomCollisionCheck(target_ply.GAS_Freeze_CollisionCheck)
		end
		target_ply:CollisionRulesChanged()
		target_ply.GAS_Freeze_CollisionCheck = nil
	end
	if (target_ply.GAS_Frozen) then
		target_ply.GAS_Frozen = false
		target_ply:Freeze(false)
	end
end)
local function FreezePlayer(target_ply)
	target_ply.GAS_Frozen = true
	target_ply:Freeze(true)

	target_ply.GAS_Freeze_CollisionCheck = target_ply:GetCustomCollisionCheck()
	target_ply:SetCustomCollisionCheck(true)
	target_ply:CollisionRulesChanged()

	target_ply.GAS_Freeze_MoveType = target_ply:GetMoveType()
	target_ply:SetMoveType(MOVETYPE_NONE)

	target_ply:EmitSound("ambient/energy/zap1.wav", 60)

	local effectData = EffectData()
	effectData:SetEntity(target_ply)
	effectData:SetOrigin(target_ply:GetPos())
	util.Effect("entity_remove", effectData, true, true)
end
GAS:hook("GAS:PhysgunDropPlayer", "adminphysgun:Freeze_Drop", function(ply, target_ply)
	if (IsValid(target_ply) and target_ply.GAS_FreezeAfterDrop) then
		target_ply.GAS_FreezeAfterDrop = nil

		target_ply:SetNWBool("GAS_Frozen", true)

		if (not target_ply:HasGodMode()) then
			target_ply:GodEnable()
			target_ply.GAS_PlayerPickupGod = true
		end

		timer.Simple(0, function()
			if (not IsValid(target_ply)) then return end
			FreezePlayer(target_ply)
		end)
	end
end)

GAS:hook("PlayerSpawn", "adminphysgun:SaveDeathFreezeSpawn", function(ply)
	if (ply.GAS_Frozen) then
		timer.Simple(0, function()
			if (ply.GAS_FrozenPos) then
				ply:SetPos(ply.GAS_FrozenPos)
			end
			FreezePlayer(ply)
			timer.Simple(0, function()
				if (ply.GAS_FrozenEyeAng) then
					ply:SetEyeAngles(ply.GAS_FrozenEyeAng)
				end
			end)
		end)
	end
end)
GAS:hook("PlayerDeath", "adminphysgun:SaveDeathFreezeDeath", function(ply)
	if (ply.GAS_Frozen) then
		ply.GAS_FrozenPos = ply:GetPos()
		ply.GAS_FrozenEyeAng = ply:EyeAngles()
		ply:Freeze(false)
	end
end)

--######## NoFallDamage ########--

local NegateFallDamage = {}
GAS:hook("GAS:PhysgunDropPlayer", "adminphysgun:NoFallDamage_Drop", function(ply, target_ply)
	if (GAS.AdminPhysgun.Config.NegateFallDamage and OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/negate_fall_damage")) then
		if (not IsValid(target_ply:GetGroundEntity()) and not target_ply:GetGroundEntity():IsWorld()) then
			GAS:untimer("adminphysgun:NegateFallDamage_FallDamage")
			NegateFallDamage[target_ply] = false
		end
	end
end)
GAS:hook("GetFallDamage", "adminphysgun:NegateFallDamage_NoFallDamage", function(ply)
	if (GAS.AdminPhysgun.Config.NegateFallDamage and NegateFallDamage[ply] and NegateFallDamage[ply] <= CurTime() + 1) then
		GAS:untimer("adminphysgun:NegateFallDamage_FallDamage")
		NegateFallDamage[ply] = nil

		local effectData = EffectData()
		effectData:SetEntity(ply)
		effectData:SetOrigin(ply:GetPos())

		ply:EmitSound("garrysmod/balloon_pop_cute.wav", 60)

		util.Effect("VortDispel", effectData)
		
		return 0
	end
end)
GAS:hook("OnPlayerHitGround", "adminphysgun:NegateFallDamage_FallDamage", function(ply)
	if (NegateFallDamage[ply] == false) then
		NegateFallDamage[ply] = CurTime()
		GAS:timer("adminphysgun:NegateFallDamage_FallDamage", 1, 1, function()
			NegateFallDamage[ply] = nil
		end)
	end
end)

--######## GOD ########--

GAS:hook("GAS:PhysgunPickupPlayer", "adminphysgun:God_Pickup", function(ply, target_ply)
	if (GAS.AdminPhysgun.Config.GodPickup and not target_ply:HasGodMode() and OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/god_on_pickup")) then
		target_ply:GodEnable()
		target_ply.GAS_PlayerPickupGod = true
	end
end)
GAS:hook("GAS:PhysgunDropPlayer", "adminphysgun:God_Drop", function(ply, target_ply)
	if (target_ply.GAS_PlayerPickupGod) then
		target_ply:GodDisable()
	end
end)

--######## NON-LETHAL ########--

GAS:hook("GAS:PhysgunPickupPlayer", "adminphysgun:NonLethal_Pickup", function(ply, target_ply)
	if (GAS.AdminPhysgun.Config.StripWeapons and OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/strip_weapons")) then
		if (IsValid(target_ply:GetActiveWeapon())) then
			if (target_ply:GetActiveWeapon():GetClass() == "gas_weapon_hands") then
				target_ply.GAS_PlayerPickupNonLethal = target_ply.GAS_PlayerPickupNonLethal_Old or true
			else
				target_ply.GAS_PlayerPickupNonLethal = target_ply:GetActiveWeapon():GetClass()
			end
		else
			target_ply.GAS_PlayerPickupNonLethal = true
		end
		if (not target_ply:HasWeapon("gas_weapon_hands")) then
			target_ply:Give("gas_weapon_hands")
		end
		target_ply:SelectWeapon("gas_weapon_hands")
		target_ply.GAS_PlayerPickupNonLethal_Old = nil
	end
end)
GAS:hook("GAS:PhysgunDropPlayer", "adminphysgun:NonLethal_Drop", function(ply, target_ply)
	if (target_ply.GAS_PlayerPickupNonLethal) then
		local GAS_PlayerPickupNonLethal = target_ply.GAS_PlayerPickupNonLethal
		target_ply.GAS_PlayerPickupNonLethal = nil
		target_ply.GAS_PlayerPickupNonLethal_Old = GAS_PlayerPickupNonLethal
		if (GAS_PlayerPickupNonLethal ~= true) then
			target_ply:SelectWeapon(GAS_PlayerPickupNonLethal)
		end
		target_ply:StripWeapon("gas_weapon_hands")
	end
end)

GAS:SuperiorHook("PlayerSwitchWeapon", "adminphysgun:PlayerSwitchWeapon", function(ply, oldWeapon, newWeapon)
	if (IsValid(GAS.AdminPhysgun.PickedUpPlayersIndexed[ply]) and ply.GAS_PlayerPickupNonLethal and IsValid(oldWeapon) and oldWeapon:GetClass() == "gas_weapon_hands") then
		return true
	end
end)
GAS:hook("PlayerDroppedWeapon", "adminphysgun:PlayerDroppedWeapon", function(ply, wep)
	if (ply.GAS_PlayerPickupNonLethal and IsValid(wep) and wep:GetClass() == "gas_weapon_hands") then
		ply:Give("gas_weapon_hands")
		ply:SelectWeapon("gas_weapon_hands")
	end
end)

--######## NETWORKING ########--

GAS:netInit("adminphysgun:RainbowPhysgunInit")
GAS:netReceive("adminphysgun:RainbowPhysgunInit", function(ply)
	GAS:netStart("adminphysgun:RainbowPhysgunInit")
		net.WriteBool(GAS.AdminPhysgun.Config.RainbowPhysgun)
	net.Send(ply)
end)

GAS:netInit("adminphysgun:FreezePlayer")
GAS:netReceive("adminphysgun:FreezePlayer", function(ply)
	local target_ply = GAS.AdminPhysgun.PickedUpPlayers[ply]
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite_adminphysgun/quick_freeze")) then return end
	if (IsValid(target_ply)) then
		target_ply.GAS_FreezeAfterDrop = true
		target_ply:EmitSound("Weapon_Physgun.Special1")
		GAS:netQuickie("adminphysgun:FreezePlayer", ply)
	end
end)

GAS:netInit("adminphysgun:SetSetting")
GAS:netReceive("adminphysgun:SetSetting", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local setting = net.ReadString()
	local checked = net.ReadBool()
	if (GAS.AdminPhysgun.Config[setting] ~= nil) then
		GAS.AdminPhysgun.Config[setting] = checked
		GAS:SaveConfig("adminphysgun", GAS.AdminPhysgun.Config)
	end
end)