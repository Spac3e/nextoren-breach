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
		evacuate(v,"vse",2000,"l:cutscene_evac_by_o5")
	end
-- Побег через машину
	for k,v in pairs(ents.FindInSphere(Vector(-7112, 15128, 2153), 100)) do

		evacuate(v,"vse",900,"l:cutscene_evac_by_car")

		for k,v in pairs(ents.FindInSphere(Vector(-7112, 15128, 2153), 100)) do
			if v:GetModel() == "models/tdmcars/jeep_wrangler_fnf.mdl" then
				v:Remove()
			end
		end


	end
-- Побег через ОНП
	for k,v in pairs(ents.FindInSphere(Vector(-7024, -960, 1793), 5)) do
		evacuate(v,"vse",500,"l:cutscene_evac_by_onp")
	end
-- Побег через руку
	for k,v in pairs(ents.FindInSphere(Vector(-8001, -810, 1804), 50)) do
		evacuate(v,"vse",750,"l:cutscene_evac_by_onp")
	end
-- Побег через РПХ
	for k,v in pairs(ents.FindInSphere(Vector(-1969, 4863, 1515), 50)) do
		evacuate(v,"vse",2300,"l:cutscene_evac_by_rph")
	end

end