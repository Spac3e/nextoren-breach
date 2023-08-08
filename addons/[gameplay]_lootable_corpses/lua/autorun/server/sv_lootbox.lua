if CLIENT then end
AddCSLuaFile( "lootable_corpses_config.lua" )
include( "lootable_corpses_config.lua" )


local HeadEnt = HeadEnt || {}

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

local function StartPreDeathAnimation( ply, attacker, dmginfo )
	ply.force = dmginfo:GetDamageForce() * math.random( 2, 4 )
	ply.type = dmginfo:GetDamageType()
	if ( attacker && attacker:IsValid() && attacker:IsPlayer() && attacker:Team() == TEAM_SCP ) then
		ply.type = attacker:GetRoleName()
	end
end

hook.Add( "DoPlayerDeath", "StartDeathAnimation", StartPreDeathAnimation )


local DeathReasons = {
	[ DMG_BULLET ] = "На теле видны пулевые ранения",
	[ DMG_SLASH ] = "На теле видны порезы",
	[ DMG_ACID ] = "На теле видны многочисленные ожоги",
	[ DMG_FALL ] = "На теле обнаружены многочисленные переломы",
	[ "SCP173" ] = "У тела свёрнута шея",
	[ "SCP0492" ] = "На теле обнаружены многочисленные укусы"
}

function CreateLootBox(ply)
	local tr = util.TraceLine({
		start  = ply:GetPos() + ply:GetUp()*20,
		endpos = ply:GetPos() + ply:GetUp()*20 + Vector(0,0,-1000000),
		filter = ply
	})
	
	local Hit = tr.HitPos
    LootBox=ents.Create("prop_ragdoll")
	--Bonemerge(self.ArmorModel, ply)
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", ply ) || {}
   	for i = 1, #tbl_bonemerged do
		local bonemerge = tbl_bonemerged[ i ]
		Bonemerge(bonemerge:GetModel(), LootBox)
	end
	LootBox:SetModel(ply:GetModel())
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

	if ( DeathReason ) then
		LootBox:SetNWString("DeathReason2", DeathReasons[ ply.type ] )

	else
		LootBox:SetNWString("DeathReason2", "Невозможно определить причину смерти" )
	end
	if ( knockedout ) then
		LootBox:SetNWString( "DeathReason2", "Человек находится в бессознательном состоянии." )
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
	LootBox:SetPos(Hit)
	LootBox:SetOwner( ply )
	LootBox:SetAngles(Angle(0,math.random(0,360),0))
	LootBox:Spawn()
	LootBox:SetSkin( ply:GetSkin() )
	LootBox:SetMaterial( ply:GetMaterial() )
	--LootBox:SetDeathName( ply:GetNamesurvivor() )
	LootBox.VictimName = ply:Nick()
	LootBox.IsLooted = false
	LootBox.vtable = {}
	LootBox.vtab = LootBox.vtable
	LootBox.vtable.Entity = LootBox
	LootBox.vtable.Weapons = {}
	LootBox.vtable.Name = ply:GetNamesurvivor()
	for _, v in pairs( ply:GetBodyGroups() ) do
		LootBox:SetBodygroup( v.id, ply:GetBodygroup( v.id ) )	
	end
	for _, weapon in ipairs( ply:GetWeapons() ) do
		table.insert( LootBox.vtable.Weapons, weapon:GetClass() )
	end
	LootBox.Weapons = {}
	for i, weapon in pairs (ply:GetWeapons()) do
		table.insert(LootBox.Weapons, weapon:GetClass())
	end
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
	if ( ply:LastHitGroup() == HITGROUP_HEAD ) then
		ParticleEffectAttach( "blood_advisor_pierce_spray", PATTACH_POINT_FOLLOW, LootBox, 1 )
		ply:Bonemerge("error.mdl", ply)
		if ( LootBox:GetModel() == "models/cultist/humans/sci/scientist.mdl" ) then
			LootBox:SetBodygroup( 3, 0 )
		end
		timer.Simple( .25, function()
	--		LootBox.HeadEnt:SetSkin( ply:GetSkin() )
	--		LootBox.HeadEnt:SetBodygroup( 0, math.random( 1, 3 ) )
		end )
		ply.Head_Split = nil
	end
end 
hook.Add("PlayerDeath", "create_loot_box", CreateLootBox)

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

net.Receive( "LC_TakeWep", function( weaponname ) 
	local plyid = net.ReadInt(16)
	local entid = net.ReadEntity()
	local ply = Player(plyid)
	local niggaposeye = ply:GetEyeTraceNoCursor().Entity
	local wepindex = net.ReadString(weaponname)
	ply:BreachGive(wepindex)
	table.remove(niggaposeye.vtable.Weapons, weaponname)
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

local Delay = 1
local Refresh = 0

hook.Add( "KeyPress", "KeyPressForRagdoll", function( ply, key )
	local tr = ply:GetEyeTrace()
	local trent = ply:GetEyeTrace().Entity
	local self = tr.Entity
	if(!IsValid(ply) or !ply:IsPlayer()) then return end
	if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return end
	if(ply.IsLooted) then return end
	ply = ply
	local TimeLeft = Refresh - CurTime()
	if TimeLeft < 0 and (key == IN_USE) and trent:GetClass() == "prop_ragdoll" then
	--ply:SetForcedAnimation( 616, 0, nil )
	ply:BrProgressBar("l:looting_body", 6, "nextoren/gui/icons/notifications/breachiconfortips.png", trent, false, function()
	if ( !self.vtable ) then return end
	--------------------
	net.Start("OpenLootMenu")
	net.WriteTable( self.vtable )
	net.WriteEntity( self )
	net.Send(ply)
	--(ply, self:EntIndex(), self.Weapons, self.VictimName)
	ply.LastUsedBoxId = self:EntIndex()
	Refresh = CurTime() + Delay
	end)
end
end)