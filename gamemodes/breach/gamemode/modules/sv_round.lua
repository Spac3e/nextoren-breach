activeRound = activeRound
rounds = rounds or -1
roundEnd = roundEnd or 0

MAP_LOADED = MAP_LOADED or false
util.AddNetworkString("bettersendlua")

function BREACH.Round_System_Start()
	for k,v in pairs(ents.FindByClass("prop_door_rotating")) do
		v:AddEFlags(8192)
		v:SetKeyValue("returndelay", "5")
		v:SetKeyValue("wait", "1")
	end
	for k,v in pairs(ents.FindByClass("func_door_rotating")) do
		v:AddEFlags(8192)
		v:SetKeyValue("returndelay", "5")
		v:SetKeyValue("wait", "1")
	end
	for k,v in pairs(ents.FindByClass("func_door")) do
		v:AddEFlags(8192)
		v:SetKeyValue("returndelay", "5")
		v:SetKeyValue("wait", "1")
	end
   BREACH.Round_System_Doors_Work()
   BREACH.Round_System_Announcer()
		  --timer.Create("RandAnnouncerKrivota", 135, 0, PlayRandomAnnouncer)
		  timer.Create( "lc_15_s", 180, 1, function()
			  for k,v in pairs(player.GetAll()) do
				  v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_15min", Color(255, 255, 255))
			  end
			  PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_15_b.mp3" )
		  end)
	  
		  timer.Create( "lc_12_s", 360, 1, function()
			  for k,v in pairs(player.GetAll()) do
				  v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:decont_1min", Color(255, 255, 255))
			  end
			  BREACH.Decontamination = true
			  timer.Remove("RandomAnnouncer")
			  PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_1_min.ogg" )
			  BroadcastPlayMusic("sound/no_music/light_zone/light_zone_decontamination.ogg", 2)
		  end )
	  
		  timer.Create( "lc_11:15_s", 375, 1, function()
			  PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_countdown.ogg" )
		  end )
	  
		  timer.Create( "lc_11_s", 420, 1, function()
			  PlayAnnouncer( "nextoren/round_sounds/lhz_decont/decont_ending.ogg" )
		  end )
	  
		  timer.Create( "lc_10_s", 480, 1, function()
			  for k,v in pairs(player.GetAll()) do
				  v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_10min", Color(255, 255, 255))
			  end
			  PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_10_b.mp3" )
		  end )
	  
		  timer.Create( "lc_5_s", 780, 1, function()
			  for k,v in pairs(player.GetAll()) do
				  v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_5min", Color(255, 255, 255))
			  end
			  PlayAnnouncer( "nextoren/round_sounds/main_decont/decont_5_b.mp3" )
		  end )
	  
		  timer.Create( "lc_3_15_s", 885, 1, function(ply)
			  SetGlobalBool("Evacuation", true)
			  BREACH.Evacuation = true
			  local songevac = "sound/no_music/evacuation_"..math.random(1,6)..".ogg"
			  BroadcastPlayMusic(songevac, 0)
			  for k,v in pairs(player.GetAll()) do
				  v:RXSENDNotify("l:evac_start_leave_immediately")
			  end
			  PlayAnnouncer( "nextoren/round_sounds/intercom/start_evac.ogg" )
		  end )
	  
		  timer.Create( "lc_2_10_s", 955, 1, function()
			SetGlobalBool("Evacuation_HUD", true )
			  for k,v in pairs(player.GetAll()) do
				  v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:evac_start", Color(255, 0, 0))
			  end
			  BroadcastPlayMusic("sound/nextoren/round_sounds/main_decont/final_nuke.mp3", 0)
		  end )
	  
		  LockKPPDoors()
	  
 

	  timer.Create( "lc_15_sv_scp_open_door", 180, 1, function()
		  OpenSCPDoors()
		  UnlockKPPDoors()
	  end)
	  
	  timer.Create( "lc_11_open_kpp_15_siren", 365, 1, function()
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
	  end)
	  
	  
  
	  timer.Create( "spawnsupport_12_11", 360, 1, function()
	  
		SupportSpawn()
	  
	  end )
	  
	  timer.Create( "spawnsupport_9_8", 540, 1, function()
	  
		SupportSpawn()
	  
	  end )
	  
	  
	  
	  timer.Create( "lc_2_10_s_sv", 955, 1, function()
	  
		  local heli = ents.Create( "heli" )
		  heli:Spawn()
	  
		  local btr = ents.Create( "apc" )
		  btr:Spawn()
	  
		  local portal = ents.Create( "portal" )
		  portal:Spawn()
	  
	  end)
	  
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
  
	  local scp_item_1 = Vector(7700, -4140, 53) 
	  local scp_item_2 = Vector(7788, -3988, 53) 
	  local scp_item_3 = Vector(8113, -3921, 56) 
	  local scp_item_4 = Vector(8561, -3769, 55) 
	  local scp_item_5 = Vector(8405, -3682, 55) 
	  local scp_item_6 = Vector(8547, -1905, 53) 
	  local scp_item_7 = Vector(7132, -2114, 56) 
	  local scp_item_8 = Vector(6629, -2299, 56) 
	  local scp_item_9 = Vector(6715, -2114, 53) 
	  local scp_item_10 = Vector(6246, -1957, 55) 
	  local scp_item_11 = Vector(6314, -2459, 57) 
  
	 for k,ball in pairs(ents.FindInSphere((scp_item_2), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_3), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_4), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_5), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_6), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_7), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_8), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_9), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_10), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
			end
	  end
		  for k,ball in pairs(ents.FindInSphere((scp_item_11), 5)) do
			if IsValid(ball) then
				if ball:GetClass() == "func_button" then ball:Fire("unlock") end
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


function BREACH.Round_System_Stop()
	timer.Remove( "lc_15_sv_scp_open_door" )
	timer.Remove( "lc_2_10_s_sv" )
	timer.Remove( "lc_11_open_kpp_15_s" )
	timer.Remove("lc_11_open_kpp_15_siren")
	timer.Remove( "lc_11_s_close" )
	timer.Remove( "spawnsupport_12_11" )
	timer.Remove( "spawnsupport_9_8" )
	timer.Remove( "mog_door_open" )
	timer.Remove( "sb_door_open" )
	timer.Remove( "lc_15_s" )
	timer.Remove( "lc_12_s" )
	timer.Remove( "lc_11:30_s" )
	timer.Remove( "lc_11_s" )
	timer.Remove( "lc_10_s" )
	timer.Remove( "lc_5_s" )
	timer.Remove( "lc_3_15_s" )
	timer.Remove( "lc_2_10_s" )
end

function BREACH.Round_System_Announcer()
	timer.Create("RandomAnnouncer",math.random(46,53),math.random(5,7), function()
	PlayAnnouncer("nextoren/round_sounds/intercom/"..math.random(1,19)..".ogg")
    end)
end

function BREACH.Round_System_Doors_Work()
	timer.Create( "mog_door_open", 80, 1, function()
	  
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

end)

	timer.Create( "sb_door_open", 100, 1, function()
		for k,ball in pairs(ents.FindInSphere((Vector(9871, -1514, 68)), 130)) do
		  if IsValid(ball) then
			  sound.Play( "nextoren/others/button_unlocked.wav", Vector(9904, -1515, 65) )
			  ball:Fire("Unlock")
		  end
		end
	end)
	timer.Create( "lc_11_open_kpp_15_s", 375, 1, function()
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
	end )
	timer.Create( "lc_11_s_close", 420, 1, function()
		for k,v in pairs(ents.FindByClass("br_alarm")) do
			v:Remove()
		end
		local lzgas = ents.Create( "lz_gas" )
		lzgas:Spawn()
		local lzgaz = ents.Create( "lz_gaz" )
		lzgaz:Spawn()
	
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
	end )
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
	SetGlobalInt("RoundUntilRestart", 10)
	game.ConsoleCommand("changelevel "..game.GetMap().."\n")
end

function CleanUp()
	BREACH.Round_System_Stop()
	timer.Remove("PreparingTime")
	timer.Remove("RoundTime")
	timer.Remove("PostTime")
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

function RoundRestart()
	print("round: starting")
	CleanUp()
	if GetConVar("br_rounds"):GetInt() > 0 then
		if rounds == GetConVar("br_rounds"):GetInt() then
			RestartGame()
		end
		rounds = rounds + 1
	else
		rounds = 0
	end	
	CleanUpPlayers()
	preparing = true
	postround = false
	activeRound = nil
	if #GetActivePlayers() < 10 then WinCheck() end
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
	timer.Destroy("PostTime") -----?????
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
			net.Start("PostStart")
				net.WriteInt(GetPostTime(), 6)
				net.WriteInt(1, 4)
			net.Broadcast()	
			print( "data broadcast: good" )
			roundEnd = 0
			timer.Destroy("PunishEnd")
			hook.Run( "BreachPostround" )
			timer.Create("PostTime", GetPostTime(), 1, function()
				print( "restarting round" )
				RoundRestart()
			end)		
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
		
		net.Start("PostStart")
			net.WriteInt(GetPostTime(), 6)
			net.WriteInt(2, 4)
		net.Broadcast()
		activeRound.postround()	
		GiveExp()
		endround = false
		hook.Run( "BreachPostround" )
		timer.Create("PostTime", GetPostTime(), 1, function()
			RoundRestart()
		end)
	end
end

function StopRound()
	timer.Stop("PreparingTime")
	timer.Stop("RoundTime")
	timer.Stop("PostTime")
	timer.Stop("GateOpen")
	timer.Stop("PlayerInfo")
end

timer.Create("WinCheckTimer", 5, 0, function()
	if postround == false and preparing == false then
		WinCheck()
	end
end)

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