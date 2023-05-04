
net.Receive( "OpenInventory", function()

	local victimstable = net.ReadTable()

	ShowEQ( false, victimstable )

	local client = LocalPlayer()

	if ( !client.MovementLocked ) then

		client.MovementLocked = true

	end

end )

net.Receive( "ParticleAttach", function()

	local particle_name = net.ReadString()
	local attach_entity = net.ReadEntity()
	local bone_id = net.ReadUInt( 4 )

	ParticleEffectAttach( particle_name, PATTACH_POINT_FOLLOW, attach_entity, bone_id || 3 )

end )
