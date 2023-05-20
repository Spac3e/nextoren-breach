AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
--52
end

local function easedLerp(fraction, from, to)
	return LerpVector(math.ease.InSine(fraction), from, to)
end

function ENT:Use( activator, caller )
	--print(heli_hui)
	--timer.Create( "tolkatel_heli", 2, 0, function() self:SetPos(Vector(heli_hui)) end )
end
 
function ENT:Think()

			print("или нахуй")
			local entsinbox = ents.FindInBox( Vector( -1061, 7111, 1674 ), Vector( -1922, 6667, 2047 ) ) 
			for k, v in ipairs( entsinbox ) do
			if ( v:IsPlayer() ) then
				v:KillSilent()
				v:ChatPrint( "<hsv=t()*300> [ЪеЪ Песочница] <color=255,0,0> Вас убила турель! Это секретный объект (скоро)." )
			end
			end

end