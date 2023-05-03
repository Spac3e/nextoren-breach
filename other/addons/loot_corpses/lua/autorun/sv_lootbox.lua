if CLIENT then end

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

local function Check_Weapons(ply)
if ply:GTeam() == TEAM_SPEC then return end
if ply:GTeam() == TEAM_SCP then return end
   timer.Simple( 0.02, function()
      ply.wepspawnwith = ply:GetWeapons() 
   end)
end 

local function CreateLootBox(ply)
if ply:GTeam() == TEAM_SPEC then return end
if ply:GTeam() == TEAM_SCP then return end
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
		local tr = util.TraceLine({
			start  = ply:GetPos() + ply:GetUp()*20,
			endpos = ply:GetPos() + ply:GetUp()*20 + Vector(0,0,-1000000),
			filter = ply
			-- mask = MASK_NPCWORLDSTATIC 
		})
		
		Hit = tr.HitPos
	end
	
	LootBox=ents.Create("loot_box")
	LootBox:SetPos(Hit)
	LootBox:SetAngles(Angle(0,math.random(0,360),0))
	LootBox:Spawn()
	
	LootBox.VictimName = ply:GetNClass()
	LootBox.IsLooted = false
	
	LootBox.Weapons = {}
	for i, weapon in pairs (ply:GetWeapons()) do
		if(!IsWep(weapon:GetClass(), LC.UndroppableWeapons)) then
			if(LC.DisSpawnWeps) then
				if(!IsWep(weapon:GetClass(), ply.wepspawnwith)) then
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
