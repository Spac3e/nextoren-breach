--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/breach_gift/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include('shared.lua')

ENT.Model = Model("models/shaky/breach/gift.mdl")

function ENT:Initialize()

	self.csMdl = ClientsideModel(self.Model)

	self.csMdl:SetRenderMode(RENDERMODE_TRANSCOLOR)

end

function ENT:OnRemove()
	if IsValid(self.csMdl) then self.csMdl:Remove() end
end

function ENT:Draw()

	local ang = (SysTime() * 25) % 360
	local pos = (math.sin(SysTime()*2)*2)

	self.csMdl:SetColor(self:GetColor())

	self.csMdl:SetAngles(Angle(0,ang,0))
	self.csMdl:SetPos(self:GetPos() + Vector(0,0,pos+2))

end