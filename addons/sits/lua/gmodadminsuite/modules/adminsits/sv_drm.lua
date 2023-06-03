for _,__ in ipairs({
	"AdminSits.IsInSit",
	"AdminSits.IsInSit[]",
	"AdminSits.NotAllowedInSit",
	"AdminSits.DisconnectedPlayerReconnected",
	"AdminSits.NoSitPosition",
	"AdminSits.TimingOut",
	"AdminSits.PlayerMayBeStuck",
	"AdminSits.WindowFocus",
	"AdminSits.FlashWindow",
	"AdminSits.GetCountry",
	"AdminSits.GetOS",
	"AdminSits.JoinedSit[]",
	"AdminSits.JoinedSit",
	"AdminSits.LeftSit",
	"AdminSits.TakeScreenshot",
	"AdminSits.SendScreenshot",
	"AdminSits.ScreenshotMetadata",
	"AdminSits.ScreenshotPacket",
	"AdminSits.ScreenshotPacketChunk",
	"AdminSits.SteamFriends",
	"AdminSits.CheckSteamFriends",
	"AdminSits.RemoveFromSit",
	"AdminSits.NoPermission",
	"AdminSits.NoPermission.TargetStaff",
	"AdminSits.ChatCommand.MultipleMatches",
	"AdminSits.ChatCommand.MatchFailed",
	"AdminSits.ChatCommand.AlreadyInSit",
	"AdminSits.ChatCommand.Clash.AddToSit",
	"AdminSits.ChatCommand.Clash.RemoveFromSit",
	"AdminSits.ScreenshotUploaded",
	"AdminSits.ScreenshotDownloaded",
	"AdminSits.TeleportPlayerToSit",
	"AdminSits.CheckPocket",
	"AdminSits.CheckSteamFamilySharing",
	"AdminSits.ChatCommand.Clash",
	"AdminSits.DisableTextChat",
	"AdminSits.MuteMicrophone",
	"AdminSits.EndSit",
	"AdminSits.AddPlayerToSit",
	"AdminSits.InviteToSit",
	"AdminSits.LeaveSit",
	"AdminSits.OpenHelp",
	"AdminSits.AllStaffDisconnected",
	"AdminSits.AllPlayersDisconnected",
	"AdminSits.AcceptSitInvite",
	"AdminSits.DismissSitInvite",
	"AdminSits.PlayerDisconnected",
	"AdminSits.NetworkingReady",
	"AdminSits.ReloadTip",
	"AdminSits.ReloadTip.Remove",
	"AdminSits.GetSits",
	"AdminSits.JoinSit",
	"AdminSits.SitPos.Failed",
	"AdminSits.SitPos.Success",
	"AdminSits.Zap",
	"AdminSits.VortDispel",
	"AdminSits.InviteSent",
	"AdminSits.SitInvite.Declined",
	"AdminSits.InvitedToSit",
	"AdminSits.CmdFailed",
	"AdminSits.ScreenshotFailed",
}) do GAS:netInit(__) end

local function SitCreated(Sit)
	GAS:netStart("AdminSits.IsInSit[]")
		net.WriteBool(true)
		net.WriteUInt(Sit.InvolvedPlayers:len(), 7)
		for _,ply in Sit.InvolvedPlayers:ipairs() do
			if (IsValid(ply)) then
				net.WriteEntity(ply)
			end
		end
	net.Broadcast()
end
GAS:hook("GAS.AdminSits.SitCreated", "AdminSits.IsInSit", SitCreated)

local function SitEnded(Sit)
	GAS:netStart("AdminSits.IsInSit[]")
		net.WriteBool(false)
		net.WriteUInt(Sit.InvolvedPlayers:len(), 7)
		for _,ply in Sit.InvolvedPlayers:ipairs() do
			if (IsValid(ply)) then
				net.WriteEntity(ply)
			end
		end
	net.Broadcast()
end
GAS:hook("GAS.AdminSits.SitEnded", "AdminSits.IsInSit", SitEnded)

do
	local WindowFocus = {}
	local function WindowFocusReceived(ply)
		local HasFocus = net.ReadBool()
		if (WindowFocus[ply] ~= HasFocus) then
			WindowFocus[ply] = HasFocus

			local Sit = GAS.AdminSits.SitPlayers[ply]
			if (Sit) then
				GAS:netStart("AdminSits.WindowFocus")
					net.WriteEntity(ply)
					net.WriteBool(HasFocus)
				net.Send(Sit.InvolvedPlayers:sequential())
			end
		end
	end
	GAS:netReceive("AdminSits.WindowFocus", WindowFocusReceived)
end

GAS.AdminSits.PlayerOS = {}
local function ReceiveOS(ply)
	local OSEnum = net.ReadUInt(2)
	if (OSEnum >= 0 and OSEnum <= 2) then
		GAS.AdminSits.PlayerOS[ply] = GAS.AdminSits.PlayerOS[ply] or OSEnum
		local Sit = GAS.AdminSits:GetPlayerSit(ply)
		if (Sit) then
			GAS:netStart("AdminSits.GetOS")
				net.WriteEntity(ply)
				net.WriteUInt(OSEnum, 2)
			net.Send(Sit.InvolvedPlayers:sequential())
		end
	end
end
GAS:netReceive("AdminSits.GetOS", ReceiveOS)

GAS.AdminSits.PlayerCountries = {}
local function ReceiveCountry(ply)
	local country = net.ReadString()
	if (#country == 2 and country ~= "XX") then
		GAS.AdminSits.PlayerCountries[ply] = GAS.AdminSits.PlayerCountries[ply] or country
		local Sit = GAS.AdminSits:GetPlayerSit(ply)
		if (Sit) then
			GAS:netStart("AdminSits.GetCountry")
				net.WriteEntity(ply)
				net.WriteString(country)
			net.Send(Sit.InvolvedPlayers:sequential())
		end
	end
end
GAS:netReceive("AdminSits.GetCountry", ReceiveCountry)

do
	local FlashWindowCooldowns = {}
	local function FlashWindow(ply)
		local target = net.ReadEntity()
		local cooldown = FlashWindowCooldowns[target]
		if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target) and (cooldown == nil or os.time() >= cooldown)) then
			FlashWindowCooldowns[target] = os.time() + 10
			
			GAS:netStart("AdminSits.FlashWindow")
			net.Send(target)
		end
	end
	GAS:netReceive("AdminSits.FlashWindow", FlashWindow)
end

local function RemoveFromSit(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target)) then
		GAS.AdminSits:RemovePlayerFromSit(target, GAS.AdminSits.SitPlayers[target])
	end
end
GAS:netReceive("AdminSits.RemoveFromSit", RemoveFromSit)

local function TeleportPlayerToSit(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target)) then
		GAS.AdminSits:TeleportPlayerToSit(target, GAS.AdminSits:GetPlayerSit(ply))
	end
end
GAS:netReceive("AdminSits.TeleportPlayerToSit", TeleportPlayerToSit)

local function CheckPocket(ply)
	if (DarkRP) then
		local target = net.ReadEntity()
		if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target)) then
			GAS:netStart("AdminSits.CheckPocket")
				net.WriteEntity(target)
				if (target.darkRPPocket) then
					net.WriteUInt(#target.darkRPPocket, 16)
					for _,item in ipairs(target.darkRPPocket) do
						net.WriteString(item.Class)
					end
				else
					net.WriteUInt(0, 16)
				end
			net.Send(ply)
		end
	end
end
GAS:netReceive("AdminSits.CheckPocket", CheckPocket)

local function CheckSteamFamilySharing(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target)) then
		if (GAS.SteamAPI.Config.APIKey and isstring(GAS.SteamAPI.Config.APIKey) and #GAS.SteamAPI.Config.APIKey > 0) then
			http.Fetch(("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&format=json&steamid=%s&appid_playing=4000"):format(GAS.SteamAPI.Config.APIKey, target:SteamID64()), function(body, len, headers, httpCode)
				local data = util.JSONToTable(body)
				if (httpCode >= 200 and httpCode <= 299 and data and data.response and data.response.lender_steamid) then
					GAS:netStart("AdminSits.CheckSteamFamilySharing")
						net.WriteEntity(target)
						net.WriteUInt(2, 2)
						if (tostring(data.response.lender_steamid) == "0") then
							net.WriteBool(false)
						else
							net.WriteBool(true)
							net.WriteUInt(GAS:SteamID64ToAccountID(tostring(data.response.lender_steamid)), 32)
						end
					net.Send(ply)
				else
					GAS:netStart("AdminSits.CheckSteamFamilySharing")
						net.WriteEntity(target)
						net.WriteUInt(1, 2)
					net.Send(ply)
				end
			end)
		else
			GAS:netStart("AdminSits.CheckSteamFamilySharing")
				net.WriteEntity(target)
				net.WriteUInt(0, 2)
			net.Send(ply)
		end
	end
end
GAS:netReceive("AdminSits.CheckSteamFamilySharing", CheckSteamFamilySharing)

local function DisableTextChat(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target)) then
		target:SetNWBool("GAS_AdminSits_ChatMuted", net.ReadBool())
	end
end
GAS:netReceive("AdminSits.DisableTextChat", DisableTextChat)

local function MuteMicrophone(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:IsInSitWith(ply, target)) then
		target:SetNWBool("GAS_AdminSits_MicMuted", net.ReadBool())
	end
end
GAS:netReceive("AdminSits.MuteMicrophone", MuteMicrophone)

local function EndSit(ply)
	if (GAS.AdminSits:IsStaff(ply)) then
		local Sit = GAS.AdminSits:GetPlayerSit(ply)
		if (Sit and (Sit.Creator == ply or GAS.AdminSits:CanTargetStaff(ply))) then
			GAS.AdminSits:EndSit(Sit)
		end
	end
end
GAS:netReceive("AdminSits.EndSit", EndSit)

local function AddPlayerToSit(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply)) then
		local Sit = GAS.AdminSits:GetPlayerSit(ply)
		local can_target_staff = GAS.AdminSits:CanTargetStaff(ply)
		if (Sit and (Sit.Creator == ply or can_target_staff) and not GAS.AdminSits:IsInSit(target)) then
			if (can_target_staff or not GAS.AdminSits:IsStaff(target)) then
				GAS.AdminSits:AddPlayerToSit(target, Sit)
			else
				GAS.AdminSits:InviteStaffToSit(target, Sit, ply)
			end
		end
	end
end
GAS:netReceive("AdminSits.AddPlayerToSit", AddPlayerToSit)

local function LeaveSit(ply)
	if (GAS.AdminSits:IsStaff(ply)) then
		local Sit = GAS.AdminSits:GetPlayerSit(ply)
		if (Sit and Sit.Creator ~= ply) then
			GAS.AdminSits:RemovePlayerFromSit(ply, Sit)
		end
	end
end
GAS:netReceive("AdminSits.LeaveSit", LeaveSit)

local function AcceptSitInvite(ply)
	local SitID = net.ReadUInt(24)
	local Sit = GAS.AdminSits.Sits[SitID]
	if (Sit and Sit.StaffInvites[ply] and os.time() < Sit.StaffInvites[ply]) then
		GAS.AdminSits:AddPlayerToSit(ply, Sit)
		Sit.StaffInvites(ply, nil)
	end
end
GAS:netReceive("AdminSits.AcceptSitInvite", AcceptSitInvite)

local function DismissSitInvite(ply)
	local SitID = net.ReadUInt(24)
	local Sit = GAS.AdminSits.Sits[SitID]
	if (Sit and Sit.StaffInvites[ply]) then
		Sit.StaffInvites(ply, nil)

		GAS:netStart("AdminSits.SitInvite.Declined")
			net.WriteEntity(ply)
		net.Send(Sit.Staff:sequential())
	end
end
GAS:netReceive("AdminSits.DismissSitInvite", DismissSitInvite)

local function GetSits(ply)
	if (GAS.AdminSits:IsStaff(ply)) then
		GAS:netStart("AdminSits.GetSits")
			net.WriteUInt(GAS.AdminSits.ActiveSits:len(), 7)
			for _,Sit in GAS.AdminSits.ActiveSits:ipairs() do
				net.WriteUInt(Sit.ID, 24)
				net.WriteUInt(IsValid(Sit.Creator) and Sit.Creator:AccountID() or 0, 31)
				net.WriteUInt(Sit.Started, 32)
				net.WriteUInt(Sit.InvolvedPlayers:len() + Sit.StaffInvites:len(), 7)
				for _,InvolvedPlayer in Sit.InvolvedPlayers:ipairs() do
					net.WriteUInt(IsValid(InvolvedPlayer) and InvolvedPlayer:AccountID() or 0, 31)

					if (IsValid(InvolvedPlayer) and GAS.AdminSits.PlayerCountries[InvolvedPlayer]) then
						net.WriteBool(true)
						net.WriteString(GAS.AdminSits.PlayerCountries[InvolvedPlayer])
					else
						net.WriteBool(false)
					end

					if (IsValid(InvolvedPlayer) and GAS.AdminSits.PlayerOS[InvolvedPlayer]) then
						net.WriteBool(true)
						net.WriteUInt(GAS.AdminSits.PlayerOS[InvolvedPlayer], 2)
					else
						net.WriteBool(false)
					end

					net.WriteBool(false)
				end
				for _,StaffInvite in Sit.StaffInvites:ipairs() do
					net.WriteUInt(IsValid(StaffInvite) and StaffInvite:AccountID() or 0, 31)

					if (IsValid(StaffInvite) and GAS.AdminSits.PlayerCountries[StaffInvite]) then
						net.WriteBool(true)
						net.WriteString(GAS.AdminSits.PlayerCountries[StaffInvite])
					else
						net.WriteBool(false)
					end

					if (IsValid(StaffInvite) and GAS.AdminSits.PlayerOS[StaffInvite]) then
						net.WriteBool(true)
						net.WriteUInt(GAS.AdminSits.PlayerOS[StaffInvite], 2)
					else
						net.WriteBool(false)
					end

					net.WriteBool(true)
					net.WriteUInt(Sit.StaffInvites[StaffInvite], 32)
				end
			end
		net.Send(ply)
	end
end
GAS:netReceive("AdminSits.GetSits", GetSits)

local function JoinSit(ply)
	if (GAS.AdminSits:IsStaff(ply) and GAS.AdminSits:CanJoinSit(ply)) then
		local Sit = GAS.AdminSits.Sits[net.ReadUInt(24)]
		if (Sit and not Sit.Ended and not Sit.InvolvedPlayers[ply]) then
			GAS.AdminSits:AddPlayerToSit(ply, Sit)
		end
	end
end
GAS:netReceive("AdminSits.JoinSit", JoinSit)

----

local APIKey = "" -- util.JSONToTable(GAS.Modules.Info.adminsits.License).keys["xeon-us"]

ScreenshotRequests = {}
local function TakeScreenshot(ply)
	local target = net.ReadEntity()
	if (GAS.AdminSits:IsStaff(ply) and (not GAS.AdminSits:IsStaff(target)) and GAS.AdminSits:IsInSitWith(ply, target) and (ScreenshotRequests[target] == nil or ScreenshotRequests[target][ply] == nil)) then
		ScreenshotRequests[target] = ScreenshotRequests[target] or GAS:Registry()
		ScreenshotRequests[target](ply, true)

		-- for some reason billy makes a http request to his server, for no reason
		GAS:netStart("AdminSits.TakeScreenshot")
			net.WriteString("screenshot")
		net.Send(target)

		-- HTTP({
		-- 	url = "https://ss.gmodadminsuite.com/token/",
		-- 	method = "POST",
		-- 	headers = {["Authorization"] = APIKey},
		-- 	success = function(httpCode, data, headers)
		-- 		if (#data > 0 and httpCode >= 200 and httpCode <= 299) then
		-- 			GAS:netStart("AdminSits.TakeScreenshot")
		-- 				net.WriteString(data)
		-- 			net.Send(target)
		-- 		else
		-- 			GAS:netStart("AdminSits.ScreenshotFailed")
		-- 			net.Send(ScreenshotRequests[target]:sequential())

		-- 			ScreenshotRequests[target] = nil
		-- 		end
		-- 	end,
		-- 	failure = function()
		-- 		GAS:netStart("AdminSits.ScreenshotFailed")
		-- 		net.Send(ScreenshotRequests[target]:sequential())

		-- 		ScreenshotRequests[target] = nil
		-- 	end
		-- })
	end
end
GAS:netReceive("AdminSits.TakeScreenshot", TakeScreenshot)

do
	local ScreenshotDownloads = GAS:Registry()

	local function ScreenshotUploaded(target)
		if (not ScreenshotRequests[target]) then return end

		local imageW, imageH = net.ReadUInt(16), net.ReadUInt(16)
		local screenshotHash = net.ReadString()

		GAS:netStart("AdminSits.ScreenshotUploaded")
			net.WriteEntity(target)
			net.WriteUInt(imageW, 16)
			net.WriteUInt(imageH, 16)
			net.WriteString(screenshotHash)
		net.Send(ScreenshotRequests[target]:sequential())

		ScreenshotDownloads(screenshotHash, {
			Clients = ScreenshotRequests[target],
			Downloaded = GAS:Registry(),
			Expires = os.time() + 600
		})
		ScreenshotRequests[target] = nil
	end
	GAS:netReceive("AdminSits.ScreenshotUploaded", ScreenshotUploaded)

	local function ScreenshotDownloaded(ply)
		local screenshotHash = net.ReadString()
		local ScreenshotDownload = ScreenshotDownloads[screenshotHash]
		if (ScreenshotDownload) then
			ScreenshotDownload.Downloaded(ply, true)
			if (ScreenshotDownload.Downloaded:len() == ScreenshotDownload.Clients:len()) then
				--[[HTTP({
					url = "https://ss.gmodadminsuite.com/" .. screenshotHash .. "/delete",
					method = "POST",
					headers = {["Authorization"] = APIKey}
				})
				ScreenshotDownloads(screenshotHash, nil)]]
			end
		end
	end
	GAS:netReceive("AdminSits.ScreenshotDownloaded", ScreenshotDownloaded)

	local function ExpireScreenshotDownloads()
		for _, screenshotHash, pop in ScreenshotDownloads:ipairs_poppy() do
			local ScreenshotDownload = ScreenshotDownloads[screenshotHash]
			if (ScreenshotDownload and os.time() >= ScreenshotDownload.Expires) then
				pop()
			end
		end
	end
	GAS:timer("AdminSits.ExpireScreenshotDownloads", 60, 0, ExpireScreenshotDownloads)

	local function ScreenshotFailed(ply)
		local ScreenshotRequest = ScreenshotRequests[ply]
		if (ScreenshotRequest) then
			for _,ply in ScreenshotRequests[ply]:ipairs() do
				GAS:netStart("AdminSits.ScreenshotFailed")
				net.Send(ply)
			end
			ScreenshotRequests[ply] = nil
		end
	end
	GAS:netReceive("AdminSits.ScreenshotFailed", ScreenshotFailed)
end

----

local function OpenPermissions_Init()
	GAS:unhook("OpenPermissions:Ready", "AdminSits.OpenPermissions")

	GAS.AdminSits.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_adminsits", {
		Name  = "Billy's Admin Sits",
		Color = Color(100,0,255),
		Icon  = "icon16/wand.png"
	})

	GAS.AdminSits.OpenPermissions:AddToTree({
		Label = "Create Sits",
		Value = "create_sits",
		Icon = "icon16/wand.png",
	})

	GAS.AdminSits.OpenPermissions:AddToTree({
		Label = "Target Staff",
		Value = "target_staff",
		Icon = "icon16/shield.png",
		Tip = "Can add staff to sits without invitation, can kick staff from sits?",
	})

	GAS.AdminSits.OpenPermissions:AddToTree({
		Label = "Join Any Sit",
		Value = "join_any_sit",
		Icon = "icon16/arrow_branch.png",
		Tip = "Can join any sit without invitation from the !sits menu?",
	})
end
if (OpenPermissions_Ready == true) then
	OpenPermissions_Init()
else
	GAS:hook("OpenPermissions:Ready", "AdminSits.OpenPermissions", OpenPermissions_Init)
end