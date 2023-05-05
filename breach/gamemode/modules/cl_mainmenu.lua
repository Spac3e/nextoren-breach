--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/gamemode/modules/cl_mainmenu.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local MenuTable = {}
MenuTable.url = "https://discord.gg/WfaQDe9"
MenuTable.start = "Play"
MenuTable.Leave = "Leave"
MenuTable.OurGroup = "Discord"
MenuTable.FAQ = "Information"
MenuTable.Settings = "Settings"

surface.CreateFont("MainMenuFont", {

  font = "Conduit ITC",
  size = 24,
  weight = 800,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false

})

surface.CreateFont("MainMenuFontmini", {

  font = "Conduit ITC",
  size = 26,
  weight = 800,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false

})

local BREACH = BREACH || {}

ShowMainMenu = ShowMainMenu || false
local clr1 = Color( 128, 128, 128 )
local whitealpha = Color( 255, 255, 255, 90 )
local clrblackalpha = Color( 0, 0, 0, 220 )

local gradient = Material("vgui/gradient-r")
local gradients = Material("gui/center_gradient")
local backgroundlogo = Material("nextoren/menu")
local scp = Material("nextoren/gui/icons/notifications/breachiconfortips.png")

local Material_To_Check = {

  "nextoren_hud/overlay/frost_texture",
  "weapons/weapon_flashlight",
  "cultist/door_1",
  "models/balaclavas/balaclava",
  "models/cultist/heads/zombie_face",
  "models/all_scp_models/shared/arms_new",
  "nextoren/gui/special_abilities/special_fbi_commander.png",
  "models/breach_items/ammo_box/ammocrate_smg1"

}


function GM:DrawDeathNotice( x,  y ) end

local intro_clr = Color( 200, 200, 200 )

local function StartIntro()

	local intropanel = vgui.Create( "DPanel" )
	intropanel:SetPos( ScrW() * .75, ScrH() * .7 )
	intropanel:SetSize( math.min( ScrW() * .35, 500 ), 128 )
	intropanel:SetText( "" )
	intropanel.Paint = function( self, w, h ) end

	local NextSymbolTime = RealTime()
	local count = 0
	local alpha = 255

	local TextPanel = vgui.Create( "DLabel", intropanel )
	TextPanel:SetPos( 5, 0 )
	TextPanel:SetFont( "SubScoreboardHeader" )
	TextPanel:SetText( "" )

	local roundstring

	if ( gamestarted ) then

		roundstring = "A new round will begin in " .. string.ToMinutesSeconds( cltime )
		--BREACH.Round.GameStarted = true

	else

		roundstring = "The new round has not started yet"

	end

	local teststring = tostring( "\nSCP Foundation\n Welcome, " .. LocalPlayer():GetName() .. "!\n " .. roundstring .. "\n Good luck!" )

	local stringtable = string.Explode( "", teststring, false )
	surface.SetFont( "SubScoreboardHeader" )
	local stringw, stringh = surface.GetTextSize( teststring )
	TextPanel:SetSize( stringw, stringh )

	TextPanel.Paint = function( self, w, h )

		draw.DrawText( tostring( os.date( "%X" ) ), "SubScoreboardHeader", 0, 0, intro_clr, TEXT_ALIGN_LEFT )

		if ( NextSymbolTime <= RealTime() && count != #stringtable ) then

			NextSymbolTime = NextSymbolTime + 0.08

			count = count + 1
			if ( stringtable[count] != " " ) then

				surface.PlaySound( "common/talk.wav" )

			end

			if ( count == #stringtable ) then

				NextSymbolTime = NextSymbolTime + 10

			end

			TextPanel:SetText( TextPanel:GetText() .. stringtable[count] )

		end

		if ( NextSymbolTime <= RealTime() && count == #stringtable ) then

			alpha = math.Approach( alpha, 0, FrameTime() * 45 )
			TextPanel:SetAlpha( alpha )

			if ( TextPanel:GetAlpha() == 0 ) then

				intropanel:Remove()

			end

		end

	end

end

function music_menu()
  surface.PlaySound( "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
end
concommand.Add( "music_menu", music_menu )

function Fluctuate(c) --used for flashing colors
  return (math.cos(CurTime()*c)+1)/2
end

function Pulsate(c) --Использование флешей
  return (math.abs(math.sin(CurTime()*c)))
end

FIRSTTIME_MENU = FIRSTTIME_MENU || true
function StartBreach( firsttime )
local size = 0

  local ply = LocalPlayer()

  if ( !FIRSTTIME_MENU ) then

    MenuTable.start = "Resume"
    ply.SecondTimeMenu = true

  else
    mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
    mainmenumusic:Play()
  end

  gui.EnableScreenClicker( true )

  local scrw, scrh = ScrW(), ScrH()

	INTRO_PANEL = vgui.Create( "DPanel" );
	INTRO_PANEL:SetSize( scrw, scrh );
	INTRO_PANEL:SetPos( 0, 0 );
  INTRO_PANEL.OpenTime = RealTime()
  INTRO_PANEL.Paint = function(self, w , h)

    draw.RoundedBox( 0, 0, 0, w, h, color_black )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end

  end
	local INTRO_HTML = vgui.Create( "DHTML", INTRO_PANEL );
	INTRO_HTML:SetAllowLua( true );
	INTRO_HTML:SetSize( scrw, scrh );
	INTRO_HTML:SetPos( 0, 0 );

  INTRO_HTML.Paint = function(self, w, h)
    surface.SetMaterial( backgroundlogo )
    surface.DrawTexturedRect( 0, 0, scrw, scrh )
  end

  local BG = vgui.Create( "DPanel", INTRO_PANEL )
  BG:SetSize( ScrW(), ScrH() )
  BG:SetPos( 0, 0 )
  BG:SetText( "" )
  BG.TimeCreate = RealTime()
  BG.Paint = function(self, w, h)

    if ( input.IsKeyDown( KEY_ESCAPE ) && INTRO_PANEL.OpenTime < RealTime() - .2 && !FIRSTTIME_MENU ) then

      ShowMainMenu = CurTime() + .1
      gui.HideGameUI()
      INTRO_PANEL:SetVisible( false )
      gui.EnableScreenClicker( false )
      mainmenumusic:Stop()

    end

    local scrw, scrh = ScrW(), ScrH()

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( scp )
    surface.DrawTexturedRect( scrw / 9, scrh / 3.9, 100, 100 )

    draw.SimpleText( "[VAULT] Breach 2.6.0", "MenuHUDFont", scrw / 6, scrh / 3.4, whitealpha, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Created by VAULT", "MainMenuFont", scrw / 6, scrh / 3.2, whitealpha, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    if jit.arch != "x64" then
      draw.SimpleText( "x86-64 - Chromium beta version of Garry's Mod is strongly recommended.", "MainMenuFont", scrw * 0.1, scrh * 0.9, Color(255, 0, 0, 255 * Pulsate(2)), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end


    draw.SimpleText( "Created by -Spac3, Imperator, Maleyvich and VAULT Team", "MainMenuFont", scrw * 0.1, scrh * 0.93, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

  end

  BG.OnRemove = function()

    gui.EnableScreenClicker( false )

  end

  local MainMenuPanel = vgui.Create( "DPanel", BG )
  MainMenuPanel:SetPos( scrw / 9, scrh / 3.35)
  MainMenuPanel:SetSize(350, 400)
  MainMenuPanel:MoveToFront()

  MainMenuPanel.Paint = function(self, w, h)

    surface.SetDrawColor( 255, 255, 255, 80 )
    surface.SetMaterial( gradients )
    surface.DrawTexturedRect( 32, 44, w / 1.2, 2 )

  end

  local CLOSE = vgui.Create( "DButton", MainMenuPanel )
  CLOSE:SetPos( 0, 50 )
  CLOSE:SetSize( 350, 40 )
  CLOSE:SetText("")
  CLOSE:MoveToFront()
  CLOSE.DoClick = function()

    if ( FIRSTTIME_MENU ) then
      FIRSTTIME_MENU = false
      surface.PlaySound( "nextoren/gui/main_menu/confirm.wav" )

      if ( mainmenumusic ) then

        mainmenumusic:Stop()

      end

      INTRO_PANEL:SetVisible( false )
      gui.EnableScreenClicker( false )
      mainmenumusic:Stop()
      ShowMainMenu = false
      if mainmenumusic then
        mainmenumusic:Stop()
      end

      MenuTable.start = "Resume"

      surface.PlaySound( "nextoren/unity/scpu_objective_completed_v1.01.ogg" )

      ply:ConCommand( "r_decals 4096" )
      ply:ConCommand( "gmod_mcore_test 1" )

      --ply.Active = true
      --INTRO_PANEL:Remove()
      StartIntro()

      PrecachePlayerSounds(LocalPlayer())

      ply:ConCommand( "lounge_chat_clear" )

    else
surface.PlaySound( "nextoren/gui/main_menu/confirm.wav" )
      INTRO_PANEL:SetVisible( false )
      gui.EnableScreenClicker( false )
      if mainmenumusic then
        mainmenumusic:Stop()
      end
      ShowMainMenu = false

    end

  end

  CLOSE.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE.FadeAlpha = 0

  CLOSE.Paint = function(self, w, h)

    draw.SimpleText( MenuTable.start, "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( self:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

  	end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect(0, 0, w, h )

  end

  local confirm = false

  local CLOSE3 = vgui.Create("DButton", MainMenuPanel)
  CLOSE3:SetPos(0,250)
  CLOSE3:SetSize(350,40)
  CLOSE3:SetText("")
  CLOSE3.DoClick = function()
    if !confirm then
      confirm = true
      surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    else
      LocalPlayer():ConCommand("disconnect")
    end
  end
  CLOSE3.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE3.OnCursorExited = function()
    if confirm then
      confirm = false
      surface.PlaySound( "nextoren/gui/main_menu/cancel_1.wav" )
    end
  end

  CLOSE3.FadeAlpha = 0

  CLOSE3.Paint = function( self, w, h )

    if !confirm then
      draw.SimpleText(MenuTable.Leave, "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
      draw.SimpleText("Click to confirm", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if ( CLOSE3:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 0,0, w, h )

  end

  local CLOSE5 = vgui.Create("DButton", MainMenuPanel)
  CLOSE5:SetPos(0,200)
  CLOSE5:SetSize(350,40)
  CLOSE5:SetText("")
  CLOSE5.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    OpenFAQ()
  end
  CLOSE5.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end
  CLOSE5.FadeAlpha = 0
  CLOSE5.Paint = function( self, w, h )

    draw.SimpleText(MenuTable.FAQ, "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if ( CLOSE5:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 0,0, w, h )

  end

  local CONFIG = vgui.Create("DButton", MainMenuPanel)
  CONFIG:SetPos(0,100)
  CONFIG:SetSize(350,40)
  CONFIG:SetText("")
  CONFIG.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    OpenConfigMenu()
  end
  CONFIG.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end
  CONFIG.FadeAlpha = 0
  CONFIG.Paint = function( self, w, h )

    draw.SimpleText(MenuTable.Settings, "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if ( CONFIG:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 0,0, w, h )

  end

  local CLOSE4 = vgui.Create( "DButton", MainMenuPanel )
  CLOSE4:SetPos( 0, 150 )
  CLOSE4:SetSize( 350, 40 )
  CLOSE4:SetText( "" )

  CLOSE4.DoClick = function()

    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    gui.OpenURL( MenuTable.url )

  end

  CLOSE4.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE4.FadeAlpha = 0

  CLOSE4.Paint = function( self, w, h )

    draw.SimpleText( MenuTable.OurGroup, "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( CLOSE4:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 0, 0, w, h )

  end

end

--[[
do

  local client = LocalPlayer()

  if ( !( client.GetActive && client:GetActive() ) && !IsValid( INTRO_PANEL ) ) then

    timer.Create( "StartMainMenu", 0, 0, function()

      local client = LocalPlayer()

      if ( client && client:IsValid() ) then

        --StartBreach( true )
        timer.Remove( "StartMainMenu" )

      end

    end )

  end

end
--]]

hook.Add("InitPostEntity", "NameColorSend", function()
  timer.Simple(30, function()
    local tab = {
    --  spawnsupport = GetConVar("breach_config_spawn_support"):GetBool(),
    --  spawnmale = GetConVar("breach_config_spawn_male_only"):GetBool(),
    --  spawnfemale = GetConVar("breach_config_spawn_female_only"):GetBool(),
    --  displaypremiumicon = GetConVar("breach_config_display_premium_icon"):GetBool(),
      leanright = GetConVar("breach_config_leanright"):GetInt(),
      leanleft = GetConVar("breach_config_leanleft"):GetInt(),
      useability = GetConVar("breach_config_useability"):GetInt()
    }
    net.Start("Load_player_data")
    net.WriteTable(tab)
    net.SendToServer()
    NameColorSend("pidr", "pidr", GetConVar("breach_config_name_color"):GetString())
  end)
end)


hook.Add("InitPostEntity", "StartBreachIntro", function()
  StartBreach(true)
end)

function OpenFAQ()

  local ply = LocalPlayer()

  --mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )

  gui.EnableScreenClicker( true )
  INTRO_PANEL:Remove()

  local scrw, scrh = ScrW(), ScrH()

	INTRO_PANEL3 = vgui.Create( "DPanel" );
	INTRO_PANEL3:SetSize( scrw, scrh );
	INTRO_PANEL3:SetPos( 0, 0 );
  INTRO_PANEL3.OpenTime = RealTime()
  INTRO_PANEL3.Paint = function(self, w , h)

    draw.RoundedBox( 0, 0, 0, w, h, color_black )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end

  end
	local INTRO_HTML3 = vgui.Create( "DHTML", INTRO_PANEL3 );
	INTRO_HTML3:SetAllowLua( true );
	INTRO_HTML3:SetSize( scrw, scrh );
	INTRO_HTML3:SetPos( 0, 0 );

  INTRO_HTML3.Paint = function(self, w, h)
    surface.SetMaterial( backgroundlogo )
    surface.DrawTexturedRect( 0, 0, scrw, scrh )
  end

  local BG3 = vgui.Create( "DPanel", INTRO_PANEL3 )
  BG3:SetSize( ScrW(), ScrH() )
  BG3:SetPos( 0, 0 )
  BG3:SetText( "" )
  BG3.TimeCreate = RealTime()

  BG3.Paint = function(self, w, h)

    if ( input.IsKeyDown( KEY_ESCAPE ) && INTRO_PANEL3.OpenTime < RealTime() - .2 && !FIRSTTIME_MENU ) then

      ShowMainMenu = CurTime() + .1
      gui.HideGameUI()
      INTRO_PANEL3:Remove()
      gui.EnableScreenClicker( false )
      mainmenumusic:Stop()

    end

    local scrw, scrh = ScrW(), ScrH()

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( scp )
    surface.DrawTexturedRect( scrw / 9, scrh / 3.9, 100, 100 )

    draw.SimpleText( "Breach", "MenuHUDFont", scrw / 6, scrh / 3.4, whitealpha, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Created by VAULT Team", "MainMenuFont", scrw / 6, scrh / 3.2, whitealpha, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

  end

  BG3.OnRemove = function()

    gui.EnableScreenClicker( false )

  end

  local MainMenuPanel3 = vgui.Create( "DPanel", BG3 )
  MainMenuPanel3:SetPos( scrw / 9, scrh / 3.35)
  MainMenuPanel3:SetSize(350, 500)
  MainMenuPanel3:MoveToFront()

  MainMenuPanel3.Paint = function(self, w, h)

    surface.SetDrawColor( 255, 255, 255, 80 )
    surface.SetMaterial( gradients )
    surface.DrawTexturedRect( 32, 44, w / 1.2, 2 )

  end

  local CLOSE222 = vgui.Create( "DButton", MainMenuPanel3 )
  CLOSE222:SetPos( 0, 90 )
  CLOSE222:SetSize( 350, 40 )
  CLOSE222:SetText("")
  CLOSE222:MoveToFront()
  CLOSE222.DoClick = function()

    INTRO_PANEL3:Remove()
    StartBreach(false)
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
  end

  CLOSE222.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE222.FadeAlpha = 0

  CLOSE222.Paint = function(self, w, h)

    draw.SimpleText( "Return", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( self:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

  	end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect(0, 0, w, h )

  end

  local CLOSE33 = vgui.Create( "DButton", MainMenuPanel3 )
  CLOSE33:SetPos( 0, 50 )
  CLOSE33:SetSize( 350, 40 )
  CLOSE33:SetText("")
  CLOSE33:MoveToFront()
  CLOSE33.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    --my life, my rules...
    gui.OpenURL("https://docs.google.com/document/d/1uGs-4KcOQpLJmyFVBugI9wgvQHqYRg0u0d-JEWtPSkw")

  end

  CLOSE33.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE33.FadeAlpha = 0

  CLOSE33.Paint = function(self, w, h)

    draw.SimpleText( "Game rules", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( self:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

  	end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect(0, 0, w, h )

  end

  --[[
  local TRELLO = vgui.Create( "DButton", MainMenuPanel3 )
  TRELLO:SetPos( 0, 130 )
  TRELLO:SetSize( 350, 40 )
  TRELLO:SetText("")
  TRELLO:MoveToFront()
  TRELLO.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wavv" )
    gui.OpenURL("https://trello.com/b/tMzwIsNX/nextoren-260-unofficial-vault")

  end

  TRELLO.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  TRELLO.FadeAlpha = 0

  TRELLO.Paint = function(self, w, h)

    draw.SimpleText( "Trello", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( self:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect(0, 0, w, h )

  end
  --]]
  --[[
  local CLOSE332 = vgui.Create( "DButton", MainMenuPanel3 )
  CLOSE332:SetPos( 0, 50 )
  CLOSE332:SetSize( 350, 40 )
  CLOSE332:SetText("")
  CLOSE332:MoveToFront()
  CLOSE332.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    OpenFactionMenu()

  end

  CLOSE332.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE332.FadeAlpha = 0

  CLOSE332.Paint = function(self, w, h)

    draw.SimpleText( "Faction diplomacy", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( self:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

  	end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect(0, 0, w, h )

  end]]

end

--breach config
CreateConVar("breach_config_cw_viewmodel_fov", 70, FCVAR_ARCHIVE, "Change CW 2.0 weapon viewmodel FOV", 50, 100)
CreateConVar("breach_config_announcer_volume", GetConVar("volume"):GetFloat() * 100, FCVAR_ARCHIVE, "Change announcer's volume", 0, 100)
CreateConVar("breach_config_music_volume", GetConVar("snd_musicvolume"):GetFloat() * 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_language", "english", FCVAR_ARCHIVE, "Change gamemode language")
CreateConVar("breach_config_name_color", "255,255,255", FCVAR_ARCHIVE, "Change your nick color in chat. Example: 150,150,150. Premium or higher only")
CreateConVar("breach_config_draw_spec", 0, FCVAR_ARCHIVE, "Draw spectators while dead.", 0, 1)
CreateConVar("breach_config_draw_spec_alive", 0, FCVAR_ARCHIVE, "Draw spectators while alive. Developers only", 0, 1)
CreateConVar("breach_config_screenshot_mode", 0, FCVAR_ARCHIVE, "Completely disables HUD. Can be buggy", 0, 1)
CreateConVar("breach_config_draw_legs", 1, FCVAR_ARCHIVE, "Draw legs")
CreateConVar("breach_config_useability", 18, FCVAR_ARCHIVE, "number you will use ability with")
CreateConVar("breach_config_leanright", KEY_3, FCVAR_ARCHIVE, "Leans to the right")
CreateConVar("breach_config_leanleft", KEY_1, FCVAR_ARCHIVE, "Leans to the left")

RunConsoleCommand("breach_config_language", GetConVar("breach_config_language"):GetString())
local function ChangeServerValue(id, bool)

  net.Start("Change_player_settings")
  net.WriteUInt(id, 12)
  net.WriteBool(bool)
  net.SendToServer()

end

local function ChangeServerValueInt(id, int)

  net.Start("Change_player_settings_id")
  net.WriteUInt(id, 12)
  net.WriteUInt(int, 32)
  net.SendToServer()

end
--language
cvars.AddChangeCallback("breach_config_useability", function(_, _, new)

  LocalPlayer().AbilityKey = string.upper(input.GetKeyName(new))
  LocalPlayer().AbilityKeyCode = new
  ChangeServerValueInt(1, new)

end)
cvars.AddChangeCallback("breach_config_language", function(cvar, old, new)
  RunConsoleCommand("cvar_br_language", new)
end)

BREACH.AllowedNameColorGroups = {
  ["superadmin"] = true,
  ["spectator"] = true,
  ["admin"] = true,
  ["premium"] = true,
}

--name color
cvars.AddChangeCallback("breach_config_name_color", function(cvar, old, new)
  if BREACH.AllowedNameColorGroups[LocalPlayer():GetUserGroup()] or LocalPlayer():IsAdmin() then
    local color_tbl = string.Explode(",", new)

    if color_tbl then
      color = Color(color_tbl[1], color_tbl[2], color_tbl[3])
      if IsColor(color) then
        color.a = 255 --xyecocs
        --don't even fucking try to exploit it or you will suck my dick or BAN
        net.Start("NameColor")
          net.WriteColor(color)
        net.SendToServer()
      end
    end
  end
end)

--draw spectors
hook.Add("PrePlayerDraw", "Breach_Should_Draw_Spectators", function(ply, flags)
  if ply:GTeam() == TEAM_SPEC then
    if LocalPlayer():GTeam() == TEAM_SPEC then
      if GetConVar("breach_config_draw_spec"):GetInt() > 0 then
        return
      end
    end

    if LocalPlayer():IsSuperAdmin() and LocalPlayer():GTeam() != TEAM_SPEC then
      if GetConVar("breach_config_draw_spec_alive"):GetInt() > 0 then
        return
      end
    end

    return true
  end
end)

hook.Add("HUDShouldDraw", "Breach_Screenshot_Mode", function(name)
  if GetConVar("breach_config_screenshot_mode"):GetInt() == 0 then return end

  -- So we can change weapons
  if ( name == "CHudWeaponSelection" ) then return true end
  if ( name == "CHudChat" ) then return true end

  return false

end)

BREACH.Options = {
  [1] = {
    name = "Weapon VFOV",
    short_name = "VFOV",
    cvar = "breach_config_cw_viewmodel_fov",
    string_type = false,
  },
  [2] = {
    name = "Music volume",
    short_name = "Music",
    cvar = "breach_config_music_volume",
    string_type = false,
  },
  [3] = {
    name = "Announcer volume",
    short_name = "Announcer",
    cvar = "breach_config_announcer_volume",
    string_type = false,
  },
  [4] = {
    name = "Language[russian, english]",
    short_name = "Language",
    cvar = "breach_config_language",
    string_type = true,
  },
  [5] = {
    name = "Name RGB color[premium]",
    short_name = "Usage: 150,150,150",
    cvar = "breach_config_name_color",
    string_type = true,
  },
  [6] = {
    name = "Draw spectators while dead",
    short_name = "",
    cvar = "breach_config_draw_spec",
    string_type = false,
  },
  [7] = {
    name = "Draw spectators while alive[dev]",
    short_name = "",
    cvar = "breach_config_draw_spec_alive",
    string_type = false,
  },
  [8] = {
    name = "Screenshot mode",
    short_name = "",
    cvar = "breach_config_screenshot_mode",
    string_type = false,
  },
  [9] = {
    name = "Special Ability Key",
    short_name = "",
    cvar = "breach_config_useability",
    string_type = true,
  }
}

local TEXTENTRY_FRAME

function OpenConfigMenu()

  local ply = LocalPlayer()

  --mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )

  gui.EnableScreenClicker( true )
  INTRO_PANEL:Remove()

  local scrw, scrh = ScrW(), ScrH()

  INTRO_PANEL3 = vgui.Create( "DPanel" );
  INTRO_PANEL3:SetSize( scrw, scrh );
  INTRO_PANEL3:SetPos( 0, 0 );
  INTRO_PANEL3.OpenTime = RealTime()
  INTRO_PANEL3.Paint = function(self, w , h)

    draw.RoundedBox( 0, 0, 0, w, h, color_black )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end

  end
  local INTRO_HTML3 = vgui.Create( "DHTML", INTRO_PANEL3 );
  INTRO_HTML3:SetAllowLua( true );
  INTRO_HTML3:SetSize( scrw, scrh );
  INTRO_HTML3:SetPos( 0, 0 );

  INTRO_HTML3.Paint = function(self, w, h)
    surface.SetMaterial( backgroundlogo )
    surface.DrawTexturedRect( 0, 0, scrw, scrh )
  end

  local BG3 = vgui.Create( "DPanel", INTRO_PANEL3 )
  BG3:SetSize( ScrW(), ScrH() )
  BG3:SetPos( 0, 0 )
  BG3:SetText( "" )
  BG3.TimeCreate = RealTime()

  BG3.Paint = function(self, w, h)

    if ( input.IsKeyDown( KEY_ESCAPE ) && INTRO_PANEL3.OpenTime < RealTime() - .2 && !FIRSTTIME_MENU ) then

      ShowMainMenu = CurTime() + .1
      gui.HideGameUI()
      INTRO_PANEL3:Remove()
      gui.EnableScreenClicker( false )
      mainmenumusic:Stop()

    end

    local scrw, scrh = ScrW(), ScrH()

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( scp )
    surface.DrawTexturedRect( scrw / 9, scrh / 3.9, 100, 100 )

    draw.SimpleText( "Breach", "MenuHUDFont", scrw / 6, scrh / 3.4, whitealpha, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Created by VAULT Team", "MainMenuFont", scrw / 6, scrh / 3.2, whitealpha, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( "You can find all config commands by typing breach_config_* in console", "MainMenuFont", scrw * 0.1, scrh * 0.93, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

  end

  BG3.OnRemove = function()

    gui.EnableScreenClicker( false )

  end

  local MainMenuPanel3 = vgui.Create( "DPanel", BG3 )
  MainMenuPanel3:SetPos( scrw / 9, scrh / 3.35)
  MainMenuPanel3:SetSize(600, 500)
  MainMenuPanel3:MoveToFront()

  MainMenuPanel3.Paint = function(self, w, h)

    surface.SetDrawColor( 255, 255, 255, 80 )
    surface.SetMaterial( gradients )
    surface.DrawTexturedRect( 32, 44, w / 1.2, 2 )

  end

  local CLOSE222 = vgui.Create( "DButton", MainMenuPanel3 )
  CLOSE222:SetPos( 0, 50 * #BREACH.Options + 50)
  CLOSE222:SetSize( 350, 40 )
  CLOSE222:SetText("")
  CLOSE222:MoveToFront()
  CLOSE222.DoClick = function()

    INTRO_PANEL3:Remove()
    StartBreach(false)
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )

  end

  CLOSE222.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end

  CLOSE222.FadeAlpha = 0

  CLOSE222.Paint = function(self, w, h)

    draw.SimpleText( "Return", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( self:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect(0, 0, w, h )

  end

  for i = 1, #BREACH.Options do
    local button_name = vgui.Create( "DButton", MainMenuPanel3 )
    button_name:SetPos( 0, 50 * i )
    button_name:SetSize( 600, 40 )
    button_name:SetText("")
    button_name:MoveToFront()
    button_name.DoClick = function()
      if IsValid(TEXTENTRY_FRAME) then
        TEXTENTRY_FRAME:Remove()
      end
      TEXTENTRY_FRAME = vgui.Create( "DFrame" )
        TEXTENTRY_FRAME:SetSize(250, 80)
        TEXTENTRY_FRAME:SetPos(scrw / 9 + scrh / 2, scrh / 3.35 + 50 * i - 30)
        TEXTENTRY_FRAME:MakePopup()
        TEXTENTRY_FRAME:SetDraggable(false)
        TEXTENTRY_FRAME:SetTitle(BREACH.Options[i].short_name)
        TEXTENTRY_FRAME.Paint = function(self, w, h)
          draw.RoundedBox(4, 0,0, w, h, Color(70, 70, 70, 100))
        end
      local TextEntry = vgui.Create("DTextEntry", TEXTENTRY_FRAME )
        TextEntry:Dock(TOP)
        TextEntry:SetSize(100, 40)
        TextEntry:SetPlaceholderText("Enter value here...")
        TextEntry:SetUpdateOnType(false)
        TextEntry:SetFont("ChatFont_new")

        TextEntry.AllowInput = function( self, stringValue )
          return false
        end
        TextEntry.OnGetFocus = function(self)
          self:SetValue("")
        end
        TextEntry.OnChange = function(self)
          if !BREACH.Options[i].string_type then
            if tonumber(self:GetValue()) == nil then
              return
            end
          end
          RunConsoleCommand(BREACH.Options[i].cvar, self:GetValue())
        end
    end
  
    button_name.OnCursorEntered = function()
  
      surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )
  
    end
  
    button_name.FadeAlpha = 0
  
    button_name.Paint = function(self, w, h)

      local max = ""
      local bracket = ")"
      if !BREACH.Options[i].string_type then
        max = "/"..GetConVar(BREACH.Options[i].cvar):GetMax()..")"
        bracket = ""
      end

      draw.SimpleText( BREACH.Options[i].name.."(current: "..GetConVar(BREACH.Options[i].cvar):GetString()..bracket..max, "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  
      if ( self:IsHovered() ) then
  
        self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )
  
      else
  
        self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )
  
      end
  
      surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
      surface.SetMaterial( gradient )
      surface.DrawTexturedRect(0, 0, w, h )
  
    end
  end

end

function OpenFactionMenu()

  local ply = LocalPlayer()

  INTRO_PANEL3:Remove()

  gui.EnableScreenClicker( true )

  local scrw, scrh = ScrW(), ScrH()

  local clrgray = Color( 198, 198, 198, 200 )
  local gradient = Material( "vgui/gradient-r" )

  local BREACH =  {}

  local faction_table = {

    [ 1 ] = { name = "Девятихвостая Лиса", icon = Material( "nextoren/gui/roles_icon/ntf.png" ), class_d = "Враг", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник" },
    [ 2 ] = { name = "Повстанцы Хаоса", icon = Material( "nextoren/gui/roles_icon/chaos.png" ), class_d = "Союзник", chaos = "Союзник", gru = "Враг", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Враг", sb = "Враг", mog = "Враг", obr = "Враг", scp = "Враг", ntf = "Враг" },
    [ 3 ] = { name = "Главное Разведывательное Управление", icon = Material( "nextoren/gui/roles_icon/gru.png"), class_d = "Нейтралитет", chaos = "Враг", gru = "Союзник", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Нейтралитет", sb = "Нейтралитет", mog = "Нейтралитет", obr = "Нейтралитет", scp = "Враг", ntf = "Нейтралитет" },
    [ 4 ] = { name = "Длань Змея", icon = Material( "nextoren/gui/roles_icon/dz.png" ), class_d = "Враг", chaos = "Враг", gru = "Враг", dz = "Союзник", uiu = "Враг", goc = "Враг", sci = "Враг", sb = "Враг", mog = "Враг", obr = "Враг", scp = "Союзник", ntf = "Враг" },
    [ 5 ] = { name = "Отдел Необычных Происшествий", icon = Material( "nextoren/gui/roles_icon/fbi.png" ), class_d = "Нейтралитет", chaos = "Враг", gru = "Враг", dz = "Враг", uiu = "Союзник", goc = "Враг", sci = "Нейтралитет", sb = "Враг", mog = "Враг", obr = "Враг", scp = "Враг", ntf = "Враг" },
    [ 6 ] = { name = "Глобальная Оккультная Коалиция", icon = Material( "nextoren/gui/roles_icon/goc.png" ), class_d = "Враг", chaos = "Враг", gru = "Враг", dz = "Враг", uiu = "Враг", goc = "Союзник", sci = "Враг", sb = "Враг", mog = "Враг", obr = "Враг", scp = "Враг", ntf = "Враг" },
    [ 7 ] = { name = "Научный Отдел", icon = Material( "nextoren/gui/roles_icon/sci.png"), class_d = "Нейтралитет", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Нейтралитет", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник" },
    [ 8 ] = { name = "Служба Безопасности", icon = Material( "nextoren/gui/roles_icon/sb.png" ), class_d = "Нейтралитет", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник" },
    [ 9 ] = { name = "Мобильная Оперативная Группа", icon = Material( "nextoren/gui/roles_icon/mtf.png" ), class_d = "Враг", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник" },
    [ 10 ] = { name = "Отряд Быстрого Реагирования", icon = Material( "nextoren/gui/roles_icon/obr.png" ), class_d = "Враг", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник" },
    [ 11 ] = { name = "Персонал Класса-Д", icon = Material( "nextoren/gui/roles_icon/class_d.png"), class_d = "Союзник", chaos = "Союзник", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Нейтралитет", sb = "Нейтралитет", mog = "Враг", obr = "Враг", scp = "Враг", ntf = "Враг" },
    [ 12 ] = { name = "SCP-объекты", icon = Material( "nextoren/gui/roles_icon/scp.png"), class_d = "Враг", chaos = "Враг", gru = "Враг", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Враг", sb = "Враг", mog = "Враг", obr = "Враг", scp = "Союзник", ntf = "Враг" }

  }


	INTRO_PANEL22 = vgui.Create( "DPanel" );
	INTRO_PANEL22:SetSize( scrw, scrh );
	INTRO_PANEL22:SetPos( 0, 0 );
  INTRO_PANEL22.OpenTime = RealTime()
  INTRO_PANEL22.Paint = function(self, w , h)

    draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50) )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end


  end

  local BG22 = vgui.Create( "DPanel", INTRO_PANEL22 )
  BG22:SetSize( ScrW(), ScrH() )
  BG22:SetPos( 0, 0 )
  BG22:SetText( "" )
  BG22.TimeCreate = RealTime()

  BG22.Paint = function(self, w, h)

    if ( input.IsKeyDown( KEY_ESCAPE ) && INTRO_PANEL22.OpenTime < RealTime() - .2 && !FIRSTTIME_MENU ) then
      
      ShowMainMenu = CurTime() + .1
      gui.HideGameUI()
      INTRO_PANEL22:SetVisible( false )
      BREACH.MainPanel22:SetVisible( false )
      BREACH.NameFac:SetVisible( false )
      BREACH.Disclaimer_Fac:SetVisible( false )
      BREACH.Diplomatic:SetVisible( false )
      BREACH.Tasks:SetVisible( false )
      gui.EnableScreenClicker( false )
      mainmenumusic:Stop()

    end

    local scrw, scrh = ScrW(), ScrH()

  end

  BG22.OnRemove = function()

    gui.EnableScreenClicker( false )

  end

  local MainMenuPanel22 = vgui.Create( "DPanel", BG22 )
  MainMenuPanel22:SetPos( scrw / 9, scrh / 3.35)
  MainMenuPanel22:SetSize(350, 1000)
  MainMenuPanel22:MoveToFront()

  MainMenuPanel22.Paint = function(self, w, h)

    draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50) )

  end

  local class_modelpanel23 = vgui.Create( "DPanel", INTRO_PANEL22 )
  class_modelpanel23:SetPos(500, 30)
  class_modelpanel23:SetSize(1000, 1000)
  class_modelpanel23.Paint = function( self, w, h )
    draw.RoundedBox( 0, 250, 0, w / 2, h * 2, Color(50,50,50) )

  end

  BREACH.Disclaimer_Fac = vgui.Create( "DPanel" )
  BREACH.Disclaimer_Fac:SetSize( 256, 64 )
  BREACH.Disclaimer_Fac:SetPos( ScrW() / 2 - 896, ScrH() / 2 - 444 )
  BREACH.Disclaimer_Fac:SetText( "" )

  local client = LocalPlayer()

  BREACH.Disclaimer_Fac.Paint = function( self, w, h )

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

    draw.DrawText( "Фракции", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  end

  BREACH.Diplomatic = vgui.Create( "DPanel" )
  BREACH.Diplomatic:SetSize( 320, 640 )
  BREACH.Diplomatic:SetPos( ScrW() / 2 + 576, ScrH() / 2 - 444 )
  BREACH.Diplomatic:SetText( "" )

  BREACH.Diplomatic.Paint = function( self, w, h )

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

  end

  BREACH.Tasks = vgui.Create( "DPanel" )
  BREACH.Tasks:SetSize( 0, 0 )
  BREACH.Tasks:SetPos( ScrW() / 2 - 70, ScrH() / 2 + 200 )
  BREACH.Tasks:SetText( "" )

  BREACH.MainPanel22 = vgui.Create( "DPanel" )
  BREACH.MainPanel22:SetSize( 256, 768 )
  BREACH.MainPanel22:SetPos( ScrW() / 2 - 896, ScrH() / 2 - 384 )
  BREACH.MainPanel22:SetText( "" )
  BREACH.MainPanel22.DieTime = CurTime() + 10
  BREACH.MainPanel22.Paint = function( self, w, h )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )



  end

  BREACH.ScrollPanel22 = vgui.Create( "DScrollPanel", BREACH.MainPanel22 )
  BREACH.ScrollPanel22:Dock( FILL )

  BREACH.NameFac = vgui.Create( "DPanel" )
  BREACH.NameFac:SetSize( 256, 64 )
  BREACH.NameFac:SetPos( ScrW() / 2 - 70, ScrH() / 2 + 448 )
  BREACH.NameFac:SetText( "" )

  local client = LocalPlayer()

  BREACH.NameFac.Paint = function( self, w, h )

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

    draw.DrawText( "None", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  end


  for i = 1, #faction_table do
    BREACH.Roles22 = BREACH.ScrollPanel22:Add( "DButton" )
    BREACH.Roles22:SetText( "" )
    BREACH.Roles22:Dock( TOP )
    BREACH.Roles22:SetSize( 256, 64 )
    BREACH.Roles22:DockMargin( 0, 0, 0, 2 )
    BREACH.Roles22.CursorOnPanel = false
    BREACH.Roles22.gradientalpha = 0

    BREACH.Roles22.Paint = function( self, w, h )

      if ( self.CursorOnPanel ) then

        self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )

      else

        self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )

      end

      draw.RoundedBox( 0, 0, 0, w, h, color_black )
      draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )

      surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
      surface.SetMaterial( gradient )
      surface.DrawTexturedRect( 0, 0, w, h )

      draw.SimpleText( GetLangRole(faction_table[ i ].name), "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

    BREACH.Roles22.OnCursorEntered = function( self )

      self.CursorOnPanel = true

    end

    BREACH.Roles22.OnCursorExited = function( self )

      self.CursorOnPanel = false

    end

    BREACH.Roles22.DoClick = function()
      surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
      class_modelpanel23.Paint = function( self, w, h )
        draw.RoundedBox( 0, 250, 0, w / 2, h * 2, Color(50,50,50) )

        surface.SetDrawColor( 255,255,255  )
        surface.SetMaterial( faction_table[ i ].icon )
        surface.DrawTexturedRect( ScrW() / 2 - 715, ScrH() / 2 - 384, 512, 512 )
    
      end
      BREACH.NameFac.Paint = function( self, w, h )

        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
        draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
    
        draw.DrawText( faction_table[ i ].name, "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    
      end

      BREACH.Diplomatic.Paint = function( self, w, h )

        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
        draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
    
        draw.DrawText( "Персонал Класс-Д: " .. faction_table[ i ].class_d, "ChatFont_new", w / 2, h / 2 - 300, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Научный Отдел: " .. faction_table[ i ].sci, "ChatFont_new", w / 2, h / 2 - 260, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Служба Безопасности: " .. faction_table[ i ].sb, "ChatFont_new", w / 2, h / 2 - 220, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Мобильная Опергруппа: " .. faction_table[ i ].mog, "ChatFont_new", w / 2, h / 2 - 180, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Девятихвостая Лиса: " .. faction_table[ i ].ntf, "ChatFont_new", w / 2, h / 2 - 140, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Отдел Необычных Происшествий: " .. faction_table[ i ].uiu, "ChatFont_new", w / 2, h / 2 - 100, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Длань Змея: " .. faction_table[ i ].dz, "ChatFont_new", w / 2, h / 2 - 60, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "ГРУ: " .. faction_table[ i ].gru, "ChatFont_new", w / 2, h / 2 - 20, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Повстанцы Хаоса: " .. faction_table[ i ].chaos, "ChatFont_new", w / 2, h / 2 - -20, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Отряд Быстрого Реагирования: " .. faction_table[ i ].obr, "ChatFont_new", w / 2, h / 2 - -60, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "Глобальная Оккультная Коалиция: " .. faction_table[ i ].goc, "ChatFont_new", w / 2, h / 2 - -100, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.DrawText( "SCP-объекты: " .. faction_table[ i ].scp, "ChatFont_new", w / 2, h / 2 - -140, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    
      end

      BREACH.Tasks.Paint = function( self, w, h )

        draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
        draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
    
      end

    end

  end

  local CLOSE_CUSTOM2 = vgui.Create("DButton", MainMenuPanel22)
  CLOSE_CUSTOM2:SetPos(0,650)
  CLOSE_CUSTOM2:SetSize(350,40)
  CLOSE_CUSTOM2:SetText("")
  CLOSE_CUSTOM2.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    INTRO_PANEL22:Remove()
    BREACH.MainPanel22:Remove()
    BREACH.NameFac:Remove()
    BREACH.Disclaimer_Fac:Remove()
    BREACH.Diplomatic:Remove()
    BREACH.Tasks:Remove()
    OpenFAQ()
  end
  CLOSE_CUSTOM2.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end
  CLOSE_CUSTOM2.FadeAlpha = 0
  CLOSE_CUSTOM2.Paint = function( self, w, h )

    draw.SimpleText("Return", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if ( CLOSE_CUSTOM2:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 0,0, w, h )

  end

end

function OpenCustomMenu()

  local ply = LocalPlayer()

  INTRO_PANEL3:Remove()

  gui.EnableScreenClicker( true )

  local scrw, scrh = ScrW(), ScrH()

  local clrgray = Color( 198, 198, 198, 200 )
  local gradient = Material( "vgui/gradient-r" )

  local BREACH = {}

  --[[
  local faction_table = {

    [ 1 ] = { name = ALLCLASSES.security.name, classes = ALLCLASSES.security.roles },
    [ 2 ] = { name = ALLCLASSES.securitys.name, classes = ALLCLASSES.securitys.roles},
    [ 3 ] = { name = ALLCLASSES.researchers.name, classes = ALLCLASSES.researchers.roles },
    [ 4 ] = { name = ALLCLASSES.classds.name, classes = ALLCLASSES.classds.roles },
    [ 5 ] = { name = ALLCLASSES.support.name, classes = ALLCLASSES.support.roles }

  }
  --]]


	INTRO_PANEL2 = vgui.Create( "DPanel" );
	INTRO_PANEL2:SetSize( scrw, scrh );
	INTRO_PANEL2:SetPos( 0, 0 );
  INTRO_PANEL2.OpenTime = RealTime()
  INTRO_PANEL2.Paint = function(self, w , h)

    draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50) )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end


  end

  local BG2 = vgui.Create( "DPanel", INTRO_PANEL2 )
  BG2:SetSize( ScrW(), ScrH() )
  BG2:SetPos( 0, 0 )
  BG2:SetText( "" )
  BG2.TimeCreate = RealTime()

  BG2.Paint = function(self, w, h)

    if ( input.IsKeyDown( KEY_ESCAPE ) && INTRO_PANEL2.OpenTime < RealTime() - .2 && !FIRSTTIME_MENU ) then
      
      ShowMainMenu = CurTime() + .1
      gui.HideGameUI()
      INTRO_PANEL2:SetVisible( false )
      BREACH.MainPanel2:SetVisible( false )
      BREACH.NameRole:SetVisible( false )
      BREACH.Disclaimer:SetVisible( false )
      BREACH.Health:SetVisible( false )
      gui.EnableScreenClicker( false )
      mainmenumusic:Stop()

    end

    local scrw, scrh = ScrW(), ScrH()

  end

  BG2.OnRemove = function()

    gui.EnableScreenClicker( false )

  end

  local MainMenuPanel2 = vgui.Create( "DPanel", BG2 )
  MainMenuPanel2:SetPos( scrw / 9, scrh / 3.35)
  MainMenuPanel2:SetSize(350, 1000)
  MainMenuPanel2:MoveToFront()

  MainMenuPanel2.Paint = function(self, w, h)

    draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50) )

  end

  local class_modelpanel2 = vgui.Create( "DPanel", INTRO_PANEL2 )
  class_modelpanel2:SetPos(500, 30)
  class_modelpanel2:SetSize(1000, 1000)
  class_modelpanel2.Paint = function( self, w, h )
    draw.RoundedBox( 0, 250, 0, w / 2, h * 2, Color(50,50,50) )

  end

  local icon_SPEC2 = vgui.Create( "DModelPanel", class_modelpanel2 )
  icon_SPEC2:SetSize(500,500)
  icon_SPEC2:Dock( FILL )
  icon_SPEC2:SetModel("")
  function icon_SPEC2:LayoutEntity( Entity )
    Entity:SetAngles(Angle(0,45,0))
  end

  local icon_SPEC = vgui.Create( "DModelPanel", class_modelpanel2 )
  icon_SPEC:SetSize(500,500)
  icon_SPEC:Dock( FILL )
  icon_SPEC:SetModel("")
  function icon_SPEC:LayoutEntity( Entity )
    Entity:SetAngles(Angle(0,45,0))
  end

  local icon_SPEC3 = vgui.Create( "DModelPanel", class_modelpanel2 )
  icon_SPEC3:SetSize(500,500)
  icon_SPEC3:Dock( FILL )
  icon_SPEC3:SetModel("")
  function icon_SPEC3:LayoutEntity( Entity )
    Entity:SetAngles(Angle(0,45,0))
  end

  local icon_SPEC4 = vgui.Create( "DModelPanel", class_modelpanel2 )
  icon_SPEC4:SetSize(500,500)
  icon_SPEC4:Dock( FILL )
  icon_SPEC4:SetModel("")
  function icon_SPEC4:LayoutEntity( Entity )
    Entity:SetAngles(Angle(0,45,0))
  end

  local icon_SPEC5 = vgui.Create( "DModelPanel", class_modelpanel2 )
  icon_SPEC5:SetSize(500,500)
  icon_SPEC5:Dock( FILL )
  icon_SPEC5:SetModel("")
  function icon_SPEC5:LayoutEntity( Entity )
    Entity:SetAngles(Angle(0,45,0))
  end

  BREACH.Disclaimer = vgui.Create( "DPanel" )
  BREACH.Disclaimer:SetSize( 256, 64 )
  BREACH.Disclaimer:SetPos( ScrW() / 2 - 896, ScrH() / 2 - 444 )
  BREACH.Disclaimer:SetText( "" )

  local client = LocalPlayer()

  BREACH.Disclaimer.Paint = function( self, w, h )

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

    draw.DrawText( "Роли", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  end

  BREACH.Health = vgui.Create( "DPanel" )
  BREACH.Health:SetSize( 256, 96 )
  BREACH.Health:SetPos( ScrW() / 2 + 640, ScrH() / 2 - 444 )
  BREACH.Health:SetText( "" )

  BREACH.Health.Paint = function( self, w, h )

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

  end

  BREACH.MainPanel2 = vgui.Create( "DPanel" )
  BREACH.MainPanel2:SetSize( 256, 768 )
  BREACH.MainPanel2:SetPos( ScrW() / 2 - 896, ScrH() / 2 - 384 )
  BREACH.MainPanel2:SetText( "" )
  BREACH.MainPanel2.DieTime = CurTime() + 10
  BREACH.MainPanel2.Paint = function( self, w, h )

    if ( !vgui.CursorVisible() ) then

      gui.EnableScreenClicker( true )

    end

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )



  end

  BREACH.ScrollPanel2 = vgui.Create( "DScrollPanel", BREACH.MainPanel2 )
  BREACH.ScrollPanel2:Dock( FILL )

  BREACH.NameRole = vgui.Create( "DPanel" )
  BREACH.NameRole:SetSize( 256, 64 )
  BREACH.NameRole:SetPos( ScrW() / 2 - 70, ScrH() / 2 + 448 )
  BREACH.NameRole:SetText( "" )

  local client = LocalPlayer()

  BREACH.NameRole.Paint = function( self, w, h )

    draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
    draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

    draw.DrawText( "None", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  end


  for k,v in pairs(ALLCLASSES) do
    for a,b in ipairs(v) do
      for i, cls in ipairs(b.roles) do
      BREACH.Roles2 = BREACH.ScrollPanel2:Add( "DButton" )
      BREACH.Roles2:SetText( "" )
      BREACH.Roles2:Dock( TOP )
      BREACH.Roles2:SetSize( 256, 64 )
      BREACH.Roles2:DockMargin( 0, 0, 0, 2 )
      BREACH.Roles2.CursorOnPanel = false
      BREACH.Roles2.gradientalpha = 0
  
      BREACH.Roles2.Paint = function( self, w, h )
  
        if ( self.CursorOnPanel ) then
  
          self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 64 )
  
        else
  
          self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 128 )
  
        end
  
        draw.RoundedBox( 0, 0, 0, w, h, color_black )
        draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )
  
        surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
        surface.SetMaterial( gradient )
        surface.DrawTexturedRect( 0, 0, w, h )
  
        draw.SimpleText( GetLangRole(cls.name), "ChatFont_new", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
      end
  
      BREACH.Roles2.OnCursorEntered = function( self )
  
        self.CursorOnPanel = true
  
      end
  
      BREACH.Roles2.OnCursorExited = function( self )
  
        self.CursorOnPanel = false
  
      end
  
      BREACH.Roles2.DoClick = function()
      surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
        BREACH.NameRole.Paint = function( self, w, h )
      
          draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
          draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
      
          draw.DrawText( GetLangRole(cls.name), "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          draw.DrawText( cls.team_name, "ChatFont_new", w / 2, h / 2 - 0, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      
        end

        BREACH.Health.Paint = function( self, w, h )

          draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
          draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )

          draw.DrawText( "Здоровье: " .. cls.health, "ChatFont_new", w / 2, h / 2 - 24, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.DrawText( "Скорость: " .. cls.runspeed, "ChatFont_new", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.DrawText( "Сила Прыжка: " .. cls.jumppower, "ChatFont_new", w / 2, h / 2 + 24, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          
        end

        class_modelpanel2.Paint = function( self, w, h )
          draw.RoundedBox( 0, 250, 0, w / 2, h * 2, Color(50,50,50) )
          local faction_icon 
          if cls.team == TEAM_NTF then
            faction_icon = Material( "nextoren/gui/roles_icon/ntf.png" )
          elseif cls.team == TEAM_GRU then
            faction_icon = Material( "nextoren/gui/roles_icon/gru.png" )
          elseif cls.team == TEAM_CHAOS then
            faction_icon = Material( "nextoren/gui/roles_icon/chaos.png" )
          elseif cls.team == TEAM_GOC then
            faction_icon = Material( "nextoren/gui/roles_icon/goc.png" )
          elseif cls.team == TEAM_UIU then
            faction_icon = Material( "nextoren/gui/roles_icon/fbi.png" )
          elseif cls.team == TEAM_DZ then
            faction_icon = Material( "nextoren/gui/roles_icon/dz.png" )
          elseif cls.team == TEAM_SCI then
            faction_icon = Material( "nextoren/gui/roles_icon/sci.png" )
          elseif cls.team == TEAM_SECURITY then
            faction_icon = Material( "nextoren/gui/roles_icon/sb.png" )
          elseif cls.team == TEAM_CLASSD then
            faction_icon = Material( "nextoren/gui/roles_icon/class_d.png" )
          elseif cls.team == TEAM_GUARD then
            faction_icon = Material( "nextoren/gui/roles_icon/mtf.png" )
          elseif cls.team == TEAM_QRT then
            faction_icon = Material( "nextoren/gui/roles_icon/obr.png" )
          end
      
          surface.SetDrawColor( 255,255,255  )
          surface.SetMaterial( faction_icon )
          surface.DrawTexturedRect( ScrW() / 2 - 715, ScrH() / 2 - 384, 512, 512 )
      
        end

        if cls.head != nil then
         icon_SPEC2:SetModel( cls.head ) 
        elseif cls.head == nil then
          icon_SPEC2:SetModel("")
        end

        if cls.headgear != nil then
          icon_SPEC3:SetModel( cls.headgear ) 
        elseif cls.headgear == nil then
          icon_SPEC3:SetModel("")
        end

        if cls.hackerhat != nil then
          icon_SPEC5:SetModel( cls.hackerhat ) 
        elseif cls.hackerhat == nil then
          icon_SPEC5:SetModel("")
        end

        if cls.headgearrandom != nil then
          icon_SPEC4:SetModel( table.Random(cls.headgearrandom) ) 
        elseif cls.headgearrandom == nil then
          icon_SPEC4:SetModel("")
        end
  
        if cls.models != nil then
          icon_SPEC:SetModel( table.Random(cls.models) ) 
        elseif cls.models == nil then
          icon_SPEC:SetModel("")
        end

        function icon_SPEC:LayoutEntity( Entity )
          Entity:SetAngles(Angle(0,45,0))
          if cls.bodygroup0 != nil then
            Entity:SetBodygroup( 0, cls.bodygroup0)
          end
          if cls.bodygroup1 != nil then
            Entity:SetBodygroup( 1, cls.bodygroup1)
          end
          if cls.bodygroup2 != nil then
            Entity:SetBodygroup( 2, cls.bodygroup2)
          end
          if  cls.bodygroup3 != nil then
            Entity:SetBodygroup( 3, cls.bodygroup3)
          end
          if cls.bodygroup4 != nil then
            Entity:SetBodygroup( 4, cls.bodygroup4)
          end
          if cls.bodygroup5 != nil then
            Entity:SetBodygroup( 5, cls.bodygroup5)
          end
          if  cls.bodygroup6 != nil then
            Entity:SetBodygroup( 6, cls.bodygroup6)
          end
          if cls.bodygroup7 != nil then
            Entity:SetBodygroup( 7, cls.bodygroup7)
          end
          if  cls.bodygroup8 != nil then
            Entity:SetBodygroup( 8, cls.bodygroup8)
          end
          if cls.bodygroup9 != nil then
            Entity:SetBodygroup( 9, cls.bodygroup9)
          end
          if cls.bodygroup10 != nil then
            Entity:SetBodygroup( 10, cls.bodygroup10)
          end
          if cls.bodygroup11 != nil then
            Entity:SetBodygroup( 11, cls.bodygroup11)
          end
          if cls.bodygroup12 != nil then
            Entity:SetBodygroup( 12, cls.bodygroup12)
          end
          if cls.bodygroup13 != nil then
            Entity:SetBodygroup( 13, cls.bodygroup13)
          end
          if cls.skin != nil then
            Entity:SetSkin( cls.skin )
          end

        end
  
      end
    end
  end
  end


  local CLOSE_CUSTOM = vgui.Create("DButton", MainMenuPanel2)
  CLOSE_CUSTOM:SetPos(0,650)
  CLOSE_CUSTOM:SetSize(350,40)
  CLOSE_CUSTOM:SetText("")
  CLOSE_CUSTOM.DoClick = function()
    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    INTRO_PANEL2:Remove()
    BREACH.MainPanel2:Remove()
    BREACH.NameRole:Remove()
    BREACH.Disclaimer:Remove()
    BREACH.Health:Remove()
    OpenFAQ()
  end
  CLOSE_CUSTOM.OnCursorEntered = function()

    surface.PlaySound( "nextoren/gui/main_menu/cursorentered_1.wav" )

  end
  CLOSE_CUSTOM.FadeAlpha = 0
  CLOSE_CUSTOM.Paint = function( self, w, h )

    draw.SimpleText("Return", "MainMenuFont", 75, h / 2, clr1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if ( CLOSE_CUSTOM:IsHovered() ) then

      self.FadeAlpha = math.Approach( self.FadeAlpha, 255, RealFrameTime() * 256 )

    else

      self.FadeAlpha = math.Approach( self.FadeAlpha, 0, RealFrameTime() * 512 )

    end

    surface.SetDrawColor( 138, 138, 138, self.FadeAlpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 0,0, w, h )

  end
  
end

function GM:PreRender()

  local ply = LocalPlayer()

  if IsValid(INTRO_PANEL) && !gui.IsGameUIVisible() then INTRO_PANEL:MakePopup() end

  if ( input.IsKeyDown( KEY_ESCAPE ) && gui.IsGameUIVisible()  ) then
    if ( isnumber( ShowMainMenu ) ) then

      gui.HideGameUI()
        if ( ShowMainMenu < CurTime() ) then

          ShowMainMenu = false

        end

        return
    end

    if ( !ShowMainMenu ) then

      gui.HideGameUI()

      if ( INTRO_PANEL && INTRO_PANEL:IsValid() ) then

        INTRO_PANEL.OpenTime = RealTime()
        INTRO_PANEL:SetVisible( true )
        ShowMainMenu = true
        mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
    mainmenumusic:Play()

      else

        StartBreach(false) -- syka
        ShowMainMenu = true
        mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
    mainmenumusic:Play()

      end

    end

  end

end
