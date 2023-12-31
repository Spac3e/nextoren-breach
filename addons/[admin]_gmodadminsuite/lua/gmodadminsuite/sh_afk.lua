--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/sh_afk.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

GAS.AFK = {}
GAS.AFK.AFKTime = GAS.Config.AFKTime

if (SERVER) then

	GAS_AFK_PlayerPositions = GAS_AFK_PlayerPositions or {}
	GAS_AFK_PlayerLastMoved = GAS_AFK_PlayerLastMoved or {}

	function GAS.AFK:SetAFK(ply, is_afk, pos_signature)
		if (is_afk) then
			if (not ply.GAS_PlayerAFK) then
				ply.GAS_PlayerAFK = true
				ply:SetNWBool("GAS_PlayerAFK", true)
				hook.Run("GAS:AFK", ply)
			end
		else
			GAS_AFK_PlayerLastMoved[ply] = os.time()
			GAS_AFK_PlayerPositions[ply] = pos_signature
			if (ply.GAS_PlayerAFK) then
				ply.GAS_PlayerAFK = false
				ply:SetNWBool("GAS_PlayerAFK", false)
				hook.Run("GAS:UnAFK", ply)
			end
		end
	end

	GAS:timer("afk:update_player_positions", 5, 0, function()
		for _,ply in ipairs(player.GetHumans()) do
			local pos = ply:GetPos()
			local pos_signature = math.Round(pos.x) + math.Round(pos.y) + math.Round(pos.z)
			if (GAS_AFK_PlayerLastMoved[ply]) then
				if (pos_signature ~= GAS_AFK_PlayerPositions[ply]) then
					GAS.AFK:SetAFK(ply, false, pos_signature)
				elseif (os.time() - GAS_AFK_PlayerLastMoved[ply] >= GAS.AFK.AFKTime) then
					GAS.AFK:SetAFK(ply, true)
				end
			end
		end
	end)

	GAS:hook("PlayerInitialSpawn", "afk:PlayerInitialSpawn", function(ply)
		if (ply:IsBot()) then return end
		ply.GAS_PlayerAFK = true

		ply:SetNWBool("GAS_PlayerAFK", true)
	end)

	GAS:netInit("afk:InitPostEntity")
	GAS:netReceive("afk:InitPostEntity", function(ply)
		local pos = ply:GetPos()
		local pos_signature = math.Round(pos.x) + math.Round(pos.y) + math.Round(pos.z)
		GAS_AFK_PlayerLastMoved[ply] = os.time()
		GAS_AFK_PlayerPositions[ply] = pos_signature
	end)

else

	GAS:InitPostEntity(function()
		GAS:netStart("afk:InitPostEntity")
		net.SendToServer()
	end)

end

function GAS.AFK:IsAFK(ply)
	return ply.GAS_PlayerAFK or ply:GetNWBool("GAS_PlayerAFK", true)
end