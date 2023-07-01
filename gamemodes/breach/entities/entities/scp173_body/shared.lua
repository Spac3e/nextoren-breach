--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/scp173_body/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


ENT.Base = "base_entity"
ENT.Type = "ai"

ENT.PrintName		= "Base SNPC"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.AutomaticFrameAdvance = false

--[[---------------------------------------------------------
	Name: OnRemove
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function ENT:OnRemove()
end

--[[---------------------------------------------------------
	Name: PhysicsCollide
	Desc: Called when physics collides. The table contains 
			data on the collision
-----------------------------------------------------------]]
function ENT:PhysicsCollide( data, physobj )
end

--[[---------------------------------------------------------
	Name: PhysicsUpdate
	Desc: Called to update the physics .. or something.
-----------------------------------------------------------]]
function ENT:PhysicsUpdate( physobj )
end

--[[---------------------------------------------------------
	Name: SetAutomaticFrameAdvance
	Desc: If you're not using animation you should turn this 
		off - it will save lots of bandwidth.
-----------------------------------------------------------]]
function ENT:SetAutomaticFrameAdvance( bUsingAnim )

	self.AutomaticFrameAdvance = bUsingAnim

end
