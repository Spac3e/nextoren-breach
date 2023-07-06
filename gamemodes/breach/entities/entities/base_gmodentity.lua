--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/base_gmodentity.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- gamemodes/breach/entities/entities/base_gmodentity.lua
-- Retrieved by https://github.com/lewez/glua-steal

AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

if ( CLIENT ) then

	function ENT:BeingLookedAtByLocalPlayer()

		if ( LocalPlayer():GetEyeTrace().Entity != self ) then return false end
		if ( LocalPlayer():GetViewEntity() == LocalPlayer() && LocalPlayer():GetShootPos():Distance( self:GetPos() ) > 256 ) then return false end
		if ( LocalPlayer():GetViewEntity() != LocalPlayer() && LocalPlayer():GetViewEntity():GetPos():Distance( self:GetPos() ) > 256 ) then return false end

		return true

	end

end

function ENT:Think()

	if ( CLIENT && self:BeingLookedAtByLocalPlayer() && self:GetOverlayText() != "" ) then

		AddWorldTip( self:EntIndex(), self:GetOverlayText(), 0.5, self:GetPos(), self.Entity )

		halo.Add( { self }, color_white, 1, 1, 1, true, true )

	end

end

function ENT:SetOverlayText( text )

	self:SetNWString( "GModOverlayText", text )

end

function ENT:GetOverlayText()

	local txt = self:GetNWString( "GModOverlayText" )

	if ( txt == "" ) then
		return ""
	end

	if ( game.SinglePlayer() ) then
		return txt
	end

	local PlayerName = self:GetPlayerName()

	return txt .. "\n(" .. PlayerName .. ")"

end

function ENT:SetPlayer( ply )

	if ( IsValid( ply ) ) then

		self:SetVar( "Founder", ply )
		self:SetVar( "FounderIndex", ply:UniqueID() )

		self:SetNWString( "FounderName", ply:Nick() )

	end

end

function ENT:GetPlayer()

	return self:GetVar( "Founder", NULL )

end

function ENT:GetPlayerIndex()

	return self:GetVar( "FounderIndex", 0 )

end

function ENT:GetPlayerName()

	local ply = self:GetPlayer()
	if ( IsValid( ply ) ) then
		return ply:Nick()
	end

	return self:GetNWString( "FounderName" )

end

