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

if not MTFMenuFrame then
	MTFMenuFrame = nil
end

nextmenudelete = 0
showmenu = false

local zoom_in = false
local ZoomFOVModifier = 0

function GM:KeyPress( ply, key )
	if ( key == IN_ZOOM ) then
		zoom_in = true
	end
end

function GM:KeyRelease( ply, key )
	if ( key == IN_ZOOM ) then
		zoom_in = false
	end
end

function CloseMTFMenu()
	if ispanel(MTFMenuFrame) then
		if MTFMenuFrame.Close then
			MTFMenuFrame:Close()
		end
	end
end

function OpenMenu()
	if IsValid(MTFMenuFrame) then return end
	local ply = LocalPlayer()
	if !(ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS) then return end
	
	MTFMenuFrame = vgui.Create( "DFrame" )
	MTFMenuFrame:SetTitle( "" )
	MTFMenuFrame:SetSize( 265, 375 )
	MTFMenuFrame:Center()
	MTFMenuFrame:SetDraggable( true )
	MTFMenuFrame:SetDeleteOnClose( true )
	MTFMenuFrame:SetDraggable( false )
	MTFMenuFrame:ShowCloseButton( true )
	MTFMenuFrame:MakePopup()
	MTFMenuFrame.Paint = function( self, w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color(0, 0, 0) )
		draw.RoundedBox( 2, 1, 1, w - 2, h - 2, Color(90, 90, 95) )
	end
	
	local maininfo = vgui.Create( "DLabel", MTFMenuFrame )
	maininfo:SetText( "Mobile Task Force Manager" )
	maininfo:Dock( TOP )
	maininfo:SetFont("MTF_2Main")
	maininfo:SetContentAlignment( 5 )
	//maininfo:DockMargin( 245, 8, 8, 175 )
	maininfo:SetSize(0,24)
	maininfo.Paint = function( self, w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color(0, 0, 0) )
		draw.RoundedBox( 2, 1, 1, w - 2, h - 2, Color(90, 90, 95) )
	end
	
	local button_gatea = vgui.Create( "DButton", MTFMenuFrame )
	button_gatea:SetText( "Destroy Gate A" )
	button_gatea:Dock( TOP )
	button_gatea:SetFont("MTF_Main")
	button_gatea:SetContentAlignment( 5 )
	button_gatea:DockMargin( 0, 5, 0, 0	)
	button_gatea:SetSize(0,32)
	button_gatea.DoClick = function()
		RunConsoleCommand("br_destroygatea")
		MTFMenuFrame:Close()
	end

	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Request Escorting" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_requestescort")
		MTFMenuFrame:Close()
	end
	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Sound: Random" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_random")
		MTFMenuFrame:Close()
	end
	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Sound: Searching" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_searching")
		MTFMenuFrame:Close()
	end
	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Sound: Class D Found" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_classd")
		MTFMenuFrame:Close()
	end
	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Sound: Stop!" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_stop")
		MTFMenuFrame:Close()
	end
	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Sound: Target Lost" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_lost")
		MTFMenuFrame:Close()
	end
end




