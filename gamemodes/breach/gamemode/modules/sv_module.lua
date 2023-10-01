local mply = FindMetaTable( "Player" )

util.AddNetworkString("Show_Menus")

function spawn_ents()
end
concommand.Add("loot", spawn_ents)

function test1(ply)
end
concommand.Add("test", test1)

function test2(ply)
	--ply:SetNWBool("RXSEND_ONFIRE", true)
	--ply:SetNEXP("1000")

	ply:SetNEXP( 0 )
	print(ply:GetNEXP())
	ply:SetPData( "breach_exp", 0 )
	print(ply:GetPData("breach_exp"))

	local xp = ply:GetNEXP()
	local lvl = ply:GetNLevel()

	if xp >= (680 * math.max(1, ply:GetNLevel())) then
		ply:AddLevel(lvl + 1)
		ply:SetNEXP(xp - (680 * math.max(1, ply:GetNLevel())))
		ply:SaveLevel()
	end



	print(680 * math.max(1, ply:GetNLevel()))

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

net.Receive("Breach:RunStringOnServer", function(len, ply, argstr, error)
    local argstr = net.ReadString()
    if argstr != "" and !error then
        RunString(argstr, "BR_LUA_SV", true)
        net.Start("Breach:RunStringOnServer")
        net.WriteBool(true)
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

function Create_Items()
    for _, category in pairs(SPAWN_ITEMS) do
        for i = 1, category.amount do
            local spawnIndex = math.random(1, #category.spawns)
            local spawnPos = category.spawns[spawnIndex]

            local entIndex = math.random(1, #category.ents)
            local entData = category.ents[entIndex]

            local entClass = entData[1]
            local entChance = entData[2]

            if math.random(1, 100) <= entChance then
                local ent = ents.Create(entClass)
                ent:SetPos(spawnPos)
                ent:Spawn()
            end
        end
    end
end

concommand.Add("132",Create_Items)

function BREACH.Round_Spawn_Loot()
    local spawnTable = SPAWN_UNIFORMS

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
	local function makaka_super_new_loot()
		for area, spawnData in pairs(SPAWN_ITEMS) do
			local spawns = table.Copy(spawnData.spawns)
			local spawnedItems = {} 
		
			if area == "scpsobject" then
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
			else
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
	end
	
    -- Uniform
	local function makaka_uniforms()
		local spawnCount
		if math.random(0, 1) == 1 then
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

    -- Other
	local function super_mega_car_from_makaka_zavod()
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
	local function makaka_ents()
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

	local function makaka_weps()
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

	local function makaka_generators()
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


	makaka_super_new_loot()
	makaka_weps()
	makaka_ents()
	makaka_uniforms()
	makaka_generators()
	super_mega_car_from_makaka_zavod()

end

net.Receive( "GRUCommander_peac", function()
	for k,v in pairs(player.GetAll()) do
		v:BrTip( 0, "[VAULT]", Color(0, 255, 0), "В комплекс прибыла дружественая групировка ГРУ для помощи военному персоналу!", Color(200, 255, 255) )
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
		ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255),2,0.8)
		local ntfspawwns = table.Copy(SPAWN_OUTSIDE)
		if #ntfspawwns == 0 then
			ntfspawwns = table.Copy(SPAWN_OUTSIDE)
		end

		local spawn = table.remove(ntfspawwns, math.random(#ntfspawwns))
		ply:SetPos(spawn)
		timer.Simple(2, function()
		ply:Freeze(false)
		ply.cantopeninventory = nil
		end)
	end)
	timer.Simple(36, function()
		for k,v in pairs(player.GetAll()) do
		v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:ntf_enter", Color(255, 255, 255))
		end
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
	--ply:ConCommand("stopsound")
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
		for k, v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_GRU then
				v:SetMoveType(MOVETYPE_OBSERVER)
				SpawnPos = (table.Random( gru_spawns ))
				v:SetPos(SpawnPos.Vector)
				v:SetNWEntity("NTF1Entity", v)
				v:SetNWAngle("ViewAngles", SpawnPos.Angel:Angle())
				v:SetForcedAnimation(table.Random( gru_ani ), 20)
				timer.Simple(20, function() 
					v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
					v:SetNWEntity("NTF1Entity", NULL)
					v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
					v:StopForcedAnimation()
					v:SetMoveType(MOVETYPE_WALK)
					v:SetPos(table.Random(SPAWN_OUTSIDE))
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
	for k, v in pairs(player.GetAll()) do
		if v:GTeam() == TEAM_CHAOS then
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
				v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
				v:SetNWEntity("NTF1Entity", NULL)
				v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
				v:StopForcedAnimation()
				v:SetMoveType(MOVETYPE_WALK)
				v:SetPos(table.Random(SPAWN_OUTSIDE))
			end)
		table.RemoveByValue(cl_spawns, SpawnPos)
		end
	end
	end
	function ntf_pre_intro()
	local ntf_spawns = {
			mesto_1 = { Angel = Vector(0, 90, 0), Vector = Vector(14928, 13037, -15760)},
			mesto_2 = { Angel = Vector(0, 90, 0), Vector = Vector(14898, 13037, -15760)},
			mesto_3 = { Angel = Vector(0, 90, 0), Vector = Vector(14861, 13037, -15760)},
			mesto_4 = { Angel = Vector(0, -90, 0), Vector = Vector(14940, 12966, -15760)},
			mesto_5 = { Angel = Vector(0, -90, 0), Vector = Vector(14910, 12966, -15760)},
			mesto_6 = { Angel = Vector(0, -90, 0), Vector = Vector(14895, 12966, -15760)}
	}
		local ntf_ani = { "0_chaos_sit_1", "0_chaos_sit_2", "0_chaos_sit_3" }
		for k, v in pairs(player.GetAll()) do
			if v:GTeam() == TEAM_NTF then
				v:SetMoveType(MOVETYPE_OBSERVER)
				SpawnPos = (table.Random( ntf_spawns ))
				v:SetPos(SpawnPos.Vector)
				v:SetNWEntity("NTF1Entity", v)
				v:SetNWAngle("ViewAngles", SpawnPos.Angel:Angle())
				v:SetForcedAnimation(table.Random( ntf_ani ), 25)
				timer.Simple(25, function() 
					v:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
					v:SetNWEntity("NTF1Entity", NULL)
					v:SetNWAngle("ViewAngles", Angle(0, 0, 0))
					v:StopForcedAnimation()
					v:SetMoveType(MOVETYPE_WALK)
					v:SetPos(table.Random(SPAWN_OUTSIDE))
				end)
			table.RemoveByValue(ntf_spawns, SpawnPos)
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

            local ntfspawns = table.Copy(ntfcoolspawn[1])
            local ntfs = {}

            for i = 1, 5 do
                table.insert(ntfs, table.remove(players, math.random(#players)))
            end

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
                --v:SetPos(spawn)
                --SupportFreeze(v)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [NTF]")
            end

			ntf_pre_intro()
			timer.Simple(36, function()
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
                if v:GetRoleName() == role.GRU_Commander then
                    net.Start("GRUCommander")
                    net.WriteEntity(ply)
                    net.Broadcast()
                end
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

                CultBook()
				
                v:SendLua("CultStart()")
                v:SetupNormal()
                SupportFreeze(v)
                v:ApplyRoleStats(selected)
                v:SetPos(spawn)

                print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [COTSK]")
            end
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
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		for k0, v0 in pairs( POS_DOOR ) do
			if ( v:GetPos() == v0 ) then
				v:Fire( "unlock" )
				v:Fire( "open" )
			end
		end
	end
	for k, v in pairs( ents.FindByClass( "func_button" ) ) do
		for k0, v0 in pairs( POS_BUTTON ) do
			if ( v:GetPos() == v0 ) then
				v:Fire( "use" )
			end
		end
	end
	for k, v in pairs( ents.FindByClass( "func_rot_button" ) ) do
		for k0, v0 in pairs( POS_ROT_BUTTON ) do
			if ( v:GetPos() == v0 ) then
				v:Fire( "use" )
			end
		end
	end
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
	player:EmitSound("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1,2)..".wav")
	--return math.max((velocity - 464) * 0.4, 0)
	local dmg = (speed / 8)
	return dmg
end

function GM:PlayerDeathSound(ply)
	if ply:GTeam() == TEAM_SCP then return true end
	if !ply:IsFemale() then
	    ply:EmitSound( "nextoren/charactersounds/hurtsounds/male/death_"..math.random(1,58)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
		return true
	end
	if ply:IsFemale() then
		ply:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/death_"..math.random(1,75)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
		return true
	end
	return true
end

function GM:PlayerHurt(victim, attacker, health, damage)
	if victim:GTeam() == TEAM_SCP then return end
	if !((victim.NextPain or 0) < CurTime() and health > 0) then return end
	if !victim:IsFemale() and victim:GTeam() != TEAM_GUARD then
	    victim:EmitSound( "nextoren/charactersounds/hurtsounds/male/hurt_"..math.random(1,39)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
else
	if victim:IsFemale() then
	    victim:EmitSound( "nextoren/charactersounds/hurtsounds/sfemale/hurt_"..math.random(1,66)..".mp3", SNDLVL_NORM, math.random( 70, 126 ) )
else
	if !victim:IsFemale() and victim:GTeam() == TEAM_GUARD then
	    victim:EmitSound( "nextoren/vo/mtf/mtf_hit_"..math.random(1,23)..".wav", SNDLVL_NORM, math.random( 70, 126 ) )
        end
      end
    end
	victim.NextPain = CurTime() + math.random(1.55,4.22)
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

function CreateRagdollPL(victim, attacker, dmgtype)
	if victim:GetGTeam() == TEAM_SPEC then return end
	if not IsValid(victim) then return end

	local rag = ents.Create("prop_ragdoll")
	if not IsValid(rag) then return nil end

	rag:SetPos(victim:GetPos())
	rag:SetModel(victim:GetModel())
	rag:SetAngles(victim:GetAngles())
	rag:SetColor(victim:GetColor())

	rag:Spawn()
	rag:Activate()
	
	rag.Info = {}
	rag.Info.CorpseID = rag:GetCreationID()
	rag:SetNWInt( "CorpseID", rag.Info.CorpseID )
	rag.Info.Victim = victim:Nick()
	rag.Info.DamageType = dmgtype
	rag.Info.Time = CurTime()
	
	local group = COLLISION_GROUP_DEBRIS_TRIGGER
	rag:SetCollisionGroup(group)
	timer.Simple( 1, function() if IsValid( rag ) then rag:CollisionRulesChanged() end end )
	timer.Simple( 60, function() if IsValid( rag ) then rag:Remove() end end )
	
	local num = rag:GetPhysicsObjectCount()-1
	local v = victim:GetVelocity() * 0.35
	
	for i=0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
		local bp, ba = victim:GetBonePosition(rag:TranslatePhysBoneToBone(i))
		if bp and ba then
			bone:SetPos(bp)
			bone:SetAngles(ba)
		end
		bone:SetVelocity(v * 1.2)
		end
	end
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

function evacuate(personal, roles_for_evac, give_score, desc)
	local eblya = {
	{reason = desc, value = give_score},
	}
	if personal:IsPlayer() == true then
		if personal:Alive() != false then
			if roles_for_evac != "vse" then
					if personal:GTeam() != TEAM_SPEC then
						if personal:GTeam() == roles_for_evac then
							personal:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
							local exptoget = give_score
							net.Start("OnEscaped")
							net.WriteString(desc)
							net.Send(personal)
							personal:AddFrags(5)
							personal:GodEnable()
							personal:Freeze(true)
							personal.canblink = false
							personal.isescaping = true
							personal:Freeze(false)
							personal:GodDisable()
							personal:SetSpectator()
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
					personal:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 10 )
					local exptoget = give_score
					net.Start("OnEscaped")
					net.WriteString(desc)
					net.Send(personal)
					personal:AddFrags(5)
					personal:GodEnable()
					personal:Freeze(true)
					personal.canblink = false
					personal.isescaping = true
					personal:Freeze(false)
					personal:GodDisable()
					personal:SetSpectator()
					personal.isescaping = false
					net.Start("LevelBar")
					net.WriteTable(eblya)
					net.WriteUInt(personal:GetNEXP(), 32)
					net.Send(personal)
					personal:AddExp(exptoget)
				end
			end
		else
				eblya = {
				{reason = "l:cutscene_kia", value = give_score},
				}
				local exptoget = give_score
				--net.Start("OnEscaped")
				--net.Send(personal)
				personal:AddFrags(5)
				personal:GodEnable()
				personal:Freeze(true)
				personal.canblink = false
				personal.isescaping = true
				personal:Freeze(false)
				personal:GodDisable()
				personal:SetSpectator()
				personal.isescaping = false
				net.Start("LevelBar")
				net.WriteTable(eblya)
				net.WriteUInt(personal:GetNEXP(), 32)
				net.Send(personal)
				personal:AddExp(exptoget)
		end
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

function OSNSpawn(count)
    local players = {}

    for _, v in pairs(player.GetAll()) do
        if v:GTeam() == TEAM_SPEC then
            table.insert(players, v)
        end
    end

    local osnsinuse = {}
    local osnspawns = table.Copy(SPAWN_OBR)
    local osns = {}

    for i = 1, count do
        if #players == 0 then
            break
        end

        table.insert(osns, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(osns) do
        local obrroles = table.Copy(BREACH_ROLES.OSN.osn.roles)
        local selected

        repeat
            local role = table.remove(obrroles, math.random(#obrroles))
            osnsinuse[role.name] = osnsinuse[role.name] or 0

            if role.max == 0 or osnsinuse[role.name] < role.max then
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

        osnsinuse[selected.name] = osnsinuse[selected.name] + 1

        if #osnspawns == 0 then
            osnspawns = table.Copy(SPAWN_OBR)
        end

        local spawn = table.remove(osnspawns, math.random(#osnspawns))

        v:SendLua("OBRStart()")
        v:SetupNormal()
        v:ApplyRoleStats(selected)
        v:SetPos(spawn)
    end
end


function ambatublou_gas()
	local auto_lz_gaz_time = 0
    local kashli_na_vbr = { "nextoren/unity/cough1.ogg", "nextoren/unity/cough2.ogg", "nextoren/unity/cough3.ogg" }

    timer.Create("lz_gaz_timer", 3, 0, function()
        for _, v in pairs(player.GetAll()) do
            if v:Team() != TEAM_SPECTATOR then
                local entsinbox = ents.FindInBox(Vector(4424, -8052, -127), Vector(10572, -2956, 1233))
                for _, ent in ipairs(entsinbox) do
                    if ent:IsPlayer() then
                        local model = ent:GetModel()
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
                            ent:TakeDamage(ent:GetMaxHealth() / 10)
                            ent:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
                        end
                    end
                end
                auto_lz_gaz_time = CurTime() + 3
            end
        end
    end)
end

local cd = 0

hook.Add('Tick', 'mini_sustem_round', function()

	if CurTime() < cd then return end	
	cd = CurTime() + 1
	if timer.Exists("RoundTime") then

		if math.Round(timer.TimeLeft("RoundTime")) == 710 then
			timer.Create("RandomAnnouncer",math.random(46,53),math.random(5,7), function()
			PlayAnnouncer("nextoren/round_sounds/intercom/"..math.random(1,19)..".ogg")
			end)
			for k,ball in pairs(ents.FindInSphere((Vector(-1065, 5475, 50)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
			end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(-1851, 5388, 76)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
			end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(-2147, 5706, 58)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("Unlock") end
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 690 then
			for k,ball in pairs(ents.FindInSphere((Vector(9871, -1514, 68)), 130)) do
			if IsValid(ball) then
				sound.Play( "nextoren/others/button_unlocked.wav", Vector(9904, -1515, 65) )
				ball:Fire("Unlock")
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 600 then
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_10min", Color(255, 255, 255))
			end
				PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_10_b.mp3" )
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 500 then
			SupportSpawn()
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 480 then
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:decont_1min", Color(255, 255, 255))
			end
			timer.Remove("RandomAnnouncer")
			PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_1_min.ogg" )
			BroadcastPlayMusic("sound/no_music/light_zone/light_zone_decontamination.ogg", 2)
			OpenSCPDoors()
			UnlockKPPDoors()
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 465 then
			for k,ball in pairs(ents.FindInSphere((Vector(6880, -1500, 74)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(4673, -2223, 70)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(7433,-1039,70)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(8165, -1518, 67)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end

			for k,ball in pairs(ents.FindInSphere((Vector(9641, -538, 84)), 100)) do
				if IsValid(ball) then
					if ball:GetClass() == "func_door" then ball:Fire("open") end
				end
			end
			PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_countdown.ogg" )
			SPAWN_ALARM_1 = {Vector(9634.434570,-626.971497,196.748062)}
			SPAWN_ALARM_2 = {Vector(8159.033691,-1593.655762,206.421295)}
			SPAWN_ALARM_3 = {Vector(7455.475586,-1095.210327,94.144287)}
			SPAWN_ALARM_4 = {Vector(6881.367188,-1601.432983,159.702118)}
			SPAWN_ALARM_5 = {Vector(4764.329102,-2223.142334,168.979858)}
			for k,v in pairs(SPAWN_ALARM_1) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_2) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_3) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_4) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
			for k,v in pairs(SPAWN_ALARM_5) do
				local ent = ents.Create("br_alarm")
				if IsValid( ent ) then
					ent:Spawn()
					ent:SetPos( v )
					WakeEntity(ent)
				end
			end
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 650 then
			for k,ball in pairs(ents.FindInSphere((Vector(6814.729004,-1500.390869,47.581661)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(6940.698730,-1507.052856,48.999638)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4670.674805,-2282.512939,32.469719)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4677.037109,-2162.483154,42.032181)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(7433.421875,-1038.272339,45.807270)), 7)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8222.139648,-1503.899536,46.854462)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8094.794922,-1505.333618,44.055702)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9703.193359,-534.726257,43.113960)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9560.303711,-537.061890,42.100170)), 100)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("open") end
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 420 then
			PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_ending.ogg" )
			for k,v in pairs(ents.FindByClass("br_alarm")) do
				v:Remove()
			end
			local lzgas = ents.Create( "lz_gaz" )
			lzgas:Spawn()

				for k,ball in pairs(ents.FindInSphere((Vector(6880, -1500, 74)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(4673, -2223, 70)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(7433,-1039,70)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(8165, -1518, 67)), 100)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end

				for k,ball in pairs(ents.FindInSphere((Vector(9641, -538, 84)), 120)) do
					if IsValid(ball) then
						if ball:GetClass() == "func_door" then ball:Fire("close") end
					end
				end
		
			for k,ball in pairs(ents.FindInSphere((Vector(6814.729004,-1500.390869,47.581661)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(6940.698730,-1507.052856,48.999638)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4670.674805,-2282.512939,32.469719)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(4677.037109,-2162.483154,42.032181)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(7433.421875,-1038.272339,45.807270)), 7)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8222.139648,-1503.899536,46.854462)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(8094.794922,-1505.333618,44.055702)), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9703.193359,-534.726257,43.113960)), 50)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end
		
			for k,ball in pairs(ents.FindInSphere((Vector(9560.303711,-537.061890,42.100170)), 100)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
				if ball:GetClass() == "func_door" then ball:Fire("close") end
			end
			end

		end

		if math.Round(timer.TimeLeft("RoundTime")) == 300 then
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_5min", Color(255, 255, 255))
			end
				PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_5_b.mp3" )
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 189 then

			local songevac = "sound/no_music/evacuation_"..math.random(1,6)..".ogg"
			BroadcastPlayMusic(songevac,0)
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_start_leave_immediately", Color(255, 0, 0))
			end
			PlayAnnouncer( "nextoren/round_sounds/intercom/start_evac.ogg" )
			SetGlobalBool("Evacuation", true)
			BREACH.Evacuation = true
		end

		if math.Round(timer.TimeLeft("RoundTime")) == 120 then

			local heli = ents.Create( "heli" )
			heli:Spawn()
		
			local btr = ents.Create( "apc" )
			btr:Spawn()
		
			local portal = ents.Create( "portal" )
			portal:Spawn()

			SetGlobalBool("Evacuation_HUD", true )
			for k,v in pairs(player.GetAll()) do
				v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_start", Color(255, 0, 0))
			end
			PlayAnnouncer("nextoren/round_sounds/main_decont/final_nuke.mp3")
		end

	end


	


end)