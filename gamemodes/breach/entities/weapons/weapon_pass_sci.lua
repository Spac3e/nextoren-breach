--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/weapon_pass_sci.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/sci_id.png" )

end
SWEP.PrintName = "ID-Карта \"Научный персонал\""

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false
SWEP.Droppable = true

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/cultist/items/id_cards/id_card_sci.mdl"
SWEP.WorldModel = "models/cultist/items/id_cards/id_w_card_sci.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true


SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.UseHands = true

SWEP.HoldType = "pass"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = false

SWEP.ReloadSound = ""

SWEP.Pos = Vector( 2, -5, 5 )
SWEP.Ang = Angle( -90, 0, 90 )


function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
    self.WModel:SetNoDraw( true )
		self.WModel:AddEffects( EF_NORECEIVESHADOW )

  end

  return self.WModel

end

local vec_offset = Vector( 2, -5, 5 )
local angle_offset = Angle( -90, 0, 90 )

function SWEP:Think()

	if ( self.Owner:GetVelocity():Length() <= 0 && !self.Owner:Crouching() ) then

		self.Pos = vec_offset
		self.Ang = angle_offset

  elseif ( self.Owner:GetVelocity():Length() > 0 && self.Owner:OnGround() ) then

		self.Pos = vec_offset
		self.Ang = angle_offset

  end

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:DrawWorldModel()

	if ( ( self.Owner && self.Owner:IsValid() ) ) then

	 	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")

		if ( !bone ) then return end

	 	local pos, ang = self.Owner:GetBonePosition(bone)

		local wm = self:CreateWorldModel()

	  if ( wm && wm:IsValid() ) then

	    ang:RotateAroundAxis(ang:Right(), self.Ang.p)
	    ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
	    ang:RotateAroundAxis(ang:Up(), self.Ang.r)
	    wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
	    wm:SetRenderAngles(ang)
	    wm:DrawModel()

	 	end

	else

		self:DrawModel()

	end

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanSecondaryAttack()

	return false

end