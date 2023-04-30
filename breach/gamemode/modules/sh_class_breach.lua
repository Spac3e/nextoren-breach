local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player

local mply = FindMetaTable("Player")

function mply:GetBreachCrouch()
	return self:GetNWString("_BreachCrouch", false)
end

function mply:SetBreachCrouch(bool)
	return self:SetNWString("_BreachCrouch", bool)
end

function mply:GetUsingHelmet()
	return self:GetNWString("_UsingHelmet", "")
end

function mply:SetUsingHelmet(str)
	return self:SetNWString("_UsingHelmet", str)
end

function mply:GetUsingBag()
	return self:GetNWString("_UsingBag", "")
end

function mply:SetUsingBag(str)
	return self:SetNWString("_UsingBag", str)
end

function mply:GetUsingArmor()
	return self:GetNWString("_UsingArmor", "")
end

function mply:SetUsingArmor(str)
	return self:SetNWString("_UsingArmor", str)
end

DEFINE_BASECLASS( "player_default" )

local templevel = 0 -- set 0 to disable

local bonuslevel = 0

local PLAYER = {}

function PLAYER:SetupDataTables()
	
	self.Player:NetworkVar( "String", 0, "NClass" )
	self.Player:NetworkVar( "String", 1, "LastRole" )
	self.Player:NetworkVar( "String", 2, "Namesurvivor")
	self.Player:NetworkVar( "String", 3, "UsingCloth")
	self.Player:NetworkVar( "String", 4, "ForcedAnimation")
	self.Player:NetworkVar( "Int", 0, "NEXP" )
	self.Player:NetworkVar( "Int", 1, "NLevel" )
	self.Player:NetworkVar( "Int", 2, "NGTeam" )
	self.Player:NetworkVar( "Int", 4, "MaxSlots" )
	self.Player:NetworkVar( "Int", 3, "LastTeam" )
	self.Player:NetworkVar( "Int", 5, "SpecialMax" )
	self.Player:NetworkVar( "Int", 6, "NEscapes" )
    self.Player:NetworkVar( "Int", 7, "NDeaths" )
	self.Player:NetworkVar( "Float", 0, "SpecialCD" )
	self.Player:NetworkVar( "Float", 1, "StaminaScale" )
	self.Player:NetworkVar( "Float", 6, "Stamina")
	self.Player:NetworkVar( "Float", 7, "Elo")
	self.Player:NetworkVar( "Bool", 0, "NActive" )
	self.Player:NetworkVar( "Bool", 1, "NPremium" )
	self.Player:NetworkVar( "Bool", 2, "Active" )
	self.Player:NetworkVar( "Bool", 3, "Energized" )
	self.Player:NetworkVar( "Bool", 4, "Boosted" )
	self.Player:NetworkVar( "Bool", 5, "Adrenaline" )
	self.Player:NetworkVar( "Bool", 6, "Female" )
	self.Player:NetworkVar( "Bool", 7, "Stunned" )
	self.Player:NetworkVar( "Bool", 8, "InDimension")
	
	if SERVER then
		print("Setting up datatables for " .. self.Player:Nick())
		self.Player:SetNClass("Spectator")
		self.Player:SetNamesurvivor( "none" )
		self.Player:SetLastRole( "" )
		self.Player:SetLastTeam( 0 )
		
		CheckPlayerData(self.Player, "breach_escapes")
        self.Player:SetNEscapes(tonumber(self.Player:GetPData("breach_escapes", 0)))
        CheckPlayerData(self.Player, "breach_deaths")
        self.Player:SetNDeaths(tonumber(self.Player:GetPData("breach_deaths", 0)))
		CheckPlayerData(self.Player, "breach_elo")
        self.Player:SetElo(tonumber(self.Player:GetPData("breach_elo", 0)))
		
		CheckPlayerData( self.Player, "breach_exp" )
		self.Player:SetNEXP( tonumber( self.Player:GetPData( "breach_exp", 0 ) ) )
		if templevel == 0 then
			CheckPlayerData( self.Player, "breach_level" )
			self.Player:SetNLevel( tonumber( self.Player:GetPData( "breach_level", 0 ) ) )
		else
			self.Player:SetNLevel( templevel )
		end

		if bonuslevel > 0 then

			if self.Player:GetNLevel() < bonuslevel then

				self.Player:SetNLevel( bonuslevel )
				self.Player:SetPData( "breach_level", bonuslevel )

			end

		end

		self.Player:SetNGTeam(1)
		self.Player:SetNActive(true)
		self.Player:SetNPremium( self.Player.Premium or false )
		self.Player:SetSpecialCD( 0 )
		self.Player:SetInDimension( false )
		self.Player:SetAdrenaline( false )
		self.Player:SetEnergized( false )
		self.Player:SetBoosted( false )
		self.Player:SetMaxSlots( 8 )
		self.Player:SetFemale( false )
		self.Player:SetUsingCloth("")
		self.Player:SetUsingArmor("")
		self.Player:SetUsingHelmet("")
		self.Player:SetSpecialMax( 0 )
		self.Player:SetStunned(false)
		self.Player:SetStaminaScale(1.0)
		if SERVER then
			if self.Player:GetPData("AlphaTester", false) then
				self.Player:SetNWBool("AlphaTester", true)
			end
			if self.Player:GetPData("BetaTester", false) then
				self.Player:SetNWBool("BetaTester", true)
			end
		end
	end
end

function CheckPlayerData( player, name )
	local pd = player:GetPData( name, 0 )
	if pd == "nil" then
		print( "Damaged playerdata found..." )
		player:RemovePData( name )
		player:SetPData( name, 1 )
	end
end

player_manager.RegisterClass( "class_breach", PLAYER, "player_default" )