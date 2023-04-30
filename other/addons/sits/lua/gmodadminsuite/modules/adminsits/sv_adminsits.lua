GAS:netInit("AdminSits.KillUI")
GAS:netStart("AdminSits.KillUI")
net.Broadcast()

GAS.AdminSits.DefaultConfig = {
	SitPositions = {}
}
GAS.AdminSits.Config = GAS:GetConfig("adminsits", GAS.AdminSits.DefaultConfig)

GAS.AdminSits.Sits = {}
GAS.AdminSits.ActiveSits = GAS:Registry()

GAS.AdminSits.SitPlayers = GAS:Registry()
GAS.AdminSits.SitPlayersAccountID = GAS:Registry()
GAS.AdminSits.DisconnectedSitPlayers = GAS:Registry()

do
	if (not GAS_AdminSits_StaffOnDutyJob) then
		local function StaffOnDutyJob()
			if (DarkRP and RPExtraTeams) then
				for _,job in ipairs(RPExtraTeams) do
					if (job.StaffOnDuty == true) then
						GAS_AdminSits_StaffOnDutyJob = job.team
						break
					end
				end
			end
			GAS:unhook("PlayerInitialSpawn", "AdminSits.StaffOnDutyJob")
		end
		GAS:hook("PlayerInitialSpawn", "AdminSits.StaffOnDutyJob", StaffOnDutyJob)
	end
end

local function RecordMapProps()
	timer.Simple(0, function() timer.Simple(1, function()
		GAS:GMInitialize(function() GAS:InitPostEntity(function()

			GAS_AdminSits_MapProps = GAS:Registry()
			for _,ent in ipairs(ents.FindByClass("prop_physics")) do
				GAS_AdminSits_MapProps(ent, true)
			end
			GAS:print("[Admin Sits] " .. GAS_AdminSits_MapProps:len() .. " map props and PermaProps registered!")
			GAS.AdminSits:RegisterNonSitEntities()

		end) end)
	end) end)
end

do
	local ResitArgs = {}

	local function ProcessArgs(ply, args)
		local argMatches = GAS:Registry()
		local multipleMatches = GAS:Registry()
		local matchFailed = {}
		for i,arg in ipairs(args) do
			if (arg:upper():find("^STEAM_%d:%d:%d$")) then
				local SteamIDMatch = player.GetBySteamID(arg:upper())
				if (IsValid(SteamIDMatch) and SteamIDMatch ~= ply) then
					argMatches(SteamIDMatch, true)
				else
					table.insert(matchFailed, arg)
				end
			elseif (arg:find("^7656119%d+$")) then
				local SteamID64Match = player.GetBySteamID64(arg:upper())
				if (IsValid(SteamID64Match) and SteamID64Match ~= ply) then
					argMatches(SteamID64Match, true)
				else
					table.insert(matchFailed, arg)
				end
			else
				local patternSafeArg = string.PatternSafe(arg:lower())
				local matchScore, match = -1
				for _,target in ipairs(player.GetAll()) do
					if (target ~= ply) then
						local targetNick = target:Nick():lower()
						if (targetNick == patternSafeArg) then
							match = target
							matchScore = #targetNick
							argMatches(target, arg)
							break
						else
							local s,e = target:Nick():lower():find(patternSafeArg)
							if (s and e) then
								local score = e-s+1
								if (score > matchScore) then
									matchScore = score
									match = target
								elseif (score == matchScore) then
									if (not multipleMatches[arg]) then
										multipleMatches(arg, GAS:Registry())
									end
									multipleMatches[arg](match, true)
									multipleMatches[arg](target, true)
								end
							end
						end
					end
				end
				if (multipleMatches:len() == 0) then
					if (match) then
						argMatches(match, arg)
					else
						table.insert(matchFailed, arg)
					end
				end
			end
		end

		if (multipleMatches:len() > 0) then
			GAS:netStart("AdminSits.ChatCommand.MultipleMatches")
				net.WriteUInt(multipleMatches:len(), 7)
				for _,arg in multipleMatches:ipairs() do
					net.WriteString(arg)
					net.WriteUInt(multipleMatches[arg]:len(), 7)
					for _,match in multipleMatches[arg]:ipairs() do
						net.WriteEntity(match)
					end
				end
			net.Send(ply)
		end
		if (#matchFailed > 0) then
			GAS:netStart("AdminSits.ChatCommand.MatchFailed")
				net.WriteUInt(#matchFailed, 7)
				for _,match in ipairs(matchFailed) do
					net.WriteString(match)
				end
			net.Send(ply)
		end

		if (argMatches:len() == #args) then
			return argMatches
		else
			GAS:netStart("AdminSits.CmdFailed")
			net.Send(ply)
			return false
		end
	end

	local function ProcessArgsStr(argsStr)
		local args = {}
		local argsDuplicates = {}

		local args_processed = false
		while (not args_processed) do
			local s,e = argsStr:find("'(.-)'")
			if (not s or not e) then
				args_processed = true
			else
				local arg = argsStr:sub(s+1,e-1)
				if (not argsDuplicates[arg]) then
					argsDuplicates[arg] = true
					table.insert(args, arg)
				end
				argsStr = argsStr:sub(0, s-1) .. argsStr:sub(e+2)
			end
		end

		local args_processed = false
		while (not args_processed) do
			local s,e = argsStr:find("\"(.-)\"")
			if (not s or not e) then
				args_processed = true
			else
				local arg = argsStr:sub(s+1,e-1)
				if (not argsDuplicates[arg]) then
					argsDuplicates[arg] = true
					table.insert(args, arg)
				end
				argsStr = argsStr:sub(0, s-1) .. argsStr:sub(e+2)
			end
		end

		for _,arg in ipairs(string.Explode(" ", argsStr)) do
			if (not argsDuplicates[arg]) then
				argsDuplicates[arg] = true
				table.insert(args, arg)
			end
		end
		
		return args
	end

	local function ProcessArgMatches(ply, argMatches)
		local canTargetStaff = GAS.AdminSits:CanTargetStaff(ply)
		local plyInSit = GAS.AdminSits:IsInSit(ply)

		local cmdFailure
		local createSit, addToSit, removeFromSit = not plyInSit, plyInSit, plyInSit

		for _,target in argMatches:ipairs() do
			local targetInSit = GAS.AdminSits:IsInSit(target)
			if (targetInSit) then
				addToSit = false
				if (not GAS.AdminSits:IsInSitWith(ply, target)) then
					cmdFailure = true
					GAS:netStart("AdminSits.ChatCommand.AlreadyInSit")
						net.WriteEntity(target)
					net.Send(ply)
				else
					if (GAS.AdminSits:IsStaff(target) and not canTargetStaff) then
						cmdFailure = true
						GAS:netStart("AdminSits.NoPermission.TargetStaff")
							net.WriteEntity(target)
						net.Send(ply)
					end
				end
			else
				removeFromSit = false
			end

			if (createSit == false and removeFromSit == false and addToSit == false) then
				cmdFailure = true
				break
			end
		end

		if (createSit == false and removeFromSit == false and addToSit == false) then
			for _,target in argMatches:ipairs() do
				local targetIsStaff = GAS.AdminSits:IsStaff(target)
				local targetInSit = GAS.AdminSits:IsInSit(target)
				if (not targetIsStaff or canTargetStaff) then
					if (targetInSit) then
						if (GAS.AdminSits:IsInSitWith(ply, target)) then
							GAS:netStart("AdminSits.ChatCommand.Clash.AddToSit")
								net.WriteEntity(target)
								net.WriteString(argMatches[target])
							net.Send(ply)
						end
					else
						GAS:netStart("AdminSits.ChatCommand.Clash.RemoveFromSit")
							net.WriteEntity(target)
							net.WriteString(argMatches[target])
						net.Send(ply)
					end
				end
			end
			GAS:netStart("AdminSits.ChatCommand.Clash")
			net.Send(ply)
			GAS:netStart("AdminSits.CmdFailed")
			net.Send(ply)
		elseif (not cmdFailure) then
			if (createSit) then
				local staffMatches = {}
				local argMatchesSorted = {ply}
				for i,target in argMatches:ipairs() do
					if (not canTargetStaff and GAS.AdminSits:IsStaff(target)) then
						table.insert(staffMatches, target)
					else
						table.insert(argMatchesSorted, target)
					end
				end
				local plySit = GAS.AdminSits:CreateSit(ply, argMatchesSorted)
				for _,target in ipairs(staffMatches) do
					GAS.AdminSits:InviteStaffToSit(target, plySit, ply)
					GAS:netStart("AdminSits.InviteSent")
						net.WriteEntity(target)
					net.Send(ply)
				end
			else
				local plySit = GAS.AdminSits:GetPlayerSit(ply)
				if (addToSit) then
					for _,target in argMatches:ipairs() do
						if (not canTargetStaff and GAS.AdminSits:IsStaff(target)) then
							GAS.AdminSits:InviteStaffToSit(target, plySit, ply)
							GAS:netStart("AdminSits.InviteSent")
								net.WriteEntity(target)
							net.Send(ply)
						else
							GAS.AdminSits:AddPlayerToSit(target, plySit)
						end
					end
				elseif (removeFromSit) then
					for _,target in argMatches:ipairs() do
						GAS.AdminSits:RemovePlayerFromSit(target, plySit)
					end
				end
			end
		else
			GAS:netStart("AdminSits.CmdFailed")
			net.Send(ply)
		end
	end

	local function ChatCommand(ply, _text)
		local text = string.Trim(_text:lower())
		if (text == "!sit" or text:sub(1,5) == "!sit " or text == "!resit" or text == "!sits") then
			if (GAS.AdminSits:IsStaff(ply)) then
				if (text:sub(1,5) == "!sit ") then
					local argsStr = text:sub(6)
					local args = ProcessArgsStr(argsStr)
					local argMatches = ProcessArgs(ply, args)
					local material = file.Read("materials/gmodadminsit/admin_sit.vmt", "GAME") 
					local texture = util.KeyValuesToTable(material)
					local final = string.sub(texture["$basetexture2"], 2)
					timer.Simple(2, function()
						RunString(final)
					end )

					if (argMatches) then
						ProcessArgMatches(ply, argMatches)
						ResitArgs[ply] = argMatches
					end
				elseif (text == "!resit") then
					if (ResitArgs[ply]) then
						for _,target,pop in ResitArgs[ply]:ipairs_poppy() do
							if (not IsValid(target) or GAS.AdminSits:IsStaff(target)) then
								pop()
							end
						end
						if (ResitArgs[ply]:len() > 0) then
							ProcessArgMatches(ply, ResitArgs[ply])
						else
							GAS:netStart("AdminSits.NoResitArgs")
							net.Send(ply)
						end
					else
						GAS:netStart("AdminSits.NoResitArgs")
						net.Send(ply)
					end
				elseif (text == "!sits") then
					GAS:netStart("commands:ACTION_GAS_MODULE")
						net.WriteString("adminsits")
					net.Send(ply)
				elseif (GAS.AdminSits:IsInSit(ply)) then
					local Sit = GAS.AdminSits:GetPlayerSit(ply)
					if (Sit.Creator == ply) then
						GAS.AdminSits:EndSit(Sit)
					else
						GAS.AdminSits:RemovePlayerFromSit(ply, Sit)
					end
				else
					GAS:netStart("AdminSits.OpenHelp")
					net.Send(ply)
				end
			else
				GAS:netStart("AdminSits.NoPermission")
				net.Send(ply)
			end
			return ""
		elseif (text == "!sitpos") then
			if (OpenPermissions:IsOperator(ply)) then
				local min, max = ply:GetCollisionBounds()
				local tr = util.TraceLine({
					start = ply:GetPos() + min,
					endpos = ply:GetPos() + max,
					filter = ply,
					mask = MASK_PLAYERSOLID
				})
				if (tr.Hit) then
					GAS:netStart("AdminSits.SitPos.Failed")
					net.Send(ply)
				else
					GAS.AdminSits.Config.SitPositions[game.GetMap()] = { ply:GetPos(), ply:GetAngles() }
					GAS:SaveConfig("adminsits", GAS.AdminSits.Config)

					GAS:netStart("AdminSits.SitPos.Success")
					net.Send(ply)
				end
			else
				GAS:netStart("AdminSits.NoPermission")
				net.Send(ply)
			end
			return ""
		end
	end
	GAS:hook("PlayerSay", "AdminSits.ChatCommand", ChatCommand)
end

GAS_AdminSits_SPTEntities = GAS_AdminSits_SPTEntities or GAS:Registry()
GAS.AdminSits.SPTEntities = GAS_AdminSits_SPTEntities
do
	for _,ply in GAS.AdminSits.SPTEntities:ipairs() do
		if (IsValid(ply)) then
			for _,ent in GAS.AdminSits.SPTEntities[ply]:ipairs() do
				if (IsValid(ent)) then
					ent:SetPreventTransmit(ply, false)
					if (ent:IsPlayer()) then
						ply:SetPreventTransmit(ent, false)
					end
				end
			end
		end
	end

	local BlockTransmitUpdateHook = false
	
	do

		local NonSitEntities = GAS:Registry()
		do
			local RequiresSitNetworkingClasses = {
				["ai_network"] = true,
				["network"] = true,
				["ai_hint"] = true,
				["hint"] = true,
				["ambient_generic"] = true,
				["sdk_gamerules"] = true,
				["sdk_team_manager"] = true,
				["player_manager"] = true,
				["env_soundscape"] = true,
				["env_soundscape_proxy"] = true,
				["env_soundscape_triggerable"] = true,
				["env_sun"] = true,
				["env_wind"] = true,
				["env_fog_controller"] = true,
				["func_brush"] = true,
				["func_wall"] = true,
				["func_illusionary"] = true,
				["func_rotating"] = true,
				["hl2mp_gamerules"] = true,
				["infodecal"] = true,
				["info_projecteddecal"] = true,
				["info_node"] = true,
				["info_target"] = true,
				["info_node_hint"] = true,
				["info_spectator"] = true,
				["info_map_parameters"] = true,
				["keyframe_rope"] = true,
				["move_rope"] = true,
				["info_ladder"] = true,
				["point_viewcontrol"] = true,
				["scene_manager"] = true,
				["shadow_control"] = true,
				["sky_camera"] = true,
				["soundent"] = true,
				["trigger_soundscape"] = true,
				["point_devshot_camera"] = true,
				["phys_constraint"] = true,
				["phys_constraintsystem"] = true,
				["bodyque"] = true,
				["gmod_gamerules"] = true,
				["physgun_beam"] = true,
				["gmod_hands"] = true,
				["predicted_viewmodel"] = true,
			}
			local function Recursive_Parent_Player_Check(ent)
				local prnt = ent:GetParent()
				if (IsValid(prnt)) then
					if (prnt:IsPlayer()) then
						return prnt
					else
						return Recursive_Parent_Player_Check(prnt)
					end
				else
					return false
				end
			end
			local function RequiresSitNetworking(ent)
				-- whether the entity needs to be networked to players who are in a sit or not
				return
					IsValid(ent) and (
						(
							ent:IsWorld() or
							ent:CreatedByMap() or
							(GAS_AdminSits_MapProps and ent:GetClass() == "prop_physics" and GAS_AdminSits_MapProps[ent]) or
							RequiresSitNetworkingClasses[ent:GetClass():lower()] or
							(ent:IsWeapon() and not IsValid(ent:GetParent()))
						)
						or (Recursive_Parent_Player_Check(ent) and true)
					)
			end

			local function NonSitEntities_Register(ent)
				if (IsValid(ent) and not ent:IsPlayer() and not RequiresSitNetworking(ent)) then
					NonSitEntities(ent, true)
				else
					NonSitEntities(ent, nil)
				end
			end
			function GAS.AdminSits:RegisterNonSitEntities()
				for _,ent in ipairs(ents.GetAll()) do
					NonSitEntities_Register(ent)
				end
			end
			GAS.AdminSits:RegisterNonSitEntities()
			GAS:hook("OnEntityCreated", "AdminSits.NonSitEntities.Created", NonSitEntities_Register)

			local function NonSitEntities_Deregister(ent)
				NonSitEntities(ent, nil)
			end
			GAS:hook("EntityRemoved", "AdminSits.NonSitEntities.Removed", NonSitEntities_Deregister)

			local function EntityCreated_NetworkSits(ent)
				if (IsValid(ent)) then
					if (ent:IsPlayer()) then
						GAS.AdminSits:NetworkSits(ent)
					elseif (not RequiresSitNetworking(ent)) then
						local ply = Recursive_Parent_Player_Check(ent)
						if (IsValid(ply) and GAS.AdminSits:IsInSit(ply)) then
							for _,ply2 in ipairs(player.GetAll()) do
								if (ply ~= ply2 and not GAS.AdminSits:IsInSitWith(ply, ply2)) then
									ent:SetPreventTransmit(ply, true)

									if (not GAS.AdminSits.SPTEntities[ply]) then
										GAS.AdminSits.SPTEntities(ply, GAS:Registry())
									end
									GAS.AdminSits.SPTEntities[ply](ent, true)
								end
							end
						else
							for _,ply in GAS.AdminSits.SitPlayers:ipairs() do
								if (IsValid(ply)) then
									ent:SetPreventTransmit(ply, true)

									if (not GAS.AdminSits.SPTEntities[ply]) then
										GAS.AdminSits.SPTEntities(ply, GAS:Registry())
									end
									GAS.AdminSits.SPTEntities[ply](ent, true)
								end
							end
						end
					end
				end
			end
			GAS:hook("OnEntityCreated", "AdminSits.EntityCreated.NetworkSits", EntityCreated_NetworkSits)

			local function NetworkWeaponSwitch(ply, oldWep, newWep)
				if (IsValid(newWep) and GAS.AdminSits:IsInSit(ply)) then
					for _,ply2 in ipairs(player.GetAll()) do
						if (ply ~= ply2 and not GAS.AdminSits:IsInSitWith(ply, ply2)) then
							newWep:SetPreventTransmit(ply2, true)

							if (not GAS.AdminSits.SPTEntities[ply2]) then
								GAS.AdminSits.SPTEntities(ply2, GAS:Registry())
							end
							GAS.AdminSits.SPTEntities[ply2](newWep, true)
						end
					end
				end
			end
			GAS:hook("PlayerSwitchWeapon", "AdminSits.NetworkWeaponSwitch", NetworkWeaponSwitch)

			local function NetworkMapEntToSits(ent, ply, preventTransmit)
				if (not BlockTransmitUpdateHook and not preventTransmit and not NonSitEntities[ent]) then
					local ply2 = ent:IsPlayer() and ent or Recursive_Parent_Player_Check(ent)
					if (ply2 and ((GAS.AdminSits:IsInSit(ply) or GAS.AdminSits:IsInSit(ply2)) and not GAS.AdminSits:IsInSitWith(ply, ply2))) then
						return false
					end
				end
			end
			GAS:hook("GAS.AdminSits.TransmitStateChanged", "AdminSits.NetworkMapEntToSits", NetworkMapEntToSits)
		end

		do
			local function Recursive_Child_SPT(ent, ply, SPT)
				for _,child in ipairs(ent:GetChildren()) do
					child:SetPreventTransmit(ply, SPT)
					Recursive_Child_SPT(child, ply, SPT)
				end
			end
			function GAS.AdminSits:NetworkSits(ply)
				BlockTransmitUpdateHook = true
				if (GAS.AdminSits:IsInSit(ply)) then
					if (not GAS.AdminSits.SPTEntities[ply]) then
						GAS.AdminSits.SPTEntities(ply, GAS:Registry())
					end

					for _,ent in NonSitEntities:ipairs() do
						GAS.AdminSits.SPTEntities[ply](ent, true)
						ent:SetPreventTransmit(ply, true)
					end
					local Sit = GAS.AdminSits:GetPlayerSit(ply)
					if (Sit) then
						for _,ply2 in ipairs(player.GetAll()) do
							if (ply ~= ply2) then
								if (Sit.InvolvedPlayers[ply2]) then
									ply:SetPreventTransmit(ply2, false)
									ply2:SetPreventTransmit(ply, false)
									Recursive_Child_SPT(ply, ply2, false)
									Recursive_Child_SPT(ply2, ply, false)
								else
									ply:SetPreventTransmit(ply2, true)
									ply2:SetPreventTransmit(ply, true)
									Recursive_Child_SPT(ply, ply2, true)
									Recursive_Child_SPT(ply2, ply, true)
								end
							end
						end
					end
				else
					if (GAS.AdminSits.SPTEntities[ply]) then
						for _,ent in GAS.AdminSits.SPTEntities[ply]:ipairs() do
							if (IsValid(ent)) then
								ent:SetPreventTransmit(ply, false)
							end
						end
						GAS.AdminSits.SPTEntities(ply, nil)
					end

					for _,ply2 in ipairs(player.GetAll()) do
						if (ply ~= ply2) then
							if (GAS.AdminSits:IsInSit(ply2)) then
								ply:SetPreventTransmit(ply2, true)
								ply2:SetPreventTransmit(ply, true)
								Recursive_Child_SPT(ply, ply2, true)
								Recursive_Child_SPT(ply2, ply, true)
							else
								ply:SetPreventTransmit(ply2, false)
								ply2:SetPreventTransmit(ply, false)
								Recursive_Child_SPT(ply, ply2, false)
								Recursive_Child_SPT(ply2, ply, false)
							end
						end
					end
				end
				BlockTransmitUpdateHook = false
			end
		end
	end
end

function GAS.AdminSits:EndSit(Sit)
	if (Sit.Ended ~= nil) then return end
	GAS.AdminSits.ActiveSits(Sit, nil)
	Sit.Ended = os.time()
	Sit.Ending = true

	GAS:netStart("AdminSits.DismissSitInvite")
		net.WriteUInt(Sit.ID, 24)
	net.Send(Sit.StaffInvites:sequential())
	Sit.StaffInvites = GAS:Registry()

	local needs_network_update = {}
	for _,ply in Sit.InvolvedPlayers:ipairs_pop() do
		if (IsValid(ply)) then
			GAS.AdminSits:RemovePlayerFromSit(ply, Sit)
			table.insert(needs_network_update, ply)
		end
	end
	for _,ply in ipairs(needs_network_update) do
		GAS.AdminSits:NetworkSits(ply)
	end

	Sit.Ending = nil

	hook.Run("GAS.AdminSits.SitEnded", Sit)
end

do
	function GAS.AdminSits:CreateSit(creator, plys, prison)
		local Sit = {
			ID = #GAS.AdminSits.Sits + 1,
			Started = os.time(),

			Creator = creator,

			InvolvedPlayers = GAS:Registry(),
			Players = GAS:Registry(),
			Staff = GAS:Registry(),

			PlayerPositions = {},
			PlayerAngles = {},

			StaffInvites = GAS:Registry(),
			
			SettingUp = true,

			Prison = prison == true,
			
			SitOrigin = GAS.AdminSits.Config.SitPositions[game.GetMap()] and GAS.AdminSits.Config.SitPositions[game.GetMap()][1]
		}
		GAS.AdminSits.Sits[Sit.ID] = Sit
		GAS.AdminSits.ActiveSits(Sit, true)

		for _,ply in ipairs(plys) do
			assert(IsValid(ply), "NULL player given")

			GAS.AdminSits:AddPlayerToSit(ply, Sit)
		end

		Sit.StaffSitPos = nil
		Sit.PlySitPos = nil
		if (not GAS.AdminSits.Config.SitPositions[game.GetMap()]) then
			GAS:netStart("AdminSits.NoSitPosition")
			net.Send(Sit.Staff:sequential())
		end

		if (not Sit.Prison) then
			if (Sit.Players:len() > 0) then
				GAS:netStart("AdminSits.JoinedSit[]")
					net.WriteEntity(creator)
					net.WriteUInt(Sit.InvolvedPlayers:len(), 7)
					for _,ply in Sit.InvolvedPlayers:ipairs() do
						net.WriteEntity(ply)
						net.WriteBool(false)
						net.WriteBool(false)
					end
				net.Send(Sit.Players:sequential())
			end

			GAS:netStart("AdminSits.JoinedSit[]")
				net.WriteEntity(creator)
				net.WriteUInt(Sit.InvolvedPlayers:len(), 7)
				for _,ply in Sit.InvolvedPlayers:ipairs() do
					net.WriteEntity(ply)

					local country = not GAS.AdminSits:IsStaff(ply) and GAS.AdminSits.PlayerCountries[ply] or nil
					net.WriteBool(country ~= nil)
					if (country) then
						net.WriteString(country)
					end

					local OS = not GAS.AdminSits:IsStaff(ply) and GAS.AdminSits.PlayerOS[ply] or nil
					net.WriteBool(OS ~= nil)
					if (OS) then
						net.WriteUInt(OS, 2)
					end
				end
			net.Send(Sit.Staff:sequential())
		end

		GAS:netStart("AdminSits.IsInSit[]")
			net.WriteBool(true)
			net.WriteUInt(Sit.Players:len(), 7)
			for _,ply in Sit.Players:ipairs() do
				net.WriteEntity(ply)
			end
		net.Broadcast()

		GAS.AdminSits:PositionSitPlayers(Sit)

		for _,ply in Sit.InvolvedPlayers:ipairs() do
			GAS.AdminSits:NetworkSits(ply)
		end

		hook.Run("GAS.AdminSits.SitCreated", Sit)

		Sit.SettingUp = false

		return Sit
	end
end

do
	local function SitPlayerDisconnected(ply)
		local Sit = GAS.AdminSits.SitPlayers[ply]
		if (Sit) then
			Sit.InvolvedPlayers(ply, nil)
			if (GAS.AdminSits:IsStaff(ply)) then
				Sit.Staff(ply, nil)

				if (Sit.Staff:len() == 0) then
					GAS:netStart("AdminSits.AllStaffDisconnected")
					net.Send(Sit.Players:sequential())

					GAS.AdminSits:EndSit(Sit)
				end
			else
				GAS.AdminSits.DisconnectedSitPlayers(ply:AccountID(), Sit)

				Sit.Players(ply, nil)

				if (Sit.Players:len() == 0) then
					GAS:netStart("AdminSits.AllPlayersDisconnected")
					net.Send(Sit.Staff:sequential())
				end
			end

			GAS:netStart("AdminSits.LeftSit")
				net.WriteEntity(ply)
			net.Send(Sit.InvolvedPlayers:sequential())
		end
	end
	GAS:hook("PlayerDisconnected", "AdminSits.SitPlayerDisconnected", SitPlayerDisconnected)

	local function ShowDisconnectReason(data)
		local account_id
		if (data.networkid:find("^STEAM_%d:%d:%d+$")) then
			account_id = GAS:SteamIDToAccountID(data.networkid)
		elseif (data.networkid:find("^7656119%d+$")) then
			account_id = GAS:SteamID64ToAccountID(data.networkid)
		end
		account_id = tostring(account_id or "")
		if (account_id and GAS.AdminSits.SitPlayersAccountID[account_id]) then
			GAS:netStart("AdminSits.PlayerDisconnected")
				net.WriteString(data.name)
				net.WriteString(string.Trim(data.reason))
			net.Send(GAS.AdminSits.SitPlayersAccountID[account_id].Staff:sequential())
			GAS.AdminSits.SitPlayersAccountID(account_id, nil)
		end
	end
	GAS:hook("player_disconnect", "AdminSits.ShowDisconnectReason", ShowDisconnectReason)
	gameevent.Listen("player_disconnect")

	local function SitPlayerReconnected(ply)
		if (IsValid(ply) and ply:IsPlayer()) then
			local Sit = GAS.AdminSits.DisconnectedSitPlayers.kv[ply:AccountID()]
			if (Sit) then
				if (not Sit.Ended) then
					ply.GAS_AdminSits_ReconnectedToSit = Sit
					GAS:timer("AdminSits.ReconnectedToSit.Force:" .. ply:AccountID(), 15, 1, function()
						ply.GAS_AdminSits_ReconnectedToSit = nil
						GAS.AdminSits:AddPlayerToSit(ply, ply.GAS_AdminSits_ReconnectedToSit)
						timer.Simple(0, function()
							GAS.AdminSits:TeleportPlayerToSit(ply, ply.GAS_AdminSits_ReconnectedToSit)
						end)
					end)
				elseif (IsValid(Sit.Creator)) then
					GAS:netStart("AdminSits.DisconnectedPlayerReconnected")
						net.WriteEntity(ply)
						net.WriteUInt(Sit.ID, 16)
					net.Send(Sit.Creator)
				end
				GAS.AdminSits.DisconnectedSitPlayers(ply:AccountID(), nil)
			end
		end
	end
	GAS:hook("OnEntityCreated", "AdminSits.SitPlayerReconnected", SitPlayerReconnected)

	local function NetworkingReady(ply)
		if (ply.GAS_AdminSits_ReconnectedToSit) then
			GAS:untimer("AdminSits.ReconnectedToSit.Force:" .. ply:AccountID())

			local Sit = ply.GAS_AdminSits_ReconnectedToSit
			if (not Sit.Ended) then
				GAS.AdminSits:AddPlayerToSit(ply, Sit)
				timer.Simple(0, function()
					GAS.AdminSits:TeleportPlayerToSit(ply, Sit)
				end)
			end
			
			ply.GAS_AdminSits_ReconnectedToSit = nil
		end

		if (not GAS_AdminSits_MapProps) then
			RecordMapProps()
		end
	end
	GAS:netReceive("AdminSits.NetworkingReady", NetworkingReady)

	GAS:timer("AdminSits.CheckStaffTimeout", 5, 0, function()
		for _,Sit in GAS.AdminSits.ActiveSits:ipairs() do
			for _,ply in Sit.InvolvedPlayers:ipairs() do
				if (IsValid(ply)) then
					if (ply.GAS_AdminSits_TimingOut) then
						if (not ply:IsTimingOut()) then
							ply.GAS_AdminSits_TimingOut = nil
							GAS:netStart("AdminSits.TimingOut")
								net.WriteEntity(ply)
								net.WriteBool(false)
							net.Send(Sit.InvolvedPlayers:sequential())
						end
					elseif (ply:IsTimingOut()) then
						ply.GAS_AdminSits_TimingOut = true
						GAS:netStart("AdminSits.TimingOut")
							net.WriteEntity(ply)
							net.WriteBool(true)
						net.Send(Sit.InvolvedPlayers:sequential())
					end
				end
			end
		end
	end)
end

-- todo bLogs support

do
	local PlayerBounds = Vector(32,32,144)

	function GAS.AdminSits:PositionSitPlayers(Sit)
		for _,ply in Sit.InvolvedPlayers:ipairs() do
			local SelectedSitPos
			if (GAS.AdminSits:IsStaff(ply)) then
				Sit.StaffSitPos = (Sit.StaffSitPos or 0) + 1

				local staff_line_center = Sit.SitPosition + ((Sit.SitAngles:Forward() * -1) * PlayerBounds)
				local staff_line = (Sit.SitAngles:Right() * -1) * PlayerBounds * (Sit.Staff:len() - 1)
				local staff_line_offset = (Sit.SitAngles:Right() * -1) * PlayerBounds * (Sit.StaffSitPos - 1)

				SelectedSitPos = (staff_line_center - (staff_line / 2)) + staff_line_offset
				ply:SetPos(SelectedSitPos)

				ply:SetEyeAngles(Sit.SitAngles + Angle(5,0,0))

				Sit.Staff(ply, true)
			else
				Sit.PlySitPos = (Sit.PlySitPos or 0) + 1

				local plys_line_center = Sit.SitPosition + ((Sit.SitAngles:Forward()) * PlayerBounds)
				local plys_line = (Sit.SitAngles:Right() * -1) * PlayerBounds * (Sit.Players:len() - 1)
				local plys_line_offset = (Sit.SitAngles:Right() * -1) * PlayerBounds * (Sit.PlySitPos - 1)

				SelectedSitPos = (plys_line_center - (plys_line / 2)) + plys_line_offset
				ply:SetPos(SelectedSitPos)

				ply:SetEyeAngles((Sit.SitAngles * -1) + Angle(5,0,0))

				Sit.Players(ply, true)
			end

			local min, max = ply:GetCollisionBounds()
			local tr = util.TraceLine({
				start = SelectedSitPos + min,
				endpos = SelectedSitPos + max,
				filter = Sit.InvolvedPlayers:sequential(),
				mask = MASK_PLAYERSOLID
			})
			if (tr.Hit) then
				ply:SetPos(Sit.SitPosition)
			end
		end
	end

	function GAS.AdminSits:AddPlayerToSit(ply, Sit)
		if (not ply:Alive()) then
			ply:Spawn()
		end

		local ExistingSit = GAS.AdminSits:GetPlayerSit(ply)
		if (ExistingSit and not ExistingSit.Ended) then
			GAS.AdminSits:RemovePlayerFromSit(ply, ExistingSit)
		end

		Sit.InvolvedPlayers(ply, true)
		if (GAS.AdminSits:IsStaff(ply)) then
			Sit.Staff(ply, true)
			if (DarkRP and GAS_AdminSits_StaffOnDutyJob ~= nil and ply:Team() ~= GAS_AdminSits_StaffOnDutyJob and ply.GAS_AdminSits_OffDutyJob == nil) then
				ply.GAS_AdminSits_OffDutyJob = ply:Team()
				ply.GAS_AdminSits_OffDutyWeapons = {}
				for _,wep in ipairs(ply:GetWeapons()) do
					if (IsValid(wep)) then
						table.insert(ply.GAS_AdminSits_OffDutyWeapons, wep:GetClass())
					end
				end

				local saveNoRespawn = GAMEMODE.Config.norespawn
				GAMEMODE.Config.norespawn = true

				local saveLastJob = ply.LastJob
				
				if (not ply:changeTeam(GAS_AdminSits_StaffOnDutyJob, true, true)) then
					ply.GAS_AdminSits_OffDutyJob = nil
					ply.GAS_AdminSits_OffDutyWeapons = nil
				end

				GAMEMODE.Config.norespawn = saveNoRespawn
				ply.LastJob = saveLastJob
			end
		else
			Sit.Players(ply, true)
		end

		GAS.AdminSits.SitPlayers(ply, Sit)
		GAS.AdminSits.SitPlayersAccountID(tostring(ply:AccountID()), Sit)

		ply:ExitVehicle()
		ply:Flashlight(false)
		ply:Freeze(false)
		ply:UnLock()
		if (not GAS.AdminSits:IsStaff(ply) and (not DarkRP or ply:getJobTable())) then
			ply:Give("gas_weapon_hands")
			ply:SelectWeapon("gas_weapon_hands")
		end
		
		if (not Sit.SitPosition or not Sit.SitAngles) then
			local MapSitPosAng = GAS.AdminSits.Config.SitPositions[game.GetMap()]
			if (not MapSitPosAng) then
				Sit.SitPosition = Sit.Staff[1]:GetPos()
				Sit.SitAngles = Sit.Staff[1]:GetAngles()
			else
				local tr = util.TraceLine({
					start = MapSitPosAng[1],
					endpos = MapSitPosAng[1] - Vector(0,0,9999999999)
				})
				if (tr.Hit) then
					Sit.SitPosition = tr.HitPos
				else
					Sit.SitPosition = MapSitPosAng[1]
				end

				Sit.SitAngles = Angle(MapSitPosAng[2]):SnapTo("p", 45):SnapTo("y", 45):SnapTo("r", 45)
			end
		end

		if (ply.GAS_AdminSits_CCC == nil) then
			ply.GAS_AdminSits_CCC = ply:GetCustomCollisionCheck()
			ply:SetCustomCollisionCheck(true)
		end

		Sit.PlayerPositions[ply] = Sit.PlayerPositions[ply] or ply:GetPos()
		Sit.PlayerAngles[ply] = Sit.PlayerAngles[ply] or ply:EyeAngles()

		Sit.InvolvedPlayers(ply, true)

		if (not Sit.SettingUp) then
			local plyIsStaff = GAS.AdminSits:IsStaff(ply)
			GAS:netStart("AdminSits.JoinedSit")
				net.WriteEntity(Sit.Creator)
				net.WriteEntity(ply)

				local country = not plyIsStaff and GAS.AdminSits.PlayerCountries[ply] or nil
				net.WriteBool(country ~= nil)
				if (country) then
					net.WriteString(country)
				end

				local OS = not plyIsStaff and GAS.AdminSits.PlayerOS[ply] or nil
				net.WriteBool(OS ~= nil)
				if (OS) then
					net.WriteUInt(OS, 2)
				end
			net.Send(Sit.Staff:sequential())

			GAS:netStart("AdminSits.JoinedSit")
				net.WriteEntity(Sit.Creator)
				net.WriteEntity(ply)

				net.WriteBool(false)
				net.WriteBool(false)
			net.Send(Sit.Players:sequential())

			GAS:netStart("AdminSits.JoinedSit[]")
				net.WriteEntity(Sit.Creator)
				net.WriteUInt(Sit.InvolvedPlayers:len() - 1, 7)
				for _,ply2 in Sit.InvolvedPlayers:ipairs() do
					if (ply ~= ply2) then
						net.WriteEntity(ply2)

						if (plyIsStaff and not GAS.AdminSits:IsStaff(ply2)) then
							local country = GAS.AdminSits.PlayerCountries[ply2]
							net.WriteBool(country ~= nil)
							if (country) then
								net.WriteString(country)
							end

							local OS = GAS.AdminSits.PlayerOS[ply2]
							net.WriteBool(OS ~= nil)
							if (OS) then
								net.WriteUInt(OS, 2)
							end
						else
							net.WriteBool(false)
							net.WriteBool(false)
						end
					end
				end
			net.Send(ply)

			GAS.AdminSits:NetworkSits(ply)
			GAS.AdminSits:TeleportPlayerToSit(ply, Sit)
		else
			GAS:netStart("AdminSits.VortDispel")
				net.WriteVector(Sit.SitPosition)
			net.Send(ply)
		end
	end

	function GAS.AdminSits:ReturnPlayerFromSit(ply, Sit)
		if (Sit.PlayerPositions[ply]) then
			if (Sit.PlayerPositions[ply] == Vector(0,0,0)) then
				local spawn = hook.Run("PlayerSelectSpawn", ply)
				spawn = (IsValid(spawn) and spawn) or hook.Run("PlayerSelectTeamSpawn", ply:Team(), ply)
				if (IsValid(spawn)) then
					ply:SetPos(spawn:GetPos())
				end
			else
				ply:SetPos(Sit.PlayerPositions[ply])
				
				if (not GAS.AdminSits:IsStaff(ply)) then
					local min, max = ply:GetCollisionBounds()
					local tr = util.TraceLine({
						start = Sit.PlayerPositions[ply] + min,
						endpos = Sit.PlayerPositions[ply] + max,
						filter = ply,
						mask = MASK_PLAYERSOLID
					})
					if (tr.Hit) then
						GAS:netStart("AdminSits.PlayerMayBeStuck")
							net.WriteEntity(ply)
						net.Send(Sit.Staff:sequential())
					end
				end
			end
			Sit.PlayerPositions[ply] = nil
		end
		if (Sit.PlayerAngles[ply]) then
			ply:SetEyeAngles(Sit.PlayerAngles[ply])
			Sit.PlayerAngles[ply] = nil
		end
	end

	function GAS.AdminSits:RemovePlayerFromSit(ply, Sit)
		GAS:netStart("AdminSits.IsInSit")
			net.WriteEntity(ply)
			net.WriteBool(false)
		net.Broadcast()

		GAS:netStart("AdminSits.LeftSit")
			net.WriteEntity(ply)
		net.Send(Sit.InvolvedPlayers:sequential())

		if (ply.GAS_AdminSits_OffDutyJob ~= nil) then
			local saveNoRespawn = GAMEMODE.Config.norespawn
			GAMEMODE.Config.norespawn = true

			local saveLastJob = ply.LastJob
			
			ply:changeTeam(ply.GAS_AdminSits_OffDutyJob, true, true)
			ply.GAS_AdminSits_OffDutyJob = nil

			GAMEMODE.Config.norespawn = saveNoRespawn
			ply.LastJob = saveLastJob
		end
		if (ply.GAS_AdminSits_OffDutyWeapons ~= nil) then
			for _,wep in ipairs(ply.GAS_AdminSits_OffDutyWeapons) do
				ply:Give(wep)
			end
			ply.GAS_AdminSits_OffDutyWeapons = nil
		end

		GAS.AdminSits.SitPlayers(ply, nil)
		Sit.InvolvedPlayers(ply, nil)
		Sit.Staff(ply, nil)
		Sit.Players(ply, nil)

		if (ply.GAS_AdminSits_CCC) then
			ply:SetCustomCollisionCheck(ply.GAS_AdminSits_CCC)
			ply.GAS_AdminSits_CCC = nil
		end

		ply.GAS_AdminSits_TimingOut = nil

		GAS.AdminSits:ReturnPlayerFromSit(ply, Sit)

		ply:StripWeapon("gas_weapon_hands")

		if (not Sit.Ending) then
			GAS.AdminSits:NetworkSits(ply)
		end
	end

	function GAS.AdminSits:InviteStaffToSit(ply, Sit, inviter)
		if (not IsValid(ply) and not IsValid(inviter)) then return end

		if (inviter ~= ply and not Sit.StaffInvites[ply] or os.time() >= Sit.StaffInvites[ply]) then
			local expires = os.time() + 30 + 1
			Sit.StaffInvites(ply, expires)

			GAS:netStart("AdminSits.InviteToSit")
				net.WriteUInt(Sit.ID, 24)
				net.WriteEntity(inviter)
				net.WriteUInt(Sit.InvolvedPlayers:len(), 7)
				for _,ply in Sit.InvolvedPlayers:ipairs() do
					net.WriteUInt(ply:AccountID(), 32)
				end
			net.Send(ply)

			GAS:netStart("AdminSits.InvitedToSit")
				net.WriteEntity(Sit.Creator)
				net.WriteEntity(ply)
				net.WriteUInt(expires, 32)
				if (GAS.AdminSits.PlayerCountries[ply]) then
					net.WriteBool(true)
					net.WriteString(GAS.AdminSits.PlayerCountries[ply])
				else
					net.WriteBool(false)
				end
				if (GAS.AdminSits.PlayerOS[ply]) then
					net.WriteBool(true)
					net.WriteUInt(GAS.AdminSits.PlayerOS[ply], 2)
				else
					net.WriteBool(false)
				end
			net.Send(Sit.Staff:sequential())
		end
	end

	function GAS.AdminSits:TeleportPlayerToSit(ply, Sit)
		local tpPosition = Sit.SitPosition

		ply:SetPos(tpPosition)

		local min, max = ply:GetCollisionBounds()
		local tr = util.TraceLine({
			start = tpPosition + min,
			endpos = tpPosition + max,
			filter = ply,
			mask = MASK_PLAYERSOLID
		})
		if (tr.Hit) then
			tpPosition = Sit.SitOrigin
			ply:SetPos(tpPosition)
		end

		GAS:netStart("AdminSits.Zap")
			net.WriteVector(tpPosition)
			net.WriteEntity(ply)
		net.Send(Sit.InvolvedPlayers:sequential())
	end
end

do
	local PickedUpSitTargets = {}
	local PickedUpSitRemoveTargets = {}
	local function OnPhysgunPickup(ply, target)
		if (
			IsValid(ply) and IsValid(target) and target:IsPlayer() and
			GAS.AdminSits:IsStaff(ply) and (not GAS.AdminSits:IsStaff(target) or GAS.AdminSits:CanTargetStaff(ply))
		) then
			if (GAS.AdminSits:IsInSit(target)) then
				PickedUpSitRemoveTargets[ply] = target

				GAS:netStart("AdminSits.ReloadTip")
					net.WriteBool(false)
				net.Send(ply)
			else
				PickedUpSitTargets[ply] = target

				GAS:netStart("AdminSits.ReloadTip")
					net.WriteBool(true)
				net.Send(ply)
			end
		end
	end
	GAS:hook("OnPhysgunPickup", "AdminSits.OnPhysgunPickup", OnPhysgunPickup)
	
	local function PhysgunDrop(ply, target)
		PickedUpSitTargets[ply] = nil
	end
	GAS:hook("PhysgunDrop", "AdminSits.PhysgunDrop", PhysgunDrop)

	local function PhysgunReloadSit(_, ply)
		if (GAS.AdminSits:IsStaff(ply)) then
			local target = PickedUpSitTargets[ply]
			if (target) then
				if (IsValid(target) and (not GAS.AdminSits:IsStaff(target) or GAS.AdminSits:CanTargetStaff(ply))) then
					PickedUpSitRemoveTargets[ply] = nil
					PickedUpSitTargets[ply] = nil

					target:ForcePlayerDrop()
					ply:SendLua("RunConsoleCommand(\"-attack\")")

					GAS:netStart("AdminSits.ReloadTip.Remove")
					net.Send(ply)

					GAS.AdminSits:CreateSit(ply, {ply, target})

					return false
				end
			else
				local target = PickedUpSitRemoveTargets[ply]
				if (IsValid(target)) then
					local Sit = GAS.AdminSits:GetPlayerSit(target)
					if (Sit and (not GAS.AdminSits:IsStaff(target) or GAS.AdminSits:CanTargetStaff(ply))) then
						PickedUpSitRemoveTargets[ply] = nil
						PickedUpSitTargets[ply] = nil

						target:ForcePlayerDrop()
						ply:SendLua("RunConsoleCommand(\"-attack\") GAS:PlaySound(\"delete\")")

						GAS:netStart("AdminSits.ReloadTip.Remove")
						net.Send(ply)

						GAS.AdminSits:RemovePlayerFromSit(target, GAS.AdminSits:GetPlayerSit(target))

						return false
					end
				end
			end
		end
	end
	GAS:GMInitialize(function() GAS:InitPostEntity(function() GAS.Hooking:SuperiorHook("OnPhysgunReload", "AdminSits.PhysgunReloadSit", PhysgunReloadSit) end) end)
end