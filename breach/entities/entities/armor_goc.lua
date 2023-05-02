--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/armor_goc.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "GOC Armor"

ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 3
ENT.BodygroupModel = 1

ENT.CantStrip = true

ENT.SlotNeeded = 2

ENT.FuncOnPickup = function( ply )
  ply:Give( "breach_keycard_crack" )
  ply:Give( "cw_cultist_semisniper_arx160" )
  ply:Give( "item_nightvision_white" )

  ply:ClearBodyGroups()

  ply:SetAmmo( 200, "GOC" )

  ply:StripWeapon("item_knife")

  BREACH.Players:ChatPrint( ply, true, true, "Вы нашли снаряжение. Выполняйте основную задачу." )

  ply:AddToStatistics( "First objective complete", 100 )

  ply:SetUsingCloth("")

end
ENT.Team = TEAM_GOC
ENT.ArmorModel 			= "models/cultist/humans/goc/goc.mdl"
ENT.ArmorSkin = 2
ENT.ArmorType = "Clothes"
ENT.ShouldUnwearArmor = true
ENT.ShouldUnwearHat = false
ENT.Bodygroups = {

  [0] = "0", -- шлем
  [1] = "0", -- броня
  [2] = "0"

}
ENT.MultipliersType = {

	[ DMG_BULLET ] = .5,
	[ DMG_BLAST ] = .5,
	[ DMG_PLASMA ] = .5,
	[ DMG_SHOCK ] = .5,
	[ DMG_ACID ] = .6,
	[ DMG_POISON ] = .8


}

if ( CLIENT ) then

  local outline_clr = gteams.GetColor( TEAM_GOC )

  function ENT:Draw()

    local client = LocalPlayer()

    if ( client:GetNClass() == ROLES.ROLE_GOCSPY ) then

      self:DrawModel()

      local client_trace_pos = client:GetEyeTrace().HitPos

      if ( client_trace_pos:DistToSqr( self:GetPos() ) < 19600 ) then

        outline.Add( { self }, outline_clr, OUTLINE_MODE_VISIBLE )

      end

    end

  end

end
