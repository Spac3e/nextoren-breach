--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_scp_939.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.AbilityIcons = {

	{

		["Name"] = "Special #1",
		["Description"] = "Eat a body to regain health and increase your speed.",
		["Cooldown"] = "45",
		["CooldownTime"] = 0,
		["KEY"] = "RMB",
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_062_fr_cannibal.png",
		["Abillity"] = nil

	},
	{

		["Name"] = "Special #2",
		["Description"] = "You walk like a human and everybody can hear you for 30 seconds.",
		["Cooldown"] = "30",
		["CooldownTime"] = 0,
		["KEY"] = _G[ "KEY_G" ],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_939_blood.png",
		["Abillity"] = nil

	},

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-939"
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "bogdan"

SWEP.Base = "breach_scp_base"

local prim_maxs = Vector( 12, 2, 32 )

local clr_red = Color( 140, 0, 0, 210 )

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire( CurTime() + .6 )

	self.Owner:LagCompensation( true )

  local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80
	trace.filter = self.Owner
	trace.mins = -prim_maxs
	trace.maxs = prim_maxs

	trace = util.TraceHull( trace )

  local target = trace.Entity

  if ( CLIENT ) then

    if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then

      local effectData = EffectData()
      effectData:SetOrigin( trace.HitPos )
      effectData:SetEntity( target )

      util.Effect( "BloodImpact", effectData )

    end

    return
  end

  if ( target && target:IsValid() && target:IsPlayer() && target:Health() > 0 && target:GTeam() != TEAM_SCP ) then

    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    self.dmginfo = DamageInfo()
    self.dmginfo:SetDamageType( DMG_SLASH )
    self.dmginfo:SetDamage( target:GetMaxHealth() * .25 )
    self.dmginfo:SetDamageForce( target:GetAimVector() * 25 )
    self.dmginfo:SetInflictor( self )
    self.dmginfo:SetAttacker( self.Owner )

    self.Owner:EmitSound( "npc/antlion/shell_impact4.wav" )
    self.Owner:MeleeViewPunch( self.dmginfo:GetDamage() - 15 )

    target:MeleeViewPunch( self.dmginfo:GetDamage() )
    target:TakeDamageInfo( self.dmginfo )

  else

    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Owner:EmitSound( "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav" )
    self.Owner:ViewPunch( AngleRand( 10, 2, 10 ) )

  end

	self.Owner:LagCompensation( false )

end

function SWEP:SecondaryAttack()

 	if SERVER then
 		local ply = self.Owner
  		ply:LagCompensation(true)
		local DASUKADAIMNEEGO = util.TraceLine( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
			filter = ply
		} )
		ply:LagCompensation(false)
		local tr = DASUKADAIMNEEGO.Entity
		if tr and tr:IsValid() and tr:GetClass() == "prop_ragdoll" and tr:GetModel() != "models/cultist/humans/corpse.mdl" then
			ply:BrProgressBar("Пожираем труп...", 15, "nextoren/gui/special_abilities/scp_062_fr_cannibal.png", tr, false, function()
				tr:SetModel("models/cultist/humans/corpse.mdl")
				tr:SetSkin( 2 )
				tr.AlreadyEaten = true
				tr.breachsearchable = false
				for _, v in pairs(tr:LookupBonemerges()) do
					if IsValid(v) then v:Remove() end
				end
				ply:SetRunSpeed(math.Clamp(ply:GetRunSpeed() + 30, 0, 195))
				ply:SetWalkSpeed(math.Clamp(ply:GetWalkSpeed() + 30, 0, 195))
				ply:SetHealth(math.Clamp(ply:Health() + 300, 0, ply:GetMaxHealth()))
				self.AbilityIcons[ 1 ].CooldownTime = CurTime() + 50
				ply:SendLua("LocalPlayer():GetActiveWeapon().AbilityIcons[ 1 ].CooldownTime = CurTime() + 50")
  				self:SetNextSecondaryFire( self.AbilityIcons[ 1 ].CooldownTime )
			end, function()
				for i = 1, 15 do
					timer.Create("SCP939_EATSOUND_"..i, i - 1, 1, function()
						ply:EmitSound( "nextoren/others/cannibal/gibbing"..math.random(1,3)..".wav", 90, 100, 1, CHAN_AUTO ) 
					end)
				end
			end, function()
				for i = 1, 15 do
					timer.Remove("SCP939_EATSOUND_"..i)
				end
			end)
		else
			ply:RXSENDNotify("Вам нужно смотреть на труп!")
		end
	end
	self.AbilityIcons[ 1 ].CooldownTime = CurTime() + 3
 	self:SetNextSecondaryFire( self.AbilityIcons[ 1 ].CooldownTime)
end

function SWEP:CanSeePlayer( v )

  return self.UsingSpecialAbility && v:Health() <= v:GetMaxHealth() * .5 || v:GetVelocity():Length2DSqr() > .25 || v:GetStamina() < 20 || v:KeyDown( IN_ATTACK ) || v:IsSpeaking() || v:IsTyping()

end

function SWEP:Deploy()

	--if SERVER then
		hook.Add( "PlayerButtonDown", "SCP939_Buttons", function( caller, button )

			if ( caller:GetNClass() != "SCP939" ) then return end

			local wep = caller:GetActiveWeapon()

			if ( wep == NULL || !wep.AbilityIcons ) then return end

			if ( button == KEY_G && !( ( wep.AbilityIcons[ 2 ].CooldownTime || 0 ) > CurTime() ) ) then

				wep.AbilityIcons[ 2 ].CooldownTime = CurTime() + wep.AbilityIcons[ 2 ].Cooldown

				if SERVER then
					SCPFOOTSTEP["SCP939"] = false
					BroadcastLua("SCPFOOTSTEP[\"SCP939\"] = false")
					timer.Simple(30, function()
						SCPFOOTSTEP["SCP939"] = true
						BroadcastLua("SCPFOOTSTEP[\"SCP939\"] = true")
					end)
				end

			end
		end)
	--end

	self.Owner:DrawViewModel( false )

	if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

	end

	self:SetHoldType( self.HoldType )

	if ( CLIENT ) then

    self:ChooseAbility( self.AbilityIcons )

		colour = 0

		hook.Add( "PreDrawOutlines", "DrawPlayers", function()

			local client = LocalPlayer()

      if ( client:GetNClass() != "SCP939" || client:Health() <= 0 ) then

        hook.Remove( "PreDrawOutlines", "DrawPlayers" )

        return
      end

			local sphere_ents = ents.FindInSphere( client:GetPos(), 680 )
			local draw_tab = {}

			for i = 1, #sphere_ents do

				if ( !( self && self:IsValid() ) ) then break end

				local ent = sphere_ents[ i ]

				if ( ent:IsPlayer() && ent != client && self:CanSeePlayer( ent ) ) then

					draw_tab[ #draw_tab + 1 ] = ent

				end

			end

			if ( #draw_tab > 0 ) then

				outline.Add( draw_tab, clr_red, OUTLINE_MODE_VISIBLE )

			end

		end )

	end

end

if ( SERVER ) then

	function SWEP:Think()

		local sphere_ents = ents.FindInSphere( self.Owner:GetPos(), 680 )

		for i = 1, #sphere_ents do

			local v = sphere_ents[ i ]

			if ( v:IsPlayer() && v != self.Owner ) then

				if ( v:GetVelocity():Length2DSqr() > .25 || v:GetStamina() < 20 || v:KeyDown( IN_ATTACK ) ) then

					--RecursiveSetPreventTransmit( v, self.Owner, false )

				else

					--RecursiveSetPreventTransmit( v, self.Owner, true )

				end

			end

		end

	end

	function SWEP:OnRemove()


		local players = player.GetAll()

		local scp939_exists

		for i = 1, #players do

			local player = players[ i ]

			if ( player:GetNClass() == "SCP939" ) then

				scp939_exists = true

				break
			end

		end

		if ( !scp939_exists ) then

			hook.Remove( "PlayerButtonDown", "SCP939_Buttons" )

		end


		local players = player.GetAll()

		for i = 1, #players do

			local player = players[ i ]

			if ( player && player:IsValid() ) then

				--RecursiveSetPreventTransmit( player, self.Owner, false )

			end

		end

	end

else

	function SWEP:DrawHUD()

		if ( !self.Deployed ) then

			self.Deployed = true

			self:Deploy()

		end

	end

end
