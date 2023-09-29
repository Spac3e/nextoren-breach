activeRound = activeRound
rounds = rounds or -1
roundEnd = roundEnd or 0

MAP_LOADED = MAP_LOADED or false
util.AddNetworkString("bettersendlua")

function BREACH.Round_System_Start()
   	LockKPPDoors()  
	local ent = ents.Create("esc_vse")
	ent:Spawn()
	local ent1 = ents.Create("entity_goc_nuke")
	ent1:Spawn()

	local scp_item_pos = {
	Vector(7739, -4153, 58), 
	Vector(7749,-3972, 67), 
	Vector(8160, -3936, 55), 
	Vector(8568, -3727, 64),
	Vector(8396, -3728, 67), 
	Vector(8537, -1952, 67), 
	Vector(7085, -2104, 66), 
	Vector(6669,-2319, 66), 
	Vector(6672, -2104, 57),
	Vector(6324, -2416, 69), 
	Vector(6237, -2005, 66) 
	}
  
	for k, v in pairs( scp_item_pos ) do

		for k,ball in pairs(ents.FindInSphere((v), 40)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("lock") end
			end
		end
		
	end

   --local ent = ents.Create("entity_goc_nuke")
   --ent:SetPos(Vector(7284, -3984, 1995))
   --ent:Create()

   --local ent1 = ents.Create("esc_vse")
  -- ent1:SetPos(Vector(7284, -3984, 1995))
   --ent1:Create()
end

function UnlockKPPDoors()
	for k,ball in pairs(ents.FindInSphere((Vector(6814.729004,-1500.390869,47.581661)), 30)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
		end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(6940.698730,-1507.052856,48.999638)), 30)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(4670.674805,-2282.512939,32.469719)), 30)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(4677.037109,-2162.483154,42.032181)), 30)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(7433.421875,-1038.272339,45.807270)), 30)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(8222.139648,-1503.899536,46.854462)), 30)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(8094.794922,-1505.333618,44.055702)), 30)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(9703.193359,-534.726257,43.113960)), 50)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  
	  for k,ball in pairs(ents.FindInSphere((Vector(9560.303711,-537.061890,42.100170)), 100)) do
		if IsValid(ball) then
		  if ball:GetClass() == "func_door" or ball:GetClass() == "func_button" then ball:Fire("unlock") end
	  end
	  end
  end
  function LockKPPDoors()
	for k,ball in pairs(ents.FindInSphere((Vector(9258.547852,-4772.756836,20.109922)), 5)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("lock") end
		end
	  end
	  for k,ball in pairs(ents.FindInSphere((Vector(-2142.912354,5697.086426,48.375412)), 5)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("lock") end
		end
	  end
	  for k,ball in pairs(ents.FindInSphere((Vector(-1863.092529,5393.110840,37.665207)), 5)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("lock") end
		end
	  end
	  for k,ball in pairs(ents.FindInSphere((Vector(-1078.643555,5480.984863,37.720276)), 5)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("lock") end
		end
	  end

	for k,ball in pairs(ents.FindInSphere((Vector(9807.142578,-1504.096558,2.561043)), 5)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("lock") end
		end
	  end
	  for k,ball in pairs(ents.FindInSphere((Vector(9886.447266,-1593.926147,2.561050)), 5)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("lock") end
		end
	  end
	for k,ball in pairs(ents.FindInSphere((Vector(6814.729004,-1500.390869,47.581661)), 5)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(6940.698730,-1507.052856,48.999638)), 5)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(4670.674805,-2282.512939,32.469719)), 5)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(4677.037109,-2162.483154,42.032181)), 5)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(7433.421875,-1038.272339,45.807270)), 7)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(8222.139648,-1503.899536,46.854462)), 5)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(8094.794922,-1505.333618,44.055702)), 5)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9703.193359,-534.726257,43.113960)), 50)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end

	for k,ball in pairs(ents.FindInSphere((Vector(9560.303711,-537.061890,42.100170)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("lock") end
	  end
	end
end

  
  function OpenSCPDoors()
	  for k,box in pairs(ents.FindInBox( Vector( 7815, -6224, 239 ), Vector( 7900, -4864, 460 ) )) do
			if IsValid(box) then
				if box:GetClass() == "func_door" then 
					box:Fire("open") 
				end
			end
			for k,ball in pairs(ents.FindInSphere((Vector(9258.547852,-4772.756836,20.109922)), 5)) do
			  if IsValid(ball) then
				  if ball:GetClass() == "func_door" then ball:Fire("unlock") end
			  end
			end
  
	  local scp_b_1 = Vector(8253, 826, 50) 
	  local scp_b_2 = Vector(5787, 1538, 51) 
	  local scp_b_3 = Vector(5235, 1540, 51) 
	  local scp_b_4 = Vector(4996, 3598, 49) 
	  local scp_b_5 = Vector(4249, 2257, 28) 
	  local scp_b_6 = Vector(3694, 389, 49) 
	  local scp_b_7 = Vector(6282, -3953, 279) 
	  local scp_b_8 = Vector(7584, -272, 64) 
  
	local scp_item_pos = {
	Vector(7739, -4153, 58), 
	Vector(7749,-3972, 67), 
	Vector(8160, -3936, 55), 
	Vector(8568, -3727, 64),
	Vector(8396, -3728, 67), 
	Vector(8537, -1952, 67), 
	Vector(7085, -2104, 66), 
	Vector(6669,-2319, 66), 
	Vector(6672, -2104, 57),
	Vector(6324, -2416, 69), 
	Vector(6237, -2005, 66) 
	}
  
	for k, v in pairs( scp_item_pos ) do

		for k,ball in pairs(ents.FindInSphere((v), 40)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_door" then ball:Fire("unlock") end
			end
		end
		
	end
  
	for k,ball in pairs(ents.FindInSphere((scp_b_1), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_2), 5)) do
			if IsValid(ball) then
						  if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_3), 5)) do
			if IsValid(ball) then
						  if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_4), 5)) do
			if IsValid(ball) then
						  if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_5), 5)) do
			if IsValid(ball) then
						  if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_6), 5)) do
			if IsValid(ball) then
						  if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_7), 5)) do
			if IsValid(ball) then
						  if ball:GetClass() == "func_button" then ball:Fire("unlock") end
				if ball:GetClass() == "func_button" then ball:Fire("use") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_b_8), 5)) do
			if IsValid(ball) then
				if ball:GetModel() == "models/next_breach/door_frame_sealed.mdl" then ball:Remove() end
				if ball:GetModel() == "models/next_breach/entrance_door.mdl" then ball:Remove() end
				if ball:GetModel() == "models/next_breach/light_cz_door.mdl" then ball:Remove() end
			end
	  end
    end
  end

function BREACH.Round_Open_Dblock()

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
	local nextRoundName = GetConVar( "br_force_specialround" ):GetString()
	activeRound = nil
	if tonumber( nextRoundName ) then
		nextRoundName = tonumber( nextRoundName )
	end
	if ROUNDS[ nextRoundName ] then
		activeRound = ROUNDS[ nextRoundName ]
	end
	RunConsoleCommand( "br_force_specialround", "" )
	if !activeRound /*and #ROUNDS > 1*/ then
		local pct = math.Clamp( GetConVar( "br_specialround_pct" ):GetInt(), 0, 100 )
		--print( pct )
		if math.random( 0, 100 ) < pct then
			repeat
				activeRound = table.Random( ROUNDS )
			until( activeRound != ROUNDS.normal )
		end
	end
	if !activeRound then
		activeRound = ROUNDS.normal
	end
end

function GM:Initialize()
	SetGlobalInt("RoundUntilRestart", 10)
end

function RoundRestart()
	print("round: starting")
	CleanUp()
	if GetGlobalInt("RoundUntilRestart") then
		if GetGlobalInt("RoundUntilRestart", 10) < 1 then
			--RestartGame()
		end
		SetGlobalInt("RoundUntilRestart", GetGlobalInt("RoundUntilRestart") -1)
	else
		rounds = 0
	end
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
		timer.Create("RoundTime", GetRoundTime(), 1, function()
			net.Start("New_SHAKYROUNDSTAT") 
                net.WriteString("l:roundend_alphawarhead")
                net.WriteFloat(27)
            net.Broadcast()

			AlphaWarheadBoomEffect()
				for k,v in pairs(player.GetAll()) do
				if v:GTeam() != TEAM_SPEC then
					v:KillSilent()
				v:SendLua("surface.PlaySound(\"nextoren/ending/nuke.mp3\")")
				v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
				v:SendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")		
				end
				end
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
	end)
end

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