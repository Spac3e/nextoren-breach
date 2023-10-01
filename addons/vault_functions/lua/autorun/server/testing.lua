function GetRoleResists(ply, hit_group)
    if hit_group == "head" then
        return ply.HeadResist
    elseif hit_group == "gear" then
        return ply.GearResist
    elseif hit_group == "stomach" then
        return ply.StomachResist
    elseif hit_group == "arm" then
        return ply.ArmResist
    elseif hit_group == "leg" then
        return ply.LegResist
    else
        return ply.HeadResist, ply.GearResist, ply.StomachResist, ply.ArmResist, ply.LegResist
    end
end

function GM:EntityTakeDamage(ply,dmg)
	if ply:IsPlayer() then
		ply:AddEFlags( -2147483648 )
	else
		ply:RemoveEFlags( -2147483648 )
	end
end

local stomach_hit = {
	[ HITGROUP_STOMACH ] = true,
	[ HITGROUP_CHEST ] = true,
	[ HITGROUP_LEFTARM ] = true,
	[ HITGROUP_RIGHTARM ] = true
}

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
	if (SERVER) then
		net.Start( "BreachFlinch" )
			net.WriteEntity(ply)
		net.Send(ply)
	end
end)

hook.Add("ScalePlayerDamage", "Megadamage", function(ply,dmginfo)
    local attacker = dmginfo:GetAttacker()
    local dmgtype = dmginfo:GetDamageType()
    local wep = attacker:GetActiveWeapon()
	    if ( ply:GTeam() != TEAM_SCP && !( ply:GetRoleName():find( "jag" ) || ply:GetRoleName():find( "jug" ) ) ) then
        if ( hitgroup == HITGROUP_HEAD ) then
            if ( ply:GetUsingHelmet() != "" ) then
                if ( SERVER ) then
                    ply.HeadResist = ply.HeadResist - 1
                    if ( ( ply.HeadResist || 0 ) <= 0 ) then
                        ply.HeadResist = nil
                        ply:SetUsingHelmet("")
                        if ( ply.BoneMergedEnts && istable( ply.BoneMergedEnts ) ) then
                            for _, v in ipairs( ply.BoneMergedEnts ) do
                                if ( v && v:IsValid() && ( v:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" or v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" ) ) then
                                    v:Remove()
                                end
                            end
                        end
                    end
                end
                dmginfo:ScaleDamage( 0.5 )
            else
                dmginfo:ScaleDamage( 3 )
            end
        elseif ( stomach_hit[ hitgroup ] ) then
            if ( ply:GetUsingArmor() != "" ) then
                if ( ply.BodyResist ) then
                    ply.BodyResist = ply.BodyResist - 1
                end
                if ( ( ply.BodyResist || 0 ) <= 0 ) then
                    ply.BodyResist = nil
                    ply:SetUsingArmor("")
                    for _, v in ipairs( ply.BoneMergedEnts ) do
                        if ( v && v:IsValid() && ( v:GetModel() == "models/cultist/armor_pickable/bone_merge/light_armor.mdl" or v:GetModel() == "models/cultist/armor_pickable/bone_merge/heavy_armor.mdl" ) ) then
                            v:Remove()
                        end
                    end
                end
                dmginfo:ScaleDamage( 0.7 )
            else
                dmginfo:ScaleDamage( 1.5 )
            end
        end
    end

    if ply:GTeam() != TEAM_SCP then 
        if hitgroup == HITGROUP_HEAD then
            dmginfo:ScaleDamage( GetRoleResists(ply, "head") + 1 )
        elseif hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_GEAR then
            dmginfo:ScaleDamage( GetRoleResists(ply, "gear") + 0.5 )
        elseif hitgroup == HITGROUP_STOMACH then
            dmginfo:ScaleDamage( GetRoleResists(ply, "stomach") + 0.5 )
        elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
            dmginfo:ScaleDamage( GetRoleResists(ply, "arm") + 0.5 )
        elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
            dmginfo:ScaleDamage( GetRoleResists(ply, "leg") + 0.5 )
        end
    else
        if dmginfo:IsDamageType(DMG_BULLET) then
            dmginfo:ScaleDamage(0.4)
        end
    end

    if ( attacker:GTeam() == TEAM_GOC && ( wep && wep:IsValid() ) && wep.Primary && wep.Primary.Ammo == "GOC" && ply:GTeam() == TEAM_SCP ) then
        dmginfo:SetDamage( dmginfo:GetDamage() * 1.25 )
    end

	if attacker:GetRoleName() == role.SCI_SpyUSA and attacker:GetActiveWeapon() == "cw_kk_ins2_arse_usp" and ply:GetNWBool("Have_docs") == false then
		dmginfo:ScaleDamage(0.1)
	end
end)