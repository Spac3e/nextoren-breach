--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/entity_goc_nuke/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include( "shared.lua" )

--[[
net.Receive( "TurnSound", function()

	local time = net.ReadUInt( 8 )
	local sound = net.ReadString()

	timer.Create( "NukeTimer", time - 1, 1, function() end)

	surface.PlaySound( sound )

end)]]

net.Receive("AlphaWarheadTimer_CLIENTSIDE", function()
	local time = tonumber(net.ReadString())
	local remove = net.ReadBool()
	if !remove then
		timer.Create("NukeTimer", time - 1, 1, function() end)
	else
		timer.Remove("NukeTimer")
	end
end)

function ENT:Draw()
    --self:DrawModel() -- Draws Model Client Side
end