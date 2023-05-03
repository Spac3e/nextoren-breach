--[[-------------------------------------------------------------------------

								READ CAREFULLY!

Now to add SCP you have to call RegisterSCP() inside 'RegisterSCP' hook
Therefore if you only want to add SCPs, you don't have to reupload gamemode! Use hook instead and
place files in 'lua/autorun/server/'!


Basic infotmations about RegisterSCP():
	

	RegisterSCP( name, model, weapon, static_stats, dynamic_stats, callback, post_callback )


		name (String) - name of SCP, it will be used by most things. This function will automatically add
			every necessary variablesso you no longer have to care about ROLES table(function will
			create ROLES.ROLE_name = name). Funtion will look for valid language and spawnpos entries
			(for language: english.ROLES.ROLE_name and english.starttexts.ROLE_name, for
			spawnpos: SPAWN_name = Vector or Table of vectors). Function will throw error if something
			is wrong(See errors section below)


		model (String) - full path to model. If you put wrong path you will see error instead of model!


		weapon (String) - SWEP call name. If you put wrong name your scp will not receive weapon and you
			will see red error in console


		static_stats (Table) - this table contain important entries for your SCP. Things specified inside
			this table are more important than dynamic_stats, so it will overwrite them. These stats cannot
			be changed in 'scp.txt' file. This table cotains keys and values(key = "value"). List of valid keys is below.


		dynamic_stats (Table) - this table contains entries for your SCP that can be accessed and changed in
			'garrysmod/data/breach/scp.txt' file. So everybody can customize them. These stats will be overwritten
			by statc_stats. This table cotains keys and values(key = "value") or tables that contains value and
			clamping info(num values only!)(key = "value" or key = { var = num_value, max = max_value, min = minimum_value }).
			List of valid keys is below. 

					Valid entreis for static_stats and dynamic_stats:
							base_speed - walk speed
							run_speed - run speed
							max_speed - maximum speed
							base_health - starting health
							max_health - maximum health
							jump_power - jump power
							crouch_speed - crouched walk speed
							no_ragdoll - if true, rgdoll will not appear
							model_scale - scale of model
							hands_model - model of hands
							prep_freeze - if true, SCP will not be able to move during preparing
							no_spawn - position will not be changed
							no_model - model will not be changed
							no_swep - SCP won't have SWEP
							no_strip - player EQ won't be stripped
							no_select - SCP won't appear in game


		callback (Function) - called on beginning of SetupPlayer return true to override default actions(post callback will not be called).
			function( ply, basestats, ... ) - 3 arguments are passed:
				ply - player
				basestats - result of static_stats and dynamic_stats
				... - (varargs) passsed from SetupPlayer
		

		post_callback (Function) - called on end of SetupPlayer. Only player is passed as argument:
			function( ply )
				ply - player


To get registered SCP:
		GetSCP( name ) - global function that returns SCP object
			arguments:
				name - name of SCP(same as used in RegisterSCP)

			return:
				ObjectSCP - (explained below)

	ObjectSCP:
		functions:
			ObjectSCP:SetCallback( callback, post ) - used internally by RegisterSCP. Sets callback, if post == true, sets post_callback

			ObjectSCP:SetupPlayer( ply, ... ) - use to set specified player as SCP.
					ply - player who become SCP
					... - varargs passed to callback if ObjectSCP has one

---------------------------------------------------------------------------]]

hook.Add( "RegisterSCP", "RegisterBaseSCPs", function()

	RegisterSCP( "SCP049", "models/cultist/scp/scp_049.mdl", "weapon_scp_049_redux", {
		jump_power = 200,
	}, {
		base_health = 1600,
		max_health = 1600,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP0492", "models/cultist/scp/scp_049_2.mdl", "weapon_scp_049_2_1", {
		jump_power = 200,
		no_spawn = true,
		no_select = true,
	}, {
		base_health = 750,
		max_health = 750,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
		WinCheck()
	end )


	RegisterSCP( "SCP076", "models/cultist/scp/scp_076.mdl", "weapon_scp_076", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 300,
		max_health = 300,
		base_speed = 220,
		run_speed = 220,
		max_speed = 220,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP082", "models/cultist/scp/scp_082.mdl", "weapon_scp_082", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2300,
		max_health = 2800,
		base_speed = 160,
		run_speed = 160,
		max_speed = 160,
	}, nil, function( ply )
	end )

	RegisterSCP( "SCP096", "models/cultist/scp/scp_096.mdl", "weapon_scp_096", {
		jump_power = 200,
	}, {
		base_health = 1750,
		max_health = 1750,
		base_speed = 120,
		run_speed = 500,
		max_speed = 500,
	} )

	RegisterSCP( "SCP106", "models/cultist/scp/scp_106.mdl", "weapon_scp_106", {
		jump_power = 200,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 170,
		run_speed = 170,
		max_speed = 170,
	} )
	RegisterSCP( "SCP062DE", "models/cultist/scp/scp_062de.mdl", "cw_kk_ins2_kar62de", {
		jump_power = 200,
	}, {
		base_health = 1000,
		max_health = 1200,
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
		base_health = 2000,
		max_health = 2000,
		base_speed = 120,
		run_speed = 275,
		max_speed = 275,
	} )
	RegisterSCP( "SCP939", "models/cultist/scp/scp_939.mdl", "weapon_scp_939", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 190,
		run_speed = 190,
		max_speed = 190,
	} )
	RegisterSCP( "SCP062FR", "models/cultist/scp/scp_062fr.mdl", "weapon_scp_062", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 190,
		run_speed = 190,
		max_speed = 190,
	} )
	RegisterSCP( "SCP966", "models/cultist/scp/scp_966.mdl", "weapon_scp_966", {
		jump_power = 200,
	}, {
		base_health = 800,
		max_health = 800,
		base_speed = 140,
		run_speed = 140,
		max_speed = 140,
	} )

	RegisterSCP( "SCP999", "models/cultist/scp/scp_999.mdl", "weapon_scp_999", {
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
		prep_freeze = true,
	}, {
		base_health = 1500,
		max_health = 1500,
		base_speed = 135,
		run_speed = 135,
		max_speed = 135,
	} )

	RegisterSCP( "SCP2012", "models/cultist/scp/scp2012/scp_2012.mdl", "weapon_scp_2012", {
		jump_power = 200,
		prep_freeze = true,
	}, {
		base_health = 2000,
		max_health = 2000,
		base_speed = 165,
		run_speed = 165,
		max_speed = 165,
	} )

	RegisterSCP( "SCP973", "models/cultist/scp/scp_973/scp_973.mdl", "weapon_scp_973", {
		jump_power = 0,
		prep_freeze = true,
	}, {
		base_health = 2500,
		max_health = 2500,
		base_speed = 160,
		run_speed = 325,
		max_speed = 160,
	} )
end )

