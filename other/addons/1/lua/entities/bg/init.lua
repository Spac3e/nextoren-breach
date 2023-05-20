AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

Firt = 1

sound.Add( {
	name = "ScpNukes",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "no_music/nukes/goc_nuke.ogg"
} )

sound.Add( {
	name = "ScpNukesCrack",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "nextoren/sl/warheadcrank.ogg"
} )

sound.Add( {
	name = "ScpFailed",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "nextoren/round_sounds/intercom/goc_nuke_cancel.mp3"
} )

sound.Add( {
	name = "ScpResume",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	pitch = { 100, 100 },
	sound = "nextoren/sl/resume30.ogg"
} )

function ENT:TriggerInput(iname, value)
	 if (iname == "On") then
		if value == 1 then
		if self.Activated == 0 && self.Useable == 1 then
		timer.Simple(0.42, function() if !self:IsValid() then return end
		self:Havok() end)
		timer.Simple(0.32, function() if !self:IsValid() then return end
		self:EnableUse() end)
		self.Activated = 1
		self.Useable = 0
		return end
		end
		if value == 0 then
		if self.Activated == 1 && self.Useable == 1 then
		timer.Simple(0.42, function() if !self:IsValid() then return end
		self:EndHavok() end)
		timer.Simple(106, function() if !self:IsValid() then return end
		self:EnableUse() end)
		self.Activated = 0
		self.Useable = 0
		return end
		end
	 end
end 


function ENT:Initialize()
	
	Firt = 1

	self.Entity:SetModel("models/dav0r/buttons/button.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then	
	phys:Wake()
	end

	self.Useable = 1
	self.Activated = 0
	if !(WireAddon == nil) then self.Inputs   = Wire_CreateInputs(self, { "On" }) end

end

function ENT:SpawnFunction( ply, tr )

if ( !tr.Hit ) then return end

local SpawnPos = tr.HitPos + tr.HitNormal * 16
local ent = ents.Create( "SCPNuke" )
ent:SetPos( SpawnPos )
ent:Spawn()
ent:Activate()
return ent

end

function ENT:EnableUse()
self.Useable = 1
end

function ENT:Use( activator, caller )

	local delay = 0

	if CurTime() < delay then return end	

	if self.Activated == 0 && self.Useable == 1 && caller:GTeam() == TEAM_GOC then
	delay = CurTime() + 5
	timer.Simple(0.42, function() if !self:IsValid() then return end
	self:Havok() end)
	timer.Simple(0.32, function() self:EnableUse() end)
	self.Activated = 1
	self.Useable = 0
	return end



	if self.Activated == 1 && self.Useable == 1 && caller:GTeam() != TEAM_GOC && caller:GTeam() != TEAM_SPEC then
	delay = CurTime() + 5
	timer.Simple(0.42, function() if !self:IsValid() then return end
	self:EndHavok() end)
	timer.Simple(0.32, function() if !self:IsValid() then return end
	self:EnableUse() end)
	self.Activated = 0
	self.Useable = 0
	return end



end

function ENT:Think()
if self.Activated == 1 then
end
end

function ENT:Havok()

local squad = self:GetNetworkedString( 12 )


--self.Entity:StopSound("ScpFailed")

if Firt == 1 then
for k,v in pairs(player.GetAll()) do
	v:ConCommand("stopsound")
	timer.Simple(0.2, function()
    v:SendLua("surface.PlaySound('no_music/nukes/goc_nuke.ogg')")
	v:SendLua("surface.PlaySound('nextoren/sl/warheadcrank.ogg')")    
    end)

end
end
if Firt == 0 then
for k,v in pairs(player.GetAll()) do
	v:ConCommand("stopsound")
	timer.Simple(0.3, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume30.ogg')")
	end)
end
end



		--Entity( 1 ):EmitSound("ScpNukes")
		
		----[[
		if Firt == 1 then

		timer.Simple(94, function()

			for k,v in pairs(player.GetAll()) do

				if v:IsPlayer() == true then
				if v:Alive() == false then return end
				if v.isescaping == true then return end
					if v:GTeam() == TEAM_GOC then
						--roundstats.sescaped = roundstats.sescaped + 1
						--local rtime = timer.TimeLeft("RoundTime")
						local exptoget = 1200
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
						--WinCheck()
						v.isescaping = false
					end
				end

			end

		end)

		timer.Create( "VisualExplosion", 101, 1, function() 
		
		if self.Activated == 1 then
		
		for k,v in pairs(player.GetAll()) do

		v:SendLua("surface.PlaySound(\"scp_alphawarheads/nukeexplode.wav\")")
		v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
		v:SendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")		
		end
		end
		timer.Remove( "VisualExplosion" ) 
		end )
	
	timer.Create( "KillExplosion", 101.6 , 1, function() 
	
	if self.Activated == 1 then
	
		for k,v in pairs(player.GetAll()) do
			v:TakeDamage("50000")
			Firt = 1
			self.Activated = 0
		end

		StopRound()
	
	end
----]]
--for k,ply in pairs(player.GetAll()) do
--ply:ChatPrint( "Alpha Warheads Activated")
--end

end)
end

if Firt == 0 then
		timer.Create( "VisualExplosion", 35.6 , 1, function() 
		
		if self.Activated == 1 then
		
		for k,v in pairs(player.GetAll()) do
		v:SendLua("surface.PlaySound(\"scp_alphawarheads/nukeexplode.wav\")")
		v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
		v:SendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")		
		end
		end
		timer.Remove( "VisualExplosion" ) 
		end )
	
	timer.Create( "KillExplosion", 36.2 , 1, function() 
	
	if self.Activated == 1 then
	
		for k,v in pairs(player.GetAll()) do
			v:TakeDamage("50000")
			Firt = 1
			self.Activated = 0
		end
	
	end
----]]
--for k,ply in pairs(player.GetAll()) do
--ply:ChatPrint( "Alpha Warheads Activated")
--end

end)
end
end

function ENT:EndHavok()

local squad = self:GetNetworkedString( 12 )

		for k,v in pairs(player.GetAll()) do
			v:ConCommand("stopsound")
			timer.Simple(0.3, function()
			v:SendLua("surface.PlaySound('nextoren/round_sounds/intercom/goc_nuke_cancel.mp3')")
			end)
		end
Firt = 0

for k,v in pairs(player.GetAll()) do
	self:EmitSound( "ScpFailed" )
end

--for k,ply in pairs(player.GetAll()) do
--ply:ChatPrint( "Alpha Warheads Deactivated")
--end

end

function ENT:OnRemove()
local squad = self:GetNetworkedString( 12 )
if self.Activated == 1 then
self:EndHavok()
end
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
	end
end