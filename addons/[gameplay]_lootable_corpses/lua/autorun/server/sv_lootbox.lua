util.AddNetworkString( "OpenLootMenu" )
util.AddNetworkString( "ShowEQAgain" )
util.AddNetworkString( "ParticleAttach" )
util.AddNetworkString( "LootEnd" )
util.AddNetworkString("LC_TakeWep")

net.Receive("LootEnd", function(len, ply)
	if (ply.ForceAnimSequence) then
		ply:SetForcedAnimation(false)
		ply.MovementLocked = nil
	end
end)

AddCSLuaFile( "lootable_corpses_config.lua" )
include( "lootable_corpses_config.lua" )

net.Receive("LC_TakeWep", function(len,ply)
	local ent = net.ReadEntity()
	local wep = net.ReadString()
	print(ply:Name().." Подбирает",wep," Из",ent)
	ply:Give(wep)
	local index = table.KeyFromValue(ent.vtable.Weapons, wep)
    if index then
        table.remove(ent.vtable.Weapons, index)
    end
end)

local clr_red = Color( 255, 0, 0 )

function PlayerCanPickupWeapon( ply, weap )
	if ( ( ply.NextPickup || 0 ) > CurTime() ) then return false end
	if ( ply.ForceToGive && weap:GetClass() == ply.ForceToGive ) then
		ply.HasWeaponCheck = { class = ply.ForceToGive, ent = weap }
	 	--ply.NextPickup = CurTime() + 1
		timer.Simple( .1, function()
			if ( ply.HasWeaponCheck && ply.HasWeaponCheck.class && !ply:HasWeapon( ply.HasWeaponCheck.class ) ) then
				if ( ply.HasWeaponCheck.ent && ply.HasWeaponCheck.ent:IsValid() ) then
					ply.HasWeaponCheck.ent:Remove()
				end
				ply:Give( ply.HasWeaponCheck.class, false )
			end
			ply.HasWeaponCheck = nil
		end)
		ply.ForceToGive = nil

		return true
 	end



	if ( !ply:KeyDown( IN_USE ) ) then return false end
	if ( ply:GTeam() == TEAM_SCP || ply:GTeam() == TEAM_SPEC || ply:Health() <= 0 ) then return false end
	local tr = ply:GetEyeTrace()
	local wepent = tr.Entity

	--[[if ( ply.Stance == "Crouching" ) then
    tr.StartPos = tr.StartPos - vec_down_ctrl
    wepent = ply:StanceVision( tr )
    end]]

	--if ( !( tr.Entity && tr.Entity:IsValid() ) ) then return false end

	if ( wepent:IsWeapon() && wepent:GetPos():DistToSqr( ply:GetPos() ) <= 6400 ) then
		local ent_class = wepent:GetClass()

		if ( ply:HasWeapon( ent_class ) ) then
			ply.NextPickup = CurTime() + 1
			BREACH.Players:ChatPrint( ply, true, true, "У Вас уже есть данный предмет." )
			return false
		end

		local maximumdefaultslots = ply:GetMaxSlots()
		local maximumitemsslots = 6
		local maximumnotdroppableslots = 6
		local countdefault = 0
		local countitem = 0
		local countnotdropable = 0
		local is_cw = wepent.CW20Weapon

		for _, weapon in ipairs( ply:GetWeapons() ) do
			if ( is_cw && weapon.CW20Weapon && weapon.Primary.Ammo == wepent.Primary.Ammo ) then
				ply.NextPickup = CurTime() + 1
				BREACH.Players:ChatPrint( ply, true, true, "У Вас уже есть данный тип оружия." )
				return
			end

			if ( !weapon.Equipableitem && !weapon.UnDroppable ) then
				countdefault = countdefault + 1
			elseif ( weapon.Equipableitem ) then
				countitem = countitem + 1
			elseif ( weapon.UnDroppable ) then
				countnotdropable = countnotdropable + 1
			end
		end

		if ( !wepent.Equipableitem && !wepent.UnDroppable && countdefault >= maximumdefaultslots ) then
			ply:BrEventMessage( "Your main inventory is full" )
			return false
		elseif ( wepent.Equipableitem && countitem >= maximumitemsslots ) then
			ply:BrEventMessage( "Your second inventory is full" )
			return false
		elseif ( wepent.UnDroppable && countnotdropable >= maximumnotdroppableslots ) then
			ply:BrEventMessage( "Your main inventory is full" )
			return false
		end

		local physobj = wepent:GetPhysicsObject()

		if ( physobj && physobj:IsValid() ) then
			physobj:EnableMotion( false )
		end

		ply:BrProgressBar( "Поднятие вещи...", 1, "", "nextoren/gui/icons/notifications/breachiconfortips.png", true, function()

			if ( wepent:IsWeapon() ) then
				ply:EmitSound( "nextoren/charactersounds/inventory/nextoren_inventory_itemreceived.wav", 75, math.random( 98, 105 ), 1, CHAN_STATIC )
				ply:Give( ent_class, true )

				local wep_index = wepent:EntIndex()

				timer.Simple( .7, function()

					if ( ply && ply:IsValid() && !ply:HasWeapon( ent_class ) ) then
						for _, v in ipairs( ents.FindInSphere( ply:GetPos(), 100 ) ) do
							if ( v:IsWeapon() && v:GetClass() == ent_class && v:EntIndex() == wep_index ) then
								ply:BreachGive( v:GetClass() )
								v:Remove()
							end
						end
					end
				end)
			end

		end, nil, function() if ( physobj && physobj:IsValid() ) then physobj:EnableMotion( true ) end end )
		return false
	end
	return false
end

--hook.Add( "PlayerCanPickupWeapon", "UseWeapon", PlayerCanPickupWeapon )



local killing_sndlist = {
  "nextoren/others/cannibal/gibbing1.wav",
  "nextoren/others/cannibal/gibbing2.wav",
  "nextoren/others/cannibal/gibbing3.wav"
}

local zombie_footsteps = {
	"nextoren/charactersounds/zombie/foot1.wav",
	"nextoren/charactersounds/zombie/foot2.wav",
	"nextoren/charactersounds/zombie/foot3.wav"
}

local deathclr = Color( 169, 169, 169 )

hook.Add( "KeyPress", "KeyPressForRagdoll", function( ply, key )	
	local tr = ply:GetEyeTrace()
	local trent = ply:GetEyeTrace().Entity
	if ( key != IN_USE && key != IN_RELOAD ) then return end
 	if ( ply:GTeam() == TEAM_SPEC || ply:GTeam() == TEAM_SCP && ply:GetRoleName() != "SCP049" ) then return end

	if ( key == IN_RELOAD && ply:GetRoleName() == "SCP049" ) then
		local tr = ply:GetEyeTrace()
		local self = tr.Entity
		if ( self:GetClass() != "prop_ragdoll" || self:GetPos():DistToSqr( ply:GetPos() ) > 3025 ) then return end

	elseif ( key == IN_USE ) then

		local tr = ply:GetEyeTrace()
		local self = tr.Entity
		if ( !self.breachsearchable || self:GetClass() != "prop_ragdoll" || self:GetPos():DistToSqr( ply:GetPos() ) > 3025 ) then return end

		if ( ply:GetRoleName() == "SCP049" && self:GetIsVictimAlive() ) then
			if ( self:HasHazmat() ) then
				ply:BrTip( 3, "[NextOren Breach]", Color( 210, 0, 0, 200 ), "Вы не можете заразить тело в спец. одежде", Color( 255, 0, 0, 220 ) )
				return
			elseif ( self:GetModel():find( "scp_special_scp" ) ) then
				ply:BrTip( 3, "[NextOren Breach]", Color( 210, 0, 0, 200 ), "Вы не можете заразить данного человека", Color( 255, 0, 0, 220 ) )
				return
			end

			ply:BrProgressBar( "Превращение в зомби", 6, "nextoren/charactersounds/loot_sound.wav", nil, true, function()

				if ( self:GetIsVictimAlive() ) then
					local plyowner = self:GetOwner()					
					timer.Remove( "Death" .. plyowner:EntIndex() )
					if ( plyowner:GTeam() == TEAM_SPEC ) then return end
					plyowner:SetPos( plyowner:GetPos() + ply:GetAngles():Forward() * 4 )

					self:Remove()

					SetZombie( plyowner )

					plyowner:Give( "weapon_scp_049_2" )
					plyowner.AdditionalScaleDamage = .15

					timer.Simple( 0, function()
						plyowner:SetActiveWeapon( plyowner:GetWeapon( "weapon_scp_049_2" ) )
						timer.Simple( .25, function()
							if ( plyowner && plyowner:IsValid() && plyowner.IsZombie ) then
								plyowner:SelectWeapon( "weapon_scp_049_2" )
							end
						end)
					end)

					if ( plyowner && plyowner:IsValid() ) then
						plyowner:SetTeam( TEAM_SCP )
					end

					net.Start( "GetRoleData" )
						net.WriteString( "SCP0492" )
						net.WriteString( "Подчиняйтесь SCP-049." )
						net.WriteBool( false )
					net.Send( plyowner )

					plyowner.Footsteps = zombie_footsteps
					plyowner.IsZombie = true
					plyowner.SpecialAbility = nil
					plyowner.SpecialAbilityTable = nil

					plyowner:SetNoDraw( false )
					plyowner:SetNotSolid( false )
					plyowner:AddToStatistics( "Captured by SCP049", -50 )
					plyowner:ConCommand( "stopsound" )
					plyowner:ScreenFade( SCREENFADE.OUT, color_black, .01, 3 )
					plyowner:SetMaxHealth( plyowner:GetMaxHealth() * 2 )
					plyowner:SetHealth( plyowner:GetMaxHealth() )

					plyowner.AffectedBy049 = false

					timer.Simple( 3.25, function() -- debug timer

						if ( ( plyowner && plyowner:IsValid() ) && plyowner.IsZombie && plyowner:Health() > 0 && plyowner:IsFrozen() ) then
							plyowner:Freeze( false )
							plyowner:SetMoveType( MOVETYPE_WALK )
							plyowner:SetNotSolid( false )

							net.Start( "SCP049_PlayerScreenManipulations" )
								net.WriteUInt( 2, 2 )
								net.WriteBool( false )
							net.Send( plyowner )

							plyowner:SetDSP( 1 )
							plyowner.AdditionalScaleDamage = .7
						end
					end)

					plyowner:SetForcedAnimation( "breach_zombie_getup", 2.25, nil, function()

						plyowner:Freeze( false )
						plyowner:SetMoveType( MOVETYPE_WALK )
						plyowner:SetNotSolid( false )

						net.Start( "SCP049_PlayerScreenManipulations" )
							net.WriteUInt( 2, 2 )
							net.WriteBool( false )
						net.Send( plyowner )

						plyowner:SetDSP( 1 )
						plyowner.AdditionalScaleDamage = .7
					end )
					self:SetIsVictimAlive( false )
				end
			end)
			return
		end

		if ( ply:GTeam() == TEAM_SCP ) then return end

		--ply:SetForcedAnimation( "616", 0, nil )
		--ply:SetNWEntity( "NTF1Entity", ply )

		local skibidi_toilet = function()
			if ( ply && ply:IsValid() ) then
				ply:SetForcedAnimation( false )
				print("nerd")
			end
		end

		
		ply:BrProgressBar("l:looting_body", 6, "nextoren/gui/icons/notifications/breachiconfortips.png", trent, false, function()
			if ( !self.vtable ) then return end

			if ( table.Count( self.vtable.Weapons ) == 0 ) then
				ply:BrTip( 3, "[NextOren Breach]", Color( 210, 0, 0, 200 ), "Вы ничего не нашли", clr_red )
				return
			end

			ply.MovementLocked = true

			net.Start( "OpenLootMenu" )
				net.WriteTable( self.vtable )
				net.WriteTable( self.vtable.Ammo )
			net.Send( ply )

			net.Start("LootEnd")
			net.Send(ply)

			--ply:SetNWEntity( "NTF1Entity", NULL )

			BREACH.Players:ChatPrint( ply, true, true, "Вы обыскали тело " .. self:GetNWString("SurvivorName") )
		end)
	end
end)

local DeathReasons = {
	[8194] = "l:body_bullets", -- Почему то физичная пуля это отдельный вид урона...
	[DMG_BULLET] = "l:body_bullets",
	[DMG_SLASH] = "l:body_slashed",
	[DMG_ACID] = "l:body_acid",
	[DMG_FALL] = "l:body_fall",
	[DMG_BURN] = "l:body_burned",
	[DMG_CRUSH] = "l:body_crushed",
	["SCP173"] = "У тела свёрнута шея",
	["SCP0492"]  = "На теле обнаружены многочисленные укусы"
}

function CreateUnconsBody( victim )
	victim:SetNoDraw( true )
	victim:SetNotSolid( true )
	victim:SetDSP( 37 )
	victim:Freeze( true )
	CreateLootBox( victim, nil, nil, true )
end

function TestDeathPose( ply )
	local ragdoll = ents.Create( "base_gmodentity" )
	ragdoll:SetPos( ply:GetPos() )
	ragdoll:SetModel( ply:GetModel() )
	ragdoll:Spawn()
	ragdoll:SetPlaybackRate( 1 )
	ragdoll.AutomaticFrameAdvance = true
	ragdoll:SetSequence( ply:LookupSequence( "deathpose_front" ) )
	ragdoll:SetNoDraw( true )
	ragdoll.Think = function( self )
		self:NextThink( CurTime() )
		self:SetCycle( .16 )
		return true
	end
	--timer.Simple( 2, function()
		local test_ragdoll = ents.Create( "prop_ragdoll" )
		test_ragdoll:SetPos( ragdoll:GetPos() )
		test_ragdoll:SetModel( ragdoll:GetModel() )
		test_ragdoll:Spawn()

		local velocity = player.GetByID( 2 ):GetVelocity() - ( player.GetByID( 2 ):GetAimVector() * 6 )

		if ( test_ragdoll && test_ragdoll:IsValid() ) then
			local headIndex = test_ragdoll:LookupBone( "ValveBiped.Bip01_Head1" )
			test_ragdoll:SetCollisionGroup( COLLISION_GROUP_WEAPON )

			for i = 1, test_ragdoll:GetPhysicsObjectCount() do

				local physicsObject = test_ragdoll:GetPhysicsObjectNum( i )
				local boneIndex = test_ragdoll:TranslatePhysBoneToBone( i )
				local position, angle = ragdoll:GetBonePosition( boneIndex )

				if ( physicsObject && physicsObject:IsValid() ) then
					physicsObject:SetPos( position )
					physicsObject:SetMass( 65 )
					physicsObject:SetAngles( angle )

					if ( boneIndex == headIndex ) then
						physicsObject:SetVelocity( ( velocity / 6 ) * 1.5 )
					else
						physicsObject:SetVelocity( velocity / 6 )
					end

					if ( player.GetByID( 2 ).force ) then
						if ( boneIndex == headIndex ) then
							physicsObject:ApplyForceCenter( player.GetByID( 2 ).force * 1.5 )
						else
							physicsObject:ApplyForceCenter( player.GetByID( 2 ).force )
						end
					end

					timer.Simple( .2, function()
						physicsObject:ApplyForceCenter( Vector( 0, 0, physicsObject:GetMass() - math.random( 4000, 6000 ) ) )
					end)
				end
			end
		end
	--end)
end

local corpse_mdl = Model( "models/cultist/humans/corpse.mdl" )

function CreateLootBox( ply, inflictor, attacker, knockedout )
	local team = ply:GTeam()
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
			end)
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

	-- Fix for deffib
    LootBox.__Team = ply:GetGTeam()
	LootBox.Role = ply:GetRoleName()
	LootBox.__Health = ply:GetMaxHealth()
	LootBox.Cloth = ply:GetUsingCloth()
	LootBox.__Name = ply:GetNamesurvivor()
	LootBox.WalkSpeed = ply:GetWalkSpeed()
	LootBox.RunSpeed = ply:GetRunSpeed()
	LootBox.OldSkin = ply.OldSkin
	LootBox.OldModel = ply.OldModel
	LootBox.OldBodygroups = ply.OldBodygroups


	if ply.BoneMergedEnts and not (ply.burnttodeath or ply.Death_ByAcid) then
		if ply.HeadEnt and ply.HeadEnt:IsValid() then
			LootBox.Head_SubMaterial = ply.HeadEnt:GetSubMaterial(0)
		end

		local shittest_fix = {
			"models/cultist/humans/balaclavas_new/balaclava_full.mdl"
		}	
	
		for _, v in ipairs(ply.BoneMergedEnts) do
			if v and v:IsValid() and not v:GetInvisible() and (not ply.Head_Split or v:GetModel() == ply.HeadEnt:GetModel()) and !v:GetModel(shittest_fix) then
				GhostBoneMerge(LootBox, v:GetModel(), false, v:GetSkin(), ply.HeadEnt:GetSubMaterial(0) or {})
			end
			if v and v:IsValid() and not v:GetInvisible() and (not ply.Head_Split or v:GetModel() == ply.HeadEnt:GetModel()) and v:GetModel(shittest_fix) then
				GhostBoneMerge(LootBox, v:GetModel(), false, v:GetSkin(), ply.HeadEnt:GetSubMaterial(1) or {})
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

				if ( v:IsPlayer() && v:IsSolid() && v:GTeam() != TEAM_SCP ) then
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
		end)
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
		end)

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
				end)
			end
		end
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
	if ( ply.type && DeathReasons[ ply.type ] ) then
		LootBox:SetNWString("DeathReason1", ( DeathReasons[ ply.type ] ))
	else
		LootBox:SetNWString( "DeathReason1", "l:body_death_unknown" )
	end
	LootBox:SetNWInt("DiedWhen", os.time())
    if ply:LastHitGroup() == HITGROUP_HEAD then
		LootBox:SetNWString( "DeathReason2", "l:body_headshot" )
	end
	LootBox.vtable = {}
	LootBox.vtable.Ammo = {}
	LootBox.vtable.Entity = LootBox
	LootBox.vtable.Weapons = {}
	LootBox.vtable.Name = ply:GetNamesurvivor()

	for _, weapon in ipairs( ply:GetWeapons() ) do
		if ( weapon.droppable != false && !weapon.UnDroppable && ( ply:GTeam() != TEAM_SCP || ply.AffectedBy049 ) ) then
			table.insert( LootBox.vtable.Weapons, weapon:GetClass() )
		end
	end
end

hook.Add( "PlayerDeath", "create_loot_box", CreateLootBox )