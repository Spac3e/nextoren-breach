--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/ent_bonemerged.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--if SERVER then

local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player

--else

local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player
local LocalPlayer = LocalPlayer
local IsValid = IsValid
local FrameTime = FrameTime
local CurTime = CurTime
local EyePos = EyePos
local EyeAngles = EyeAngles
local Lerp = Lerp

--end

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Invisible" )

  self:SetInvisible( false )

end

if SERVER then

function ENT:Think()

  local parent = self:GetParent()
  local parent_valid = parent && parent:IsValid()

  if ( !parent_valid ) then

    self:Remove()

    return
  end

  local parenttable = parent:GetTable()

  local parent_nodraw = parent:GetNoDraw()
  local parent_invisibility = parenttable.CommanderAbilityActive or false
  local self_nodraw = self:GetNoDraw()

  if ( parent_valid && parent_nodraw && !self_nodraw ) then

    self:SetNoDraw( true )

  elseif ( parent_valid && self_nodraw && !parent_nodraw ) then

    self:SetNoDraw( false )

  end

  if parent_valid and parent_invisibility then
    self:SetNoDraw(true)
  end

end

end

if ( SERVER ) then return end

function ENT:Initialize()
  self.PixVis = util.GetPixelVisibleHandle()
end

local reg = debug.getregistry()

local drawmodel = reg.Entity.DrawModel

local _util_PixelVisible = util.PixelVisible

ENT.RenderGroup = RENDERGROUP_OPAQUE
function ENT:Draw( flags )
  if !self:GetInvisible() then
      drawmodel(self, flags)
  end
end