AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("AlphaWarheadTimer_CLIENTSIDE")
util.AddNetworkString("NukeStart")

function ENT:Initialize()

    self:SetModel( "models/hunter/plates/plate4x24.mdl" )

 self:PhysicsInit( SOLID_NONE )
 self:SetMoveType(MOVETYPE_NONE)
 self:SetSolid( SOLID_NONE )
 self:SetActivated( false )
 self:SetDeactivationTime( CurTime() + 120 )
 self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
 self:SetRenderMode( 1 )

 self.Calling = false

 self:SetPos( Vector(-723.134705, -6288.651367, -2343.054932) )

 if ( SERVER ) then

   self:SetUseType( SIMPLE_USE )

 end
 self:SetColor( ColorAlpha( color_white, 1 ) )


end

function ENT:Use( activator, caller )
   
 if activator:GTeam() == TEAM_GOC then
   timer.Pause("Evacuation")
   timer.Pause("EvacuationWarhead")
   timer.Pause("RoundTime")
   timer.Pause("EndRound_Timer")
   net.Start("NukeStart")
     net.WriteBool(true)
   net.Broadcast()



   print(timer.TimeLeft("RoundTime"))
   local button = ents.Create( "alphawarhead_monitor" )
   button:Spawn()
   self:SetActivated( true )
   PlayAnnouncer("nextoren/sl/warheadcrank.ogg")
   PlayAnnouncer("no_music/nukes/goc_nuke.ogg")

   timer.Simple( 15, function()

     net.Start( "AlphaWarheadTimer_CLIENTSIDE" )
             net.WriteString( 120 )
             net.WriteBool( true )
         net.Broadcast()

     end )

 elseif activator:GTeam() != TEAM_GOC then

   BroadcastLua("cltime = "..tostring(timer.TimeLeft("RoundTime")))

   timer.UnPause("Evacuation")
   timer.UnPause("EvacuationWarhead")
   timer.UnPause("RoundTime")
   timer.UnPause("EndRound_Timer")

 end



end
