--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/breach_scp_base/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Category = "Breach SCPs"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.BounceWeaponIcon = false
SWEP.HoldType = "DefaultSCP"
SWEP.EquipTime = 0
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.droppable = false

SWEP.HotKeyTable = {}

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )
  self.Owner.EquipTime = RealTime()

  for i = 1, #self.AbilityIcons do

    if ( self.AbilityIcons[ i ].KEY != "Nonekey" ) then

      self.HotKeyTable[ #self.HotKeyTable + 1 ] = self.AbilityIcons[ i ].KEY

    end

  end


  if ( self.NotDrawVW ) then

    self:DrawViewModel( false )

  end

  if ( self.NotDrawWM ) then

    self.Owner:DrawWorldModel( false )

  end

end

function SWEP:ForbidAbility( id, b_forbid )

  if ( !self.AbilityIcons || !self.AbilityIcons[ id ] ) then return end

  self.AbilityIcons[ id ].Forbidden = b_forbid

  if ( SERVER ) then

    if ( id > 15 ) then return end -- Only 4 byte

    net.Start( "ForbidTalant" )

      net.WriteBool( b_forbid )
      net.WriteUInt( id, 4 )

    net.Send( self.Owner )

  end

end

function SWEP:IsCooldown(abil)

  return self.AbilityIcons[abil].CooldownTime > CurTime()

end