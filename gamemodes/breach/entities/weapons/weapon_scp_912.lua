--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/weapons/weapon_scp_912.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.AbilityIcons = {

  {

    ["Name"] = "Smoke Grenade",
    ["Description"] = "Throw a smoke grenade you can see through.",
    ["Cooldown"] = "55",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_F"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/smoke.png",
    ["Abillity"] = nil

  },

  {

    ["Name"] = "Nerve Grenade",
    ["Description"] = "Throw a special grenade to temporarily blind other people.",
    ["Cooldown"] = "79",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_G"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/nerve_gas.png",
    ["Abillity"] = nil

  },

  {

    ["Name"] = "Stealth Style",
    ["Description"] = "You taking out a special knife, your footsteps are deaf and you are faster than before",
    ["Cooldown"] = "120",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_1"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/knife.png",
    ["Abillity"] = nil

  },

  {

    ["Name"] = "Sprint",
    ["Description"] = "Now you can sprint for 17 seconds.",
    ["Cooldown"] = "60",
    ["CooldownTime"] = 0,
    ["KEY"] = _G["KEY_2"],
    ["Using"] = false,
    ["Icon"] = "nextoren/gui/special_abilities/scp_912/sprint.png",
    ["Abillity"] = nil

  },

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-912"
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "scp638"

SWEP.Base = "breach_scp_base"

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end

function SWEP:Initialize()
  if CLIENT then
    hook.Add("HUDPaint", "SCP_912_HUD", function()
      if LocalPlayer():GetNClass() != SCP912 or !LocalPlayer():HasWeapon("weapon_scp_912") then 
        hook.Remove("HUDPaint", "SCP_912_HUD")
        return
      end
      self:DrawHUD()
    end)
  end
end

function SWEP:Deploy()

  if SERVER then
    local deploycd = SysTime() + 1
    hook.Add( "PlayerButtonDown", "SCP912_Buttons", function( caller, button )

      if ( caller:GetNClass() != "SCP912" ) then return end

      local wep = caller:GetWeapon("weapon_scp_912")

      if ( wep == NULL || !wep.AbilityIcons ) then return end

      --if !wep.haspicked and button != MOUSE_LEFT and button != MOUSE_RIGHT and deploycd <= SysTime() then
        --caller:SelectWeapon("cw_kk_scp_912")
        --wep.haspicked = true
      --end

      if button == KEY_2 and wep.AbilityIcons[4].CooldownTime <= CurTime() then

        self:Cooldown(4, tonumber(wep.AbilityIcons[4].Cooldown))

        if self.AbilityIcons[1].CooldownTime <= CurTime() + 15 then
          self:Cooldown(1, 20)
        end
        if self.AbilityIcons[2].CooldownTime <= CurTime() + 15 then
          self:Cooldown(2, 20)
        end
        if self.AbilityIcons[3].CooldownTime <= CurTime() + 15 then
          self:Cooldown(3, 20)
        end

        caller:BrProgressBar("Sprint", 15, "nextoren/gui/special_abilities/scp_912/sprint.png", NULL, true, function()
        end)

        local saverun = caller:GetRunSpeed()
        local savewalk = caller:GetWalkSpeed()
        caller:SetRunSpeed(215)
        caller:SetWalkSpeed(215)

        timer.Simple(15, function()
          if caller:GetNClass() == SCP912 then
            caller:SetRunSpeed(saverun)
            caller:SetWalkSpeed(savewalk)
          end
        end)

      elseif button == KEY_1 and wep.AbilityIcons[3].CooldownTime <= CurTime() then
        self:Cooldown(3, tonumber(wep.AbilityIcons[3].Cooldown))

        if self.AbilityIcons[1].CooldownTime <= CurTime() + 25 then
          self:Cooldown(1, 30)
        end
        if self.AbilityIcons[2].CooldownTime <= CurTime() + 25 then
          self:Cooldown(2, 30)
        end
        if self.AbilityIcons[4].CooldownTime <= CurTime() + 25 then
          self:Cooldown(4, 30)
        end

        caller:BreachGive('weapon_scp_912_knife')
        caller:GetActiveWeapon().SwitchWep = caller:GetWeapon("weapon_scp_912_knife")

        local smokeScreen = ents.Create("cw_smokescreen_912")
        smokeScreen:SetPos(caller:GetPos())
        smokeScreen:Spawn()

        caller:ScreenFade(SCREENFADE.IN, Color(255,0,0, 50), 4, 1)
        local saverun = caller:GetRunSpeed()
        local savewalk = caller:GetWalkSpeed()
        caller:SetRunSpeed(270)
        caller:SetWalkSpeed(270)

        caller:BrProgressBar("RAGE MODE", 25, "nextoren/gui/special_abilities/scp_912/knife.png", NULL, true, function()
        end)

        timer.Simple(25, function()
          if caller:GetNClass() == SCP912 then
            caller:SelectWeapon("cw_kk_scp_912")
            caller:SetRunSpeed(saverun)
            caller:SetWalkSpeed(savewalk)
          end
        end)
      elseif button == KEY_F and wep.AbilityIcons[1].CooldownTime <= CurTime() then
        self:Cooldown(1, tonumber(wep.AbilityIcons[1].Cooldown))

        caller:PlayGestureSequence("gesture_item_throw")

        caller:BrProgressBar("Бросаем гранату", 0.86, "nextoren/gui/special_abilities/scp_912/smoke.png", NULL, true, function()

          caller:ViewPunch(Angle(15,0,0))

          local smokecock = ents.Create("cw_smoke_912")
          smokecock:SetOwner(caller)
          smokecock:SetPos(caller:EyePos())
          smokecock.grenadetype = 1
          smokecock:Spawn()

          local phys = smokecock:GetPhysicsObject()

          if IsValid(phys) then
            phys:SetVelocity(caller:EyeAngles():Forward()*800)
            phys:SetAngleVelocity(Vector(1000,1000,0))
          end

        end)

      elseif button == KEY_G and wep.AbilityIcons[2].CooldownTime <= CurTime() then
        self:Cooldown(2, tonumber(wep.AbilityIcons[2].Cooldown))

        caller:PlayGestureSequence("gesture_item_throw")

        caller:BrProgressBar("Бросаем гранату", 0.86, "nextoren/gui/special_abilities/scp_912/nerve_gas.png", NULL, true, function()

          caller:ViewPunch(Angle(15,0,0))

          local smokecock = ents.Create("cw_smoke_912")
          smokecock:SetOwner(caller)
          smokecock:SetPos(caller:EyePos())
          smokecock.grenadetype = 2
          smokecock:Spawn()

          local phys = smokecock:GetPhysicsObject()

          if IsValid(phys) then
            phys:SetVelocity(caller:EyeAngles():Forward()*800)
            phys:SetAngleVelocity(Vector(1000,1000,0))
          end

        end)


      end

    end)
  end

  self:SetHoldType( self.HoldType )

  if ( CLIENT ) then

    self:ChooseAbility( self.AbilityIcons )

    colour = 0

  end

  if SERVER then

    self.Owner:BreachGive("cw_kk_scp_912")
    self.Owner:GiveAmmo(999999, "SMG1", true)
    self.Owner:SelectWeapon("cw_kk_scp_912")

    local wep = self.Owner:GetWeapon("cw_kk_scp_912")
    wep:SetClip1(wep:GetMaxClip1())
    timer.Simple(1, function()
    wep:attachSpecificAttachment("kk_ins2_suppressor_sec")
    wep:attachSpecificAttachment("kk_ins2_vertgrip") end)

  end

end

if ( SERVER ) then
  
  function SWEP:OnRemove()


    local players = player.GetAll()

    local SCP912_exists

    for i = 1, #players do

      local player = players[ i ]

      if ( player:GetNClass() == "SCP912" ) then

        SCP638_exists = true

        break
      end

    end

    if ( !SCP912_exists ) then

      hook.Remove( "PlayerButtonDown", "SCP912_Buttons" )

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
