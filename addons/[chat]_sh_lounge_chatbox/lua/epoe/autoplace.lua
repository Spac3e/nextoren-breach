--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[chat]_sh_lounge_chatbox/lua/epoe/autoplace.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local epoe_autoplace = CreateClientConVar("epoe_autoplace", 0, true, false)
local epoe_autoplace_margin = CreateClientConVar("epoe_autoplace_margin", 0, true, false)
local epoe_autoplace_scale_x = CreateClientConVar("epoe_autoplace_scale_x", 0.5, true)
local epoe_autoplace_scale_y = CreateClientConVar("epoe_autoplace_scale_y", 0.25, true)

timer.Create("epoe_autoplace", 1, 0, function()
	if not epoe or not IsValid(epoe.GUI) then return end
	local place = math.floor(epoe_autoplace:GetFloat() or 0)
	if place < 1 or place > 9 then return end
	epoe.GUI:SetSize(surface.ScreenWidth() * epoe_autoplace_scale_x:GetFloat(), surface.ScreenHeight() * epoe_autoplace_scale_y:GetFloat())
	local margin = math.floor(epoe_autoplace_margin:GetFloat() or 0)
	local x, y = (place - 1) % 3 / 2, math.floor((place - 1) / 3) % 3 / 2
	local width, height = epoe.GUI:GetSize()
	local offset_x, offset_y = surface.ScreenWidth() - width - margin * 2, surface.ScreenHeight() - height - margin * 2
	epoe.GUI:SetPos(margin + offset_x * x, margin + offset_y * y)
end)
