--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/gamemode/modules/cl_rolemenu.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

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
local blur = Material("pp/blurscreen")

surface.CreateFont( "JuneFont", {

	font = "Junegull",
	size = 16,
	weight = 500,
	antialias = true,
	  extended = true,
	shadow = false,
	outline = false
  
})

ROLEMENU = {}

local faction_switched = nil

function DrawBlurPanel( panel, amount, heavyness )

  local x, y = panel:LocalToScreen( 0, 0 )
  local scrW, scrH = ScrW(), ScrH()
  surface.SetDrawColor( 255, 255, 255 )
  surface.SetMaterial(blur)

  for i = 1, ( heavyness || 3 ) do

    blur:SetFloat( "$blur", ( i / 3 ) * ( amount || 6 ) )
    blur:Recompute()
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )

  end

end
BREACH = BREACH || {}

local cdforuse_role = 0
local cdforuse_roletime = 0.2

function OpenClassMenu()
if LocalPlayer():GTeam() != TEAM_SPEC then
	RXSENDWarning("Вы можете открывать меню ролей только в режиме наблюдателя.")
	return
end
	local client = LocalPlayer()

	if ( cdforuse_role > CurTime() ) then return end

	local mat_precache = Material( "nextoren/gui/roles_icon/mtf.png" )

    local gradient_down = Material( "gui/gradient_up" )

    local clr_red = Color( 255, 0, 0, 180 )
    local clr_gray = Color( 198, 198, 198, 180 )
    local clr_gray_noalpha = Color( 198, 198, 198 )
    local clr_white_gray = Color( 210, 210, 210 )
    local clr_whiter = Color( 222, 222, 222 )

	local clr_green = Color( 170, 170, 170 )
    local clr_green_blue = Color( 0, 255, 255 )

    local eye_offset = Vector( 2, 0, 2 )
    local pos_offset = Vector( -13, 0, 0 )

	local function drawMultiLine(text, font, mWidth, spacing, x, y, color, alignX, alignY, oWidth, oColor)
		local function toLines(text, font, mWidth)
			surface.SetFont(font)
			
			local buffer = { }
			local nLines = { }
		
			for word in string.gmatch(text, "%S+") do
				local w,h = surface.GetTextSize(table.concat(buffer, " ").." "..word)
				if w > mWidth then
					table.insert(nLines, table.concat(buffer, " "))
					buffer = { }
				end
				table.insert(buffer, word)
			end
				
			if #buffer > 0 then -- If still words to add.
				table.insert(nLines, table.concat(buffer, " "))
			end
			
			return nLines
		end
		
		local mLines = toLines(text, font, mWidth)
	
		for i,line in pairs(mLines) do
			if oWidth and oColor then
				draw.SimpleTextOutlined(line, font, x, y + (i - 1) * spacing, color, alignX, alignY, oWidth, oColor)
			else
				draw.SimpleText(line, font, x, y + (i - 1) * spacing, color, alignX, alignY)
			end
		end
			
		return (#mLines - 1) * spacing
		-- return #mLines * spacing
	end

	local mat_head = Material( "nextoren/gui/f2_menu/3.png" )
    local mat_body = Material( "nextoren/gui/f2_menu/2.png" )
    local mat_bottom = Material( "nextoren/gui/f2_menu/1.png" )

	local gradient = Material("vgui/gradient-r")
	
	local weight, height = ScrW(), ScrH()
	local dividedw, dividedh = weight / 2, height / 2
	
	gui.EnableScreenClicker( true )

	ROLEMENU.enabled = true
	
	BREACH.RoleMenu = vgui.Create( "DPanel" )
	BREACH.RoleMenu:SetSize( 960, 702 )
	BREACH.RoleMenu:SetPos( dividedw - 480, dividedh - 351 - 32 )
	BREACH.RoleMenu:SetText( "" )
	BREACH.RoleMenu.OnRemove = function()
	
		if ( vgui.CursorVisible() ) then
	
		  gui.EnableScreenClicker( false )
	
		end
	
	end
	
	BREACH.RoleMenu.Paint = function( self, w, h )
	
		if ( !vgui.CursorVisible() ) then
	
		  gui.EnableScreenClicker( true )
	
		end
	
		draw.RoundedBox( 0, 0, 0, w, h, color_black )
	
	end
	local menuw, menuh = BREACH.RoleMenu:GetSize()

	BREACH.FactionInformation = vgui.Create( "DPanel", BREACH.RoleMenu )
	BREACH.FactionInformation:SetPos( menuw * .25, 0 )
	BREACH.FactionInformation:SetSize( menuw * .75, 702 )
	BREACH.FactionInformation:SetText( "" )
  
	BREACH.FactionInformation.MatIcon = Material( "nextoren/gui/roles_icon/scp.png" )
  
	BREACH.FactionInformation.Paint = function( self, w, h )
  
	  draw.RoundedBox( 0, 0, 0, w, h, clr_gray )
  
	  surface.SetDrawColor( color_white )
	  surface.SetMaterial( self.MatIcon )
	  surface.DrawTexturedRect( w / 2 - 48, 32, 96, 96 )
  
	end
  
	local inf_menu_width, inf_menu_height = BREACH.FactionInformation:GetSize()

	BREACH.FactionInformation.Desc = vgui.Create( "DPanel", BREACH.FactionInformation )
	BREACH.FactionInformation.Desc:SetSize( inf_menu_width, inf_menu_height * .5 )
	BREACH.FactionInformation.Desc:SetPos( 0, inf_menu_height * .25 )
	BREACH.FactionInformation.Desc:SetText( "" )
	BREACH.FactionInformation.Desc.Paint = function( self, w, h )
  
	  surface.SetDrawColor( color_white )
	  surface.SetMaterial( mat_body )
	  surface.DrawTexturedRect( 0, 0, w, h )

  
		draw.SimpleText( "Выберите фракцию из предоставленного слева списка.", "ChatFont_new", w / 2, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
  
	end
  
	BREACH.FactionInformation.Desc.Title = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
	BREACH.FactionInformation.Desc.Title:SetPos( inf_menu_width * .5, 8 )
	BREACH.FactionInformation.Desc.Title:SetSize( 24, 24 )
	BREACH.FactionInformation.Desc.Title.Paint = function( self, w, h )
  
  
		surface.SetFont( "ChatFont_new" )
  
		local n_w, n_h = surface.GetTextSize( "" )
  
		self:SetSize( n_w, n_h )
		self:SetPos( inf_menu_width * .5 - n_w / 2, 8 )
  
		draw.SimpleText( "", "ChatFont_new", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
		draw.RoundedBox( 0, 0, h - 2, w, 2, color_black )
  
  
	end

	BREACH.FactionInformation.Roles = vgui.Create( "DPanel", BREACH.FactionInformation )
    BREACH.FactionInformation.Roles:SetSize( inf_menu_width, inf_menu_height * .26 )
    BREACH.FactionInformation.Roles:SetPos( 0, inf_menu_height * .75 )
    BREACH.FactionInformation.Roles:SetText( "" )
    BREACH.FactionInformation.Roles.Paint = function( self, w, h )

     draw.RoundedBox( 0, 0, 0, w, h, clr_gray_noalpha )
     draw.OutlinedBox( 0, 0, w, 2, 2, color_black )
     surface.SetDrawColor( color_white )
     surface.SetMaterial( mat_bottom )
     surface.DrawTexturedRect( 0, 0, w, h )

    end

	BREACH.FactionInformation.Head = vgui.Create( "DPanel", BREACH.FactionInformation )
    BREACH.FactionInformation.Head:SetSize( inf_menu_width, inf_menu_height * .25 )
    BREACH.FactionInformation.Head:SetText( "" )

    BREACH.FactionInformation.Head.Paint = function( self, w, h )

     draw.RoundedBox( 0, 0, 0, w, h, clr_green_blue )

     surface.SetDrawColor( color_white )
     surface.SetMaterial( mat_head )
     surface.DrawTexturedRect( 0, 0, w, h )

    end 
	local faction_table = {

		[ 1 ] = { name = "Support", icon = "nextoren/gui/roles_icon/ntf.png", roles = ALLCLASSES.support, class_d = "Враг", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник", Desc = "Мобильная опергруппа Эпсилон-11 занимается внутренней безопасностью Фонда SCP. Они представляют собой специальную оперативную группу, развернутую в передах учреждения фонда в случае сбоя стандартных протоколов и неизбежных многочисленных нарушений. Таким образом, большинство их операций классифицируются как Восстановления условий содержания." },
		[ 2 ] = { name = clang.SCI, icon = "nextoren/gui/roles_icon/sci.png", roles = ALLCLASSES.researchers, class_d = "Нейтралитет", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Нейтралитет", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник", Desc = "Персонал фонда – это люди, работающие в учреждении на гражданских должностях, от научного персонала, до простого уборщика, в большинстве своем это обычные люди нанятые фондом, хотя бывают и исключения. Старшие научные сотрудники выделяются на их плане. Это наиболее опытные члены персонала, которые проработали в фонде долгое время." },
		[ 3 ] = { name = clang.SCI_SPECIAL, icon = "nextoren/gui/roles_icon/sci_special.png", roles = ALLCLASSES.special, class_d = "Нейтралитет", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Нейтралитет", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник", Desc = "Персонал фонда – это люди, работающие в учреждении на гражданских должностях, от научного персонала, до простого уборщика, в большинстве своем это обычные люди нанятые фондом, хотя бывают и исключения. Старшие научные сотрудники выделяются на их плане. Это наиболее опытные члены персонала, которые проработали в фонде долгое время." },
	--	[ 4 ] = { name = clang.SECURITY, icon = "nextoren/gui/roles_icon/sb.png", roles = ALLCLASSES.SECURITY, class_d = "Нейтралитет", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник", Desc = "Служба Безопасности - подразделение, отвечающие за охрану и защиту всех учреждений и SCP-объектов Фонда независимо от их приоритета. Сотрудники СБ натренированы и обучены действовать в условиях нарушения условий содержания SCP-объектов, а также в случае вторжения. Они выступают в роли охраны для персонала не столько от опасных объектов, сколько от них самих." },
		[ 4 ] = { name = clang.MTF, icon = "nextoren/gui/roles_icon/mtf.png", roles = ALLCLASSES.security, class_d = "Враг", chaos = "Враг", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Союзник", sb = "Союзник", mog = "Союзник", obr = "Союзник", scp = "Враг", ntf = "Союзник", Desc = "Мобильные оперативные группы представляют собой небольшие, специализирующиеся на выполнении определенных задач или занимающиеся особыми ситуациями, военные подразделения. В их основные задачи входит восстановление условий содержания SCP-объектов и эвакуация персонала фонда, хотя существуют и более специализированные подразделения." },
		[ 5 ] = { name = clang.ClassD, icon = "nextoren/gui/roles_icon/class_d.png", roles = ALLCLASSES.classds, class_d = "Союзник", chaos = "Союзник", gru = "Нейтралитет", dz = "Враг", uiu = "Враг", goc = "Враг", sci = "Нейтралитет", sb = "Нейтралитет", mog = "Враг", obr = "Враг", scp = "Враг", ntf = "Враг", Desc = "Персонал класса-Д является специализированной категорией персонала, предназначенной для работ с опасными аномалиями. Сотрудники класса D обычно набираются из заключённых, предпочтение отдается осужденным за насильственные преступления и особенно приговоренным к смертной казни. В случае возникновения в учреждении катастрофического события, все сотрудники класса D подлежат немедленному уничтожению, если только местная служба безопасности не примет иное решение." },
		[ 6 ] = { name = "SCP", icon = "nextoren/gui/roles_icon/scp.png", roles = ALLCLASSES.scps, class_d = "Враг", chaos = "Враг", gru = "Враг", dz = "Союзник", uiu = "Враг", goc = "Враг", sci = "Враг", sb = "Враг", mog = "Враг", obr = "Враг", scp = "Союзник", ntf = "Враг", Desc = "SCP Объекты – это аномалии, которые фонд смог захватить, удержать и классифицировать. они представляют угрозу для человечества, и поэтому Фонд отлавливает их по всему миру, и пытается содержать их в наиболее подходящих условиях, но так как многие одушевленные SCP агрессивны, они стремятся вырваться на свободу" }
	
	}

	for i = 1, #faction_table do

	    local faction_tbl = faction_table[ i ]

	    if ( faction_tbl.roles ) then

	      table.SortByMember( faction_tbl.roles, "level", true )

	    end

	end
  
	BREACH.NameFac = vgui.Create( "DPanel", BREACH.RoleMenu )
	BREACH.NameFac:SetSize( 240, 64 )
	BREACH.NameFac:SetPos( 0, 0 )
	BREACH.NameFac:SetText( "" )
  
	local client = LocalPlayer()
  
	BREACH.NameFac.Paint = function( self, w, h )
  
	  draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
	  draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
  
	  draw.DrawText( "Фракции", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
	end
	BREACH.FactionsSelector = vgui.Create( "DPanel", BREACH.RoleMenu )
    BREACH.FactionsSelector:SetText( "" )
    BREACH.FactionsSelector:SetSize( menuw / 4, menuh )
    BREACH.FactionsSelector.CurrentTeamID = -1
    BREACH.FactionsSelector.Paint = function( self, w, h )

      draw.RoundedBox( 0, 0, 0, w, h, color_black )
      draw.OutlinedBox( 0, 0, w, h, 4, color_white )
      draw.RoundedBox( 0, 0, menuh * .995, w, menuh * .99, color_white )

    end

	local model_pos_x = 110
	local model_pos_y = 90
	local model_fov = 90
	
	local class_modelpanel2 = vgui.Create( "DPanel", BREACH.RoleMenu )
    class_modelpanel2:SetPos(model_pos_x + 450, model_pos_y - 50)
    class_modelpanel2:SetSize(100, 100)
	class_modelpanel2.Paint = function( self, w, h )

    end

	local faction_title = vgui.Create( "DPanel", BREACH.RoleMenu )
    faction_title:SetPos(model_pos_x + 250, model_pos_y - 10)
    faction_title:SetSize(500, 100)
	faction_title.Paint = function( self, w, h )

    end

	local icon_SPEC2 = vgui.Create( "DModelPanel", BREACH.RoleMenu )
    icon_SPEC2:SetSize(500,400)
	icon_SPEC2:SetPos(model_pos_x, model_pos_y + 50)
	icon_SPEC2:SetFOV( model_fov )
    icon_SPEC2:SetModel("")
    function icon_SPEC2:LayoutEntity( Entity )
        Entity:SetAngles(Angle(0,45,0))
    end

    local icon_SPEC = vgui.Create( "DModelPanel", BREACH.RoleMenu )
    icon_SPEC:SetSize(500,400)
	icon_SPEC:SetPos(model_pos_x, model_pos_y + 50)
	icon_SPEC:SetFOV( model_fov )
    icon_SPEC:SetModel("")
	icon_SPEC:SetAnimated(false)
    function icon_SPEC:LayoutEntity( Entity )
        Entity:SetAngles(Angle(0,45,0))

    end

    local icon_SPEC3 = vgui.Create( "DModelPanel", BREACH.RoleMenu )
    icon_SPEC3:SetSize(500,400)
	icon_SPEC3:SetPos(model_pos_x, model_pos_y + 50)
	icon_SPEC3:SetFOV( model_fov )
    icon_SPEC3:SetModel("")
    function icon_SPEC3:LayoutEntity( Entity )
        Entity:SetAngles(Angle(0,45,0))
    end

    local icon_SPEC4 = vgui.Create( "DModelPanel", BREACH.RoleMenu )
    icon_SPEC4:SetSize(500,400)
	icon_SPEC4:SetPos(model_pos_x, model_pos_y + 50)
	icon_SPEC4:SetFOV( model_fov )
    icon_SPEC4:SetModel("")
    function icon_SPEC4:LayoutEntity( Entity )
        Entity:SetAngles(Angle(0,45,0))
    end

    local icon_SPEC5 = vgui.Create( "DModelPanel", BREACH.RoleMenu )
    icon_SPEC5:SetSize(500,400)
	icon_SPEC5:SetPos(model_pos_x, model_pos_y + 50)
	icon_SPEC5:SetFOV( model_fov )
    icon_SPEC5:SetModel("")
    function icon_SPEC5:LayoutEntity( Entity )
        Entity:SetAngles(Angle(0,45,0))
    end
	
	BREACH.FactionsSelector.ActualWindow = vgui.Create( "DPanel", BREACH.RoleMenu )
    BREACH.FactionsSelector.ActualWindow:SetText( "" )
    BREACH.FactionsSelector.ActualWindow:SetPos( 0, 4 )
    BREACH.FactionsSelector.ActualWindow:SetSize( menuw / 4, menuh * .99 )
    BREACH.FactionsSelector.ActualWindow.Paint = function() end

    BREACH.FactionsSelector.Scroller = vgui.Create( "DScrollPanel", BREACH.FactionsSelector.ActualWindow )
    BREACH.FactionsSelector.Scroller:Dock( FILL )
    local sbar = BREACH.FactionsSelector.Scroller:GetVBar()
    function sbar:Paint() end
    function sbar.btnGrip:Paint() end
    function sbar.btnDown:Paint() end
    function sbar.btnUp:Paint() end

	local sizew = ( menuw / 4 ) * .4 - 5
    local offset = 0

	BREACH.FactionsSelector.Button = {}

    for i = 1, #faction_table do

		BREACH.FactionInformation.Desc.PlayerDescModel = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
		BREACH.FactionInformation.Desc.PlayerDescModel:SetText( "" )
		BREACH.FactionInformation.Desc.PlayerDescModel:SetPos( inf_menu_width * .4, 16 )
		BREACH.FactionInformation.Desc.PlayerDescModel:SetSize( inf_menu_width / 2, inf_menu_height / 4 )
		BREACH.FactionInformation.Desc.PlayerDescModel.Box1x = ( inf_menu_width / 2 ) / 2
		BREACH.FactionInformation.Desc.PlayerDescModel.Box2x = ( inf_menu_width / 2 ) / 2
		BREACH.FactionInformation.Desc.PlayerDescModel.icon_Alpha = 0
		BREACH.FactionInformation.Desc.PlayerDescModel.desc_Alpha = 0
  
		BREACH.FactionInformation.Desc.PlayerDescModel.TimeCreation = RealTime()

  
		mat_precache = Material( faction_table[ i ].icon )
  
		BREACH.FactionInformation.Desc.PlayerDescModel.Paint = function( self, w, h )
  
		end

		BREACH.FactionInformation.Desc.PlayerStatistics = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
        BREACH.FactionInformation.Desc.PlayerStatistics:SetText( "" )
        BREACH.FactionInformation.Desc.PlayerStatistics:SetPos( inf_menu_width * .4, inf_menu_height / 4 + 32 )
        BREACH.FactionInformation.Desc.PlayerStatistics:SetSize( inf_menu_width / 2, inf_menu_height / 6 )
        BREACH.FactionInformation.Desc.PlayerStatistics.Box1y = ( inf_menu_height / 6 ) / 2 - 16
        BREACH.FactionInformation.Desc.PlayerStatistics.Box2y = ( inf_menu_height / 6 ) / 2
        BREACH.FactionInformation.Desc.PlayerStatistics.TextAlpha = 0

        BREACH.FactionInformation.Desc.PlayerStatistics.Paint = function( self, w, h )

        end

     BREACH.FactionsSelector.Button[ i ] = BREACH.FactionsSelector.Scroller:Add( "DImageButton", BREACH.FactionsSelector )
     local button = BREACH.FactionsSelector.Button[ i ]
     button:SetSize( sizew, 96 )
     button:SetImage( faction_table[ i ].icon )

        if ( ( i - 1 ) % 2 == 0 && ( i - 1 ) > 0 ) then

         offset = 110 * ( ( i - 1 ) / 2 )

        end

     button:SetPos( 18 + ( sizew * ( ( i - 1 ) % 2 ) ) * 1.2, 16 + offset )
     button:SetText( "" )
     button.AlphaClr = 0
        button.Paint = function( self, w, h )

            if ( self:IsHovered() || ( BREACH.FactionsSelector.CurrentTeamID || false ) == i ) then

             button.AlphaClr = math.Approach( button.AlphaClr, 180, FrameTime() * 256 )

            elseif ( button.AlphaClr > 0 && !self:IsHovered() ) then

             button.AlphaClr = math.Approach( button.AlphaClr, 0, FrameTime() * 512 )

            end

          surface.SetDrawColor( ColorAlpha( color_white, button.AlphaClr ) )
          surface.SetMaterial( gradient_down )
          surface.DrawTexturedRect( 0, 0, w, h )

        end

		

        button.DoClick = function()
			faction_switched = true
			timer.Simple( 0.1 , function()
			    faction_switched = false
			end)

			
			if ( BREACH.FactionInformation.Roles.ActualMenu ) then
				BREACH.FactionInformation.Roles.ActualMenu:Remove()
			end



			BREACH.FactionInformation.Desc.Paint = function( self, w, h )
  
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_body )
				surface.DrawTexturedRect( 0, 0, w, h )
		  
		  
				drawMultiLine( faction_table[ i ].Desc, "JuneFont", w / 1.5, 18, 64, 32, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			
			end
			class_modelpanel2.Paint = function( self, w, h )
				surface.SetDrawColor( 255,255,255  )
				surface.SetMaterial( Material(faction_table[ i ].icon) )
				surface.DrawTexturedRect( 0, 0, 100, 100 )
			end
			faction_title.Paint = function( self, w, h )
				draw.SimpleText( faction_table[ i ].name, "JuneFont", w / 2, h / 1.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			BREACH.FactionInformation.Roles.ActualMenu = vgui.Create( "DPanel", BREACH.FactionInformation.Roles )
            BREACH.FactionInformation.Roles.ActualMenu:SetText( "" )
            BREACH.FactionInformation.Roles.ActualMenu:SetSize( inf_menu_width, inf_menu_height * .23  )
            BREACH.FactionInformation.Roles.ActualMenu.Paint = function( self, w, h ) end

            BREACH.FactionInformation.Roles.Scroller = vgui.Create( "DScrollPanel", BREACH.FactionInformation.Roles.ActualMenu )
            BREACH.FactionInformation.Roles.Scroller:Dock( FILL )
            local sbar = BREACH.FactionInformation.Roles.Scroller:GetVBar()
            function sbar:Paint( w, h ) end
            function sbar.btnGrip:Paint( w, h )

                draw.RoundedBoxEx( 4, 0, 0, 8, h, clr_gray_noalpha, true, true, true, true )

            end
            function sbar.btnDown:Paint( w, h ) end
            function sbar.btnUp:Paint( w, h ) end

            local y_offset = 0
            local x_offset = 0
			if faction_table[ i ].roles != nil then
				for k, v in pairs( faction_table[ i ].roles ) do
					


					for i,cls in ipairs(v) do
						local randomcount = 8
						if cls["white"] == true then randomcount = 6 end
						local headtext = "models/all_scp_models/shared/heads/head_1_"..tostring(math.random(1, randomcount))
						local HeadModel = istable(cls["head"]) and table.Random(cls["head"]) or cls["head"]
						local isblack = false
						if headtext == "models/all_scp_models/shared/heads/head_1_7" or headtext == "models/all_scp_models/shared/heads/head_1_8" then isblack = true end
						if ( 16 + 90 * ( i - 1 ) > inf_menu_width * .8 ) then
	
							x_offset = x_offset + 1
							y_offset = 1.1
					  
						end
					  
						BREACH.FactionInformation.Roles.RoleIcon = BREACH.FactionInformation.Roles.Scroller:Add( "DPanel", BREACH.FactionInformation.Roles )
						BREACH.FactionInformation.Roles.RoleIcon:SetText( "" )
					  
						if ( y_offset <= 0 ) then
					  
							BREACH.FactionInformation.Roles.RoleIcon:SetPos( 16 + 90 * ( i - 1 ), 16 )
					  
						else
					  
							BREACH.FactionInformation.Roles.RoleIcon:SetPos( 16 + 90 * ( x_offset - 1 ), 16 + ( 80 * y_offset ) )
					  
						end
					  
						BREACH.FactionInformation.Roles.RoleIcon:SetSize( 80, 80 )
						BREACH.FactionInformation.Roles.RoleIcon.Paint = function( self, w, h )
					  
							draw.RoundedBox( 0, 0, 0, w, h, clr_gray )
					  
						end
					  
						local player_level = LocalPlayer():GetNLevel()
					  
						local role_level = cls["level"]
					  
						head_mdl = vgui.Create( "DModelPanel", BREACH.FactionInformation.Roles.RoleIcon )
						head_mdl:SetSize( 80, 80 )
						head_mdl.LayoutEntity = function( ent )
						end
	
						headgear_mdl = vgui.Create( "DModelPanel", BREACH.FactionInformation.Roles.RoleIcon )
						headgear_mdl:SetSize( 80, 80 )
						headgear_mdl.LayoutEntity = function( ent )
						end
	
						hacker_hat = vgui.Create( "DModelPanel", BREACH.FactionInformation.Roles.RoleIcon )
						hacker_hat:SetSize( 80, 80 )
						hacker_hat.LayoutEntity = function( ent )
						end
	
						headgearrandom_mdl = vgui.Create( "DModelPanel", BREACH.FactionInformation.Roles.RoleIcon )
						headgearrandom_mdl:SetSize( 80, 80 )
						headgearrandom_mdl.LayoutEntity = function( ent )
						end
	
						BREACH.FactionInformation.Roles.FaceModel = vgui.Create( "DModelPanel", BREACH.FactionInformation.Roles.RoleIcon )
						BREACH.FactionInformation.Roles.FaceModel:SetModel( table.Random(cls["models"]) || "models/player/Group01/male_01.mdl" )
						BREACH.FactionInformation.Roles.FaceModel:SetSize( 80, 80 )
						BREACH.FactionInformation.Roles.FaceModel.LayoutEntity = function( ent ) end
					  
						local faceinfentity = BREACH.FactionInformation.Roles.FaceModel.Entity
					  
						local idle_seq = faceinfentity:LookupSequence( "MPF_itemhit" )
					  
						local head = faceinfentity:LookupBone( "ValveBiped.Bip01_Head1" )
					  
						if ( head ) then
							if cls["name"] == SCP106 then return end
					  
							local eyepos = faceinfentity:GetBonePosition( head )
							eyepos:Add( eye_offset )
					  
							BREACH.FactionInformation.Roles.FaceModel:SetLookAt( eyepos )
							BREACH.FactionInformation.Roles.FaceModel:SetCamPos( eyepos - pos_offset )
							faceinfentity:SetEyeTarget( eyepos - pos_offset )
					  
							if ( cls["skin"] ) then
					  
							  faceinfentity:SetSkin( cls["skin"] )
					  
							end

							if isblack and faceinfentity:GetModel():find("class_d") then faceinfentity:SetSkin(1) end
	
							if ( cls["bodygroups"] ) then
					  
								faceinfentity:SetBodyGroups(cls["bodygroups"])
						
							end
							if ( cls["bodygroup1"] ) then
					  
								faceinfentity:SetBodygroup( 1, cls["bodygroup1"] )
						
							end
							if ( cls["bodygroup2"] ) then
					  
								faceinfentity:SetBodygroup( 2, cls["bodygroup2"] )
						
							end
							if ( cls["bodygroup3"] ) then
					  
								faceinfentity:SetBodygroup( 3, cls["bodygroup3"] )
						
							end
							if ( cls["bodygroup4"] ) then
					  
								faceinfentity:SetBodygroup( 4, cls["bodygroup4"] )
						
							end
							if ( cls["bodygroup5"] ) then
					  
								faceinfentity:SetBodygroup( 5, cls["bodygroup5"] )
						
							end
							if ( cls["bodygroup6"] ) then
					  
								faceinfentity:SetBodygroup( 6, cls["bodygroup6"] )
						
							end
							if ( cls["bodygroup7"] ) then
					  
								faceinfentity:SetBodygroup( 7, cls["bodygroup7"] )
						
							end
							if ( cls["bodygroup8"] ) then
					  
								faceinfentity:SetBodygroup( 8, cls["bodygroup8"] )
						
							end
							if ( cls["bodygroup9"] ) then
					  
								faceinfentity:SetBodygroup( 9, cls["bodygroup9"] )
						
							end
							if ( cls["bodygroup10"] ) then
					  
								faceinfentity:SetBodygroup( 10, cls["bodygroup10"] )
						
							end
							if ( cls["bodygroup11"] ) then
					  
								faceinfentity:SetBodygroup( 11, cls["bodygroup11"] )
						
							end
							if ( cls["bodygroup12"] ) then
					  
								faceinfentity:SetBodygroup( 12, cls["bodygroup12"] )
						
							end
							if ( cls["bodygroup13"] ) then
					  
								faceinfentity:SetBodygroup( 13, cls["bodygroup13"] )
						
							end
							if ( cls["bodygroup14"] ) then
					  
								faceinfentity:SetBodygroup( 14, cls["bodygroup14"] )
						
							end
							if ( cls["bodygroup15"] ) then
					  
								faceinfentity:SetBodygroup( 15, cls["bodygroup15"] )
						
							end
	
							if cls["head"] != nil then
								head_mdl:SetModel( HeadModel ) 
								head_mdl.Entity:SetParent(faceinfentity)
								head_mdl.Entity:AddEffects(EF_BONEMERGE)
								head_mdl:SetLookAt( eyepos )
								head_mdl:SetCamPos( eyepos - pos_offset )
								head_mdl.Entity:SetEyeTarget( eyepos - pos_offset )
								local randomcount = 6
								if cls["white"] != true then
									randomcount = 8
								end
								head_mdl.Textur = "models/all_scp_models/shared/heads/head_1_"..tostring(math.random(1, randomcount))
								if HeadModel:find("head_main_1") or HeadModel:find("balaclava") then
									head_mdl.Entity:SetSubMaterial(0, headtext)
								end
							elseif cls["head"] == nil then
								head_mdl:SetModel("")
							end
					   
							if cls["headgear"] != nil then
								headgear_mdl:SetModel( cls["headgear"] ) 
								headgear_mdl:SetLookAt( eyepos )
								headgear_mdl.Entity:SetParent(faceinfentity)
								headgear_mdl.Entity:AddEffects(EF_BONEMERGE)
								headgear_mdl:SetCamPos( eyepos - pos_offset )
								headgear_mdl.Entity:SetEyeTarget( eyepos - pos_offset )
							elseif cls["headgear"] == nil then
								headgear_mdl:SetModel("")
							end
					   
							if cls["hackerhat"] != nil then
								hacker_hat:SetModel( cls["hackerhat"] ) 
								hacker_hat:SetLookAt( eyepos )
								hacker_hat.Entity:SetParent(faceinfentity)
								hacker_hat.Entity:AddEffects(EF_BONEMERGE)
								hacker_hat:SetCamPos( eyepos - pos_offset )
								hacker_hat.Entity:SetEyeTarget( eyepos - pos_offset )
							elseif cls["hackerhat"] == nil then
								hacker_hat:SetModel("")
							end
					   
							if cls["headgearrandom"] != nil then
								headgearrandom_mdl:SetModel( table.Random(cls["headgearrandom"]) ) 
								headgearrandom_mdl:SetLookAt( eyepos )
								headgearrandom_mdl.Entity:SetParent(faceinfentity)
								headgearrandom_mdl.Entity:AddEffects(EF_BONEMERGE)
								headgearrandom_mdl:SetCamPos( eyepos - pos_offset )
								headgearrandom_mdl.Entity:SetEyeTarget( eyepos - pos_offset )
							elseif cls["headgearrandom"] == nil then
								headgearrandom_mdl:SetModel("")
							end
					  
							if ( player_level < ( role_level || 0 ) ) then
					  
								if (head_mdl.Entity) then
									head_mdl.Entity:SetMaterial("lights/white001")
									head_mdl:SetColor( clr_white_gray )
								end
								if (headgear_mdl.Entity) then
									headgear_mdl.Entity:SetMaterial("lights/white001")
									headgear_mdl:SetColor( clr_white_gray )
								end
								if (hacker_hat.Entity) then
									hacker_hat.Entity:SetMaterial("lights/white001")
									hacker_hat:SetColor( clr_white_gray )
								end
								if (headgearrandom_mdl.Entity) then
									headgearrandom_mdl.Entity:SetMaterial("lights/white001")
									headgearrandom_mdl:SetColor( clr_white_gray )
								end
								faceinfentity:SetMaterial( "lights/white001" )
								BREACH.FactionInformation.Roles.FaceModel:SetColor( clr_white_gray )
					  
							end
	
					  
						end
					  
						BREACH.FactionInformation.Roles.FaceModel.Closed = vgui.Create( "DButton", BREACH.FactionInformation.Roles.FaceModel )
						BREACH.FactionInformation.Roles.FaceModel.Closed:SetText( "" )
						BREACH.FactionInformation.Roles.FaceModel.Closed:SetSize( 80, 80 )
						BREACH.FactionInformation.Roles.FaceModel.Closed.Paint = function( self, w, h )
					  
							if ( self:IsHovered() ) then
					  
								draw.OutlinedBox( 0, 0, w, h, 2, color_black )
	
								if ( self:IsHovered() ) then
	
								   self:SetCursor( "hand" )
					  
								end
					  
							else
					  
							  draw.OutlinedBox( 0, 0, w, h, 2, clr_whiter )
					  
							end
					  
							if ( player_level < ( role_level || 0 ) ) then
					  
							  draw.RoundedBox( 0, 0, 0, w, h, clr_gray )
							  draw.SimpleText( role_level, "ChatFont_new", w / 2, h / 2, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					  
							end
					  
						end

			
						BREACH.FactionInformation.Roles.FaceModel.Closed.DoClick = function()

							if cls["level"] > LocalPlayer():GetNLevel() then return end
	
							BREACH.FactionInformation.Desc.Paint = function( self, w, h )
	  
								surface.SetDrawColor( color_white )
								surface.SetMaterial( mat_body )
								surface.DrawTexturedRect( 0, 0, w, h )
						  
							end
	
							BREACH.FactionInformation.Desc.PlayerFullModel = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
							BREACH.FactionInformation.Desc.PlayerFullModel:SetText( "" )
							BREACH.FactionInformation.Desc.PlayerFullModel:SetPos( 16, 16 )
							BREACH.FactionInformation.Desc.PlayerFullModel:SetSize( inf_menu_width / 3.5, inf_menu_height / 2.2 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Box1y = ( inf_menu_height / 2.2 ) / 2
							BREACH.FactionInformation.Desc.PlayerFullModel.Box2y = ( inf_menu_height / 2.2 ) / 2
					  
							BREACH.FactionInformation.Desc.PlayerFullModel.Paint = function( self, w, h )
					  

					  
							end
	
							BREACH.FactionInformation.Desc.PlayerFullModel.Model = vgui.Create( "DModelPanel", BREACH.FactionInformation.Desc )
							BREACH.FactionInformation.Desc.PlayerFullModel.Model:SetSize( inf_menu_width / 3.5, inf_menu_height / 2.2 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Model:SetPos( 16, 16 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Model.LayoutEntity = function( ent ) end
							BREACH.FactionInformation.Desc.PlayerFullModel.Model:SetAnimated( true )
	
							BREACH.FactionInformation.Desc.PlayerFullModel.Render = vgui.Create( "DPanel", BREACH.FactionInformation.Desc.PlayerFullModel.Model )
							BREACH.FactionInformation.Desc.PlayerFullModel.Render:SetText( "" )
							BREACH.FactionInformation.Desc.PlayerFullModel.Render:SetSize( inf_menu_width / 3.5, inf_menu_height / 2.2 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Render.Box1y = ( inf_menu_height / 2.2 ) / 2
							BREACH.FactionInformation.Desc.PlayerFullModel.Render.Box2y = ( inf_menu_height / 2.2 ) / 2 - 24
					  
							BREACH.FactionInformation.Desc.PlayerFullModel.Render.Paint = function( self, w, h )


					  
							end
	
							BREACH.FactionInformation.Desc.PlayerDescModel.Paint = function( self, w, h )
	  
								self.Box1x = math.Approach( self.Box1x, 24, FrameTime() * 312 )
								self.Box2x = math.Approach( self.Box2x, w - 24, FrameTime() * 312 )
								self.icon_Alpha = math.Approach( self.icon_Alpha, 160, FrameTime() * 128 )
								DrawBlurPanel( self )
						
								local roles_icons
								if cls["team"] == TEAM_GUARD then
									roles_icons = Material("nextoren/gui/roles_icon/mtf.png")
								elseif cls["team"] == TEAM_SECURITY then
									roles_icons = Material("nextoren/gui/roles_icon/sb.png")
								elseif cls["team"] == TEAM_DZ then
									roles_icons = Material("nextoren/gui/roles_icon/dz.png")
								elseif cls["team"] == TEAM_CHAOS then
									roles_icons = Material("nextoren/gui/roles_icon/chaos.png")
								elseif cls["team"] == TEAM_CLASSD then
									roles_icons = Material("nextoren/gui/roles_icon/class_d.png")
								elseif cls["team"] == TEAM_COTSK then
									roles_icons = Material("nextoren/gui/roles_icon/scarlet.png")
								elseif cls["team"] == TEAM_GOC then
									roles_icons = Material("nextoren/gui/roles_icon/goc.png")
								elseif cls["team"] == TEAM_GRU then
									roles_icons = Material("nextoren/gui/roles_icon/gru.png")
								elseif cls["team"] == TEAM_USA then
									roles_icons = Material("nextoren/gui/roles_icon/fbi.png")
								elseif cls["team"] == TEAM_SCI then
									roles_icons = Material("nextoren/gui/roles_icon/sci.png")
								elseif cls["team"] == TEAM_SPECIAL then
									roles_icons = Material("nextoren/gui/roles_icon/sci_special.png")
								elseif cls["team"] == TEAM_NTF then
									roles_icons = Material("nextoren/gui/roles_icon/ntf.png")
								elseif cls["team"] == TEAM_OSN then
									roles_icons = Material("nextoren/gui/roles_icon/osn.png")
								elseif cls["team"] == TEAM_QRT then
									roles_icons = Material("nextoren/gui/roles_icon/obr.png")
								elseif cls["team"] == TEAM_SCP then
									roles_icons = Material("nextoren/gui/roles_icon/scp.png")
								elseif cls["team"] == TEAM_NAZI then
									roles_icons = Material("nextoren/gui/roles_icon/nazi.png")
								end
								surface.SetDrawColor( ColorAlpha( color_white, self.icon_Alpha ) )
								surface.SetMaterial( roles_icons )
								surface.DrawTexturedRect( w / 2 - 64, h / 2 - 64, 128, 128 )
						
								draw.RoundedBox( 0, self.Box1x - 24, 0, ( self.Box2x + 24 ) - self.Box1x, h, ColorAlpha( color_black, 180 ) )
						
								draw.RoundedBox( 0, self.Box1x - 24, 0, 24, h, clr_gray_noalpha )
								draw.RoundedBox( 0, self.Box2x, 0, 24, h, clr_gray_noalpha )
						
								if ( self.TimeCreation + .8 < RealTime() ) then
	
									if cls["team"] == TEAM_SCP then
										self.desc_Alpha = math.Approach( self.desc_Alpha, 255, FrameTime() * 156 )
						
										draw.SimpleText( "Level: " .. cls["level"], "ChatFont_new", 34, 12, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										draw.SimpleText( "Name: " .. cls["name"], "ChatFont_new", 34, 30, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										drawMultiLine( "Objectives: " .. ( cls["tasks"] || "Задачи не заданы" ), "ChatFont_new", w / 1.5, 16, 34, 16 * 3, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
									else
						
										self.desc_Alpha = math.Approach( self.desc_Alpha, 255, FrameTime() * 156 )
						
										draw.SimpleText( "Level: " .. cls["level"], "ChatFont_new", 34, 12, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										draw.SimpleText( "Name: " .. GetLangRole(cls["name"]), "ChatFont_new", 34, 30, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										drawMultiLine( "Objectives: " .. ( cls["tasks"] || "Задачи не заданы" ), "ChatFont_new", w / 1.5, 16, 34, 16 * 3, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
									end
						
								end
						
							end

							local stamina = "100"

							if cls["stamina"] then
								stamina = tostring(cls["stamina"]*100)
							end
	
							BREACH.FactionInformation.Desc.PlayerStatistics.Paint = function( self, w, h )
					
								self.Box1y = math.Approach( self.Box1y, 0, FrameTime() * 128 )
								self.Box2y = math.Approach( self.Box2y, inf_menu_height / 6 - 16, FrameTime() * 128 )
					
								draw.RoundedBox( 0, 0, self.Box1y, w, self.Box2y - self.Box1y, clr_gray )
					
								DrawBlurPanel( self )
					
								draw.RoundedBox( 0, 0, self.Box1y, w, 16, clr_gray_noalpha )
								draw.RoundedBox( 0, 0, self.Box2y, w, 16, clr_gray_noalpha )
					
								if ( self.Box1y == 0 ) then
					
									self.TextAlpha = math.Approach( self.TextAlpha, 210, FrameTime() * 256 )
					
									draw.SimpleText( "Character stats", "ChatFont_new", w / 2, 28, ColorAlpha( color_black, self.TextAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					
									draw.SimpleText( "Health: " .. cls["health"], "ChatFont_new", 16, 40, ColorAlpha( color_black, self.TextAlpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
									draw.SimpleText( "Stamina: " .. stamina, "ChatFont_new", 16, 40 * 1.5, ColorAlpha( color_black, self.TextAlpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
					
								end
					
							end
	
							if cls["head"] != nil then
								icon_SPEC2:SetModel( HeadModel ) 
								if HeadModel:find("head_main_1") or HeadModel:find("balaclava") then
									icon_SPEC2.Entity:SetSubMaterial(0, headtext)
								end
							elseif cls["head"] == nil then
								icon_SPEC2:SetModel("")
							end
					   
							if cls["headgear"] != nil then
								icon_SPEC3:SetModel( cls["headgear"] ) 
							elseif cls["headgear"] == nil then
								icon_SPEC3:SetModel("")
							end
					   
							if cls["hackerhat"] != nil then
								icon_SPEC5:SetModel( cls["hackerhat"] ) 
							elseif cls["hackerhat"] == nil then
								icon_SPEC5:SetModel("")
							end
					   
							if cls["headgearrandom"] != nil then
								icon_SPEC4:SetModel( table.Random(cls["headgearrandom"]) ) 
							elseif cls["headgearrandom"] == nil then
								icon_SPEC4:SetModel("")
							end
						 
							if cls["models"] != nil then
								icon_SPEC:SetModel( table.Random(cls["models"]) ) 
							elseif cls["models"] == nil then
								icon_SPEC:SetModel("")
							end
					   
							function icon_SPEC:LayoutEntity( Entity )
								
								local idle_seq = Entity:LookupSequence( "MPF_itemhit" )

								local idle_seq2 = Entity:LookupSequence( "Idle_Upper_KNIFE" )

								local idle_seq3 = Entity:LookupSequence( "idle_melee" )

								if icon_SPEC:GetModel() == "models/cultist/scp/scp638/scp_638.mdl" then
									Entity:SetSequence(idle_seq2)
								elseif icon_SPEC:GetModel() == "models/cultist/scp/scp_1027ru.mdl" then
									Entity:SetSequence(idle_seq3)
								else
									Entity:SetSequence(idle_seq)
								end

								if cls["headgear"] != nil then
								 icon_SPEC3.Entity:SetParent(Entity)
								 icon_SPEC3.Entity:AddEffects(EF_BONEMERGE)
								end
								if cls["headgearrandom"] != nil then
								 icon_SPEC4.Entity:SetParent(Entity)
								 icon_SPEC4.Entity:AddEffects(EF_BONEMERGE)
								end
								if cls["hackerhat"] != nil then
								 icon_SPEC5.Entity:SetParent(Entity)
								 icon_SPEC5.Entity:AddEffects(EF_BONEMERGE)
								end
								if cls["head"] != nil then
								 icon_SPEC2.Entity:SetParent(Entity)
								 icon_SPEC2.Entity:AddEffects(EF_BONEMERGE)
								end
								Entity:SetAngles(Angle(0,45,0))

								if ( cls["bodygroups"] ) then
					  
									Entity:SetBodyGroups(cls["bodygroups"])
							
								end
								if cls["bodygroup1"] != nil then
								   Entity:SetBodygroup( 1, cls["bodygroup1"])
								end
								if cls["bodygroup2"] != nil then
								   Entity:SetBodygroup( 2, cls["bodygroup2"])
								end
								if cls["bodygroup3"] != nil then
								   Entity:SetBodygroup( 3, cls["bodygroup3"])
								end
								if cls["bodygroup4"] != nil then
								   Entity:SetBodygroup( 4, cls["bodygroup4"])
								end
								if cls["bodygroup5"] != nil then
								   Entity:SetBodygroup( 5, cls["bodygroup5"])
								end
								if cls["bodygroup6"] != nil then
								   Entity:SetBodygroup( 6, cls["bodygroup6"])
								end
								if cls["bodygroup7"] != nil then
								   Entity:SetBodygroup( 7, cls["bodygroup7"])
								end
								if cls["bodygroup8"] != nil then
								   Entity:SetBodygroup( 8, cls["bodygroup8"])
								end
								if cls["bodygroup9"] != nil then
								   Entity:SetBodygroup( 9, cls["bodygroup9"])
								end
								if cls["bodygroup10"] != nil then
								   Entity:SetBodygroup( 10, cls["bodygroup10"])
								end
								if cls["bodygroup11"] != nil then
								   Entity:SetBodygroup( 11, cls["bodygroup11"])
								end
								if cls["bodygroup12"] != nil then
								   Entity:SetBodygroup( 12, cls["bodygroup12"])
								end
								if cls["bodygroup13"] != nil then
								   Entity:SetBodygroup( 13, cls["bodygroup13"])
								end
								if cls["skin"] != nil then
								   Entity:SetSkin( cls["skin"] )
								end
								if isblack and Entity:GetModel():find("class_d") then Entity:SetSkin(1) end
							end

						end
					end
					BREACH.FactionInformation.Roles.FaceModel.Closed.Think = function()
						if faction_switched then
							icon_SPEC:SetModel("")
							icon_SPEC2:SetModel("")
							icon_SPEC3:SetModel("")
							icon_SPEC4:SetModel("")
							icon_SPEC5:SetModel("")
							BREACH.FactionInformation.Desc.PlayerStatistics.Paint = function()
							end
							BREACH.FactionInformation.Desc.PlayerDescModel.Paint = function()
							end

						end
					end
				end
			end
        end

    end
end

function CloseRoleMenu(open_rolemenu)

	if ( !open_rolemenu ) then

		cdforuse_role = CurTime() + cdforuse_roletime

	end

	ROLEMENU.enabled = false
	gui.EnableScreenClicker( false )

	if ( IsValid( BREACH.RoleMenu ) ) then

		BREACH.RoleMenu:Remove()

	end

end

function IsRoleMenuVisible()

	return ROLEMENU.enabled 
	
end
