--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/livetablz/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.PrintName = "LZ Status Monitor"
ENT.Spawnable = true

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "EmergencyMode" )
  self:NetworkVar( "Float", 0, "DecontTimer" )

  self:SetEmergencyMode( false )
  self:SetDecontTimer(100)

end

function ENT:Initialize()

  	self:SetModel("models/next_breach/gas_monitor.mdl");

	self:PhysicsInit( SOLID_NONE )

	self:SetMoveType(MOVETYPE_NONE)

	self:SetSolid(SOLID_VPHYSICS)



	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetAngles( Angle( 0, -90, 0 ) )




	self:SetColor( ColorAlpha( color_white, 1 ) )

end