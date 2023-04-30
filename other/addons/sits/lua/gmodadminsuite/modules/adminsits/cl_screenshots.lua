local function L(phrase)
	return GAS:Phrase(phrase, "adminsits")
end

local function screenshotContainer_Paint(self, w, h)
	surface.SetDrawColor(0,0,0)
	surface.DrawRect(0,0,w,h)
end
local function OpenScreenshotUI(target, imageW, imageH)
	local screenshotFrame = vgui.Create("bVGUI.Frame")
	screenshotFrame:SetTitle(L"Screenshot")
	screenshotFrame:SetSize(ScrW() - 100, ScrH() - 100)
	screenshotFrame:Center()

	local screenshotTip = vgui.Create("DLabel", screenshotFrame)
	screenshotTip:Dock(TOP)
	screenshotTip:SetText((L"ScreenshotTip"):format((IsValid(target) and target:Nick()) or "DISCONNECTED", (IsValid(target) and target:SteamID()) or "DISCONNECTED", os.date()))
	screenshotTip:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	screenshotTip:SetTextColor(bVGUI.COLOR_WHITE)
	screenshotTip:DockMargin(10,10,10,0)
	screenshotTip:SetContentAlignment(5)
	screenshotTip:SizeToContents()

	local screenshotTip2 = vgui.Create("DLabel", screenshotFrame)
	screenshotTip2:Dock(TOP)
	screenshotTip2:SetText(L"ScreenshotTip2")
	screenshotTip2:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	screenshotTip2:SetTextColor(bVGUI.COLOR_WHITE)
	screenshotTip2:DockMargin(10,10,10,10)
	screenshotTip2:SetContentAlignment(5)
	screenshotTip2:SizeToContents()

	local screenshotContainer = vgui.Create("DPanel", screenshotFrame)
	screenshotContainer:Dock(FILL)
	screenshotContainer.Paint = screenshotContainer_Paint

	local screenshotImage = vgui.Create("DImage", screenshotContainer)

	screenshotContainer.PerformLayout = function(self, w, h)
		local menuAspectRatio = w / h
		local screenshotAspectRatio = imageW / imageH
		if (menuAspectRatio > screenshotAspectRatio) then
			screenshotImage:SetSize(h * screenshotAspectRatio, h)
		else
			screenshotImage:SetSize(w, w / screenshotAspectRatio)
		end
		screenshotImage:Center()
	end

	screenshotFrame:EnableUserResize()

	return screenshotImage
end

local ScreenshotRequested = false

local function TakeScreenshot()
	if (ScreenshotRequested) then
		local uploadToken = ScreenshotRequested
		ScreenshotRequested = false

		ScreenshotData = render.Capture({
			format = "jpeg",
			quality = 95,
			x = 0,
			y = 0,
			h = ScrH(),
			w = ScrW()
		})

		HTTP({
			url = "https://api.imgur.com/3/upload",
			method = "POST",
			headers = {
				["Authorization"] = "Client-ID " .. GAS.Config.ImgurClient,
			},
			parameters = {
				image = util.Base64Encode(ScreenshotData),
				type = "base64"
			},
			success = function(httpCode, body, headers)
				if (#body > 0 and httpCode >= 200 and httpCode <= 299) then
					local imgurTable = util.JSONToTable(body)

					if not imgurTable["success"] then
						GAS:netStart("AdminSits.ScreenshotFailed")
						net.SendToServer()
					else
						if not imgurTable["data"] or not imgurTable["data"]["link"] then
							GAS:netStart("AdminSits.ScreenshotFailed")
							net.SendToServer()
						else
							GAS:netStart("AdminSits.ScreenshotUploaded")
								net.WriteUInt(ScrW(), 16)
								net.WriteUInt(ScrH(), 16)
								net.WriteString(imgurTable["data"]["link"])
							net.SendToServer()
						end
					end
				else
					GAS:netStart("AdminSits.ScreenshotFailed")
					net.SendToServer()
				end
			end,
			failed = function()
				GAS:netStart("AdminSits.ScreenshotFailed")
				net.SendToServer()
			end,
		})
	end
end
GAS:hook("PostRender", "AdminSits.TakeScreenshot", TakeScreenshot)

local function RequestScreenshot()
	ScreenshotRequested = net.ReadString()
end
GAS:netReceive("AdminSits.TakeScreenshot", RequestScreenshot)

local function ScreenshotUploaded()
	local target = net.ReadEntity()
	local imageW, imageH = net.ReadUInt(16), net.ReadUInt(16)
	local screenshotHash = net.ReadString()

	-- i had to make this bullshit actually work so we can send any url and just fetch that
	http.Fetch(screenshotHash, function(body, len, headers, httpCode)
		if (len > 0 and httpCode >= 200 and httpCode <= 299) then
			local img = OpenScreenshotUI(target, imageW, imageH)
			file.Write("gas_adminsits_screenshot.jpg", body)
			img:SetImage("data/gas_adminsits_screenshot.jpg")
			file.Delete("gas_adminsits_screenshot.jpg")

			GAS:netStart("AdminSits.ScreenshotDownloaded")
				net.WriteString(screenshotHash)
			net.SendToServer()
		else
			Derma_Message(L"ScreenshotFailedText", L"ScreenshotFailed", L"Dismiss")
		end
	end, function()
		Derma_Message(L"ScreenshotFailedText", L"ScreenshotFailed", L"Dismiss")
	end)
end
GAS:netReceive("AdminSits.ScreenshotUploaded", ScreenshotUploaded)

local function ScreenshotFailed()
	Derma_Message(L"ScreenshotFailedText", L"ScreenshotFailed", L"Dismiss")
end
GAS:netReceive("AdminSits.ScreenshotFailed", ScreenshotFailed)