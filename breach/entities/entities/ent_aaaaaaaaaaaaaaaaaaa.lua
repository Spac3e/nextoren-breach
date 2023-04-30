--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/ent_aaaaaaaaaaaaaaaaaaa.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model( "models/props_c17/doll01.mdl" )

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:SetPos(self:GetPos() + Vector(0,0,30))
	if SERVER then
		if roundstats != nil then
			roundstats.secretf = true
		end
	end
end

ENT.LastSound = 0
function ENT:OnTakeDamage( damage )
	if self.LastSound > CurTime() then return end
	self.LastSound = CurTime() + 20
	if !damage:GetAttacker():IsPlayer() then return end
	net.Start("ForcePlaySound")
		net.WriteString("096_2.ogg")
	net.Send(damage:GetAttacker())
	damage:GetAttacker():PrintMessage(HUD_PRINTCENTER, "You shouldn't do that")
end