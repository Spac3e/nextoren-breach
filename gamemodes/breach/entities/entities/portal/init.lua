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
		evacuate(v,TEAM_SCP,1000,"l:cutscene_evac_by_rph")
		evacuate(v,TEAM_DZ,1000,"l:cutscene_evac_by_rph")
	end

end