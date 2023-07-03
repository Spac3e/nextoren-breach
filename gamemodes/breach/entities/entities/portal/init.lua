AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self:SetPos(Vector(-3643, 5276, 1690))

	//self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	//self:PhysicsInit( SOLID_VPHYSICS )
	//self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModel("models/props_junk/watermelon01.mdl")

    //local phys = self:GetPhysicsObject()
	//if (phys:IsValid()) then
		//phys:Wake()
	//end

		timer.Simple(72, function()
			self:Remove()
		end)

end
 
function ENT:Use( activator, caller )
   return
end
 
function ENT:Think()

	for k,v in pairs(ents.FindInSphere(Vector(-3643, 5276, 1690), 50)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
				if v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_DZ then
					roundstats.sescaped = roundstats.sescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 1000
					if rtime != nil then
						exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
						exptoget = exptoget * 1.9
						exptoget = math.Round(math.Clamp(exptoget, 1000, 10000))
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
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
				end
		end
	end

end