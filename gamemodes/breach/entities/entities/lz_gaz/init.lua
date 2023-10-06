AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	auto_lz_gaz_time = 0
	kashli_na_vbr = { "nextoren/unity/cough1.ogg", "nextoren/unity/cough2.ogg", "nextoren/unity/cough3.ogg"}
end
 
function ENT:Think()
for k,v in pairs(player.GetAll()) do
	if CurTime() < auto_lz_gaz_time then return end	
    if v:GTeam() != TEAM_SPEC then
			local entsinbox = ents.FindInBox( Vector( 4424, -8052, -127 ), Vector( 10572, -2956, 1233 ) ) 
			for k, v in ipairs( entsinbox ) do
			if ( v:IsPlayer() ) then
						if v:GTeam() == TEAM_SPEC then return end
						if v.GASMASK_Equiped == true then return end
                        local model = v:GetModel()
                        if model ~= "models/cultist/humans/mog/mog_hazmat.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_1.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_2.mdl"
                            and model ~= "models/cultist/humans/dz/dz.mdl"
                            and model ~= "models/cultist/humans/goc/goc.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_5.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_6.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_8.mdl"
                            and model ~= "models/cultist/scp/173.mdl"
                        then
				v:TakeDamage(v:GetMaxHealth() / 10)
				v:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
				end
			end
			end

			local entsinbox1 = ents.FindInBox( Vector( 4663, -3055, -179 ), Vector( 11121, -1430, 825 ) ) 
			for k, v in ipairs( entsinbox1 ) do
			if ( v:IsPlayer() ) then
				if v:GTeam() == TEAM_SPEC then return end
				if v.GASMASK_Equiped == true then return end
                        local model = v:GetModel()
                        if model ~= "models/cultist/humans/mog/mog_hazmat.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_1.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_2.mdl"
                            and model ~= "models/cultist/humans/dz/dz.mdl"
                            and model ~= "models/cultist/humans/goc/goc.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_5.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_6.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_8.mdl"
                            and model ~= "models/cultist/scp/173.mdl"
                        then
				v:TakeDamage(v:GetMaxHealth() / 10)
				v:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
				end
			end
			end

			local entsinbox2 = ents.FindInBox( Vector( 10650, -422, -40 ), Vector( 8433, -1776, 461 ) ) 
			for k, v in ipairs( entsinbox2 ) do
			if ( v:IsPlayer() ) then
				if v:GTeam() == TEAM_SPEC then return end
				if v.GASMASK_Equiped == true then return end
                        local model = v:GetModel()
                        if model ~= "models/cultist/humans/mog/mog_hazmat.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_1.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_2.mdl"
                            and model ~= "models/cultist/humans/dz/dz.mdl"
                            and model ~= "models/cultist/humans/goc/goc.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_5.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_6.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_8.mdl"
                            and model ~= "models/cultist/scp/173.mdl"
                        then
				v:TakeDamage(v:GetMaxHealth() / 10)
				v:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
				end
			end
			end

			local entsinbox3 = ents.FindInBox( Vector( 7130, -1870, -142 ), Vector( 7884, -1047, 346 ) ) 
			for k, v in ipairs( entsinbox3 ) do
			if ( v:IsPlayer() ) then
				if v:GTeam() == TEAM_SPEC then return end
				if v.GASMASK_Equiped == true then return end
                        local model = v:GetModel()
                        if model ~= "models/cultist/humans/mog/mog_hazmat.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_1.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_2.mdl"
                            and model ~= "models/cultist/humans/dz/dz.mdl"
                            and model ~= "models/cultist/humans/goc/goc.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_5.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_6.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_8.mdl"
                            and model ~= "models/cultist/scp/173.mdl"
                        then
				v:TakeDamage(v:GetMaxHealth() / 10)
				v:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
				end
			end
			end

			local entsinbox4 = ents.FindInBox( Vector( 2128, -3420, -1435 ), Vector( -1370, -6421, -23 ) ) 
			for k, v in ipairs( entsinbox4 ) do
			if ( v:IsPlayer() ) then
				if v:GTeam() == TEAM_SPEC then return end
				if v.GASMASK_Equiped == true then return end
                        local model = v:GetModel()
                        if model ~= "models/cultist/humans/mog/mog_hazmat.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_1.mdl"
                            and model ~= "models/cultist/humans/sci/hazmat_2.mdl"
                            and model ~= "models/cultist/humans/dz/dz.mdl"
                            and model ~= "models/cultist/humans/goc/goc.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_5.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_6.mdl"
                            and model ~= "models/cultist/humans/scp_special_scp/special_8.mdl"
                            and model ~= "models/cultist/scp/173.mdl"
                        then
				v:TakeDamage(v:GetMaxHealth() / 10)
				v:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
				end
			end
			end
	auto_lz_gaz_time = CurTime() + 3
    end
  end
  end