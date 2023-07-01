--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/kk_ins2_pkpills.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if not pk_pills then return end

pk_pills.packStart("Insurgency 2","base","icon16/rainbow.png")

pk_pills.register("kk_ins2_f1",{
	printName="F1 grenade",
	type="phys",
	side="harmless",
	model="models/weapons/w_f1.mdl",
	default_rp_cost=1000,
	health=50,
	driveType="roll",
	driveOptions={
		power=300,
		jump=5000,
		burrow=6
	},
	attack={
		mode="trigger",
		func= function(ply,ent)
			ent:PillDie()
		end
	},
	diesOnExplode=true,
	die=function(ply,ent)
		local fx = ents.Create("cw_kk_ins2_particles")
		fx:processProjectile(ent)
		fx._initClass = "cw_kk_ins2_projectile_frag"
		fx:Spawn()

		util.BlastDamage(ent, ply, ent:GetPos(), 384, 100)
	end,
})

pk_pills.register("kk_ins2_m67",{
	printName="M67 grenade",
	type="phys",
	side="harmless",
	model="models/weapons/w_m67.mdl",
	default_rp_cost=1000,
	health=50,
	driveType="roll",
	driveOptions={
		power=300,
		jump=5000,
		burrow=6
	},
	attack={
		mode="trigger",
		func= function(ply,ent)
			ent:PillDie()
		end
	},
	diesOnExplode=true,
	die=function(ply,ent)
		local fx = ents.Create("cw_kk_ins2_particles")
		fx:processProjectile(ent)
		fx._initClass = "cw_kk_ins2_projectile_frag"
		fx:Spawn()

		util.BlastDamage(ent, ply, ent:GetPos(), 384, 100)
	end,
})
