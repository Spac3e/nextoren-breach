include( "shared.lua" )

function ENT:Initialize()
	bg_self_unit = {}
end

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
	if remove == true then
		timer.Create("NukeTimer", time - 1, 1, function()
		net.Start("NukeReturn3")
   		net.SendToServer()
		end)
		--penis = true
	else
		net.Start("NukeReturn")
     		net.WriteString(timer.TimeLeft( "NukeTimer" ))
   		net.SendToServer()
		timer.Remove("NukeTimer")
	end
end)

function ENT:Draw()
   -- self:DrawModel() -- Draws Model Client Side
end

function ENT:Think(self)
	if timer.Exists( "NukeTimer" ) then
		net.Start("NukeReturn2")
     		net.WriteString(timer.TimeLeft( "NukeTimer" ))
   		net.SendToServer()
	end
end