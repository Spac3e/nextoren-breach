if CLIENT then end
AddCSLuaFile( "lootable_corpses_config.lua" )
include( "lootable_corpses_config.lua" )

local function IsWep(wep, weptab) 
	if(table.HasValue(weptab, wep)) then
		return true
	end
	return false
end

local function BoxRemove(entid)
	if(!IsValid(Entity(entid))) then return end
	Entity(entid):Remove()
	sound.Play( table.Random(LC.DespawnSounds), Entity(entid):GetPos(), 65, 100, 1 ) 
end

local function CheckIfEmpty(entid)
	if(Entity(entid).Money==0 and #Entity(entid).Weapons==0) then
		Entity(entid).IsLooted = true
		BoxRemove(entid)
	end
end

local corpse_mdl = Model( "models/cultist/humans/corpse.mdl" )



function CreateLootBox( ply, inflictor, attacker, knockedout )



	local team = ply:Team()



	if ( team == TEAM_SPEC ) then return end



	if ( team == TEAM_SCP && ply.DeathAnimation ) then



		local SCPRagdoll = ents.Create( "base_gmodentity" )

		SCPRagdoll:SetPos( ply:GetPos() )

		SCPRagdoll:SetModel( ply:GetModel() )

		SCPRagdoll:SetMaterial( ply:GetMaterial() )

		SCPRagdoll:SetAngles( ply:GetAngles() )

		SCPRagdoll:Spawn()

		SCPRagdoll:SetPlaybackRate( 1 )

		SCPRagdoll:SetSequence( ply.DeathAnimation )

		SCPRagdoll.AutomaticFrameAdvance = true

		SCPRagdoll.Think = function( self )



			self:NextThink( CurTime() )



			return true

		end



		if ( !ply.DeathLoop ) then



			timer.Simple( SCPRagdoll:SequenceDuration() - .1, function()



				local SCPRagdoll2 = ents.Create( "prop_ragdoll" )

				SCPRagdoll2:SetModel( SCPRagdoll:GetModel() )

				SCPRagdoll2:SetPos( SCPRagdoll:GetPos() )

				SCPRagdoll2:SetAngles( SCPRagdoll:GetAngles() )

				SCPRagdoll2:SetMaterial( SCPRagdoll:GetMaterial() )

				SCPRagdoll2:SetSequence( SCPRagdoll:GetSequence() )

				SCPRagdoll2:SetCycle( SCPRagdoll:GetCycle() )

				SCPRagdoll2:Spawn()



				if ( SCPRagdoll2 && SCPRagdoll2:IsValid() ) then



					SCPRagdoll2:SetCollisionGroup( COLLISION_GROUP_WEAPON )



					for i = 1, SCPRagdoll2:GetPhysicsObjectCount() do



						local physicsObject = SCPRagdoll2:GetPhysicsObjectNum( i )

						local boneIndex = SCPRagdoll2:TranslatePhysBoneToBone( i )

						local position, angle = SCPRagdoll:GetBonePosition( boneIndex )



						if ( physicsObject && physicsObject:IsValid() ) then



							physicsObject:SetPos( position )

							physicsObject:SetMass( 65 )

							physicsObject:SetAngles( angle )



						end



					end



				end



				SCPRagdoll:Remove()



			end )



		end



		return



	end



	local LootBox = ents.Create( "prop_ragdoll" )

	ply:SetNWEntity( "RagdollEntityNO", LootBox )



	if ( knockedout ) then



		ply:SetNWEntity( "NTF1Entity", LootBox )



	end



	if ( ply.burnttodeath || ply.Death_ByAcid ) then



		LootBox:SetModel( corpse_mdl )

		LootBox:SetSkin( ply.burnttodeath && 0 || 1 )



	else



		LootBox:SetModel( ply:GetModel() )



	end



	for _, v in pairs( ply:GetBodyGroups() ) do



    LootBox:SetBodygroup( v.id, ply:GetBodygroup( v.id ) )



  end



	LootBox:SetSkin( ply:GetSkin() )

	LootBox:SetMaterial( ply:GetMaterial() )



	if ( ply.BoneMergedEnts && !( ply.burnttodeath || ply.Death_ByAcid ) ) then



		if ( ply.HeadEnt && ply.HeadEnt:IsValid() ) then



			LootBox.Head_SubMaterial = ply.HeadEnt:GetSubMaterial( 0 )



		end



		for _, v in ipairs( ply.BoneMergedEnts ) do



			if ( v && v:IsValid() && !v:GetInvisible() && ( !ply.Head_Split || v:GetModel() == ply.HeadEnt:GetModel() ) ) then



				GhostBoneMerge( LootBox, v:GetModel(), v:GetSkin() || false )



			end



		end



	end



	if ( team == TEAM_SCP && ply.SCPTable && ply.SCPTable.DeleteRagdoll ) then



		LootBox:Remove()

		ply:SetNWEntity( "RagdollEntityNO", nil )

		ply.SCPTable = nil



	end



	if ( team == TEAM_SCP ) then



		if ( ply:HasWeapon( "weapon_scp_049_2" ) ) then



			for index, mat in ipairs( ply:GetMaterials() ) do



      	LootBox:SetSubMaterial( index - 1, ply:GetSubMaterial( index - 1 ) )



    	end



			if ( ply.HeadEnt && ply.HeadEnt:IsValid() ) then



				for index, mat in ipairs( ply.HeadEnt:GetMaterials() ) do



	      	LootBox.HeadEnt:SetSubMaterial( index - 1, ply.HeadEnt:GetSubMaterial( index - 1 ) )

					LootBox.HeadEnt:SetSkin( ply.HeadEnt:GetSkin() )



	    	end



			end



			LootBox.breachsearchable = true

			ply:StripWeapon( "weapon_scp_049_2" )



		end



	elseif ( team != TEAM_SCP ) then



		LootBox.breachsearchable = true



	end



	if ( ply:LastHitGroup() == HITGROUP_HEAD && ply.Head_Split ) then



		ParticleEffectAttach( "blood_advisor_pierce_spray", PATTACH_POINT_FOLLOW, LootBox, 1 )



		if ( LootBox:GetModel() == "models/cultist/humans/sci/scientist.mdl" ) then



			LootBox:SetBodygroup( 3, 0 )



		end



		timer.Simple( .25, function()



			local ef_data = { Name = "br_blood_stream", Entity = LootBox, bone_id = LootBox:LookupBone( "ValveBiped.Bip01_Head1" ) }

			NetEffect( ef_data )



			LootBox.HeadEnt:SetSkin( ply:GetSkin() )

			LootBox.HeadEnt:SetBodygroup( 0, math.random( 1, 3 ) )



		end )



		ply.Head_Split = nil



	end



	LootBox:SetAngles( ply:GetAngles() )

	LootBox:SetPos( ply:GetPos() )



	if ( ply.abouttoexplode ) then



		ply.abouttoexplode = nil



		local current_pos = LootBox:GetPos()



		LootBox.breachsearchable = false



		net.Start( "CreateParticleAtPos" )



			net.WriteString( "pillardust" )

			net.WriteVector( current_pos )



		net.Broadcast()



		net.Start( "CreateParticleAtPos" )



			net.WriteString( "gas_explosion_main" )

			net.WriteVector( current_pos )



		net.Broadcast()



		util.BlastDamage( ply, ply, current_pos, 400, 2000 )



		net.Start( "3DSoundPosition" )



			net.WriteString( "sound/nextoren/others/explosion_ambient_" .. math.random( 1, 2 ) .. ".ogg" )

			net.WriteVector( current_pos )

			net.WriteUInt( 8, 4 )



		net.Broadcast()



		local trigger_ent = ents.Create( "base_gmodentity" )

		trigger_ent:SetPos( current_pos )

		trigger_ent:SetNoDraw( true )

		trigger_ent:DrawShadow( false )

		trigger_ent:Spawn()

		trigger_ent.Die = CurTime() + 50

		trigger_ent.OnRemove = function( self )



			self:StopParticles()



		end

		trigger_ent.Think = function( self )



			self:NextThink( CurTime() + .25 )



			if ( self.Die < CurTime() ) then



				self:Remove()



			end



			for _, v in ipairs( ents.FindInSphere( self:GetPos(), 300 ) ) do



				if ( v:IsPlayer() && v:IsSolid() && v:Team() != TEAM_SCP ) then



					v:IgniteSequence( 4 )



				end



			end



		end



	end



	LootBox:Spawn()



	if ( ply.burnttodeath ) then



		ply.burnttodeath = nil

		--ParticleEffectAttach( "inferno_wall", PATTACH_POINT_FOLLOW, LootBox, 3 )

		ParticleEffectAttach( "smoke_gib_01", PATTACH_POINT_FOLLOW, LootBox, 3 )

		ParticleEffectAttach( "fire_small_03", PATTACH_POINT_FOLLOW, LootBox, 3 )



		if ( LootBox.BoneMergedEnts && istable( LootBox.BoneMergedEnts ) ) then



			for _, v in ipairs( LootBox.BoneMergedEnts ) do



				if ( v && v:IsValid() ) then



					v:Remove()



				end



			end



		end



		LootBox.breachsearchable = false

		LootBox:EmitSound( "player.burning_death" )

		timer.Simple( 20, function()



			if ( LootBox && LootBox:IsValid() ) then



				LootBox:StopParticles()

				LootBox:StopSound( "player.burning_death" )



			end



		end )



	end



	if ( ply.disintegrate ) then



		ply.disintegrate = nil



		LootBox:SetName( "dissolve_target" )



		local effect = ents.Create( "env_entity_dissolver" )

	  effect:SetKeyValue( "target", "dissolve_target" )

	  effect:SetKeyValue( "dissolvetype", "3" )

	  effect:SetKeyValue( "magnitude", "60" )

	  effect:Spawn()

	  effect:Activate()

	  effect:Fire( "Dissolve", "dissolve_target", 0 )



	end



	if ( ply.Arrow_Parent ) then



		ply.Arrow_Parent = nil



		for _, v in ipairs( ply:GetChildren() ) do



			if ( v && v:IsValid() && v:GetClass():find( "arrow" ) ) then



				v:SetParent( LootBox, v.Bone_ParentID || 0 )



			end



		end



	elseif ( ply.Death_ByAcid ) then



		ply.Death_ByAcid = nil



		timer.Simple( 1, function()



			net.Start( "CreateClientParticleSystem" )



				net.WriteEntity( LootBox )

				net.WriteString( "boomer_leg_smoke" )

				net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )

				net.WriteUInt( 0, 7 )

				net.WriteVector( vector_origin )

				net.WriteBool( true )



			net.Broadcast()



		end )



		LootBox:SetSkin( 1 )



	elseif ( ply.radiation ) then



		ply.radiation = nil



		local particle_emitter = ents.Create( "base_gmodentity" )

		particle_emitter:SetPos( LootBox:GetPos() )

		particle_emitter:SetParent( LootBox, 1 )

		particle_emitter:SetNoDraw( true )

		particle_emitter:DrawShadow( false )

		particle_emitter:AddEffects( EF_BONEMERGE )

		particle_emitter:Spawn()

		particle_emitter.Think = function( self )



			self:NextThink( CurTime() )



			if ( ( self.NextParticle || 0 ) < CurTime() ) then



				self.NextParticle = CurTime() + 3

				ParticleEffect( "rgun1_impact_pap_child", self:GetPos(), angle_zero, LootBox )



			end



			for _, v in ipairs( ents.FindInSphere( self:GetPos(), 400 ) ) do



				if ( v:IsPlayer() && v:IsSolid() && v:Health() > 0 && !v:HasHazmat() ) then



					local radiation_info = DamageInfo()

					radiation_info:SetDamageType( DMG_RADIATION )

					radiation_info:SetDamage( 4 )

					radiation_info:SetDamageForce( v:GetAimVector() * 4 )



					if ( v:Health() - radiation_info:GetDamage() <= 0 ) then



						v.radiation = true



					end



					radiation_info:ScaleDamage( 1 * ( 1600 / self:GetPos():DistToSqr( v:GetPos() ) ) )



					v:TakeDamageInfo( radiation_info )



				end



			end



		end



	end



	local velocity = ply:GetVelocity() + ( ply:GetAimVector() * math.Rand( 1, 3 ) )



	if ( LootBox && LootBox:IsValid() ) then



		local headIndex = LootBox:LookupBone( "ValveBiped.Bip01_Head1" )



		LootBox:SetCollisionGroup( COLLISION_GROUP_WEAPON )



		for i = 1, LootBox:GetPhysicsObjectCount() do



			local physicsObject = LootBox:GetPhysicsObjectNum( i )

			local boneIndex = LootBox:TranslatePhysBoneToBone( i )

			local position, angle = ply:GetBonePosition( boneIndex )



			if ( IsValid( physicsObject ) ) then



				physicsObject:SetPos( position )

				physicsObject:SetMass( 65 )

				physicsObject:SetAngles( angle )



				if ( boneIndex == headIndex ) then



					physicsObject:SetVelocity( ( velocity / math.Rand( 2, 6 ) ) * math.Rand( .6, .9 ) )



				else



					physicsObject:SetVelocity( ( velocity / math.Rand( 2, 6 ) ) * math.Rand( .6, .9 ) )



				end



				if ( ply.force ) then



					if ( boneIndex == headIndex ) then



						physicsObject:ApplyForceCenter( ply.force * 1.5 )



					else



						physicsObject:ApplyForceCenter( ply.force )



					end



				end



				timer.Simple( .2, function()



					if ( IsValid( physicsObject ) ) then



						physicsObject:ApplyForceCenter( Vector( 0, 0, physicsObject:GetMass() - math.random( 4000, 6000 ) ) )



					end



				end )



			end



		end



	end



	if ( ply.type && DeathReasons[ ply.type ] ) then



		LootBox:SetDeathReason( DeathReasons[ ply.type ] )



	else



		LootBox:SetDeathReason( "Невозможно определить причину смерти" )



	end



	if ( knockedout ) then



		LootBox:SetDeathReason( "Человек находится в бессознательном состоянии." )

		LootBox.Knockout = true

		LootBox.PlayerHealth = ply:Health()



		if ( ply.BoneMergedEnts ) then



			for _, v in ipairs( ply.BoneMergedEnts ) do



				if ( v && v:IsValid() ) then



					v:SetNoDraw( true )

					v:DrawShadow( false )



				end



			end



		end



		--local unique_id = "PlayerDeathFromBleeding" .. ply:SteamID64()



		--[[function LootBox:OnTakeDamage( dmginfo )



			local attacker = dmginfo:GetAttacker()



			if ( attacker && attacker:IsValid() && attacker:IsPlayer() ) then



				LootBox.PlayerHealth = LootBox.PlayerHealth - dmginfo:GetDamage()



				if ( LootBox.PlayerHealth <= 0 ) then



					timer.Remove( unique_id )



					ply:SetDSP( 1 )

					ply:SendLua( 'LocalPlayer().KnockedOut = false' )

					ply:SetNWEntity( "NTF1Entity", NULL )

					ply:Freeze( false )

					ply:SetSpectator()



				end



			end



		end]]



		--ply:SendLua( 'LocalPlayer().KnockedOut = true' )



		--[[timer.Create( unique_id, 25, 1, function()



			if ( LootBox && LootBox:IsValid() ) then



				LootBox.Knockout = false

				LootBox:SetDeathReason( "Скорее всего, он умер от обильного кровотечения." )



				ply:SendLua( 'LocalPlayer().KnockedOut = false' )



				ply:SetNWEntity( "NTF1Entity", nil )

				ply:SetDSP( 1 )

				ply:Freeze( false )

				ply:SetSpectator()



			end



		end )]]



	end



	if ( ply:Alive() && ply.AffectedBy049 ) then



		LootBox:SetVictimHealth( ply:Health() )

		LootBox:SetIsVictimAlive( true )

		timer.Simple( 40, function()



			if ( LootBox && LootBox:IsValid() ) then



				LootBox:SetIsVictimAlive( false )



			end



		end)



	end



	LootBox:SetOwner( ply )

	LootBox.IsInfected = false

	LootBox:SetCollisionGroup( COLLISION_GROUP_WORLD )



	LootBox:SetDeathName( ply:GetName() )



	LootBox.vtable = {}

	LootBox.vtable.Entity = LootBox

	LootBox.vtable.Weapons = {}



	LootBox.vtable.Name = ply:GetName()



	for _, weapon in ipairs( ply:GetWeapons() ) do



		if ( weapon.droppable != false && !weapon.UnDroppable && ( ply:Team() != TEAM_SCP || ply.AffectedBy049 ) ) then



			table.insert( LootBox.vtable.Weapons, weapon:GetClass() )



		end



	end



end

hook.Add( "PlayerDeath", "create_loot_box", CreateLootBox )


local function UpdateBox(entid)
	for k, v in pairs(player.GetAll()) do
	   if(v.LastUsedBoxId==entid) then
			net.Start( "LC_UpdateStuff" )
				net.WriteTable( Entity(entid).Weapons )
				net.WriteInt( Entity(entid).Money, 16 )
			net.Send(v)
	   end
	end
	CheckIfEmpty(entid)
end

net.Receive( "LC_TakeWep", function( ) 
	local plyid = net.ReadInt(16)
	local entid = net.ReadInt(16)
	local wepindex = net.ReadInt(16)
	local ply = Player(plyid)
	local plypos = ply:GetPos()
	if(!IsValid(Entity(entid)) or Entity(entid):GetClass()!="loot_box" or ply:Health()<=0) then return end
	if(plypos:Distance(Entity(entid):GetPos())>200 or Entity(entid).IsLooted) then return end
	if(Entity(entid).Weapons[wepindex]==nil) then return end
	if(Entity(entid).Weapons[wepindex] != "LC_Already_Taken") then
		ply:Give(Entity(entid).Weapons[wepindex], LC.GunsNoAmmo)
	end
	table.remove(Entity(entid).Weapons, wepindex)
	UpdateBox(entid)
	sound.Play( table.Random(LC.PickupSounds), Entity(entid):GetPos(), 65, 100, 1 ) 
end )

net.Receive( "LC_TakeMon", function( ) 
	if(!LC.MoneyEnabled) then return end
	local plyid = net.ReadInt(16)
	local entid = net.ReadInt(16)
	local ply = Player(plyid)
	local plypos = ply:GetPos()
	if(!IsValid(Entity(entid)) or Entity(entid):GetClass()!="loot_box" or ply:Health()<=0) then return end
	if(plypos:Distance(Entity(entid):GetPos())>200 or Entity(entid).IsLooted) then return end
	ply:setDarkRPVar("money", ply:getDarkRPVar("money") + Entity(entid).Money)
	Entity(entid).Money = 0
	UpdateBox(entid)
	sound.Play( table.Random(LC.PickupSounds), Entity(entid):GetPos(), 65, 100, 1 ) 
end )
