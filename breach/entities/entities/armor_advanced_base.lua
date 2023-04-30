--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_advanced_base.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.PrintName		= "Base Armor"
ENT.Author		    = "Kanade"
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.ArmorType = "armor_light"

function ENT:Initialize()

	self.Entity:SetModel(self.Model)

	self.Entity:PhysicsInit(SOLID_VPHYSICS)

	//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	self.Entity:SetMoveType(MOVETYPE_NONE)

	self.Entity:SetSolid(SOLID_BBOX)

	if SERVER then

		self:SetUseType(SIMPLE_USE)

	end
	
	//local phys = self.Entity:GetPhysicsObject()

	//if phys and phys:IsValid() then phys:Wake() end

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) 

	timer.Simple( .2, function()

		if ( !( self && self:IsValid() ) ) then return end

		self:SetPos( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z  ) )

	end )

end

function ENT:Use(ply)
	if ply:GTeam() == TEAM_CLASSD or ply:GTeam() == TEAM_SCI then 
		if SERVER then
			if ply:GetUsingArmor() != "" then
				ply:Tip( "[NO Breach]", Color(255, 0, 0), "На вас уже надет бронежилет. Снимите текущий.", Color(255, 255, 255) )
				return
			end

			ply:BrProgressBar("Подождите...", 7, "nextoren/gui/icons/hand.png")
			
			timer.Create("WearingClothThink"..ply:SteamID(), 1, 6, function()
				if ply:GetEyeTrace().Entity != self.Entity then
					timer.Remove( "WearingCloth"..ply:SteamID() )
					ply:ConCommand("stopprogress")
				end
			end)
			timer.Create( "WearingCloth"..ply:SteamID(), 7, 1, function()
				self:EmitSound( Sound("nextoren/others/cloth_pickup.wav") )

				if ( self.Bonemerge ) then
				
					for _, v in ipairs( self.Bonemerge ) do
		
						GhostBoneMergeArmor( ply, v )
		
					end
		
				end
	
				ply:Tip("[NO Breach]", Color(255, 0, 0), "Надето.", Color(255, 255, 255))
		
				ply:SetUsingArmor(self:GetClass())
				self:Remove()
			end)	
			
		end
	else
		if SERVER then
			ply:Tip( "[NO Breach]", Color(255, 0, 0), "ERROR.", Color(255, 255, 255) )
		end
	end
end

function ENT:Draw()
	self:DrawModel()
end