--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/entities/br_gift.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Sound Effect (Alarm)"
ENT.Category = "NextOren Breach"
ENT.Spawnable = true


function ENT:Draw()

end

function ENT:Think()

  if ( !self.AlarmIsPlaying ) then

    self.AlarmIsPlaying = CreateSound( self, "nextoren/ambience/lz/alarmloop.wav" )
    self.AlarmIsPlaying:SetDSP( 17 )
    self.AlarmIsPlaying:Play()

  end

end

function ENT:OnRemove()

  if ( self.AlarmIsPlaying ) then

    self.AlarmIsPlaying:Stop()

  end

end