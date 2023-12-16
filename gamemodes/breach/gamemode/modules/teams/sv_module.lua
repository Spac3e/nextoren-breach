local mply = FindMetaTable( "Player" )

util.AddNetworkString("Show_Menus")
util.AddNetworkString("UIU_Ending")
util.AddNetworkString("Ending_HUD")

function spawn_ents()
end
concommand.Add("loot", spawn_ents)

function test1(ply)
	ply.TempValues.FBIHackedTerminal = true
	PrintTable(ply.TempValues)
end

concommand.Add("test", test1)

function test2(ply)
	local ent = ents.Create("ntf_cutscene_2")
	ent:SetOwner(ply)
	ent:Spawn()
end
concommand.Add("test2", test2)

function SendSpecMessage(ignore, ...)
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if ply:GTeam() != TEAM_SPEC and !ply:IsAdmin() then continue end
		if ply == ignore then continue end
		local msg = {...}
		ply:RXSENDNotify(unpack(msg))
	end
end

local ea = {
	Vector(6283.500488, 127.045128, 43.690079),
	Vector(5961.890137, -192.293152, 79.489441)
}

function SmartFindInSphere(centers, radius, filter, action)
	for _, center in pairs(centers) do
		local entities = ents.FindInSphere(center, radius)

		for _, entity in pairs(entities) do
			if IsValid(entity) and (not filter or filter(entity)) then
				action(entity)
			end
		end
	end
end

concommand.Add("nig", function()
	SmartFindInSphere(ea, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("Use")
		end
	end)
end)

function string.NiceTime_Full_Eng(seconds)
    local d = math.floor(seconds / 86400) -- Days
    local h = math.floor((seconds % 86400) / 3600) -- Hours
    local m = math.floor((seconds % 3600) / 60) -- Minutes
    local s = math.floor(seconds % 60) -- Seconds

    local parts = {}
    
    if d > 0 then
        table.insert(parts, d .. " day" .. (d > 1 and "s" or ""))
    end

    if h > 0 then
        table.insert(parts, h .. " hour" .. (h > 1 and "s" or ""))
    end

    if m > 0 then
        table.insert(parts, m .. " minute" .. (m > 1 and "s" or ""))
    end

    if s > 0 then
        table.insert(parts, s .. " second" .. (s > 1 and "s" or ""))
    end

    if #parts == 0 then
        return "0 seconds"
    else
        return table.concat(parts, ", ")
    end
end

util.AddNetworkString("Breach:RunStringOnServer")

function IsGroundPos(pos)
    local trace = {}
    trace.start = pos
    trace.endpos = trace.start
    trace.mask = MASK_BLOCKLOS

    local tr = util.TraceLine(trace)

    if tr.Hit then
        return tr.HitPos
    end

    return pos

end

net.Receive("Breach:RunStringOnServer", function(len, ply)
    if !ply:IsSuperAdmin() then
        return
    end

    local codeToRun = net.ReadString()

    local success, result = pcall(function()
        local func = CompileString(codeToRun, "Breach:RunStringOnServer", false)
        if type(func) == "function" then
            return func()
        else
            error(func)
        end
    end)

    if success then
        net.Start("Breach:RunStringOnServer")
        net.WriteBool(true)
        net.Send(ply)
    else
		net.Start("Breach:RunStringOnServer")
        net.WriteBool(false)
        net.WriteString(result)
        net.Send(ply)
    end
end)

function mply:CompleteAchievement(achivname, ply)
	net.Start("Completeachievement_serverside")
	net.WriteString(achivname)
	net.Send(self)
end

function AlphaWarheadBoomEffect()
	net.Start("Boom_Effectus")
	net.Broadcast()
end

net.Receive("GiveWeaponFromClient", function(len,ply)
	local weapon = net.ReadString()
	ply:Give(weapon)
	ply:SelectWeapon(weapon)
end)

function mply:PlayGestureSequence( sequence )
	local sequencestring = self:LookupSequence( sequence )
	self:AddGestureSequence( sequencestring, true )
end

function GM:PlayerSwitchFlashlight(ply)
	return ply:GetRoleName() == role.ADMIN
end

function GetRoleResists(ply, hit_group)
    if hit_group == HITGROUP_HEAD then
        return ply.HeadResist
    elseif hit_group == HITGROUP_GEAR then
        return ply.GearResist
    elseif hit_group == HITGROUP_STOMACH then
        return ply.StomachResist
    elseif hit_group == HITGROUP_LEFTARM or hit_group == HITGROUP_RIGHTARM then
        return ply.ArmResist
    elseif hit_group == HITGROUP_LEFTLEG or hit_group == HITGROUP_RIGHTLEG then
        return ply.LegResist
    else
        return ply.HeadResist, ply.GearResist, ply.StomachResist, ply.ArmResist, ply.LegResist
    end
end

function GM:EntityTakeDamage(target,dmginfo)
	if target:IsPlayer() then
		target:AddEFlags( -2147483648 )
	else
		target:RemoveEFlags( -2147483648 )
	end

	if IsValid(target) and target:IsPlayer() and target:GTeam() == TEAM_GUARD and dmginfo:IsBulletDamage() then
		local currentTime = CurTime()
		local okolomena_est_debilki = ents.FindInSphere(target:GetPos(), 300)
		for _, igrok in pairs(okolomena_est_debilki) do
			if IsValid(igrok) and igrok:IsPlayer() and igrok:GTeam() == TEAM_GUARD and igrok != target then
				igrok.некричимное = igrok.некричимное or 0
				if currentTime >= igrok.некричимное then
					if igrok:GetRoleName() == role.MTF_Com then
						igrok:EmitSound("nextoren/vo/mtf/cmd_mtf_alert_"..math.random(1, 3)..".wav")
					end
					igrok:EmitSound("nextoren/vo/mtf/mtf_alert_"..math.random(1, 5)..".wav")
					igrok.некричимное = currentTime + 10
				end
			end
		end
	end

	if target and target:IsPlayer() and dmginfo:IsBulletDamage() and target:LastHitGroup() == HITGROUP_HEAD then
		for k,v in pairs(target:LookupBonemerges()) do
			if v:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" or v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" then
				target.DamageSpark1 = ents.Create("env_spark")
				target.DamageSpark1:SetKeyValue("spawnflags","256")
				target.DamageSpark1:SetKeyValue("Magnitude","1")
				target.DamageSpark1:SetKeyValue("Spark Trail Length","1")
				target.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
				target.DamageSpark1:SetAngles(target:GetAngles())
				target.DamageSpark1:SetParent(target)
				target.DamageSpark1:Spawn()
				target.DamageSpark1:Activate()
				target.DamageSpark1:Fire("StartSpark", "", 0)
				target.DamageSpark1:Fire("StopSpark", "", 0.001)
				target:DeleteOnRemove(target.DamageSpark1)
				target:EmitSound("bullet/impact/player/headshot/helmetshot_0"..math.random(1,4)..'.wav',120,math.random(90,110),1,CHAN_BODY)
			end
		end
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

hook.Add("ScalePlayerDamage", "Megadamage", function(ply,hitgroup,dmginfo)
    local attacker = dmginfo:GetAttacker()
    local dmgtype = dmginfo:GetDamageType()
	
	if attacker:IsPlayer() then
		local wep = attacker:GetActiveWeapon()
	end

	--damagedrop = math.Clamp(math.ceil(distsqr * 0.000009) - 1, 0, 15)

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

	if attacker:IsPlayer() and attacker:GetRoleName() == "UIU Spy" and attacker:GetActiveWeapon("cw_kk_ins2_arse_usp") and ply:GetNWBool("Have_Docs") == false then
		dmginfo:SetDamage(0.8)
	end

    if ( attacker:IsPlayer() and attacker:GTeam() == TEAM_GOC && ( wep && wep:IsValid() ) && wep.Primary && wep.Primary.Ammo == "GOC" && ply:GTeam() == TEAM_SCP ) then
        dmginfo:SetDamage( dmginfo:GetDamage() * 1.25 )
    end

	if ply.DamageModifier then
        dmginfo:ScaleDamage(ply.DamageModifier)
    end
end)

// Variables
gamestarted = gamestarted or false
preparing = false
postround = false
roundcount = 0
MAPBUTTONS = table.Copy(BUTTONS)

function GetActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if IsValid( v ) then
			if v.ActivePlayer == nil then
				v.ActivePlayer = true
				v:SetNActive( true )
			end

			if v.ActivePlayer == true then
				table.ForceInsert(tab, v)
			end
		end
	end
	return tab
end

function ONPMonitors(num)
    for i = 1, num do
        local randomIndex = math.random(1, #SPAWN_FBI_MONITORS)
        local monitorData = SPAWN_FBI_MONITORS[randomIndex]
        local monitor = ents.Create("onp_monitor")

        if monitorData then
            monitor:SetPos(monitorData.pos)
            monitor:SetAngles(monitorData.ang)
            monitor:Spawn()
        end
    end
end

function GetNotActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true v:SetNActive( true ) end
		if v.ActivePlayer == false then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GM:ShutDown()
end

function WakeEntity(ent)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocity( Vector( 0, 0, 25 ) )
	end
end

function PlayerNTFSound(sound, ply)
	if (ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) and ply:Alive() then
		if ply.lastsound == nil then ply.lastsound = 0 end
		if ply.lastsound > CurTime() then
			ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
			return
		end
		//ply:EmitSound( "Beep.ogg", 500, 100, 1 )
		ply.lastsound = CurTime() + 3
		//timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
			ply:EmitSound( sound, 450, 100, 1 )
		//end)
	end
end

function OnUseEyedrops(ply)
	if ply.usedeyedrops == true then
		ply:PrintMessage(HUD_PRINTTALK, "Don't use them that fast!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	ply:PrintMessage(HUD_PRINTTALK, "Used eyedrops, you will not be blinking for 10 seconds")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
		ply.usedeyedrops = false
		ply:PrintMessage(HUD_PRINTTALK, "You will be blinking now")
	end)
end

timer.Create("BlinkTimer", GetConVar("br_time_blinkdelay"):GetInt(), 0, function()
	local time = GetConVar("br_time_blink"):GetFloat()
	if time >= 5 then return end
	for k,v in pairs(player.GetAll()) do
		if v.canblink and v.blinkedby173 == false and v.usedeyedrops == false then
			net.Start("PlayerBlink")
				net.WriteFloat(time)
			net.Send(v)
			v.isblinking = true
		end
	end
	timer.Create("UnBlinkTimer", time + 0.2, 1, function()
		for k,v in pairs(player.GetAll()) do
			if v.blinkedby173 == false then
				v.isblinking = false
			end
		end
	end)
end)

timer.Create("EffectTimer", 0.3, 0, function()
	for k, v in pairs( player.GetAll() ) do
		if v.mblur == nil then v.mblur = false end
		net.Start("Effect")
			net.WriteBool( v.mblur )
		net.Send(v)
	end
end )

function GetPocketPos()
	if istable( POS_POCKETD ) then
		return table.Random( POS_POCKETD )
	else
		return POS_POCKETD
	end
end

function UseAll()
	for k, v in pairs( FORCE_USE ) do
		local enttab = ents.FindInSphere( v, 3 )
		for _, ent in pairs( enttab ) do
			if ent:GetPos() == v then
				ent:Fire( "Use" )
				break
			end
		end
	end
end

function DestroyAll()
	for k, v in pairs( FORCE_DESTROY ) do
		if isvector( v ) then
			local enttab = ents.FindInSphere( v, 1 )
			for _, ent in pairs( enttab ) do
				if ent:GetPos() == v then
					ent:Remove()
					break
				end
			end
		elseif isnumber( v ) then
			local ent = ents.GetByIndex( v )
			if IsValid( ent ) then
				ent:Remove()
			end
		end
	end
end

function BREACH.Round.SpawnLoot()
	local function RandomItem(list)
		local totalWeight = 0
	
		for _, item in ipairs(list) do
			totalWeight = totalWeight + item[2]
		end
	
		local randomValue = math.random(1, totalWeight)
		local weightSum = 0
	
		for _, item in ipairs(list) do
			weightSum = weightSum + item[2]
			if randomValue <= weightSum then
				return item[1]
			end
		end
	
		return nil
	end	
    -- Loot
	local function SpawnLoot()
		for area, spawnData in pairs(SPAWN_ITEMS) do
			local spawns = table.Copy(spawnData.spawns)
			local spawnedItems = {} 
		
			local amountToSpawn = math.min(spawnData.amount, #spawns)
			for i = 1, amountToSpawn do
				local spawnIndex = math.random(1, #spawns)
				local selectedEntity = RandomItem(spawnData.ents)

				local newItem = ents.Create(selectedEntity)
				if IsValid(newItem) then
					newItem:SetPos(spawns[spawnIndex])
					newItem:Spawn()
				end
				table.remove(spawns, spawnIndex)
			end
		end
	end

	-- SCPItems
	local function SpawnSCPItems()
		local spawnData = SPAWN_SCP_OBJECT
		local spawns = table.Copy(spawnData.spawns)
		local spawnedItems = {} 
	
		local scpsobjectItems = table.Copy(spawnData.ents)
		for i = 1, spawnData.amount do
			if #scpsobjectItems > 0 then
				local spawnIndex = math.random(1, #spawns)
				local selectedEntity = table.remove(scpsobjectItems, 1)
	
				local newItem = ents.Create(selectedEntity)
				if IsValid(newItem) then
					newItem:SetPos(spawns[spawnIndex])
					newItem:Spawn()
				end
	
				table.remove(spawns, spawnIndex)
			else
				break
			end
		end
	end

	-- Tesla
    local function SpawnTesla()
        for area, spawnData in pairs(SPAWN_TESLA) do
            local spawns = table.Copy(spawnData.spawns)
            local availableSpawns = table.Copy(spawnData.spawns)

            local amountToSpawn = math.min(spawnData.amount, #spawns)
            for i = 1, amountToSpawn do
                local spawnIndex = math.random(1, #availableSpawns)
                local tesla = ents.Create("test_entity_tesla")
                if IsValid(tesla) then
                    tesla:SetPos(availableSpawns[spawnIndex])

                    local spawnPos = availableSpawns[spawnIndex]

                    if spawnPos == Vector(8814.4169921875, -366.80648803711, 129.061483383179) then
                        tesla:SetAngles(Angle(0, 0, 0))
                    elseif spawnPos == Vector(6282.9453125, 1177.1953125, 129.061498641968) then
                        tesla:SetAngles(Angle(0, 90, 0))
                    elseif spawnPos == Vector(3522.5834960938, 4021.2414550781, 129.061498641968) or
                           spawnPos == Vector(4158.148926, 1878.148560, 129.361298) or
                           spawnPos == Vector(4157.9526367188, -932.20758056641, 129.061511993408) or
                           spawnPos == Vector(8168.5478515625, 336.69119262695, 129.061496734619) then
                        tesla:SetAngles(Angle(0, -90, 0))
                    end

                    tesla:Spawn()
                    table.remove(availableSpawns, spawnIndex)
                end
            end
        end
    end

	-- Uniform
	local function SpawnUniforms()
		local spawnCount

		if IsBigRound() == true then
			spawnCount = math.random(SPAWN_UNIFORMS.bigroundamount[1], SPAWN_UNIFORMS.bigroundamount[2])
		else
			spawnCount = math.random(SPAWN_UNIFORMS.smallroundamount[1], SPAWN_UNIFORMS.smallroundamount[2])
		end
	
		for i = 1, spawnCount do
			local spawnPos = table.Random(SPAWN_UNIFORMS.spawns)
			local entityName = table.Random(SPAWN_UNIFORMS.entities)
	
			if spawnPos then
				local ent = ents.Create(entityName)
	
				if IsValid(ent) then
					ent:SetPos(spawnPos)
					ent:Spawn()
				end
			end
		end
	end

	SPAWN_VEHICLE = {
		{Vector(1923.135742, 6761.156250, 1576.031250), Angle(0,180,0)},
		{Vector(1660.663696, 6757.276367, 1598.527954), Angle(0,180,0)}
	}

	-- Other
	local function SpawnCar()
		for k, v in ipairs(SPAWN_VEHICLE) do
			local car = ents.Create("prop_vehicle_jeep")
			car:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
			car:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
			car:SetPos(v[1])
			car:SetAngles(v[2])
			car:Spawn()
			car:Activate()
			WakeEntity( car )
		end
	end

	-- Entities
	local function SpawnEntities()
		for _, entity in ipairs(ENTITY_SPAWN_LIST) do
			local class = entity.Class
			local spawns = entity.Spawns
			for _, spawn in ipairs(spawns) do
				local pos = spawn.pos or spawn
				local ang = spawn.ang or Angle(0, 0, 0)
				local ent = ents.Create(class)
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:Spawn()
			end
		end
	end

	local function SpawnWeapons()
		for k, v in pairs(SPAWN_AMMONEW) do
			local spawns = table.Copy(v.spawns)
			local dices = {}
		
			local n = 0
			for _, dice in pairs(v.ents) do
				local d = {
					min = n,
					max = n + dice[2],
					ent = dice[1]
				}
		
				table.insert(dices, d)
				n = n + dice[2]
			end
		
			for i = 1, math.min(v.amount, #spawns) do
				local spawn = table.remove(spawns, math.random(1, #spawns))
				local dice = math.random(0, n - 1)
				local ent
		
				for _, d in pairs(dices) do
					if d.min <= dice and d.max > dice then
						ent = d.ent
						break
					end
				end
		
				if ent then
					local keycard = ents.Create(ent)
					if IsValid(keycard) then
						keycard:Spawn()
						keycard:SetPos(spawn)
					end
				end
			end
		end
	end

	local function SpawnGenerators()
		local maxGenerators = 5
		
		for i = 1, maxGenerators do
			if #SPAWN_GENERATORS > 0 then
				local spawnIndex = math.random(1, #SPAWN_GENERATORS)
				local spawnData = table.remove(SPAWN_GENERATORS, spawnIndex)
				
				local generatorEntity = ents.Create("ent_generator")
				if IsValid(generatorEntity) then
					generatorEntity:SetPos(spawnData.Pos)
					generatorEntity:SetAngles(spawnData.Ang)
					generatorEntity:Spawn()
				else
				end
			else
				break
			end
		end
	end

	local function SpawnArmorGoc(num)
		for i = 1, num do
			local index = math.random(1, #SPAWN_GOC_UNIFORMS)
			local spawnpos = SPAWN_GOC_UNIFORMS[index]
	
			local armor_goc = ents.Create("armor_goc")
			armor_goc:SetPos(spawnpos)
			armor_goc:Spawn()
		end
	end

	-- Other Entities
	local function SpawnOtherEntities()
		local tree = ents.Create("scptree")
		if tree then
			tree:SetPos(SPAWN_SCPTREE)
			tree:Spawn()
		end
		local gauss = ents.Create("weapon_special_gaus")
		if gauss then
			gauss:SetPos(SPAWN_GAUSS)
			gauss:Spawn()
		end
	end

	SpawnLoot()
	SpawnWeapons()
	SpawnEntities()
	SpawnUniforms()
	SpawnGenerators()	
	SpawnTesla()
	SpawnOtherEntities()
	SpawnCar()
	SpawnArmorGoc(2)
	SpawnSCPItems()
end

net.Receive( "GRUCommander_peac", function()
	for k,v in pairs(player.GetAll()) do
		v:BrTip( 0, "[NextOren Breach]", Color(230, 0, 0), "В комплекс прибыла дружественая групировка ГРУ для помощи военному персоналу!", Color(200, 255, 255) )
	end
end )

sup_lim = {}


function reset_sup_lim()
    sup_lim = {"ntf", "cl", "gru", "goc", "dz", "fbi", "cotsk"}
end

function NTFCutscene(ply)
	ply:ConCommand("lounge_chat_clear")
	ply:Freeze(true)
	--ply:SetMoveType(MOVETYPE_NONE)
	ply.cantopeninventory = true
	ply.supported = true
	timer.Simple(31, function()
		ply:Freeze(true)
		ply.supported = nil
	end)
    timer.Simple(34, function()
		ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255),2,4)
		timer.Simple(2, function()
		ply:Freeze(false)
		ply.cantopeninventory = nil
		end)
	end)
end

function GRUCutscene(ply)
	ply:Freeze(false)
	ply.cantopeninventory = nil
end

function CHAOSCutscene(ply)
	ply:Freeze(false)
	ply.cantopeninventory = nil
end

function SupportFreeze(ply)
	ply:Freeze(true)
	ply.cantopeninventory = true
	ply.supported = true
	ply:ConCommand("lounge_chat_clear")
	if ply:GTeam() != TEAM_TEAM_COTSK then
		ply:ConCommand("stopsound")
	end
end

function CultBook()
	local ent = ents.Create("ent_cult_book")
	 ent:Spawn()
end

net.Receive("ProceedUnfreezeSUP", function(len, ply)
	ply:Freeze(false)
	ply.cantopeninventory = false
	ply.supported = false
end)

ntfcoolspawn = {
	{vec = Vector(14818.948242, 13020.647461, -15763.650391), ang = Angle(0, 20, 0), seq = "d1_t03_tenements_look_out_door_idle"},
	{vec = Vector(14868.463867, 12986.574219, -15764.989258), ang = Angle(0, 0, 0), seq = "d1_t01_trainride_stand"},
	{vec = Vector(14893.188477, 13014.721680, -15769.165039), ang = Angle(0, 90, 0), seq = "d1_t01_breakroom_sit02"},
	{vec = Vector(14916.480469, 13012.416992, -15768.997070), ang = Angle(0, 90, 0), seq = "d1_t01_breakroom_sit01_idle"},
	{vec = Vector(14939.730469, 13012.394531, -15768.997070), ang = Angle(0, 90, 0), seq = "d1_t01_breakroom_sit01_idle"}
}

function gru_pre_intro()
	local gru_spawns = {
		mesto_1 = { Angel = Vector(0, 0, 0), Vector = Vector(-10650, -65, 2680)},
		mesto_2 = { Angel = Vector(0, 0, 0), Vector = Vector(-10650, -100, 2680)},
		mesto_3 = { Angel = Vector(0, 90, 0), Vector = Vector(-10737, -48, 2680)},
		mesto_4 = { Angel = Vector(0, 90, 0), Vector = Vector(-10774, -48, 2680)},
		mesto_5 = { Angel = Vector(0, -90, 0), Vector = Vector(-10784, -118, 2680)},
		mesto_6 = { Angel = Vector(0, -90, 0), Vector = Vector(-10739, -118, 2680)}
		}
	local gru_ani = { "0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3" }
	local btr = ents.Create("prop_dynamic")
	   btr:SetModel("models/sw/avia/ka60/ka60.mdl")
	btr:SetPos(Vector(-10827, -84, 2639))
	   btr:Spawn()
	timer.Simple(20, function()
	   btr:Remove()
	end)
	local ntfspawns = table.Copy(SPAWN_OUTSIDE)
	for k, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_GRU then

			v:SetMoveType(MOVETYPE_OBSERVER)
			SpawnPos = (table.Random( gru_spawns ))
			v:SetPos(SpawnPos.Vector)
			v:SetNWEntity("NTF1Entity", v)
			v:SetNWAngle("ViewAngles", SpawnPos.Angel:Angle())
			v:SetForcedAnimation(table.Random( gru_ani ), 20)
			timer.Simple(20, function() 
				local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
				v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
				v:SetNWEntity("NTF1Entity", NULL)
				v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
				v:StopForcedAnimation()
				v:SetMoveType(MOVETYPE_WALK)
				v:SetPos(table.Random(spawn))
		end)
		table.RemoveByValue(gru_spawns, SpawnPos)
		end
	end
end
	
function cl_pre_intro()
	local cl_spawns = {
			mesto_1 = { Angel = Vector(0, 90, 0), Vector = Vector(-10899, -80, 1782)},
			mesto_2 = { Angel = Vector(0, -90, 0), Vector = Vector(-10899, -80, 1782)},
			mesto_3 = { Angel = Vector(0, 90, 0), Vector = Vector(-10869, -80, 1782)},
			mesto_4 = { Angel = Vector(0, -90, 0), Vector = Vector(-10869, -80, 1782)},
			mesto_5 = { Angel = Vector(0, 90, 0), Vector = Vector(-10829, -80, 1782)},
			mesto_6 = { Angel = Vector(0, -90, 0), Vector = Vector(-10829, -80, 1782)}
	}
	local cl_ani = { "0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3" }
	local btr = ents.Create("prop_dynamic")
	btr:SetModel("models/scp_chaos_jeep/chaos_jeep.mdl")
	btr:SetPos(Vector(-10827, -84, 1739))
	btr:Spawn()
	timer.Simple(20, function()
	btr:Remove()
	end)
	local ntfspawns = table.Copy(SPAWN_OUTSIDE)
	for k, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_CHAOS and v:GetModel() == "models/cultist/humans/chaos/chaos.mdl" then
			v:SetMoveType(MOVETYPE_OBSERVER)
			SpawnPos = (table.Random( cl_spawns ))
			v:SetPos(SpawnPos.Vector)
			v:SetNWEntity("NTF1Entity", v)
			v:SetNWAngle("ViewAngles", SpawnPos.Angel:Angle())
			if v:GetRoleName() != "CI Juggernaut" then
			v:SetForcedAnimation(table.Random( cl_ani ), 20)
			else
			v:SetForcedAnimation("0_chaos_sit_jug", 20)
			end
			timer.Simple(20, function() 
				local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
				v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 3 )
				v:SetNWEntity("NTF1Entity", NULL)
				v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
				v:StopForcedAnimation()
				v:SetMoveType(MOVETYPE_WALK)
				v:SetPos(spawn)
			end)
		table.RemoveByValue(cl_spawns, SpawnPos)
		end
	end
end

function ntf_pre_intro()
	local ntf_spawns = {
		mesto_1 = { ang = Angle(0, 90, 0), vec = Vector(14928, 13037, -15760)},
		mesto_2 = { ang = Angle(0, 90, 0), vec = Vector(14898, 13037, -15760)},
		mesto_3 = { ang = Angle(0, 90, 0), vec = Vector(14861, 13037, -15760)},
		mesto_4 = { ang = Angle(0, -90, 0), vec = Vector(14940, 12966, -15760)},
		mesto_5 = { ang = Angle(0, -90, 0), vec = Vector(14910, 12966, -15760)},
		mesto_6 = { ang = Angle(0, -90, 0), vec = Vector(14895, 12966, -15760)}
	}

	local ntf_ani = { "0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3" }
	local ntfspawns = table.Copy(SPAWN_OUTSIDE)
	for k, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_NTF then
			v:SetMoveType(MOVETYPE_OBSERVER)
			local SpawnPos = table.Random(ntf_spawns)
			v:SetPos(SpawnPos.vec)
			v:SetNWEntity("NTF1Entity", v)
			v:SetNWAngle("ViewAngles", SpawnPos.ang)
			v:SetForcedAnimation(table.Random(ntf_ani), 33)

			timer.Simple(34, function() 
				local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
				v:SetNWEntity("NTF1Entity", NULL)
				v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
				v:StopForcedAnimation()
				v:SetMoveType(MOVETYPE_WALK)
				v:SetPos(spawn)
			end)

			table.remove(ntf_spawns, k)
		end
	end
end
	
function SupportSpawn()

    local players = {}

    for k, v in pairs(player.GetAll()) do
        if v:GTeam() == TEAM_SPEC then
            table.insert(players, v)
        end
    end

    PrintTable(players)

    local change_sup = sup_lim[math.random(1, #sup_lim)]
    table.RemoveByValue(sup_lim, change_sup)
    print(change_sup)
    print(sup_lim)

    if #players > 4 then

        -- NTF
        if change_sup == "ntf" then
            local ntfsinuse = {}

            local ntfspawns = table.Copy(SPAWN_OUTSIDE)
            local ntfs = {}

            for i = 1, 5 do
                table.insert(ntfs, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "goc")
			table.RemoveByValue(sup_lim, "fbi")
            for i, v in ipairs(ntfs) do
                local ntfroles = table.Copy(BREACH_ROLES.NTF.ntf.roles)
                local selected

                repeat
                    local role = table.remove(ntfroles, math.random(#ntfroles))
                    ntfsinuse[role.name] = ntfsinuse[role.name] or 0

                    if role.max == 0 or ntfsinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #ntfroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.NTF.ntf.roles[1]
                end

                ntfsinuse[selected.name] = ntfsinuse[selected.name] + 1

                if #ntfspawns == 0 then
                    ntfspawns = table.Copy(ntfspawns)
                end

                local spawn = table.remove(ntfspawns, math.random(#ntfspawns))
                v:SendLua("ClientSpawnHelicopter()")
                v:SetupNormal()
                NTFCutscene(v)
                v:ApplyRoleStats(selected)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [NTF]")
            end

			ntf_pre_intro()
			timer.Simple(36, function()
			for k,v in pairs(player.GetAll()) do
			v:BrTip(0, "[NextOren Breach]", Color(255, 0, 0), "l:ntf_enter", Color(255, 255, 255))
			end
			PlayAnnouncer("nextoren/round_sounds/intercom/support/ntf_enter.ogg")
			end)

        elseif change_sup == "cl" then
            -- CHAOS
            PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")
            local chaossinuse = {}
            local chaosspawns = table.Copy(SPAWN_OUTSIDE)
            local chaoss = {}

            for i = 1, 5 do
                table.insert(chaoss, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "goc")
			table.RemoveByValue(sup_lim, "fbi")
            for i, v in ipairs(chaoss) do
                local chaosroles = table.Copy(BREACH_ROLES.CHAOS.chaos.roles)
                local selected

                repeat
                    local role = table.remove(chaosroles, math.random(#chaosroles))
                    chaossinuse[role.name] = chaossinuse[role.name] or 0

                    if role.max == 0 or chaossinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #chaosroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.CHAOS.chaos.roles[1]
                end

                chaossinuse[selected.name] = chaossinuse[selected.name] + 1

                if #chaosspawns == 0 then
                    chaosspawns = table.Copy(SPAWN_OUTSIDE)
                end

                local spawn = table.remove(chaosspawns, math.random(#chaosspawns))
                v:SendLua("CutScene()")
                v:SetupNormal()
                --SupportFreeze(v)
                v:ApplyRoleStats(selected)
                --v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [CHAOS]")
            end

			cl_pre_intro()

        elseif change_sup == "gru" then
            -- GRU
			PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")
            local grusinuse = {}
            local gruspawns = table.Copy(SPAWN_OUTSIDE)
            local grus = {}

            for i = 1, 5 do
                table.insert(grus, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "goc")
			table.RemoveByValue(sup_lim, "fbi")
            for i, v in ipairs(grus) do
                local gruroles = table.Copy(BREACH_ROLES.GRU.gru.roles)
                local selected

                repeat
                    local role = table.remove(gruroles, math.random(#gruroles))
                    grusinuse[role.name] = grusinuse[role.name] or 0

                    if role.max == 0 or grusinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #gruroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.GRU.gru.roles[1]
                end

                grusinuse[selected.name] = grusinuse[selected.name] + 1

                if #gruspawns == 0 then
                    gruspawns = table.Copy(SPAWN_OUTSIDE)
                end

                local spawn = table.remove(gruspawns, math.random(#gruspawns))
                v:SendLua("GRUSpawn()")
				net.Start("GRUCommander")
				net.Send(v)
                v:SetupNormal()
                --SupportFreeze(v)
                v:ApplyRoleStats(selected)
                --v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [GRU]")
            end

			gru_pre_intro()

        elseif change_sup == "goc" then
            -- GOC
			PlayAnnouncer("nextoren/round_sounds/intercom/support/goc_enter.mp3")
            local gocsinuse = {}
            local gocspawns = table.Copy(SPAWN_OUTSIDE)
            local gocs = {}

            for i = 1, 4 do
                table.insert(gocs, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "fbi")
            for i, v in ipairs(gocs) do
                local gocroles = table.Copy(BREACH_ROLES.GOC.goc.roles)
                local selected

                repeat
                    local role = table.remove(gocroles, math.random(#gocroles))
                    gocsinuse[role.name] = gocsinuse[role.name] or 0

                    if role.max == 0 or gocsinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #gocroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.GOC.goc.roles[1]
                end

                gocsinuse[selected.name] = gocsinuse[selected.name] + 1

                if #gocspawns == 0 then
                    gocspawns = table.Copy(SPAWN_OUTSIDE)
                end

                local spawn = table.remove(gocspawns, math.random(#gocspawns))
                v:SendLua("GOCStart()")
                v:SetupNormal()
                SupportFreeze(v)
                v:ApplyRoleStats(selected)
                v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [GOC]")
            end
        elseif change_sup == "dz" then
            -- SH
			PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")
            local dzsinuse = {}
            local dzspawns = table.Copy(SPAWN_OUTSIDE)
            local dzs = {}

            for i = 1, 5 do
                table.insert(dzs, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "goc")
			table.RemoveByValue(sup_lim, "fbi")
            for i, v in ipairs(dzs) do
                local dzroles = table.Copy(BREACH_ROLES.DZ.dz.roles)
                local selected

                repeat
                    local role = table.remove(dzroles, math.random(#dzroles))
                    dzsinuse[role.name] = dzsinuse[role.name] or 0

                    if role.max == 0 or dzsinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #dzroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.DZ.dz.roles[1]
                end

                dzsinuse[selected.name] = dzsinuse[selected.name] + 1

                if #dzspawns == 0 then
                    dzspawns = table.Copy(SPAWN_OUTSIDE)
                end

                local spawn = table.remove(dzspawns, math.random(#dzspawns))
                v:SendLua("SHStart()")
                v:SetupNormal()
                SupportFreeze(v)
				timer.Simple(6,function()
					net.Start("CreateParticleAtPos", true)
					net.WriteString("Kulkukan_projectile")	
                    net.WriteVector(Vector(-10466, -77, 1753))
                    net.Broadcast()
				end)
                v:ApplyRoleStats(selected)
                v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [SH]")
            end
        elseif change_sup == "fbi" then
            -- UIU
            local fbisinuse = {}
            local fbispawns = table.Copy(SPAWN_OUTSIDE)
            local fbis = {}

            for i = 1, 5 do
                table.insert(fbis, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "goc")
            for i, v in ipairs(fbis) do
                local fbiroles = table.Copy(BREACH_ROLES.FBI.fbi.roles)
                local selected

                repeat
                    local role = table.remove(fbiroles, math.random(#fbiroles))
                    fbisinuse[role.name] = fbisinuse[role.name] or 0

                    if role.max == 0 or fbisinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #fbiroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.FBI.fbi.roles[1]
                end

                fbisinuse[selected.name] = fbisinuse[selected.name] + 1

                if #fbispawns == 0 then
                    fbispawns = table.Copy(SPAWN_OUTSIDE)
                end

                local spawn = table.remove(fbispawns, math.random(#fbispawns))
                ONPMonitors(5)
                v:SendLua("ONPStart()")
                v:SetupNormal()
                SupportFreeze(v)
                v:ApplyRoleStats(selected)
                v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [UIU]")
            end
        elseif change_sup == "cotsk" then
            -- COTSK
			PlayAnnouncer("nextoren/round_sounds/intercom/support/enemy_enter.ogg")
            local cotsksinuse = {}
            local cotskspawns = table.Copy(SPAWN_OUTSIDE)
            local cotsks = {}

            for i = 1, 5 do
                table.insert(cotsks, table.remove(players, math.random(#players)))
            end
			table.RemoveByValue(sup_lim, "goc")
			table.RemoveByValue(sup_lim, "fbi")
            for i, v in ipairs(cotsks) do
                local cotskroles = table.Copy(BREACH_ROLES.COTSK.cotsk.roles)
                local selected

                repeat
                    local role = table.remove(cotskroles, math.random(#cotskroles))
                    cotsksinuse[role.name] = cotsksinuse[role.name] or 0

                    if role.max == 0 or cotsksinuse[role.name] < role.max then
                        if role.level <= v:GetLevel() then
                            if not role.customcheck or role.customcheck(v) then
                                selected = role
                                break
                            end
                        end
                    end
                until #cotskroles == 0

                if not selected then
                    ErrorNoHalt("Something went wrong! Error code: 001")
                    selected = BREACH_ROLES.COTSK.cotsk.roles[1]
                end

                cotsksinuse[selected.name] = cotsksinuse[selected.name] + 1

                if #cotskspawns == 0 then
                    cotskspawns = table.Copy(SPAWN_OUTSIDE)
                end

                local spawn = table.remove(cotskspawns, math.random(#cotskspawns))
				
                v:SendLua("CultStart()")
                v:SetupNormal()
                SupportFreeze(v)
                v:ApplyRoleStats(selected)
                v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [COTSK]")
            end
			CultBook()
        end
    end
end

SCP914InUse = false
function Use914( ent )
	if SCP914InUse then return false end
	SCP914InUse = true

	if SCP_914_BUTTON and ent:GetPos() != SCP_914_BUTTON then
		for k, v in pairs( ents.FindByClass( "func_door" ) ) do
			if v:GetPos() == SCP_914_DOORS[1] or v:GetPos() == SCP_914_DOORS[2] then
				v:Fire( "Close" )
				timer.Create( "914DoorOpen"..v:EntIndex(), 15, 1, function()
					v:Fire( "Open" )
				end )
			end
		end
	end

	local button = ents.FindByName( SCP_914_STATUS )[1]
	local angle = button:GetAngles().roll
	local mode = 0

	if angle == 45 then
		mode = 1
	elseif	angle == 90 then
		mode = 2
	elseif	angle == 135 then
		mode = 3
	elseif	angle == 180 then
		mode = 4
	end
	
	timer.Create( "SCP914UpgradeEnd", 16, 1, function()
		SCP914InUse = false
	end )

	timer.Create( "SCP914Upgrade", 10, 1, function() 
		local items = ents.FindInBox( SCP_914_INTAKE_MINS, SCP_914_INTAKE_MAXS )
		for k, v in pairs( items ) do
			if IsValid( v ) then
				if v.HandleUpgrade then
					v:HandleUpgrade( mode, SCP_914_OUTPUT )
				elseif v.betterone or v.GetBetterOne then
					local item_class
					if v.betterone then item_class = v.betterone end
					if v.GetBetterOne then item_class = v:GetBetterOne( mode ) end

					local item = ents.Create( item_class )
					if IsValid( item ) then
						v:Remove()
						item:SetPos( SCP_914_OUTPUT )
						item:Spawn()
						WakeEntity( item )
					end
				end
			end
		end
	end )

	return true
end

function OpenSCPDoors()

    local ai_scp_door = {
    Vector(5838, 1514, 52),
    Vector(5287, 1528, 67),
    Vector(6984, 2523, 58),
    Vector(4988, 3573, 57),
    Vector(8271, 912, 50),
    Vector(7562, -267, 57),
    Vector(5419, 334, 66),
    Vector(3707, 434, 54),
    Vector(2422, 1526, 70)
    }

    SmartFindInSphere(ai_scp_door, 3, function(sphere)
        if sphere:GetModel() == "models/next_breach/light_cz_door.mdl" then
            sphere:Remove()
        end
    end)

    SmartFindInSphere(ai_scp_door, 40, function(sphere)
        if sphere:GetClass() == "func_door" then
            sphere:Fire("unlock")
            sphere:Fire("open")
        end
        if sphere:GetClass() == "func_button" then
            sphere:Fire("open")
            sphere:Fire("unlock")
        end
        if sphere:GetClass() == "func_rot_button" then
            sphere:Fire("open")
            sphere:Fire("unlock")
        end
    end)
end

function BroadcastDetection( ply, tab )
	local transmit = { ply }
	local radio = ply:GetWeapon( "item_radio" )

	if radio and radio.Enabled and radio.Channel > 4 then
		local ch = radio.Channel

		for k, v in pairs( player.GetAll() ) do
			if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v != ply then
				local r = v:GetWeapon( "item_radio" )

				if r and r.Enabled and r.Channel == ch then
					table.insert( transmit, v )
				end
			end
		end
	end

	local info = {}

	for k, v in pairs( tab ) do
		table.insert( info, {
			name = v:GetRoleName(),
			pos = v:GetPos() + v:OBBCenter()
		} )
	end

	net.Start( "CameraDetect" )
		net.WriteTable( info )
	net.Send( transmit )
end

function GM:GetFallDamage(player,speed)
	local dmg = (speed / 8)

	player:EmitSound("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1,2)..".wav")

	return dmg
end

function GM:PlayerDeathSound(ply)
    if ply:GTeam() == TEAM_SCP then return true end

    if !ply:IsFemale() then
	    ply:EmitSound( "nextoren/charactersounds/hurtsounds/male/death_"..math.random(1,58)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
	end

	if ply:IsFemale() then
		ply:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/death_"..math.random(1,75)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
	end

    return true
end

function GM:PlayerHurt(victim, attacker, health, damage)
    if victim:GTeam() == TEAM_SCP then return end
    if !((victim.NextPain or 0) < CurTime() and health > 0) then return end

    if victim:GTeam() == TEAM_GUARD and !victim:IsFemale() then
        victim:EmitSound("nextoren/vo/mtf/mtf_hit_" .. math.random(1, 23) .. ".wav", SNDLVL_NORM, math.random(70, 126))
    end

    if victim:IsFemale() then
        victim:EmitSound("nextoren/charactersounds/hurtsounds/sfemale/hurt_" .. math.random(1, 66) .. ".mp3", SNDLVL_NORM, math.random(70, 126))
    end

    if !victim:IsFemale() and victim:GTeam() != TEAM_GUARD and victim:GTeam() != TEAM_GRU then
        victim:EmitSound("nextoren/charactersounds/hurtsounds/male/hurt_" .. math.random(1, 39) .. ".wav", SNDLVL_NORM, math.random(70, 126))
    end

    if victim:GTeam() == TEAM_GRU then
        victim:EmitSound("nextoren/vo/gru/pain0" .. math.random(1, 10) .. ".wav", SNDLVL_NORM)
    end

	if attacker and attacker:IsPlayer() and attacker:GTeam() == TEAM_GRU and victim:Alive() and attacker:GetActiveWeapon().CW20Weapon and ((attacker.NextSpot or 0) < CurTime() and health > 0) then
		attacker:EmitSound("nextoren/vo/gru/spot" .. math.random(1, 7) .. ".wav", SNDLVL_NORM)
		attacker.NextSpot = CurTime() + math.Rand(8.92,12.85)
	end

    victim.NextPain = CurTime() + math.Rand(1.55, 4.22)
end


function PlayerCount()
	return #player.GetAll()
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
	if ( ent:GetClass() == "prop_ragdoll" ) then
		ent:InstallDataTable()
		ent:NetworkVar( "Int", 0, "VictimHealth" )
		ent:NetworkVar( "Bool", 0, "IsVictimAlive" )
	elseif ( ent:GetClass() == "prop_physics" ) then
		ent.RenderGroup = RENDERGROUP_OPAQUE
	end
end

function GetPlayer(nick)
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == nick then
			return v
		end
	end
	return nil
end

function ServerSound( file, ent, filter )
	ent = ent or game.GetWorld()
	if !filter then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end

	local sound = CreateSound( ent, file, filter )

	return sound
end

inUse = false
function explodeGateA( ply )
	if ply and !isInTable( ply, ents.FindInSphere(POS_EXPLODE_A, 250) ) then return end
	if inUse == true then return end
	if isGateAOpen() then return end
	inUse = true
	
	local filter = RecipientFilter()
	filter:AddAllPlayers()
	local sound = CreateSound( game.GetWorld(), "ambient/alarms/alarm_citizen_loop1.wav", filter )
	sound:SetSoundLevel( 0 )
	
	BroadcastLua( 'surface.PlaySound("radio/franklin1.ogg")' )
	sound:Play()
	sound:ChangeVolume( 0.25 )
	local waitTime = GetConVar( "br_time_explode" ):GetInt()
	local ttime = 0
	PrintMessage( HUD_PRINTTALK, "Time to Gate A explosion: "..waitTime.."s")
	timer.Create( "GateExplode", 1, waitTime, function()
		if ttime > waitTime then return end
		if isGateAOpen() then 
			timer.Destroy( "GateExplode" )
			sound:Stop()
			PrintMessage( HUD_PRINTTALK, "Gate A explosion terminated")
			inUse = false
			return
		end
		
		ttime = ttime + 1
		if ttime % 5 == 0 then PrintMessage( HUD_PRINTTALK, "Time to Gate A explosion: "..waitTime - ttime.."s" ) end
		if ttime + 1 == waitTime then sound:Stop() end
		if ttime == waitTime then
			BroadcastLua( 'surface.PlaySound("ambient/explosions/exp2.wav")' )
			local explosion = ents.Create( "env_explosion" ) // Creating our explosion
			explosion:SetKeyValue( "spawnflags", 210 ) //Setting the key values of the explosion 
			explosion:SetPos( POS_MIDDLE_GATE_A )
			explosion:Spawn()
			explosion:Fire( "explode", "", 0 )
			destroyGate()
			takeDamage( explosion, ply )
			if ply then
				ply:AddExp(100, true)
			end
		end
	end )
end

function takeDamage( ent, ply )
	local dmg = 0
	for k, v in pairs( ents.FindInSphere( POS_MIDDLE_GATE_A, 1000 ) ) do
		if v:IsPlayer() then
			if v:Alive() then
				if v:GTeam() != TEAM_SPEC then
					dmg = ( 1001 - v:GetPos():Distance( POS_MIDDLE_GATE_A ) ) * 10
					if dmg > 0 then 
						v:TakeDamage( dmg, ply or v, ent )
					end
				end
			end
		end
	end
end

function destroyGate()
	if isGateAOpen() then return end
	local doorsEnts = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doorsEnts ) do
		if v:GetClass() == "prop_dynamic" or v:GetClass() == "func_door" then
			v:Remove()
		end
	end
end

function isGateAOpen()
	local doors = ents.FindInSphere( POS_MIDDLE_GATE_A, 125 )
	for k, v in pairs( doors ) do
		if v:GetClass() == "prop_dynamic" then 
			if isInTable( v:GetPos(), POS_GATE_A_DOORS ) then return false end
		end
	end
	return true
end

function Recontain106( ply )
	if Recontain106Used then
		ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 recontain procedure can be triggered only once per round" )
		return false
	end

	local cage
	for k, v in pairs( ents.GetAll() ) do
		if v:GetPos() == CAGE_DOWN_POS then
			cage = v
			break
		end
	end
	if !cage then
		ply:PrintMessage( HUD_PRINTCENTER, "Power down ELO-IID electromagnet in order to start SCP 106 recontain procedure" )
		return false
	end

	local e = ents.FindByName( SOUND_TRANSMISSION_NAME )[1]
	if e:GetAngles().roll == 0 then
		ply:PrintMessage( HUD_PRINTCENTER, "Enable sound transmission in order to start SCP 106 recontain procedure" )
		return false
	end

	local fplys = ents.FindInBox( CAGE_BOUNDS.MINS, CAGE_BOUNDS.MAXS )
	local plys = {}
	for k, v in pairs( fplys ) do
		if IsValid( v ) and v:IsPlayer() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
			table.insert( plys, v )
		end
	end

	if #plys < 1 then
		ply:PrintMessage( HUD_PRINTCENTER, "Living human in cage is required in order to start SCP 106 recontain procedure" )
		return false
	end

	local scps = {}
	for k, v in pairs( player.GetAll() ) do
		if IsValid( v ) and v:GTeam() == TEAM_SCP and v:GetRoleName() == role.SCP106 then
			table.insert( scps, v )
		end
	end

	if #scps < 1 then
		ply:PrintMessage( HUD_PRINTCENTER, "SCP 106 is already recontained" )
		return false
	end

	Recontain106Used = true

	timer.Simple( 6, function()
		if postround or !Recontain106Used then return end
		for k, v in pairs( plys ) do
			if IsValid( v ) then
				v:Kill()
			end
		end

		for k, v in pairs( scps ) do
			if IsValid( v ) then
				local swep = v:GetActiveWeapon()
				if IsValid( swep ) and swep:GetClass() == "weapon_scp_106" then
					swep:TeleportSequence( CAGE_INSIDE )
				end
			end
		end

		timer.Simple( 11, function()
			if postround or !Recontain106Used then return end
			for k, v in pairs( scps ) do
				if IsValid( v ) then
					v:Kill()
				end
			end
			local eloiid = ents.FindByName( ELO_IID_NAME )[1]
			eloiid:Use( game.GetWorld(), game.GetWorld(), USE_TOGGLE, 1 )
			if IsValid( ply ) then
				ply:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for recontaining SCP 106!")
				ply:AddFrags( 10 )
			end
		end )


	end )

	return true
end

OMEGAEnabled = false
OMEGADoors = false
function OMEGAWarhead( ply )
	if OMEGAEnabled then return end

	local remote = ents.FindByName( OMEGA_REMOTE_NAME )[1]
	if GetConVar( "br_enable_warhead" ):GetInt() != 1 or remote:GetAngles().pitch == 180 then
		ply:PrintMessage( HUD_PRINTCENTER, "You inserted keycard but nothing happened" )
		return
	end

	OMEGAEnabled = true

	--local alarm = ServerSound( "warhead/alarm.ogg" )
	--alarm:SetSoundLevel( 0 )
	--alarm:Play()
	net.Start( "SendSound" )
		net.WriteInt( 1, 2 )
		net.WriteString( "warhead/alarm.ogg" )
	net.Broadcast()

	timer.Create( "omega_announcement", 3, 1, function()
		--local announcement = ServerSound( "warhead/announcement.ogg" )
		--announcement:SetSoundLevel( 0 )
		--announcement:Play()
		net.Start( "SendSound" )
			net.WriteInt( 1, 2 )
			net.WriteString( "warhead/announcement.ogg" )
		net.Broadcast()

		timer.Create( "omega_delay", 11, 1, function()
			for k, v in pairs( ents.FindByClass( "func_door" ) ) do
				if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
					v:Fire( "Unlock" )
					v:Fire( "Open" )
					v:Fire( "Lock" )
				end
			end

			OMEGADoors = true

			--local siren = ServerSound( "warhead/siren.ogg" )
			--siren:SetSoundLevel( 0 )
			--siren:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/siren.ogg" )
			net.Broadcast()
			timer.Create( "omega_alarm", 12, 5, function()
				--siren = ServerSound( "warhead/siren.ogg" )
				--siren:SetSoundLevel( 0 )
				--siren:Play()
				net.Start( "SendSound" )
					net.WriteInt( 1, 2 )
					net.WriteString( "warhead/siren.ogg" )
				net.Broadcast()
			end )

			timer.Create( "omega_check", 1, 89, function()
				if !IsValid( remote ) or remote:GetAngles().pitch == 180 or !OMEGAEnabled then
					WarheadDisabled( siren )
				end
			end )
		end )

		timer.Create( "omega_detonation", 90, 1, function()
			--local boom = ServerSound( "warhead/explosion.ogg" )
			--boom:SetSoundLevel( 0 )
			--boom:Play()
			net.Start( "SendSound" )
				net.WriteInt( 1, 2 )
				net.WriteString( "warhead/explosion.ogg" )
			net.Broadcast()
			for k, v in pairs( player.GetAll() ) do
				v:Kill()
			end
		end )
	end )
end

function WarheadDisabled( siren )
	OMEGAEnabled = false
	OMEGADoors = false

	--if siren then
		--siren:Stop()
	--end
	net.Start( "SendSound" )
		net.WriteInt( 0, 2 )
		net.WriteString( "warhead/siren.ogg" )
	net.Broadcast()

	if timer.Exists( "omega_check" ) then timer.Remove( "omega_check" ) end
	if timer.Exists( "omega_alarm" ) then timer.Remove( "omega_alarm" ) end
	if timer.Exists( "omega_detonation" ) then timer.Remove( "omega_detonation" ) end
	
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		if IsInTolerance( OMEGA_GATE_A_DOORS[1], v:GetPos(), 100 ) or IsInTolerance( OMEGA_GATE_A_DOORS[2], v:GetPos(), 100 ) then
			v:Fire( "Unlock" )
			v:Fire( "Close" )
		end
	end
end

function GM:BreachSCPDamage( ply, ent, dmg )
	if IsValid( ply ) and IsValid( ent ) then
		if ent:GetClass() == "func_breakable" then
			ent:TakeDamage( dmg, ply, ply )
			return true
		end
	end
end

function isInTable( element, tab )
	for k, v in pairs( tab ) do
		if v == element then return true end
	end
	return false
end

function DARK()
    engine.LightStyle( 0, "a" )
    BroadcastLua('render.RedownloadAllLightmaps(true)')
    BroadcastLua('RunConsoleCommand("mat_specular", 0)')
end

function evacuate(personal, roles_for_evac, give_score, desc, corpsed)
    local exptoget = give_score
    local eblya = {
        {reason = desc, value = give_score},
    }

    if IsValid(personal) and personal:Alive() and personal:IsPlayer() then
        for k, v in pairs(personal:GetWeapons()) do
            if v:GetClass() == "item_cheemer" then
                table.insert(eblya, {reason = "l:cheemer_rescue", value = 1000})
                exptoget = exptoget + 1000
            end
        end

        if personal:GTeam() == TEAM_USA and (m_UIUCanEscape == false or m_UIUCanEscape == nil) then
            net.Start("Ending_HUD")
            net.WriteString("l:ending_mission_failed")
            net.Send(personal)
        elseif personal:GTeam() == TEAM_USA and m_UIUCanEscape == true then
            table.insert(eblya, {reason = "l:death", value = 500})
            net.Start("Ending_HUD")
            net.WriteString("l:ending_mission_complete")
            net.Send(personal)
        end

        if personal:GTeam() == TEAM_CHAOS and heli_live == false then
            table.insert(eblya, {reason = "l:choppa_bonus", value = 700})
            exptoget = exptoget + 700
        end

        if (personal:GTeam() == TEAM_NTF or personal:GTeam() == TEAM_GUARD) and asic_evac != 0 then
            table.insert(eblya, {reason = "l:sci_evac", value = (asic_evac * 250)})
            exptoget = exptoget + (asic_evac * 250)
        end

        if personal:GTeam() == TEAM_CHAOS and fat_evac != 0 and fat_evac != nil then
            table.insert(eblya, {reason = "l:ci_classd_evac", value = (fat_evac * 250)})
            exptoget = exptoget + (fat_evac * 250)
        end

        if personal.kills != 0 then 
            table.insert(eblya, {reason = "l:enemykill", value = (personal.kills * 25)})
            exptoget = exptoget + (personal.kills * 25)
        else
            table.insert(eblya, {reason = "l:pacifist", value = 100})
            exptoget = exptoget + 100
        end

        if personal.teamkills != 0 then 
            table.insert(eblya, {reason = "l:teamkill", value = (personal.teamkills * -250)})
            exptoget = exptoget + (personal.teamkills * -25)
        end

        if personal:GetUserGroup() == "superadmin" or personal:GetUserGroup() == "vip" then
            table.insert(eblya, {reason = "l:ulx_premium_will_expire_pt2", value = exptoget})
            exptoget = exptoget * 2
        end
    end

    if IsValid(personal) and personal:Alive() then
        if roles_for_evac != "vse" then
            if personal:GTeam() != TEAM_SPEC then
                if personal:GTeam() == roles_for_evac then
                    personal:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 10)
					if personal:GTeam() != TEAM_USA then
						net.Start("OnEscaped")
						net.WriteString(desc)
						net.Send(personal)
					end
                    personal:AddFrags(5)
                    personal:GodEnable()
                    personal:Freeze(true)
                    personal.canblink = false
                    personal.isescaping = true
                    personal:Freeze(false)
                    personal:GodDisable()
					if personal.deathsequence != true then
						personal:SetSpectator()
					end
                    personal.isescaping = false
                    net.Start("LevelBar")
                    net.WriteTable(eblya)
                    net.WriteUInt(personal:GetNEXP(), 32)
                    net.Send(personal)
                    personal:AddExp(exptoget)
                end
            end
        else
            if personal:GTeam() != TEAM_SPEC then
                personal:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 10)
				if personal:GTeam() != TEAM_USA then
                    net.Start("OnEscaped")
                    net.WriteString(desc)
                    net.Send(personal)
				end
                personal:AddFrags(5)
                personal:GodEnable()
                personal:Freeze(true)
                personal.canblink = false
                personal.isescaping = true
                personal:Freeze(false)
                personal:GodDisable()
				if personal.deathsequence != true then
					personal:SetSpectator()
				end
				personal.isescaping = false
                net.Start("LevelBar")
                net.WriteTable(eblya)
                net.WriteUInt(personal:GetNEXP(), 32)
                net.Send(personal)
                personal:AddExp(exptoget)
            end
        end
    else
        local rtime = timer.TimeLeft("RoundTime")
        if rtime != nil then
            exptoget = 1000
            exptoget = (CurTime() - rtime) * 0.05
            --exptoget = math.Round(math.Clamp(exptoget, 1000, 10000))
        else
            exptoget = 10
        end

        local survival_bonus = {
            {reason = "l:survival_bonus", value = exptoget},
        }

        if personal.kills != 0 then 
            table.insert(survival_bonus, {reason = "l:enemykill", value = (personal.kills * 25)})
            exptoget = exptoget + (personal.kills * 25)
        else
            table.insert(survival_bonus, {reason = "l:pacifist", value = 100})
            exptoget = exptoget + 100
        end

        if personal.teamkills != 0 then 
            table.insert(survival_bonus, {reason = "l:teamkill", value = (personal.teamkills * -250)})
            exptoget = exptoget + (personal.teamkills * -25)
        end

        if personal:GetUserGroup() == "superadmin" or personal:GetUserGroup() == "vip" then
            table.insert(survival_bonus, {reason = "l:ulx_premium_will_expire_pt2", value = exptoget})
            exptoget = exptoget * 2
        end

        table.insert(survival_bonus, {reason = "l:death", value = -10})
        exptoget = exptoget - 10

        --net.Start("OnEscaped")
        --net.Send(personal)
        personal:AddFrags(5)
        personal:GodEnable()
        personal:Freeze(true)
        personal.canblink = false
        personal.isescaping = true
        personal:Freeze(false)
        personal:GodDisable()
		if personal.deathsequence != true then
			personal:SetSpectator()
		end
        personal.isescaping = false
        net.Start("LevelBar")
        net.WriteTable(survival_bonus)
        net.WriteUInt(personal:GetNEXP(), 32)
        net.Send(personal)
        personal:AddExp(exptoget)
    end
end

function OBRSpawn(count)
    local players = {}

    for _, v in pairs(player.GetAll()) do
        if v:GTeam() == TEAM_SPEC then
            table.insert(players, v)
        end
    end

    local obrsinuse = {}
    local obrspawns = table.Copy(SPAWN_OBR)
    local obrs = {}

    for i = 1, count do
        if #players == 0 then
            break
        end

        table.insert(obrs, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(obrs) do
        local obrroles = table.Copy(BREACH_ROLES.OBR.obr.roles)
        local selected

        repeat
            local role = table.remove(obrroles, math.random(#obrroles))
            obrsinuse[role.name] = obrsinuse[role.name] or 0

            if role.max == 0 or obrsinuse[role.name] < role.max then
                if role.level <= v:GetLevel() then
                    if not role.customcheck or role.customcheck(v) then
                        selected = role
                        break
                    end
                end
            end
        until #obrroles == 0

        if not selected then
            ErrorNoHalt("Something went wrong! Error code: 001")
            selected = BREACH_ROLES.OBR.obr.roles[1]
        end

        obrsinuse[selected.name] = obrsinuse[selected.name] + 1

        if #obrspawns == 0 then
            obrspawns = table.Copy(SPAWN_OBR)
        end

        local spawn = table.remove(obrspawns, math.random(#obrspawns))

        v:SendLua("OBRStart()")
        v:SetupNormal()
        v:ApplyRoleStats(selected)
        v:SetPos(spawn)
    end
end

function BREACH.PowerfulUIUSupport()
    local players = {}

    for _, v in pairs(player.GetAll()) do
        if v:GTeam() == TEAM_SPEC then
            table.insert(players, v)
        end
    end

    local uiusinuse = {}
    local uiuspawns = table.Copy(SPAWN_OUTSIDE)
    local uius = {}

    for i = 1, 12 do
        if #players == 0 then
            break
        end

        table.insert(uius, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(uius) do
        local selected = BREACH_ROLES.FBI.fbi.roles[1]

        uiusinuse[selected.name] = uiusinuse[selected.name] or 0

        if selected.max == 0 or uiusinuse[selected.name] < selected.max then
            if selected.level <= v:GetLevel() then
                if not selected.customcheck or selected.customcheck(v) then
                    uiusinuse[selected.name] = uiusinuse[selected.name] or 0

                    if #uiuspawns == 0 then
                        uiuspawns = table.Copy(SPAWN_OUTSIDE)
                    end

                    local spawn = table.remove(uiuspawns, math.random(#uiuspawns))
					
                    v:SendLua("ONPStart()")
                    v:SetupNormal()
                    SupportFreeze(v)
                    v:ApplyRoleStats(selected)
                    v:SetPos(spawn)
                end
            end
        end
    end
	PlayAnnouncer("nextoren/round_sounds/intercom/support/onpzahod.ogg")
end

local DoorClasses = {
	["func_door"] = true,
	["func_door_rotating"] = true,
	["prop_dynamic"] = true,
	["func_button"] = true
}

function DoorIsOpen( door )
	local doorClass = door:GetClass()
	if ( doorClass == "func_door" or doorClass == "func_door_rotating" ) then
		return door:GetInternalVariable( "m_toggle_state" ) == 0
	elseif ( doorClass == "prop_door_rotating" ) then
		return door:GetInternalVariable( "m_eDoorState" ) ~= 0
	else
		return false
	end
end

function IsDoorLocked( entity )
	return ( entity:GetInternalVariable( "m_bLocked" ) )
end

hook.Add("AcceptInput", "AutoCloseDoor", function(ent, name, activator, caller, data)
    local idi_gulay = {228,1799,1797,1660,1661}
    local timerokdayname = "дверкащаприкроется_" .. ent:EntIndex()
    local model_gulay = {"models/next_breach/elev/elevator_b_top.mdl"}
	local closetime = 10

	if ent:EntIndex() == 2814 then
		closetime = 16
	end

    if table.HasValue(idi_gulay, ent:EntIndex()) then
        return
    end

    if table.HasValue(model_gulay, ent:GetModel()) then
        return
    end

    if string.find(ent:GetName(), "elev") then return end
    if string.find(ent:GetName(), "checkpoint") then return end

    if timer.Exists(timerokdayname) then
        timer.Destroy(timerokdayname)
    end

    timer.Create(timerokdayname, closetime, 1, function()
        if IsValid(ent) and not ent:IsPlayer() then
            ent:Fire("close")
            ent:SetKeyValue("Skin", 0)
        end
    end)
 
	-- Вообще, весь код открытия дверей лежит в playeruse, но я бы его перенес сюда ибо из-за пинга и т.д факторов двери иногда не хотят открываться, но пусть пока что будет так
	if DoorClasses[ent:GetClass()] and activator:IsPlayer() and !DoorIsOpen(ent) and !IsDoorLocked(ent) then
	    ChangeSkinKeypad(activator, ent, true)
    end
end)

function table_contains(table, element)
	for _, val in pairs(table) do
		if val == element then
			return true
		end
	end
	return false
end

local keypad_mdls = {"models/next_breach/elev/elevator_b_top.mdl","models/next_breach/elev/elevator_b_down.mdl","models/next_breach/keycard_panel.mdl","models/next_breach/hcz_keycard_panel.mdl","models/next_breach/entrance_button.mdl"}

function ChangeSkinKeypad(target, ent, state)
	local skin

	if state == nil then
		skin = 0
	elseif state == true then
		skin = 1
	else
		skin = 2
	end

	for _, v in pairs(ents.FindInSphere(target:GetPos(), 100)) do
		if v:GetClass() == "prop_dynamic" and table_contains(keypad_mdls, v:GetModel()) then
			v:SetKeyValue("Skin", skin)
			timer.Create("dver_rabota"..skin..v:EntIndex(), 1.4, 1, function()
				v:SetKeyValue("Skin", 0)
			end)
		end
	end
end

function MakeDoorBustSound(ply)
	for i = 1, 3 do
		timer.Create("BreakDoorSound_"..i.."_"..ply:SteamID64(), 0.6 + (i - 1), 1, function()
		ply:EmitSound("nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO)
		end)
  	end
end

function StopDoorBustSound(ply)
	for i = 1, 3 do
    	timer.Remove("BreakDoorSound_"..i.."_"..ply:SteamID64())
	end
end

function thisisdoor(ply)
	local traceResult = ply:GetEyeTrace()
	local время = 7
    local падажжи = 2.5
	if traceResult.Entity:GetClass() == "func_button" then

		local взломПроисходит = false
        local звукиПроиграны = 0
		--print("да")
	 	ply:BrProgressBar("Выламываю...", время, "nextoren/gui/icons/notifications/breachiconfortips.png", traceResult.Entity, false, function()
			--ply:SetBottomMessage("Выломал")
			timer.Remove("BreakDoorSound")
            ply:EmitSound("nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO)
            traceResult.Entity:Fire("use")
		end, function() MakeDoorBustSound(ply) end, function() StopDoorBustSound(ply) end)
	else
	end
end

function InGas(ply)
	if GAS_AREAS == nil then return false end
	for k,v in pairs(GAS_AREAS) do
		local pos1 = v.pos1
		local pos2 = v.pos2
		OrderVectors(pos1, pos2)
		if ply:GetPos():WithinAABox( pos1, pos2 ) then
			return true
		end
	end
	return false
end

function CreatePlayerTimer(player, timerName, delay, repetitions, callback)
    if not IsValid(player) or not timerName or not delay or not repetitions or not callback then
        return
    end

    local timerData = {
        Player = player,
        TimerName = timerName,
        RepetitionsLeft = repetitions,
        Callback = callback
    }

    local function TimerCallback()
        local ply = timerData.Player

        if IsValid(ply) and timerData.RepetitionsLeft > 0 then
            timerData.Callback(ply)
            timerData.RepetitionsLeft = timerData.RepetitionsLeft - 1

            if timerData.RepetitionsLeft > 0 then
                timer.Create(timerData.TimerName, delay, 1, TimerCallback)
            end
        end
    end

    timer.Create(timerName, delay, 1, TimerCallback)
end

concommand.Add("gg", function(player, yes)
	local body_origin = Vector(-5782.422852, 2421.731445, 2104.031250)
	if yes then
		player:SetPos(body_origin)
	end
	player.Dimension_TouchEntity = ents.Create( "touch_entity" )
    player.Dimension_TouchEntity:SetModel( player:GetModel() )
    player.Dimension_TouchEntity:SetOwner( player )
	local position_to_return = initial_pos
	player.Dimension_TouchEntity.OwnerName = player:GetNamesurvivor()
    player.Dimension_TouchEntity:SetPos( body_origin )
    player.Dimension_TouchEntity:Spawn()
    print( "touch entity has been created at vector ", body_origin )

	player.Dimension_TouchEntity.Think = function( self )
		local owner = self:GetOwner()
		if ( !( owner && owner:IsValid() ) || owner:Health() <= 0 || owner:GetNamesurvivor() != self.OwnerName || owner:GetRoleName() == "Spectator" ) then
			self:Remove()
		end
	end

    player.Dimension_TouchEntity.TouchFunc = function( self, player )
			net.Start( "DimensionSequence" )
			net.Send( player )
			player:Freeze( true )
      player.canblink = nil
			timer.Simple( .25, function()

				if ( ( player && player:IsValid() ) && ( self && self:IsValid() ) ) then

					player:ScreenFade( SCREENFADE.OUT, color_white, .1, 1.25 )

					net.Start( "ForcePlaySound" )

						net.WriteString( "nextoren/charactersounds/stun_in.wav" )

					net.Send( player )

					local unique_id = "TeleportMeAlready" .. player:SteamID64()

					timer.Create( unique_id, 0, 0, function()

						if ( player:GetPos():DistToSqr( position_to_return ) < 6400 ) then

							timer.Remove( unique_id )

							return
						end

						player:SetInDimension( false )
						player:SetPos( position_to_return )

					end )

				end

			end )

      player:ScreenFade( SCREENFADE.IN, color_white, .6, 1.3 )

      timer.Simple( .6, function()

        if ( ( player && player:IsValid() ) && ( self && self:IsValid() ) ) then

          player:SetForcedAnimation( "l4d_GetUpFrom_Incap_04", 5.2, function()

            if ( player:IsFemale() ) then

    					net.Start( "ForcePlaySound" )

    						net.WriteString( "nextoren/charactersounds/breathing/breathing_female.wav" )

    					net.Send( player )

    				else

    					net.Start( "ForcePlaySound" )

    						net.WriteString( "nextoren/others/player_breathing_knockout01.wav" )

    					net.Send( player )

    				end

            player:SetDSP( 16 )

            player:Freeze( true )
            player:SetNWEntity( "NTF1Entity", player )

          end, function()

            player:ScreenFade( SCREENFADE.IN, color_black, .1, .75 )

            player:SetDSP( 1 )

            player:Freeze( false )
            player:SetNWEntity( "NTF1Entity", NULL )

          end )

          timer.Simple( 1, function()

            if ( player && player:IsValid() ) then

              player.canblink = true

            end

          end )

          self:Remove()

        end

      end )

    end
end)
