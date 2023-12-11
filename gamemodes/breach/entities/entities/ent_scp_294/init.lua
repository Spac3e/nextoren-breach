AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("create_294_menu")
util.AddNetworkString("send_drink")

net.Receive("send_drink", function(len,ply)
    local str = net.ReadString()
    local ent = net.ReadEntity()
    print(str,ent)
end)

function ENT:Initialize()
    self:SetModel( "models/vinrax/scp294/scp294_ru.mdl" )
    self:SetPos(Vector(195.409302, 3096.036865, -127.968750))
    self:SetAngles(Angle(0,90,0))
    self:PhysWake()
	self:SetSolid( SOLID_VPHYSICS )
    self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
end

function ENT:Use(activator,caller)
    net.Start("create_294_menu")
    net.Send(activator)
end