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

    [ROLES.ROLE_MTFGUARD] = "ar2",
    [ROLES.ROLE_MTFMEDIC] = "SMG1",
    [ROLES.ROLE_MTFL] = "ar2",
    [ROLES.ROLE_MTFCOM] = "ar2",
    [ROLES.ROLE_MTFSHOCK] = "Shotgun",
    [ROLES.ROLE_Engi] = "ar2",
    [ROLES.ROLE_MTFCHEMIST] = "SMG1",
    [ROLES.ROLE_SPECIALIST] = "ar2",
    [ROLES.ROLE_MTFJAG] = "ar2",
    [ROLES.ROLE_HOF] = "Revolver",
    
  }

  local Teams_Setup = {

    [ ROLES.ROLE_SECURITYRECRUIT ] = {

      weapon = { "cw_kk_ins2_cstm_mp7" },
      ammo = {"cw_kk_ins2_cstm_mp7", 120},
      bodygroups = "11001001",
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 1,
        ["HITGROUP_CHEST"] = 0.8,
        ["HITGROUP_LEFTARM"] = 1,
        ["HITGROUP_RIGHTARM"] = 1,
        ["HITGROUP_STOMACH"] = 0.8,
        ["HITGROUP_GEAR"] = 0.8,
        ["HITGROUP_LEFTLEG"] = 1,
        ["HITGROUP_RIGHTLEG"] = 1
       },

    },

    [ ROLES.ROLE_SECURITYCHIEF ] = {

      weapon = { "cw_kk_ins2_uar556" },
      ammo = {"cw_kk_ins2_uar556", 180},
      bodygroups = "12001001",
      bonemerge = "models/cultist/humans/balaclavas_new/balaclava_full.mdl",
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 1,
        ["HITGROUP_CHEST"] = 0.8,
        ["HITGROUP_LEFTARM"] = 1,
        ["HITGROUP_RIGHTARM"] = 1,
        ["HITGROUP_STOMACH"] = 0.8,
        ["HITGROUP_GEAR"] = 0.8,
        ["HITGROUP_LEFTLEG"] = 1,
        ["HITGROUP_RIGHTLEG"] = 1
       },

    },

    [ ROLES.ROLE_SECURITYSERG ] = {

      weapon = { "cw_kk_ins2_ump45" },
      ammo = {"cw_kk_ins2_ump45", 180},
      bodygroups = "22001001",
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 1,
        ["HITGROUP_CHEST"] = 0.8,
        ["HITGROUP_LEFTARM"] = 1,
        ["HITGROUP_RIGHTARM"] = 1,
        ["HITGROUP_STOMACH"] = 0.8,
        ["HITGROUP_GEAR"] = 0.8,
        ["HITGROUP_LEFTLEG"] = 1,
        ["HITGROUP_RIGHTLEG"] = 1
       },

    },

    [ ROLES.ROLE_SECURITYOFFICER ] = {

      weapon = { "cw_kk_ins2_ump45" },
      ammo = {"cw_kk_ins2_ump45", 180},
      bodygroups = "10101001",
      bonemerge = "models/cultist/humans/balaclavas_new/head_balaclava_month.mdl",
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 0.8,
        ["HITGROUP_CHEST"] = 0.8,
        ["HITGROUP_LEFTARM"] = 1,
        ["HITGROUP_RIGHTARM"] = 1,
        ["HITGROUP_STOMACH"] = 0.8,
        ["HITGROUP_GEAR"] = 0.8,
        ["HITGROUP_LEFTLEG"] = 0.9,
        ["HITGROUP_RIGHTLEG"] = 0.9
       },

    },

    [ ROLES.ROLE_SECURITYSTORMTROOPER ] = {

      weapon = { "cw_kk_ins2_cstm_ksg" },
      ammo = {"cw_kk_ins2_cstm_ksg", 40},
      bodygroups = "22011101",
      bonemerge = "models/cultist/humans/balaclavas_new/balaclava_full.mdl",
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 0.65,
        ["HITGROUP_CHEST"] = 0.65,
        ["HITGROUP_LEFTARM"] = 0.65,
        ["HITGROUP_RIGHTARM"] = 0.65,
        ["HITGROUP_STOMACH"] = 0.65,
        ["HITGROUP_GEAR"] = 0.65,
        ["HITGROUP_LEFTLEG"] = 0.65,
        ["HITGROUP_RIGHTLEG"] = 0.65
       },

    },

    [ ROLES.ROLE_SECURITYWARDEN ] = {

      weapon = { "cw_kk_ins2_uar556" },
      ammo = {"cw_kk_ins2_uar556", 160},
      bodygroups = "12001001",
      bonemerge = true,
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 0.8,
        ["HITGROUP_CHEST"] = 0.8,
        ["HITGROUP_LEFTARM"] = 1,
        ["HITGROUP_RIGHTARM"] = 1,
        ["HITGROUP_STOMACH"] = 0.8,
        ["HITGROUP_GEAR"] = 0.8,
        ["HITGROUP_LEFTLEG"] = 1,
        ["HITGROUP_RIGHTLEG"] = 1
       },

    },

    [ ROLES.ROLE_SECURITYIMV ] = {

      weapon = { "cw_kk_ins2_blackout" },
      ammo = {"cw_kk_ins2_blackout", 160},
      bodygroups = "22001001",
      bonemerge = "models/cultist/humans/balaclavas_new/balaclava_full.mdl",
      damage_modifiers = {
        ["HITGROUP_HEAD"] = 0.9,
        ["HITGROUP_CHEST"] = 0.8,
        ["HITGROUP_LEFTARM"] = 1,
        ["HITGROUP_RIGHTARM"] = 1,
        ["HITGROUP_STOMACH"] = 0.8,
        ["HITGROUP_GEAR"] = 0.8,
        ["HITGROUP_LEFTLEG"] = 1,
        ["HITGROUP_RIGHTLEG"] = 1
       },

    },
  }

  function ENT:Use( survivor )

    if ( ( self.NextUse || 0 ) > CurTime() ) then return end

    self.NextUse = CurTime() + .25

    local gteam = survivor:GTeam()

    if ( gteam != TEAM_SCI and gteam != TEAM_GUARD ) or survivor:GetNClass() == ROLES.ROLE_DISPATCHER then
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


    elseif gteam == TEAM_SCI then
      if gteam == TEAM_SCI and survivor:GetModel():find("mog.mdl") then
        survivor:RXSENDNotify("На вас уже надето вооружение!")
        return
      end
      if gteam != TEAM_SCI or !Teams_Setup[survivor:GetNClass()] then
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
      
      --survivor:CompleteAchievement("weaponry")
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
