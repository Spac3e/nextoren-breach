activeRound = activeRound
rounds = rounds or -1
roundEnd = roundEnd or 0

MAP_LOADED = MAP_LOADED or false

function RestartGame()
	game.ConsoleCommand("changelevel "..game.GetMap().."\n")
end

function CleanUp()
	reset_sup_lim()
	timer.Remove("PreparingTime")
	timer.Remove("RoundTime")
	--timer.Remove("PostTime")
	timer.Remove("GateOpen")
	timer.Remove("PlayerInfo")
	timer.Remove("NTFEnterTime")
	timer.Remove("966Debug")
	timer.Remove("MTFDebug")
	timer.Remove("GateExplode")
	if timer.Exists("CheckEscape") == false then
		timer.Create("CheckEscape", 1, 0, CheckEscape)
	end
	Radio_RandomizeChannels()
	game.CleanUpMap()	
	SetGlobalBool("Evacuation_HUD", false )
	SetGlobalBool("NukeTime", false)
	SetGlobalBool("Evacuation", false)
	BREACH.Evacuation = false 
	BREACH.Decontamination = false
	Recontain106Used = false
	OMEGAEnabled = false
	OMEGADoors = false
	nextgateaopen = 0
	spawnedntfs = 0
	roundstats = {
		descaped = 0,
		rescaped = 0,
		sescaped = 0,
		dcaptured = 0,
		rescorted = 0,
		deaths = 0,
		teleported = 0,
		snapped = 0,
		zombies = 0,
		secretf = false
	}
	inUse = false
end

function CleanUpPlayers()
	for k,v in pairs(player.GetAll()) do
		v:SetModelScale( 1 )
		v:SetCrouchedWalkSpeed(0.6)
		v.mblur = false
		--print( v.ActivePlayer, v:GetNActive() )
		player_manager.SetPlayerClass( v, "class_breach" )
		player_manager.RunClass( v, "SetupDataTables" )
		--print( v.ActivePlayer, v:GetNActive() )
		v:Freeze(false)
		v.MaxUses = nil
		v.blinkedby173 = false
		v.scp173allow = false
		v.scp1471stacks = 1
		v.usedeyedrops = false
		v.isescaping = false
		v:SendLua( "CamEnable = false" )
	end
	net.Start("Effect")
		net.WriteBool( false )
	net.Broadcast()
	net.Start("957Effect")
		net.WriteBool( false )
	net.Broadcast()
end

function RoundTypeUpdate()
	
	--activeRound = ROUNDS.normal
	if math.random( 1, 6 ) != 6 then
		activeRound = ROUNDS.normal
	else
		activeRound = ROUNDS.dm
	end
	
end

function GM:Initialize()
	SetGlobalInt("RoundUntilRestart", 10)
	Radio_RandomizeChannels()
end

function RoundRestart()
	print("round: starting")
	CleanUp()
	if GetGlobalInt("RoundUntilRestart") then
		if GetGlobalInt("RoundUntilRestart", 10) < 1 then
			BREACH.Relay:SendRoundStats(закончи)
			--RestartGame()
		end
		SetGlobalInt("RoundUntilRestart", GetGlobalInt("RoundUntilRestart") -1)
	else
		rounds = 0
	end
	BREACH.Relay:SendRoundStats(продолжай)
	CleanUpPlayers()
	preparing = true
	postround = false
	activeRound = nil
	if #GetActivePlayers() < 10 then
	   --WinCheck()
	   	SetGlobalBool("EnoughPlayersCountDown", true)
		SetGlobalInt("EnoughPlayersCountDownStart", CurTime() + 365)
	end
	RoundTypeUpdate()
	timer.Remove('RandomAnnouncer')
	print(activeRound.name)
	if activeRound.name == "Containment Breach" then
		SetGlobalBool('Evacuation', false) 
		BREACH.Evacuation = false
		SetupCollide()
		SetupAdmins( player.GetAll() )
		activeRound.setup()
		net.Start("UpdateRoundType")
			net.WriteString(activeRound.name)
		net.Broadcast()	
		activeRound.init()	
		BREACH.Round_System_Start()
		gamestarted = true
		BroadcastLua('gamestarted = true')
		net.Start("PrepStart")
			net.WriteInt(GetPrepTime(), 8)
		net.Broadcast()
		UseAll()
		DestroyAll()
		--timer.Destroy("PostTime") -----?????
		hook.Run( "BreachPreround" )
		timer.Create("PreparingTime", GetPrepTime(), 1, function()
			for k,v in pairs(player.GetAll()) do
				v:Freeze(false)
			end
			preparing = false
			postround = false		
			activeRound.roundstart()
			net.Start("RoundStart")
				net.WriteInt(GetRoundTime(), 12)
			net.Broadcast()
			print("round: started")
			roundEnd = CurTime() + GetRoundTime() + 3
			hook.Run( "BreachRound" )
			print(#GetActivePlayers())
			if #GetActivePlayers() > 30 then
				SetGlobalBool("BigRound",true)
				timer.Create("RoundTime", GetRoundTime(), 1, function()
					net.Start("New_SHAKYROUNDSTAT") 
						net.WriteString("l:roundend_alphawarhead")
						net.WriteFloat(27)
					net.Broadcast()

							AlphaWarheadBoomEffect()
							timer.Simple(5, function()
								for k,v in pairs(player.GetAll()) do
							if v:GTeam() != TEAM_SPEC then
								v:TakeDamage(99999,nil,nil)
							end
								end
						end)
						
						timer.Simple(27, function()
								RoundRestart()
						end)

					postround = false
					postround = true	
					print( "post init: good" )
					activeRound.postround()		
					GiveExp()	
					print( "post functions: good" )
					print( "round: post" )			
					net.Start("SendRoundInfo")
						net.WriteTable(roundstats)
					net.Broadcast()		
					--net.Start("PostStart")
						--net.WriteInt(GetPostTime(), 6)
					--	net.WriteInt(1, 4)
					--net.Broadcast()	
					print( "data broadcast: good" )
					roundEnd = 0
					timer.Destroy("PunishEnd")
					hook.Run( "BreachPostround" )
					--timer.Create("PostTime", GetPostTime(), 1, function()
						print( "restarting round" )
					--end)		
				end)
			else
				SetGlobalBool("BigRound",false)
				SetGlobalBool("EnoughPlayersCountDown", false)
				timer.Create("RoundTime", GetRoundTime(), 1, function()
					net.Start("New_SHAKYROUNDSTAT") 
						net.WriteString("l:roundend_alphawarhead")
						net.WriteFloat(27)
					net.Broadcast()

						AlphaWarheadBoomEffect()
							timer.Simple(5, function()
								for k,v in pairs(player.GetAll()) do
							if v:GTeam() != TEAM_SPEC then
								v:TakeDamage(99999,nil,nil)
							end
								end
						end)
						
						timer.Simple(27, function()
								RoundRestart()
						end)

					postround = false
					postround = true	
					print( "post init: good" )
					activeRound.postround()		
					GiveExp()	
					print( "post functions: good" )
					print( "round: post" )			
					net.Start("SendRoundInfo")
						net.WriteTable(roundstats)
					net.Broadcast()		
					--net.Start("PostStart")
						--net.WriteInt(GetPostTime(), 6)
					--	net.WriteInt(1, 4)
					--net.Broadcast()	
					print( "data broadcast: good" )
					roundEnd = 0
					timer.Destroy("PunishEnd")
					hook.Run( "BreachPostround" )
					--timer.Create("PostTime", GetPostTime(), 1, function()
						print( "restarting round" )
					--end)		
				end)
			end

		end)
		OpenSecDoors = false
		SCPLockDownHasStarted = false
	else
		activeRound.setup()
        gamestarted = true
        BroadcastLua('gamestarted = true')
        CleanUpPlayers()
        for k,v in pairs(player.GetAll()) do
            v:BrTip(0, "[MONIX Breach]", Color(255, 0, 0), "l:evac_5min", Color(255, 255, 255))
        end
        PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_5_b.mp3" )
		activeRound.init()	
		for k,v in pairs(player.GetAll()) do
			v:Freeze(false)
		end
		preparing = false
		postround = false		
		activeRound.roundstart()
		net.Start("RoundStart")
			net.WriteInt(300, 12)
		net.Broadcast()
        timer.Create("RoundTime", 300, 1, function()
            net.Start("New_SHAKYROUNDSTAT") 
                net.WriteString("l:roundend_alphawarhead")
                net.WriteFloat(27)
            net.Broadcast()
           							AlphaWarheadBoomEffect()
							timer.Simple(5, function()
								for k,v in pairs(player.GetAll()) do
							if v:GTeam() != TEAM_SPEC then
								v:TakeDamage(99999,nil,nil)
							end
								end
						end)
						
						timer.Simple(27, function()
								RoundRestart()
						end)
            postround = false
            postround = true
            net.Start("SendRoundInfo")
            net.WriteTable(roundstats)
            roundEnd = 0
            timer.Destroy("PunishEnd")
            hook.Run( "BreachPostround" )
        end)
	end
end

--[[ Staroe
canescortds = true
canescortrs = true
function CheckEscape()
	for k,v in pairs(ents.FindInSphere(POS_ESCAPE, 250)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
			if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_SCP then
				if v:GTeam() == TEAM_SCI then
					roundstats.rescaped = roundstats.rescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 300
					if rtime != nil then
						exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
						exptoget = exptoget * 1.8
						exptoget = math.Round(math.Clamp(exptoget, 300, 10000))
					end
					net.Start("OnEscaped")
						net.WriteInt(1,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
						v:Freeze(false)
						v:GodDisable()
						v:SetSpectator()
						WinCheck()
						v.isescaping = false
					end)
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
				elseif v:GTeam() == TEAM_CLASSD then
					roundstats.descaped = roundstats.descaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 500
					if rtime != nil then
						exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
						exptoget = exptoget * 2
						exptoget = math.Round(math.Clamp(exptoget, 500, 10000))
					end
					net.Start("OnEscaped")
						net.WriteInt(2,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
						v:Freeze(false)
						v:GodDisable()
						v:SetSpectator()
						WinCheck()
						v.isescaping = false
					end)
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by Chaos Insurgency Soldiers next time to get bonus points.")
				elseif v:GTeam() == TEAM_SCP then
					roundstats.sescaped = roundstats.sescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 425
					if rtime != nil then
						exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
						exptoget = exptoget * 1.9
						exptoget = math.Round(math.Clamp(exptoget, 425, 10000))
					end
					net.Start("OnEscaped")
						net.WriteInt(4,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
						v:Freeze(false)
						v:GodDisable()
						v:SetSpectator()
						WinCheck()
						v.isescaping = false
					end)
				end
			end
		end
	end
end
timer.Create("CheckEscape", 1, 0, CheckEscape)
-- [[ Experementi

canescortds = true
canescortrs = true

function CheckEscape()
	for _, v in pairs(ents.FindInSphere(POS_ESCAPE, 250)) do
		if v:IsPlayer() and v:Alive() and not v.isescaping then
			local team = v:GTeam()

			if team == TEAM_CLASSD or team == TEAM_SCI or team == TEAM_SCP then
				local exptoget = CalculateExpToGet(v, team)
				local escapeType = GetEscapeType(team)

				-- Add error handling for timer
				local rtime = timer.Exists("RoundTime") and timer.TimeLeft("RoundTime") or nil

				net.Start("OnEscaped")
					net.WriteInt(escapeType, 4)
				net.Send(v)

				v:AddFrags(5)
				v:AddExp(exptoget, true)
				v:GodEnable()
				v:Freeze(true)
				v.canblink = false
				v.isescaping = true

				timer.Create("EscapeWait" .. v:SteamID64(), 2, 1, function()
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
				end)
			end
		end
	end
end

function CalculateExpToGet(player, team)
	local rtime = timer.Exists("RoundTime") and timer.TimeLeft("RoundTime") or nil
	local exptoget = 300

	if rtime then
		exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
		exptoget = exptoget * GetMultiplier(team)
		exptoget = math.Round(math.Clamp(exptoget, 300, 10000))
	end

	return exptoget
end

function GetEscapeType(team)
	if team == TEAM_SCI then
		return 1
	elseif team == TEAM_CLASSD then
		return 2
	elseif team == TEAM_SCP then
		return 4
	end
end

function GetMultiplier(team)
	if team == TEAM_SCI then
		return 1.8
	elseif team == TEAM_CLASSD then
		return 2
	elseif team == TEAM_SCP then
		return 1.9
	end
end

timer.Create("CheckEscape", 1, 0, CheckEscape)
--]]

function CheckEscape() -- Интересный факт, таймер нагружает меньше чем Think или Tick что можно использовать в этом варианте выходов, я хз зачем Danx91 в 18 году запихал таймер а в сцп лк запихнул Tick
	for k,v in pairs(ents.FindInSphere(POS_UIUTUNNEL, 15)) do -- Общий
		if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_GOC then
			if v:GTeam() == TEAM_USA and m_UIUCanEscape == false and GetGlobalBool("Evacuation") == false then
				evacuate(v,"vse",-435,"l:ending_mission_failed")
			elseif
				 v:GTeam() == TEAM_USA and m_UIUCanEscape == true then
					evacuate(v,"vse",950,"l:ending_mission_complete")
				end
			end
			if v:GTeam() == TEAM_CLASSD and v:CanEscapeFBI() then
				evacuate(v,"vse",2000,"l:ending_escaped_site19_got_captured")
			elseif v:GTeam() != TEAM_USA then
				evacuate(v,"vse",2000,"l:ending_escaped_site19")
			end
		end
    end
	for k,v in pairs(ents.FindInSphere(POS_UNKNOWNTUNNEL, 47)) do -- РПХ
		if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeChaosRadio() and !v.escaping then
			v.escaping = true
			v:ConCommand("stopsound")
			v:Freeze(true)
			net.Start("StartCIScene")
			net.Send(v)
			timer.Simple(9, function()
            evacuate(v,"vse",1200,"l:ending_captured_by_unknown")
			v:Freeze(false)
			v.escaping = false
			end)
		end
    end
	for k,v in pairs(ents.FindInSphere(POS_ESCAPEALL, 35)) do -- Рука
		if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeHand() then
        evacuate(v,"vse",730,"l:ending_escaped_site19")
		end
    end
	for k,v in pairs(ents.FindInSphere(POS_CARESCAPE, 150)) do -- Машина
		if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeCar() and v:InVehicle() then
			v:ExitVehicle()
            evacuate(v,"vse",900,"l:ending_car")
		end
		if v:GetModel() == "models/scpcars/scpp_wrangler_fnf.mdl" then v:Remove() end
    end
	for k,v in pairs(ents.FindInSphere(POS_O5EXIT, 75)) do -- Выход О5
		if v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC and v:CanEscapeO5() then
        evacuate(v,"vse",840,"l:ending_o5")
	end
end

timer.Create("CheckEscape", 1, 0, CheckEscape)

function WinCheck()
	if postround then return end
	if !activeRound then return end
	activeRound.endcheck()
	if roundEnd > 0 and roundEnd < CurTime() then
		roundEnd = 0
		print( "Something went wrong! Error code: 100" )
		print( debug.traceback() )
	end
	if endround then
		print("Ending round because " .. why)
		PrintMessage(HUD_PRINTCONSOLE, "Ending round because " .. why)
		StopRound()
		timer.Destroy("RoundTime")
		preparing = false
		postround = true
		// send infos
		net.Start("SendRoundInfo")
			net.WriteTable(roundstats)
		net.Broadcast()
		
		--net.Start("PostStart")
			--net.WriteInt(GetPostTime(), 6)
			--net.WriteInt(2, 4)
		--net.Broadcast()
		activeRound.postround()	
		GiveExp()
		endround = false
		hook.Run( "BreachPostround" )
--		timer.Create("PostTime", GetPostTime(), 1, function()
			RoundRestart()
--		end)
	end
end

function StopRound()
	timer.Stop("PreparingTime")
	timer.Stop("RoundTime")
	--timer.Stop("PostTime")
	timer.Stop("GateOpen")
	timer.Stop("PlayerInfo")
end

--timer.Create("WinCheckTimer", 5, 0, function()
	--if postround == false and preparing == false then
		--WinCheck()
	--end
--end)

timer.Create("EXPTimer", 180, 0, function()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) and v.AddExp != nil then
			v:AddExp(200, true)
		end
	end
end)

function SetupCollide()
	local vply = player.GetAll()
	local fent = ents.GetAll()
	for k, v in pairs( fent ) do
		if v and v:GetClass() == "func_door" or v:GetClass() == "prop_dynamic" then
			if v:GetClass() == "prop_dynamic" then
				local ennt = ents.FindInSphere( v:GetPos(), 5 )
				local neardors = false
				for k, v in pairs( ennt ) do
					if v:GetClass() == "func_door" then
						neardors = true
						break
					end
				end
				if !neardors then 
					v.ignorecollide106 = false
					continue
				end
			end

			local changed
			for _, pos in pairs( DOOR_RESTRICT106 ) do
				if v:GetPos():Distance( pos ) < 100 then
					v.ignorecollide106 = false
					changed = true
					break
				end
			end
			
			if !changed then
				v.ignorecollide106 = true
			end
		end
	end
end

function BREACH.Round_System_Start()  
	local ent = ents.Create("esc_vse")
	ent:Spawn()
	local ent1 = ents.Create("entity_goc_nuke")
	ent1:Spawn()
end

local scpdoors = {
	Vector(5404.2802734375, -259.37396240234, 10.03125),
	Vector(3704.5900878906, 441.98110961914, 10.03125),
	Vector(5439.4916992188, 325.10293579102, 10.78125),
	Vector(5827.2192382813, 1524.0278320313, 11.668544769287),
	Vector(5273.0688476563, 1526.7156982422, 10.668546676636),
	Vector(8268.8212890625, 883.66925048828, 10.031251907349),
	Vector(7904.6162109375, -368.5002746582, 10.03125),
	Vector(7561.9755859375, -276.5368347168, 11.03125),
	Vector(6976.447265625, 2526.205078125, 10.031253814697),
	Vector(6550.5649414063, 2367.6569824219, 10.03125),
	Vector(4984.06640625, 3551.0676269531, 11.261253356934),
	Vector(2560.8029785156, 1722.7680664063, 11.261247634888),
	Vector(2432.5673828125, 1535.0313720703, 11.261245727539),
}

local scpitems = {
	Vector(8869.84765625, -2003.3256835938, 12.445949554443),
	Vector(8680.3662109375, -1870.5889892578, 12.811046600342),
	Vector(8536.14453125, -1953.6025390625, 12.561046600342),
	Vector(8658.306640625, -1584.7407226563, 11.734949111938),
	Vector(8701.591796875, -1151.7880859375, 12.561042785645),
	Vector(8392.10546875, -3724.3542480469, 12.611045837402),
	Vector(8568.279296875, -3724.2563476563, 12.611045837402),
	Vector(8156.935546875, -3935.9489746094, 12.561042785645),
	Vector(7736.7963867188, -3975.1257324219, 12.561046600342),
	Vector(7742.8608398438, -4150.4125976563, 12.561046600342),
	Vector(7090.6508789063, -2102.9553222656, 12.561050415039),
	Vector(6675.6469726563, -2103.9831542969, 12.561046600342),
	Vector(6670.0581054688, -2311.8208007813, 12.561050415039),
	Vector(6234.8784179688, -2002.12890625, 12.668548583984),
	Vector(6329.373046875, -2415.232421875, 13.075740814209),
	-- 914
	Vector(9260.3818359375, -4770.6357421875, 11.331050872803),
}

local kppdoors = {
	Vector(4672.8354492188, -2293.1130371094, 11.261245727539),
	Vector(4671.833984375, -2165.1789550781, 11.261245727539),
	Vector(6818.1791992188, -1504.5305175781, 12.561046600342),
	Vector(6946.4765625, -1503.189453125, 12.561044692993),
	Vector(7441.5, -1040.5297851563, 12.561044692993),
	Vector(8095.1108398438, -1503.5629882813, 12.561046600342),
	Vector(8218.5263671875, -1503.8485107422, 12.561050415039),
	Vector(9578.1376953125, -532.71966552734, 12.555744171143),
	Vector(9704.041015625, -532.83288574219, 12.555744171143),
}

function BREACH.Round.Open_Dblock()
	for k,box in pairs(ents.FindInBox( Vector( 7815, -6224, 239 ), Vector( 7900, -4864, 460 ) )) do
		if IsValid(box) then
			if box:GetClass() == "func_door" then 
				box:Fire("open") 
			end
		end
  end
  for k,box in pairs(ents.FindInBox( Vector( 6256, -6260, 117 ), Vector( 6057, -4922, 310 ) )) do
		if IsValid(box) then
			if box:GetClass() == "func_door" then 
				box:Fire("open") 
			end
		end
  end
end

function UnlockKPPDoors()
	SmartFindInSphere(kppdoors, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("unlock")
		end
	end)
end

function LockKPPDoors()
	SmartFindInSphere(kppdoors, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("lock")
		end
	end)
end

function SB_Anonce()
	local sbdoors = {Vector(-1065, 5475, 50),Vector(-1851, 5388, 76),Vector(-2147, 5706, 58)}

	timer.Create("RandomAnnouncer",math.random(46,53),math.random(5,7), function() PlayAnnouncer("nextoren/round_sounds/intercom/"..math.random(1,19)..".ogg") end)

	SmartFindInSphere(sbdoors, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("unlock")
		end
	end)
end

function KPP_Evac()
	SmartFindInSphere(kppdoors, 5, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("open")
		end
	end)
	PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_countdown.ogg" )

	local SPAWN_ALARMS = {
		Vector(9634.434570, -626.971497, 196.748062),
		Vector(8159.033691, -1593.655762, 206.421295),
		Vector(7455.475586, -1095.210327, 94.144287),
		Vector(6881.367188, -1601.432983, 159.702118),
		Vector(4764.329102, -2223.142334, 168.979858)
	}

	for _, v in pairs(SPAWN_ALARMS) do
		local ent = ents.Create("br_alarm")
		if IsValid(ent) then
			ent:SetPos(v)
			ent:Spawn()
			WakeEntity(ent)
		end
	end	
end

function KPP_Evac_End()
	PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_ending.ogg" )
	for k,v in pairs(ents.FindByClass("br_alarm")) do v:Remove() end
	local ent = ents.Create("lz_gaz")
	ent:Spawn()
	SmartFindInSphere(kppdoors, 40, function(sphere)
		if sphere:GetClass() == "func_door" then
			sphere:Fire("close")
			sphere:Fire("unlock")
		end
	end)
end

function Simpe_anons_run(time,sing)
	if math.Round(timer.TimeLeft("RoundTime")) == time then
		RunString(sing)
	end
end

function PreEvacTemp()
    local songevac = 'shaky_newmusic/evacuation'..math.random(1,6)..'.ogg' 
    PlayAnnouncer(songevac) 
    for k,v in pairs(player.GetAll()) do 
    v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_start_leave_immediately', Color(255, 0, 0)) 
    end 
    PlayAnnouncer( 'nextoren/round_sounds/intercom/start_evac.ogg' ) 
    SetGlobalBool('Evacuation', true) 
    BREACH.Evacuation = true
end

local cd = 0

hook.Add("Tick", "RoundSytem", function()
	if CurTime() < cd then return end	
	cd = CurTime() + 1
	if timer.Exists("RoundTime") == false then return end
	--print(GetGlobalString("RoundName"))
	if GetGlobalString("RoundName") == "ww2tdm" then return end
	if GetGlobalBool("BigRound") == true then
		Simpe_anons_run(1000,"SB_Anonce()")
		Simpe_anons_run(980,"sound.Play( 'nextoren/others/button_unlocked.wav', Vector(4743, -2750, 66) ) OpenSecDoors = true") 
		Simpe_anons_run(900,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_15min', Color(255, 255, 255)) end OpenSecDoors = true SCPLockDownHasStarted = true PlayAnnouncer( 'nextoren/round_sounds/main_decont/decont_15_b.mp3' )")
		Simpe_anons_run(899,"OpenSCPDoors()") 
		Simpe_anons_run(730,"SupportSpawn()") 
		Simpe_anons_run(720,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:decont_1min', Color(255, 255, 255)) end timer.Remove('RandomAnnouncer') PlayAnnouncer( 'nextoren/round_sounds/lhz_decont/decont_1_min.ogg' ) BroadcastPlayMusic('sound/no_music/light_zone/light_zone_decontamination.ogg', 2)") 
		Simpe_anons_run(705,"KPP_Evac()")
		Simpe_anons_run(660,"KPP_Evac_End() BREACH.Decontamination = true")
		Simpe_anons_run(600,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_10min', Color(255, 255, 255)) end PlayAnnouncer( 'nextoren/round_sounds/main_decont/decont_10_b.mp3' )") 
		Simpe_anons_run(540,"SupportSpawn()") 
		Simpe_anons_run(300,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_5min', Color(255, 255, 255)) end PlayAnnouncer( 'nextoren/round_sounds/main_decont/decont_5_b.mp3' )")
		Simpe_anons_run(189,"PreEvacTemp()")
		Simpe_anons_run(133,"local heli = ents.Create( 'heli' ) heli:Spawn() local btr = ents.Create( 'apc' ) btr:Spawn() local portal = ents.Create( 'portal' ) portal:Spawn() SetGlobalBool('Evacuation_HUD', true ) for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_start', Color(255, 0, 0)) end PlayAnnouncer('nextoren/round_sounds/main_decont/final_nuke.mp3')") 
	else
		Simpe_anons_run(710,"SB_Anonce()") 
		Simpe_anons_run(690,"sound.Play( 'nextoren/others/button_unlocked.wav', Vector(4743, -2750, 66) ) OpenSecDoors = true") 
		Simpe_anons_run(600,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_10min', Color(255, 255, 255)) end PlayAnnouncer( 'nextoren/round_sounds/main_decont/decont_10_b.mp3' )") 
		Simpe_anons_run(599,"OpenSCPDoors()") 
		Simpe_anons_run(500,"SupportSpawn()") 
		Simpe_anons_run(480,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:decont_1min', Color(255, 255, 255)) end timer.Remove('RandomAnnouncer') PlayAnnouncer( 'nextoren/round_sounds/lhz_decont/decont_1_min.ogg' ) BroadcastPlayMusic('sound/no_music/light_zone/light_zone_decontamination.ogg', 2) OpenSecDoors = true SCPLockDownHasStarted = true") 
		Simpe_anons_run(465,"KPP_Evac()")
		Simpe_anons_run(420,"KPP_Evac_End()") 
		Simpe_anons_run(300,"for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_5min', Color(255, 255, 255)) end PlayAnnouncer( 'nextoren/round_sounds/main_decont/decont_5_b.mp3' )")
		Simpe_anons_run(189,"PreEvacTemp()")
		Simpe_anons_run(133,"local heli = ents.Create( 'heli' ) heli:Spawn() local btr = ents.Create( 'apc' ) btr:Spawn() local portal = ents.Create( 'portal' ) portal:Spawn() SetGlobalBool('Evacuation_HUD', true ) for k,v in pairs(player.GetAll()) do v:BrTip(0, '[MONIX Breach]', Color(255, 0, 0), 'l:evac_start', Color(255, 0, 0)) end PlayAnnouncer('nextoren/round_sounds/main_decont/final_nuke.mp3')") 
	end
end)

function Nazi_spawn()
    local players = {}

    for k, v in pairs(player.GetAll()) do
        table.insert(players, v)
    end

    -- NAZI
    local nazispawns = table.Copy(SPAWN_NAZI)
    local nazis = {}

    for i = 1, (table.Count(players) / 2) do
        table.insert(nazis, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(nazis) do
        local selected
        if v == nil then
            return
        end
        selected = BREACH_ROLES.MINIGAMES.minigame.roles[1]

        if #nazispawns == 0 then
            nazispawns = table.Copy(SPAWN_NAZI)
        end

        local spawn = table.remove(nazispawns, math.random(#nazispawns))
        v:SetupNormal()
        v:ApplyRoleStats(selected)
        v:SetPos(spawn)

        print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [NAZI]")
    end

    -- USA
    local usaspawns = table.Copy(SPAWN_USA)
    local usas = {}

    for i = 1, table.Count(players) do
        table.insert(usas, table.remove(players, math.random(#players)))
    end

    for i, v in ipairs(usas) do
        if v == nil then
            return
		end
        local selected = BREACH_ROLES.MINIGAMES.minigame.roles[2]

        if #usaspawns == 0 then
            usaspawns = table.Copy(SPAWN_USA)
        end

        local spawn = table.remove(usaspawns, math.random(#usaspawns))
        v:SetupNormal()
        v:ApplyRoleStats(selected)
        v:SetPos(spawn)

        print("Assigning " .. v:Nick() .. " to role: " .. selected.name .. " [USA]")
    end
end
