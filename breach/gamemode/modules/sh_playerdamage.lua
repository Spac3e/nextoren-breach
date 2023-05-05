

local stomach_hit = {



	[ HITGROUP_STOMACH ] = true,

	[ HITGROUP_CHEST ] = true,

	[ HITGROUP_LEFTARM ] = true,

	[ HITGROUP_RIGHTARM ] = true



}



function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )



	local attacker = dmginfo:GetAttacker()

	local dmgtype = dmginfo:GetDamageType()



	if ( ply:Team() != TEAM_SCP && !( ply:GetNClass():find( "jag" ) || ply:GetNClass():find( "jug" ) ) ) then



		if ( hitgroup == HITGROUP_HEAD ) then



			if ( ply.HasHelmet ) then



				if ( SERVER ) then



					ply.MaxHitsHelmet = ply.MaxHitsHelmet - 1



					if ( ( ply.MaxHitsHelmet || 0 ) <= 0 ) then



						ply.MaxHitsHelmet = nil

						ply.HasHelmet = nil



						if ( ply.BoneMergedEnts && istable( ply.BoneMergedEnts ) ) then



							for _, v in ipairs( ply.BoneMergedEnts ) do



								if ( v && v:IsValid() && v:GetModel() == ply.Bonemergetoremove ) then



									v:Remove()



									ply.Bonemergetoremove = nil



								end



							end



						end



					end



				end



				dmginfo:ScaleDamage( .5 )



			else



				dmginfo:ScaleDamage( 9 )



			end



		elseif ( stomach_hit[ hitgroup ] ) then



			if ( ply.HasArmor ) then



				if ( ply.MaxHitsArmor ) then



					ply.MaxHitsArmor = ply.MaxHitsArmor - 1



				end



				if ( ( ply.MaxHitsArmor || 0 ) <= 0 ) then



					ply.MaxHitsArmor = nil

					ply.HasArmor = nil



					for _, v in ipairs( ply.BoneMergedEnts ) do



						if ( v && v:IsValid() && v:GetModel() == ply.Bonemergetoremove_armor ) then



							v:Remove()



							ply.Bonemergetoremove_armor = nil



						end



					end



				end



				dmginfo:ScaleDamage( .7 )



			else



				dmginfo:ScaleDamage( 1.5 )



			end



		end



	end



	if ( ply.ScaleTypeDamage && ply.ScaleTypeDamage[ dmginfo:GetDamageType() ] ) then



		dmginfo:ScaleDamage( ply.ScaleTypeDamage[ dmginfo:GetDamageType() ] )



	end



	if ( attacker:IsPlayer() ) then



		if ( attacker.CantKillAnyone ) then



			dmginfo:ScaleDamage( 0 )



			return

		end



		local wep = attacker:GetActiveWeapon()



		if ( attacker:Team() == TEAM_GOC && ( wep && wep:IsValid() ) && wep.Primary.Ammo == "GOC" && ply:Team() == TEAM_SCP ) then



			dmginfo:SetDamage( dmginfo:GetDamage() * 1.25 )



		end



	end



end



hook.Add("ScalePlayerDamage", "Flinch", function(ply, grp)



	if ( ply:IsPlayer() ) then

		local group = nil

		hitpos = {

			[HITGROUP_HEAD] = { "flinch_head_01", "flinch_head_02" },

			[HITGROUP_CHEST] = { "flinch_phys_01", "flinch_phys_02" },

			[HITGROUP_STOMACH] = { "flinch_stomach_01", "flinch_stomach_02" },

			[HITGROUP_LEFTARM] = "flinch_shoulder_l",

			[HITGROUP_RIGHTARM] = "flinch_shoulder_r",

			[HITGROUP_LEFTLEG] = ply:GetSequenceActivity(ply:LookupSequence("flinch_01")),

			[HITGROUP_RIGHTLEG] = ply:GetSequenceActivity(ply:LookupSequence("flinch_02"))

		}

	end



	if ( !hitpos[grp] ) then return end



	if ( istable( hitpos[grp] ) ) then



		group = ply:LookupSequence( table.Random( hitpos[grp] ) )



	else



		group = ply:LookupSequence( hitpos[grp] )



	end





	--[[if hitpos[grp] == nil then

    group = ACT_FLINCH_PHYSICS

  else

    group = hitpos[grp]

  end]]



	--print( group )



	if ( SERVER ) then



		net.Start( "BreachFlinch" )



			net.WriteEntity( ply )



		net.Send( ply )



	end



end)

