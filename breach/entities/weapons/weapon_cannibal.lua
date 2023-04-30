--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_cannibal.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


if ( CLIENT ) then
	SWEP.PrintName = "Каннибализм"
	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/canibal.png" )

end

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel						= Model( "models/jessev92/weapons/buddyfinder_c.mdl" )
SWEP.WorldModel						= Model( "models/jessev92/weapons/buddyfinder_w.mdl" )

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.droppable				= false
SWEP.UnDroppable 			= true
SWEP.teams					= {2,3,5,6,7,8,9,10,11,12}
SWEP.HoldType 				= "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.LockPickTime = 60

SWEP.CorpseEated = 0

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
SWEP.SoundList = {

  "nextoren/others/cannibal/gibbing1.wav",
  "nextoren/others/cannibal/gibbing2.wav",
  "nextoren/others/cannibal/gibbing3.wav"

}

function SWEP:Deploy()

    self.Owner:DrawViewModel( false )
    if ( SERVER ) then

        self.Owner:DrawWorldModel( false )

    end

end

function SWEP:Think() end

function SWEP:PrimaryAttack()

	if ( ( self.NextTry || 0 ) >= CurTime() ) then return end
	self.NextTry = CurTime() + 2

	local tr = self.Owner:GetEyeTraceNoCursor()
	local time;
	local ent = tr.Entity
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	if ( ent:GetClass() == "prop_ragdoll" && !ent.AlreadyEaten ) then

		self.Owner:DoAnimationEvent(ACT_IDLE_AIM_STEALTH)

		timer.Create("Standing" , 6.8 , 1, function()
			self.Owner:DoAnimationEvent(ACT_RANGE_ATTACK2)
		end)

	end

	if SERVER then
		if ( ent:GetClass() == "prop_ragdoll" && !ent.AlreadyEaten ) then
	
			self.Owner:Freeze(true)
	
			if SERVER then
				self.Owner:BrProgressBar( "Поедаю...", 8, "nextoren/gui/icons/canibal.png")
			end
	
			timer.Create("Gibbing" , 1 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("Gibbing2" , 4 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("Gibbing3" , 6 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("Gibbing4" , 7 , 1, function() 
				if IsValid(self.Owner) then 
					self.Owner:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO )  
				end 
			end)
			timer.Create("FinalGibbing" , 8 , 1, function()
				if ( ent:GetClass() == "prop_ragdoll" ) then
					ent:SetModel( "models/cultist/humans/corpse.mdl" )
					ent:SetSkin( 2 )
					self.Owner:Freeze(false)
	
					if ( ent.BoneMergedEnts ) then
	
						for _, v in ipairs( ent.BoneMergedEnts ) do
	
							if ( v && v:IsValid() ) then
	
								v:Remove()
							end
						end
					end
					if ( ent.BoneMergedHackerHat ) then
	
						for _, v in ipairs( ent.BoneMergedHackerHat ) do
	
							if ( v && v:IsValid() ) then
	
								v:Remove()
							end
						end
					end
					if ( ent.GhostBoneMergedEnts ) then
	
						for _, v in ipairs( ent.GhostBoneMergedEnts ) do
	
							if ( v && v:IsValid() ) then
	
								v:Remove()
							end
						end
					end

					ent.AlreadyEaten = true
					ent.breachsearchable = false
					self.Owner:SetHealth( self.Owner:Health() + 30 )
					self.CorpseEated = self.CorpseEated + 1
					if self.CorpseEated == 5 then
						self.Owner:SetMaxHealth( self.Owner:GetMaxHealth() + 40 )
					elseif self.CorpseEated >= 10 then
						self.Owner:SetMaxHealth( self.Owner:GetMaxHealth() + 20 )
					end
				else
					self.Owner:Freeze(false)
				end
			end)
		end
	end
end

function SWEP:DrawWorldModel()

	return false

end

function SWEP:Holster()

	hook.Remove("CalcView", "FirstPersonScene")

	timer.Remove("FinalGibbing")
	timer.Remove("Gibbing")
	timer.Remove("Gibbing2")
	timer.Remove("Gibbing3")
	timer.Remove("Gibbing4")
	timer.Remove("RemoveFP")
	timer.Remove("Standing")

	self.Owner:DoAnimationEvent(ACT_RESET)
	return true

end

function SWEP:OnRemove()

	self.CorpseEated = 0

end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end


