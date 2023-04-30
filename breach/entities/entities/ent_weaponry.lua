--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/ent_weaponry.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

ENT.Type        = "anim"
ENT.Category    = "Breach"

ENT.Model       = Model( "models/cultist/armory/armory.mdl" )

function ENT:Initialize()

  if ( SERVER ) then

    self:SetModel( self.Model )
    self:SetMoveType( MOVETYPE_NONE )

    self.BannedUsers = {}

  end

  self:SetSolid( SOLID_VPHYSICS )

end

if ( SERVER ) then

  local MTF_SETUP = {

    [ROLES.ROLE_MTFSHOCK] = "Shotgun",
    
  }

  local Teams_Setup = {

 }

  function ENT:Use( survivor )

    if ( ( self.NextUse || 0 ) > CurTime() ) then return end

    self.NextUse = CurTime() + .25

    local gteam = survivor:GTeam()

    if ( gteam != TEAM_SECURITY and gteam != TEAM_GUARD ) or survivor:GetNClass() == ROLES.ROLE_DISPATCHER then
      survivor:RXSENDNotify("Вы не можете взаимодействовать с данным объектом!")
      return
    end
    
    if gteam == TEAM_GUARD then

      if self.BannedUsers[survivor:GetName()] then
        survivor:RXSENDNotify("Вы уже брали снаряжение!")
        return
      end

      self.BannedUsers[survivor:GetName()] = true

      local ammotype = "AR2"

      if MTF_SETUP[survivor:GetNClass()] then
        ammotype = MTF_SETUP[survivor:GetNClass()]
      end

      local ammo = 30

      for i, v in pairs(survivor:GetWeapons()) do

        if v.GetPrimaryAmmoType and v:GetPrimaryAmmoType() == game.GetAmmoID(ammotype) then
          ammo = v:GetMaxClip1()
        end

      end

      survivor:GiveAmmo(ammo*30, ammotype, true)

      survivor:EmitSound( "nextoren/equipment/ammo_pickup.wav", 75, math.random( 95, 105 ), .75, CHAN_STATIC )


    elseif gteam == TEAM_SECURITY then
      if gteam == TEAM_SECURITY and survivor:GetModel():find("mog.mdl") then
        survivor:RXSENDNotify("На вас уже надето вооружение!")
        return
      end
      if gteam != TEAM_SECURITY or !Teams_Setup[survivor:GetNClass()] then
        survivor:RXSENDNotify("Вы не можете взаимодействовать с данным объектом!")
        return
      end
      if survivor:GetMaxSlots() - survivor:GetPrimaryWeaponAmount() < #Teams_Setup[survivor:GetNClass()].weapon then
        survivor:RXSENDNotify("Вам нужно иметь "..tostring(#Teams_Setup[survivor:GetNClass()].weapon).." свободных ячеек в инвентаре!")
        return
      end

      if self.BannedUsers[survivor:GetName()] then
        survivor:RXSENDNotify("Вы уже брали снаряжение!")
        return
      end

      self.BannedUsers[survivor:GetName()] = true
      
      survivor:CompleteAchievement("weaponry")
      local tab = Teams_Setup[survivor:GetNClass()]
      survivor:EmitSound( Sound("nextoren/others/cloth_pickup.wav"), 125, 100, 1.25, CHAN_VOICE)
      survivor:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
      if survivor:IsFemale() then
        survivor:SetModel("models/cultist/humans/mog/mog_woman_capt.mdl")
      else
        survivor:SetModel("models/cultist/humans/mog/mog.mdl")
        if tab.bonemerge then
          for _, bnmrg in ipairs(survivor:LookupBonemerges()) do
            if bnmrg:GetModel():find("male_head") or bnmrg:GetModel():find("balaclava") then
              local copytext = bnmrg:GetSubMaterial(0)
              local bnmrg_new
              if tab.bonemerge != true then
                bnmrg_new = Bonemerge(tab.bonemerge, survivor)
              else
                bnmrg_new = Bonemerge(PickHeadModel(), survivor)
              end
              bnmrg_new:SetSubMaterial(0, copytext)
              bnmrg:Remove()
            end
          end
        end
      end
      survivor:ClearBodyGroups()
      survivor:SetupHands()
      survivor:SetBodyGroups(tab.bodygroups)
      survivor.ScaleDamage = tab.damage_modifiers
      for _, wep in ipairs(tab.weapon) do
       survivor:Give(wep)
      end
      survivor:GiveAmmo(tab.ammo[2], survivor:GetWeapon(tab.ammo[1]):GetPrimaryAmmoType(), true)
      survivor:RXSENDNotify("Вам было выдано снаряжение ", gteams.GetColor(TEAM_GUARD), "\"МОГ\"")
    end
  end

end

if ( CLIENT ) then

  function ENT:Draw()

    self:DrawModel()

  end

end
