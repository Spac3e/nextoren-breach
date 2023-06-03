AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheSound( "nextoren/scp/914/refining.ogg" )

function ENT:Initialize()



	for k,ball in pairs(ents.FindInSphere(Vector(9496, -4767, 61), 16)) do
        if IsValid(ball) then
            if ball:GetModel() != "models/next_breach/gas_monitor.mdl" then
			
				ball:Remove()

			end
        end
    end

	scp_914_r_status = "Rough"

	util.AddNetworkString( "914_OPEN_MENU" )
	util.AddNetworkString( "914_edit_status" )
	util.AddNetworkString( "914_status" )
	util.AddNetworkString( "914_run" )

	self:SetModel( "models/next_breach/gas_monitor.mdl" )
	--self:PhysicsInit( SOLID_BBOX )
	--self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetPos(Vector(9497, -4767, 61))
	self:SetAngles(Angle(0,90,0))
	self:SetModelScale( self:GetModelScale() * 1.25, 0 )

	delay_open_914 = 0
	delay_status_914 = 0
	scp_914_spawn_item = "breach_keycard_1"
	scp_914_result_key = "breach_keycard_1"

end

-- https://wiki.facepunch.com/gmod/GM:PostPlayerDraw

local function easedLerp(fraction, from, to)
	return LerpVector(math.ease.InSine(fraction), from, to)
end

function ENT:Use( activator, caller )

	if CurTime() < delay_open_914 then return end

	local ply = activator

    net.Start( "914_OPEN_MENU" )
    net.WriteEntity( ply )
    net.Broadcast()

	delay_open_914 = CurTime() + 5

	--print(heli_hui)
	--timer.Create( "tolkatel_heli", 2, 0, function() self:SetPos(Vector(heli_hui)) end )
end
 
net.Receive( "914_edit_status", function()

	local ply = net.ReadEntity()
    scp_914_r_status = net.ReadString()
	print(scp_914_r_status)
    
end)

net.Receive( "914_run", function()
    
	visual_work()

end)



function fackt_work()





	local entsinbox = ents.FindInBox( Vector( 9553, -4481, 4 ), Vector( 9614, -4606, 125 ) ) 
    for k, v in ipairs( entsinbox ) do

		if v:GetClass() != "func_door" and v:GetClass() != "prop_dynamic" then

		local hui = v:GetClass()

		local get_br_key = hui
		local get_br_key_id = string.len( get_br_key )
		key_scp_914_id = string.sub( get_br_key, get_br_key_id, get_br_key_id + 1  )
		key_scp_914_name = string.sub( get_br_key, 1, get_br_key_id - 1  )

		if scp_914_r_status == "ry Fine" then

			if get_br_key == "breach_keycard_5" then

				scp_914_spawn_item = "breach_keycard_1"

			end

			if get_br_key == "breach_keycard_guard_4" then

				scp_914_spawn_item = "breach_keycard_guard_1"

			end

			if get_br_key == "breach_keycard_guard_4" then

				scp_914_spawn_item = "breach_keycard_guard_1"

			end

			if get_br_key == "breach_keycard_sci_4" then

				scp_914_spawn_item = "breach_keycard_sci_1"

			end

			if get_br_key == "breach_keycard_security_4" then

				scp_914_spawn_item = "breach_keycard_security_1"

			end

			print("хуй ",key_scp_914_id)

			scp_914_result_key = (key_scp_914_name..(key_scp_914_id + 1))

		elseif scp_914_r_status == "ne" then

			scp_914_result_key = (key_scp_914_name..(key_scp_914_id + 1))

			if get_br_key == "breach_keycard_5" then

				scp_914_spawn_item = "breach_keycard_1"

			end

			if get_br_key == "breach_keycard_guard_4" then

				scp_914_spawn_item = "breach_keycard_guard_1"

			end

			if get_br_key == "breach_keycard_guard_4" then

				scp_914_spawn_item = "breach_keycard_guard_1"

			end

			if get_br_key == "breach_keycard_sci_4" then

				scp_914_spawn_item = "breach_keycard_sci_1"

			end

			if get_br_key == "breach_keycard_security_4" then

				scp_914_spawn_item = "breach_keycard_security_1"

			end

		elseif scp_914_r_status == "arse" then

			scp_914_result_key = (key_scp_914_name..(key_scp_914_id - 1))

		elseif scp_914_r_status == "ugh" then

			scp_914_result_key = (key_scp_914_name..(key_scp_914_id - 2))

		end

		--print(key_scp_914_id)
		local wep = string.sub( hui, 1, 15 )
		if wep == "breach_keycard_" then

			scp_914_spawn_item = scp_914_result_key

			print(scp_914_spawn_item)

			local get_br_key_id1 = string.len( scp_914_spawn_item )
			key_scp_914_id1 = string.sub( scp_914_result_key, get_br_key_id1, get_br_key_id1 + 1  )

			print(key_scp_914_id1)

			if (key_scp_914_id1 > "0") and (key_scp_914_id1 < "6") then 
			
				local spawn_item = ents.Create( scp_914_spawn_item )
				spawn_item:SetPos( Vector( 9585, -4979, 66 ) )
				spawn_item:Spawn()

			else
				local spawn_item = ents.Create( "breach_keycard_1" )
				spawn_item:SetPos( Vector( 9585, -4979, 66 ) )
				spawn_item:Spawn()
			end

		end
		v:Remove()
        v:TakeDamage("5000")

		end
    end

end

function visual_work()

	--EmitSound("nextoren/scp/914/refining.ogg")
	--EmitSound( "nextoren/scp/914/refining.ogg", Vector(9566, -4769, 88), 1, CHAN_AUTO, 1, 75, 0, 100 )
	sound.Play( "nextoren/scp/914/refining.ogg", Vector(9566, -4769, 88) )

	timer.Simple( 2, function()

	for k,ball in pairs(ents.FindInSphere((Vector(9544, -4556, 66)), 50)) do
        if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Close") end
        end
    end

	for k,ball in pairs(ents.FindInSphere((Vector(9543, -5004, 66)), 50)) do
        if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Close") end
        end
    end

	end)

	timer.Simple( 13, function()

	fackt_work()

	for k,ball in pairs(ents.FindInSphere((Vector(9544, -4556, 66)), 15)) do
        if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Open") end
        end
    end

	for k,ball in pairs(ents.FindInSphere((Vector(9543, -5004, 66)), 15)) do
        if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Open") end
        end
    end

	end)

end

function ENT:Think()

end