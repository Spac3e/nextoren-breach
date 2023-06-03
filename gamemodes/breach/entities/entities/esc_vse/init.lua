AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:Initialize()


	self:SetModel( "models/props_interiors/Furniture_Couch01a.mdl" )
	//self:PhysicsInit( SOLID_VPHYSICS )
	//self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    //local phys = self:GetPhysicsObject()
	//if (phys:IsValid()) then
		//phys:Wake()
	//end
end
 
function ENT:Use( activator, caller )
   return
end
 
function ENT:Think()
-- Побег через о5
	for k,v in pairs(ents.FindInSphere(Vector(-14797, 3622, -15617), 100)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
			if v:GTeam() != TEAM_SPEC then
				if v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_SECURITY or v:GTeam() == TEAM_SPECIAL or v:GTeam() == TEAM_GUARD then
					roundstats.rescaped = roundstats.rescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 2000
					net.Start("OnEscaped")
						net.WriteInt(1,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
				end
			end
		end
	end
-- Побег через машину
	for k,v in pairs(ents.FindInSphere(Vector(-7112, 15128, 2153), 100)) do

		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
			if v:InVehicle() then
				if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC then
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 2000
					net.Start("OnEscaped")
						net.WriteInt(1,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false

						for k,v in pairs(ents.FindInSphere(Vector(-7112, 15128, 2153), 100)) do
							if v:GetModel() == "models/tdmcars/jeep_wrangler_fnf.mdl" then
								v:Remove()
							end
						end

					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
				end
			end
		end
	end
-- Побег через ОНП
	for k,v in pairs(ents.FindInSphere(Vector(-7024, -960, 1793), 5)) do
		
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
			if v:GTeam() != TEAM_SPEC then
					roundstats.rescaped = roundstats.rescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 500
					net.Start("OnEscaped")
						net.WriteInt(1,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
			end
		end
	end
-- Побег через руку
	for k,v in pairs(ents.FindInSphere(Vector(-8001, -810, 1804), 50)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
				if v:GTeam() != TEAM_SPEC then
					roundstats.rescaped = roundstats.rescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 750
					net.Start("OnEscaped")
						net.WriteInt(1,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
				end
		end
	end
-- Побег через РПХ
	for k,v in pairs(ents.FindInSphere(Vector(-1969, 4863, 1515), 50)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
				if v:GTeam() == TEAM_CLASSD then
					roundstats.descaped = roundstats.descaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 2300
					net.Start("OnEscaped")
						net.WriteInt(2,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
				end
		end
	end

end