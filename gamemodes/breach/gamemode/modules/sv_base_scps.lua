hook.Add( "RegisterSCP", "RegisterBaseSCPs", function()

	RegisterSCP( "SCP049", "models/cultist/scp/scp_049.mdl", "weapon_scp_049_redux", {
		jump_power = 200,
	}, {
		base_health = 2200,
		max_health = 2200,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP076", "models/cultist/scp/scp_076.mdl", "weapon_scp_076", {
		jump_power = 200,
	}, {
		base_health = 1100,
		max_health = 1100,
		base_speed = 220,
		run_speed = 220,
		max_speed = 220,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP082", "models/cultist/scp/scp_082.mdl", "weapon_scp_082", {
		jump_power = 200,
	}, {
		base_health = 2400,
		max_health = 2400,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP1903", "models/cultist/scp/scp_1903.mdl", "weapon_scp_1903", {
		jump_power = 200,
	}, {
		base_health = 2400,
		max_health = 2400,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP096", "models/cultist/scp/scp_096.mdl", "weapon_scp096", {
		jump_power = 200,
	}, {
		base_health = 1450,
		max_health = 1450,
		base_speed = 120,
		run_speed = 500,
		max_speed = 500,
	} )

	RegisterSCP( "SCP106", "models/cultist/scp/scp_106.mdl", "weapon_scp_106", {
		jump_power = 200,
	}, {
		base_health = 1600,
		max_health = 1600,
		base_speed = 170,
		run_speed = 170,
		max_speed = 170,
	} )
	RegisterSCP( "SCP062DE", "models/cultist/scp/scp_062de.mdl", "cw_kk_ins2_kar62de", {
		jump_power = 200,
	}, {
		base_health = 3200,
		max_health = 3200,
		base_speed = 170,
		run_speed = 170,
		max_speed = 170,
	} )
	RegisterSCP( "SCP173", "models/cultist/scp/173.mdl", "weapon_scp_173", {
		jump_power = 200,
		no_ragdoll = true,
	}, {
		base_health = 3000,
		max_health = 3000,
		base_speed = 400,
		run_speed = 400,
		max_speed = 400,
	} )

	RegisterSCP( "SCP457", "models/cultist/scp/scp_457.mdl", "weapon_scp_457", {
		jump_power = 200,
		//no_draw = true,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP682", "models/cultist/scp/scp_682.mdl", "weapon_scp_682", {
		jump_power = 200,
		no_ragdoll = true,
	}, {
		base_health = 6800,
		max_health = 6800,
		base_speed = 120,
		run_speed = 275,
		max_speed = 275,
	} )

	RegisterSCP( "SCP811", "models/cultist/scp/scp_811.mdl", "weapon_scp_811", {
		jump_power = 200,
	}, {
		base_health = 3200,
		max_health = 3200,
		base_speed = 120,
		run_speed = 275,
		max_speed = 275,
	} )

	RegisterSCP( "SCP939", "models/cultist/scp/scp_939.mdl", "weapon_scp_939", {
		jump_power = 200,
	}, {
		base_health = 3200,
		max_health = 3200,
		base_speed = 190,
		run_speed = 190,
		max_speed = 190,
	} )
	RegisterSCP( "SCP062FR", "models/cultist/scp/scp_062fr.mdl", "weapon_scp_062", {
		jump_power = 200,
	}, {
		base_health = 2600,
		max_health = 2600,
		base_speed = 190,
		run_speed = 190,
		max_speed = 190,
	} )
	RegisterSCP( "SCP999", "models/cultist/scp/scp_999_new.mdl", "weapon_scp_999", {
		jump_power = 200,
	}, {
		base_health = 1000,
		max_health = 1000,
		base_speed = 150,
		run_speed = 150,
		max_speed = 150,
	} )

	RegisterSCP( "SCP542", "models/cultist/scp/scp_542.mdl", "weapon_scp_542", {
		jump_power = 200,
	}, {
		base_health = 2100,
		max_health = 2100,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP2012", "models/shaky/scp/scp2012/scp_2012.mdl", "weapon_scp_2012", {
		jump_power = 200,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 165,
		run_speed = 165,
		max_speed = 165,
	} )
	RegisterSCP( "SCP638", "models/cultist/scp/scp638/scp_638.mdl", "weapon_scp_638", {
		jump_power = 200,
	}, {
		base_health = 2300,
		max_health = 2300,
		base_speed = 165,
		run_speed = 165,
		max_speed = 165,
	} )
	RegisterSCP( "SCP912", "models/cultist/scp/scp_912.mdl", "weapon_scp_912", {
		jump_power = 200,
	}, {
		base_health = 1000,
		max_health = 1000,
		base_speed = 165,
		run_speed = 165,
		max_speed = 165,
	} )
	RegisterSCP( "SCP973", "models/cultist/scp/scp_973/scp_973.mdl", "weapon_scp_973", {
		jump_power = 0,
	}, {
		base_health = 2700,
		max_health = 2700,
		base_speed = 160,
		run_speed = 325,
		max_speed = 160,
	} )
	RegisterSCP( "SCP8602", "models/cultist/scp/scp_860.mdl", "weapon_scp_860", {
		jump_power = 0,
	}, {
		base_health = 2700,
		max_health = 2700,
		base_speed = 160,
		run_speed = 325,
		max_speed = 160,
	} )
end )

