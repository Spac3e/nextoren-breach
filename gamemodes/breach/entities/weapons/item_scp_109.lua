--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/item_scp_109.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]



SWEP.InvIcon = Material( "nextoren/gui/icons/scp/119.png" )
SWEP.PrintName 		= "SCP-109"

SWEP.teams					= {2,3,5,6,7,8,9,10,11,12}

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.AdminOnly 		= false

SWEP.BounceWeaponIcon = false
SWEP.DrawWeaponInfoBox = false

SWEP.ViewModelFOV 	= 54

SWEP.ViewModel 		= "models/casual/scp109/c_scp109.mdl"
SWEP.WorldModel 	= "models/casual/scp109/w_scp109.mdl"

SWEP.ViewModelFlip 	= false

SWEP.AutoSwitchTo 	= false
SWEP.AutoSwitchFrom = false
SWEP.Napoje = nil
SWEP.Slot 			= 75
SWEP.SlotPos 		= 1

SWEP.Primary.Ammo     = ""
SWEP.Secondary.Ammo 	= ""
SWEP.Primary.ClipSize     = 3
SWEP.Secondary.ClipSize 	= -1
SWEP.Primary.DefaultClip     = 3
SWEP.Secondary.DefaultClip     = -1

SWEP.UseHands         = true

SWEP.HoldType         = "items" 

SWEP.DrawCrosshair     = false
SWEP.DrawAmmo          = true

SWEP.Primary.Automatic 		= false 
SWEP.Secondary.Automatic 	= false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

if SERVER then
	util.AddNetworkString("drink")
	util.AddNetworkString("drink_start")
end

function SWEP:PrimaryAttack()
if self.Owner:GetSpecialCD5() > CurTime() then return end
			
  if ( self.Owner.Napoje ) then return end
	
	local ply = self.Owner
	local HealAmount = 15

  if SERVER then
    self.Owner:BrProgressBar( "Использование..", 8, "nextoren/gui/icons/scp/119.png")
  
    timer.Simple( 0.5, function()
      if IsValid(self) then
        self.Owner:EmitSound( "casual/scp/scp109_drinkmale.wav", 97, math.random( 100, 120 ), 1, CHAN_WEAPON )
      end
    end)


  end

  timer.Simple( 4, function()
    if IsValid(self) then
      self.Owner.Napoje = true
    end
  end)

  self.droppable = false
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.5)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() 
		if (IsValid(self)) && self:Clip1() > -1 then
			self:SendWeaponAnim(ACT_VM_IDLE)
		elseif self:Clip1() < 0 then
			if SERVER then
				self.Owner:EmitSound("casual/soda/soda_holster.wav", 100)
			end
			self:SetSkin(1)
			self:SendWeaponAnim(ACT_VM_HOLSTER)
			timer.Create("weapon_holster" .. self:EntIndex(), self:SequenceDuration(), 1, function()
        if (IsValid(self)) then 
				  self:DropJunk()
				end
			end)
		end 
  end )
	self.Owner:SetSpecialCD5( CurTime() + 15 )	
  local owner = self:GetOwner()
  timer.Create( "piciekawy"..owner:SteamID(), 4.8, 1, function()
    if IsValid(owner) then
      owner.Napoje = false
	    self.droppable = true
    end
  end)
end

function SWEP:OnRemove()

	timer.Stop("weapon_idle" .. self:EntIndex())
	timer.Stop("weapon_holster" .. self:EntIndex())
	timer.Stop("weapon_drink" .. self:EntIndex())

end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end


	
local exit_icon = Material( "nextoren/gui/special_abilities/kanierka109.png" )
local clrgray = Color( 198, 198, 198 )
local darkgray = Color( 105, 105, 105 )

function SWEP:DrawHUDBackground()




	local icon_x, icon_y = ScrW() / 2 - 32, ScrH() / 1.1

	surface.SetDrawColor( color_white )
	surface.SetMaterial( exit_icon )
	surface.DrawTexturedRect( icon_x, icon_y, 64, 64 )

	if ( self.Owner:GetSpecialCD5() > CurTime() ) then

		draw.RoundedBox( 0, icon_x, icon_y, 64, 64, ColorAlpha( darkgray, 190 ) )
		draw.SimpleTextOutlined( math.Round( self.Owner:GetSpecialCD5() - CurTime() ), "ChatFont_new", icon_x / 0.97, icon_y * 1.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
	end

	if ( input.IsKeyDown( KEY_H ) ) then

    draw.RoundedBox( 0, icon_x, icon_y, 64, 64, ColorAlpha( clrgray, 70 ) )

  end

	draw.SimpleTextOutlined( "LMB", "ChatFont_new", icon_x + 64 - ( 32 / 4 ), icon_y + 4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1.5, color_black )


	end