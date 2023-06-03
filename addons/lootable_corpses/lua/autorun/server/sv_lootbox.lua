if CLIENT then end

util.AddNetworkString( "LC_OpenMenu" )  
util.AddNetworkString( "LC_TakeWep" )
util.AddNetworkString( "LC_TakeMon" )
util.AddNetworkString( "LC_UpdateStuff" )

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
	if(#Entity(entid).Weapons==0) then
		Entity(entid).IsLooted = true
	end
end

local function CreateLootBox(ply)
	if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return end
	local Hit
	if(LC.PUBGlike) then
		local tr = util.TraceLine({
			start  = ply:GetPos() + ply:GetUp()*20,
			endpos = ply:GetPos() + ply:GetUp()*20 + Vector(0,0,-1000000),
			filter = ply
			-- mask = MASK_NPCWORLDSTATIC 
		})
		
		Hit = tr.HitPos
	else
		Hit = ply:GetPos()
	end
	LootBox=ents.Create("prop_ragdoll")
	LootBox:SetPos(Hit)
	LootBox:SetModel(ply:GetModel())
	LootBox:SetAngles( ply:GetAngles() )
	LootBox:Spawn()
	for _, v in pairs( ply:GetBodyGroups() ) do
	LootBox:SetBodygroup( v.id, ply:GetBodygroup( v.id ) )
	end
	

	LootBox.Weapons = LootBox.Weapons or {}
	LootBox.VictimName = LootBox.VictimName or "" 

	
	LootBox.VictimName = ply:Nick()
	LootBox.IsLooted = false
	
	LootBox.Weapons = {}
	for i, weapon in pairs (ply:GetWeapons()) do
		if(!IsWep(weapon:GetClass(), LC.UndroppableWeapons)) then
			if(LC.DisSpawnWeps && DarkRP) then
				if(!IsWep(weapon:GetClass(), RPExtraTeams[ply:Team()].weapons)) then
					table.insert(LootBox.Weapons, weapon:GetClass())
				end
			else
				table.insert(LootBox.Weapons, weapon:GetClass())	
			end
		end
	end
		CheckIfEmpty(LootBox:EntIndex())
end 
hook.Add("PlayerDeath", "create_loot_box", CreateLootBox)

local function UpdateBox(entid)
	for k, v in pairs(player.GetAll()) do
	   if(v.LastUsedBoxId==entid) then
			net.Start( "LC_UpdateStuff" )
				net.WriteTable( Entity(entid).Weapons )
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
	if(!IsValid(Entity(entid)) or Entity(entid):GetClass()!="prop_ragdoll" or ply:Health()<=0) then return end
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
end)

local Delay = 1
local Refresh = 0

local function OpenLootMenu(ply, entid, entweps, victimname)
	net.Start( "LC_OpenMenu" )
		net.WriteInt( entid, 16 )
		net.WriteTable( entweps )
		net.WriteString( victimname )
	net.Send( ply )
end


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
	--------------------
	OpenLootMenu(ply, self:EntIndex(), self.Weapons, self.VictimName)
	ply.LastUsedBoxId = self:EntIndex()
	--------------------
	Refresh = CurTime() + Delay
	end
end)