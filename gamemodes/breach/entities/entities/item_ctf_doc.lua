--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/item_ctf_doc.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/entities/item_doc.lua
--]]
AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"

ENT.PrintName = "Document"

ENT.Spawnable = true

ENT.AdminSpawnable = false

ENT.Category = "Breach"

ENT.RenderGroup = RENDERGROUP_OPAQUE

if SERVER then

function ENT:Initialize()

    self:SetModel("models/scp_documents/secret_document.mdl");

    self:PhysicsInit(SOLID_VPHYSICS);

    self:SetMoveType(MOVETYPE_VPHYSICS);

    self:SetSolid(SOLID_VPHYSICS);

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON);

    self:SetColor(Color(150, 150, 150, 255))

    self:SetRenderMode(RENDERMODE_TRANSCOLOR)

    self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

    local phys = self:GetPhysicsObject();

    if (phys:IsValid()) then

        phys:Wake();

    end

end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Carrier")
end

local nextuse = 0
local delay = 1

function ENT:Use(activator, caller)
    if nextuse > CurTime() then return end
    nextuse = CurTime() + delay
    activator:BrProgressBar("l:picking_up_docs", 10, "nextoren/gui/icons/hand.png", self, false, function()
        activator:RXSENDNotify("l:ctf_docs_to_base")
        self:SetCarrier(activator)
        self:SetParent(activator)
        self:SetLocalPos(vector_origin)
        self:SetLocalAngles(angle_zero)
        self:SetColor(Color(150, 150, 150, 0))
    end)
end

function ENT:Think()
    local selftable = self:GetTable()
    local carrier = self:GetCarrier()

    if IsValid(carrier) then
        if carrier:Health() <= 0 then
            self:SetCarrier(nil)
            local doc = ents.Create("item_ctf_doc")
            doc:SetPos(carrier:GetShootPos())
            doc:SetAngles(carrier:GetAngles())
            doc:Spawn()

            self:Remove()
        end
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

end

if SERVER then return end

function ENT:Draw()
    self:DrawModel();
end