CLASSMENU = nil

selectedclass = nil

selectedclr = nil



surface.CreateFont("MTF_2Main",   {font = "Trebuchet24",

									size = 20,

									weight = 750})

surface.CreateFont("MTF_Main",   {font = "Trebuchet24",

									size = ScreenScale(9),

									weight = 750})

surface.CreateFont("MTF_Secondary", {font = "Trebuchet24",

									size = ScreenScale(14),

									weight = 750,

									shadow = true})

surface.CreateFont("MTF_Third", {font = "Trebuchet24",

									size = ScreenScale(10),

									weight = 750,

									shadow = true})



local blur = Material("pp/blurscreen")



local function DrawBlur(panel, amount)

    local x, y = panel:LocalToScreen(0, 0)

    local scrW, scrH = ScrW(), ScrH()

    surface.SetDrawColor(255, 255, 255)

    surface.SetMaterial(blur)

    for i = 1, 3 do

        blur:SetFloat("$blur", (i / 3) * (amount or 6))

        blur:Recompute()

        render.UpdateScreenEffectTexture()

        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)

    end

end







function OpenClassMenu()

	if IsValid(CLASSMENU) then return end



	local ply = LocalPlayer()



	surface.CreateFont("MTF_2Main",   {font = "Trebuchet24",

										size = 35,

										weight = 750})

	surface.CreateFont("MTF_Main",   {font = "Trebuchet24",

										size = ScreenScale(9),

										weight = 750})

	surface.CreateFont("MTF_Secondary", {font = "Trebuchet24",

										size = ScreenScale(14),

										weight = 750,

										shadow = true})

	surface.CreateFont("MTF_Third", {font = "Trebuchet24",

										size = ScreenScale(10),

										weight = 750,

										shadow = true})

	

	local ourlevel = LocalPlayer():GetLevel()

	

	selectedclass = ALLCLASSES["support"]["roles"][1]

	selectedclr = ALLCLASSES["support"]["color"]

	

	if selectedclr == nil then selectedclr = Color(255,255,255) end

	

	local width = ScrW() / 1.5

	local height = ScrH() / 1.5

	

	--- GŁÓWNE OKIENKO

	CLASSMENU = vgui.Create( "DFrame" )

	CLASSMENU:SetTitle( "" )

	CLASSMENU:SetSize( width, height )

	CLASSMENU:Center()

	CLASSMENU:SetDraggable( true )

	CLASSMENU:SetDeleteOnClose( true )

	CLASSMENU:SetDraggable( true )

	CLASSMENU:ShowCloseButton( true )

	CLASSMENU:MakePopup()

	CLASSMENU.Paint = function( self, w, h )

				 DrawBlur(self, 2)

				draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 200 ) )


				

	surface.SetDrawColor( 165, 42, 42, 255 ) 






	surface.SetDrawColor( 165, 42, 42, 255 ) 




if ScrH() == 1080 then

	surface.SetDrawColor( 165, 42, 42, 255 ) 





elseif ScrH() == 900 then

	surface.SetDrawColor( 165, 42, 42, 255 ) 





elseif ScrH() == 768 then

	surface.SetDrawColor( 165, 42, 42, 255 ) 





elseif ScrH() == 720 then

	surface.SetDrawColor( 165, 42, 42, 255 ) 





elseif ScrH() == 664 then

	surface.SetDrawColor( 165, 42, 42, 255 ) 


else

	surface.SetDrawColor( 165, 42, 42, 255 ) 




end

	end

	---- NAPIS KLASY POSTACI

	local maininfo = vgui.Create( "DLabel", CLASSMENU )

	maininfo:SetText( "" )

	maininfo:Dock( TOP )

	maininfo:SetFont("MTF_Main")

	maininfo:SetContentAlignment( 5 )

	maininfo:SetSize(0,28)

	maininfo.Paint = function( self, w, h )

if ScrH() == 1080 then

		draw.Text( {

			text = "Меню Ролей",

			font = "MTF_Main",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w * 0.10, h * 0.31 }

		} )

elseif ScrH() == 900 then

		draw.Text( {

			text = "Меню Ролей",

			font = "MTF_Main",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w * 0.10, h * 0.24 }

		} )

elseif ScrH() == 768 then

		draw.Text( {

			text = "Меню Ролей",

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w * 0.10, h * 0.15 }

		} )

elseif ScrH() == 720 then

		draw.Text( {

			text = "Меню Ролей",

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w * 0.10, h * 0.15 }

		} )

elseif ScrH() == 664 then

		draw.Text( {

			text = "Меню Ролей",

			font = "MTF_Main",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w * 0.10, h * 0.15 }

		} )

else

		draw.Text( {

			text = "Меню Ролей",

			font = "MTF_Main",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w * 0.10, h * 0.31 }

		} )

end



	end

	

	local panel_right = vgui.Create( "DPanel", CLASSMENU )

	panel_right:Dock( FILL )

	panel_right:DockMargin( width / 4 - 5, 0, width / 9 - 5, 0	)

	panel_right.Paint = function( self, w, h ) 



	end

	

	

	local sclass_toppanel = vgui.Create( "DPanel", panel_right )

	sclass_toppanel:Dock( TOP )

	sclass_toppanel:SetSize(0, height / 2.5)

	sclass_toppanel.Paint = function( self, w, h ) 



	end

	

	local smodel

	if selectedclass.showmodel == nil then

		smodel = table.Random(selectedclass.models)

	else

		smodel = selectedclass.showmodel

	end

	---- POSTAĆ POKAZANA

	local class_modelpanel = vgui.Create( "DPanel", sclass_toppanel )

	class_modelpanel:Dock( LEFT )

	class_modelpanel:SetSize(width / 5)

	class_modelpanel.Paint = function( self, w, h )



	end



	sclass_model = vgui.Create( "DModelPanel", class_modelpanel )

	sclass_model:Dock( FILL )

	sclass_model:SetFOV(68)

	sclass_model:SetModel( smodel )

	function sclass_model:LayoutEntity( entity )

		entity:SetAngles(Angle(0,18,0))

	end

	local ent = sclass_model:GetEntity()

	if selectedclass.pmcolor != nil then

		function ent:GetPlayerColor() return Vector ( selectedclass.pmcolor.r / 255, selectedclass.pmcolor.g / 255, selectedclass.pmcolor.b / 255 ) end

	end



	

	---- NAPIS DO POSTACI Z TŁA

	local sclass_name = vgui.Create( "DPanel", sclass_toppanel )

	sclass_name:Dock( TOP )

	sclass_name:SetSize(0, 69)

	sclass_name.Paint = function( self, w, h )

	

if ScrH() == 1080 then

		draw.Text( {

			text = GetLangRole(selectedclass.name),

			font = "HUDFont2",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { ScrW() * 0.22, h * 0.60 }

		} )

elseif ScrH() == 900 then

		draw.Text( {

			text = GetLangRole(selectedclass.name),

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { ScrW() * 0.22, h * 0.40 }

		} )

elseif ScrH() == 768 then

		draw.Text( {

			text = GetLangRole(selectedclass.name),

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { ScrW() * 0.22, h * 0.20 }

		} )

elseif ScrH() == 720 then

		draw.Text( {

			text = GetLangRole(selectedclass.name),

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { ScrW() * 0.22, h * 0.10 }

		} )

elseif ScrH() == 664 then

		draw.Text( {

			text = GetLangRole(selectedclass.name),

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { ScrW() * 0.22, h * 0.08 }

		} )

else

		draw.Text( {

			text = GetLangRole(selectedclass.name),

			font = "HUDFont",

			xalign = TEXT_ALIGN_CENTER,

			yalign = TEXT_ALIGN_CENTER,

			pos = { ScrW() * 0.22, h * 0.60 }

		} )

end



	end

	

	

	

	---- DANE POSTACI

	local sclass_name = vgui.Create( "DPanel", sclass_toppanel )

	sclass_name:Dock( FILL )

	sclass_name:SetSize(0, 60)

	sclass_name.Paint = function( self, w, h )



if ScrH() == 1080 then

		local atso = w / 16

		local starpos = w / 11

		draw.Text( {

			text = "Здоровье: " .. selectedclass.health,

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w / 3.30, starpos }

		} )

		draw.Text( {

			text = "Ходьба: " .. math.Round(240 * selectedclass.walkspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso) }

		} )

		draw.Text( {

			text = "Бег: " .. math.Round(240 * selectedclass.runspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 2) }

		} )

		draw.Text( {

			text = "Прыжок: " .. math.Round(200 * selectedclass.jumppower),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 3) }

		} )

		local lvl = selectedclass.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

		if lvl == 6 then lvl = "6" end

		draw.Text( {

			text = "Уровень: " .. lvl,

			font = "nowyfont",

			color = clr,

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 1.60, starpos + (atso * 4.50) }

		} )

elseif ScrH() == 900 then

		local atso = w / 18

		local starpos = w / 11

		draw.Text( {

			text = "Здоровье: " .. selectedclass.health,

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w / 3.30, starpos }

		} )

		draw.Text( {

			text = "Ходьба: " .. math.Round(240 * selectedclass.walkspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso) }

		} )

		draw.Text( {

			text = "Бег: " .. math.Round(240 * selectedclass.runspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 2) }

		} )

		draw.Text( {

			text = "Прыжок: " .. math.Round(200 * selectedclass.jumppower),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 3) }

		} )

		local lvl = selectedclass.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

		if lvl == 6 then lvl = "6" end

		draw.Text( {

			text = "Уровень: " .. lvl,

			font = "nowyfont",

			color = clr,

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 1.60, starpos + (atso * 4.50) }

		} )

elseif ScrH() == 768 then

		local atso = w / 22

		local starpos = w / 11

		draw.Text( {

			text = "Здоровье: " .. selectedclass.health,

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w / 3.30, starpos }

		} )

		draw.Text( {

			text = "Ходьба: " .. math.Round(240 * selectedclass.walkspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso) }

		} )

		draw.Text( {

			text = "Скорость: " .. math.Round(240 * selectedclass.runspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 2) }

		} )

		draw.Text( {

			text = "Прыжок: " .. math.Round(200 * selectedclass.jumppower),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 3) }

		} )

		local lvl = selectedclass.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

		if lvl == 6 then lvl = "6" end

		draw.Text( {

			text = "Уровень: " .. lvl,

			font = "nowyfont",

			color = clr,

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 1.60, starpos + (atso * 4.50) }

		} )

elseif ScrH() == 720 then

		local atso = w / 22

		local starpos = w / 11

		draw.Text( {

			text = "Здоровье: " .. selectedclass.health,

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w / 3.30, starpos }

		} )

		draw.Text( {

			text = "Ходьба: " .. math.Round(240 * selectedclass.walkspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso) }

		} )

		draw.Text( {

			text = "Бег: " .. math.Round(240 * selectedclass.runspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 2) }

		} )

		draw.Text( {

			text = "Прыжок: " .. math.Round(200 * selectedclass.jumppower),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 3) }

		} )

		local lvl = selectedclass.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

		if lvl == 6 then lvl = "6" end

		draw.Text( {

			text = "Уровень: " .. lvl,

			font = "nowyfont",

			color = clr,

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 1.60, starpos + (atso * 4.50) }

		} )

elseif ScrH() == 664 then

		local atso = w / 26

		local starpos = w / 11

		draw.Text( {

			text = "Здоровье: " .. selectedclass.health,

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w / 3.30, starpos }

		} )

		draw.Text( {

			text = "Ходьба: " .. math.Round(240 * selectedclass.walkspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso) }

		} )

		draw.Text( {

			text = "Бег: " .. math.Round(240 * selectedclass.runspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 2) }

		} )

		draw.Text( {

			text = "Прыжок: " .. math.Round(200 * selectedclass.jumppower),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 3) }

		} )

		local lvl = selectedclass.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

		if lvl == 6 then lvl = "6" end

		draw.Text( {

			text = "Уровень: " .. lvl,

			font = "nowyfont",

			color = clr,

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 1.60, starpos + (atso * 4.50) }

		} )

else

		local atso = w / 16

		local starpos = w / 11

		draw.Text( {

			text = "Здоровье: " .. selectedclass.health,

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = { w / 3.30, starpos }

		} )

		draw.Text( {

			text = "Ходьба: " .. math.Round(240 * selectedclass.walkspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso) }

		} )

		draw.Text( {

			text = "Бег: " .. math.Round(240 * selectedclass.runspeed),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 2) }

		} )

		draw.Text( {

			text = "Прыжок: " .. math.Round(200 * selectedclass.jumppower),

			font = "nowyfont",

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 3.30, starpos + (atso * 3) }

		} )

		local lvl = selectedclass.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

		if lvl == 6 then lvl = "6" end

		draw.Text( {

			text = "Уровень: " .. lvl,

			font = "nowyfont",

			color = clr,

			xalign = TEXT_ALIGN_LEFT,

			yalign = TEXT_ALIGN_CENTER,

			pos = {  w / 1.60, starpos + (atso * 4.50) }

		} )

end



	end

	
	local sclass_downpanel = vgui.Create( "DPanel", panel_right )

	sclass_downpanel:Dock( FILL )

	sclass_downpanel:SetSize(0, height / 2.5)

	sclass_downpanel.Paint = function( self, w, h )

		

if ScrH() == 1080 then

		local atso = h / 21

		local starpos = ScrW() * 0.11

		local numw = 0

		for k,v in pairs(selectedclass.showweapons) do

			draw.Text( {

				text = "- " .. v,

				font = "nowyfont",

				xalign = TEXT_ALIGN_LEFT,

				yalign = TEXT_ALIGN_CENTER,

				pos = { ScrW() * 0.01, starpos + (numw * atso) }

			} )

			numw = numw + 1

		end

elseif ScrH() == 900 then

		local atso = h / 21

		local starpos = ScrW() * 0.11

		local numw = 0

		for k,v in pairs(selectedclass.showweapons) do

			draw.Text( {

				text = "- " .. v,

				font = "nowyfont",

				xalign = TEXT_ALIGN_LEFT,

				yalign = TEXT_ALIGN_CENTER,

				pos = { ScrW() * 0.01, starpos + (numw * atso) }

			} )

			numw = numw + 1

		end

elseif ScrH() == 768 then

		local atso = h / 21

		local starpos = ScrW() * 0.11

		local numw = 0

		for k,v in pairs(selectedclass.showweapons) do

			draw.Text( {

				text = "- " .. v,

				font = "nowyfont",

				xalign = TEXT_ALIGN_LEFT,

				yalign = TEXT_ALIGN_CENTER,

				pos = { ScrW() * 0.01, starpos + (numw * atso) }

			} )

			numw = numw + 1

		end

elseif ScrH() == 720 then

		local atso = h / 21

		local starpos = ScrW() * 0.10

		local numw = 0

		for k,v in pairs(selectedclass.showweapons) do

			draw.Text( {

				text = "- " .. v,

				font = "nowyfont",

				xalign = TEXT_ALIGN_LEFT,

				yalign = TEXT_ALIGN_CENTER,

				pos = { ScrW() * 0.01, starpos + (numw * atso) }

			} )

			numw = numw + 1

		end

elseif ScrH() == 664 then

		local atso = h / 19

		local starpos = ScrW() * 0.09

		local numw = 0

		for k,v in pairs(selectedclass.showweapons) do

			draw.Text( {

				text = "- " .. v,

				font = "nowyfont",

				xalign = TEXT_ALIGN_LEFT,

				yalign = TEXT_ALIGN_CENTER,

				pos = { ScrW() * 0.01, starpos + (numw * atso) }

			} )

			numw = numw + 1

		end

else

		local atso = h / 21

		local starpos = ScrW() * 0.11

		local numw = 0

		for k,v in pairs(selectedclass.showweapons) do

			draw.Text( {

				text = "- " .. v,

				font = "nowyfont",

				xalign = TEXT_ALIGN_LEFT,

				yalign = TEXT_ALIGN_CENTER,

				pos = { ScrW() * 0.01, starpos + (numw * atso) }

			} )

			numw = numw + 1

		end

end



	end

	

	local maininfo = vgui.Create( "DLabel", sclass_downpanel )

	maininfo:SetText( "Снаряжение" )

	maininfo:Dock( TOP )

	maininfo:SetFont("MTF_Main")

	maininfo:SetContentAlignment( 5 )

if ScrH() == 1080 then

	maininfo:DockMargin(  ScrW() * - 0.29, ScrH() * 0.15, 0, 0	)

elseif ScrH() == 900 then

	maininfo:DockMargin(  ScrW() * - 0.29, ScrH() * 0.14, 0, 0	)

elseif ScrH() == 768 then

	maininfo:DockMargin(  ScrW() * - 0.29, ScrH() * 0.13, 0, 0	)

elseif ScrH() == 720 then

	maininfo:DockMargin(  ScrW() * - 0.29, ScrH() * 0.12, 0, 0	)

elseif ScrH() == 664 then

	maininfo:DockMargin(  ScrW() * - 0.29, ScrH() * 0.11, 0, 0	)

else

	maininfo:DockMargin(  ScrW() * - 0.29, ScrH() * 0.15, 0, 0	)

end

	maininfo:SetSize(0,28)

	maininfo.Paint = function( self, w, h )



	end

	

	// LEFT PANELS

	

	local panel_left = vgui.Create( "DPanel", CLASSMENU )

	panel_left:Dock( FILL )

	panel_left:DockMargin( 0, 0, width / 1.30 - 5, 0	)

	panel_left.Paint = function( self, w, h ) 



	end

	

	local scroller = vgui.Create( "DScrollPanel", panel_left )

	scroller:Dock( FILL )

		scroller.Paint = function( self, w, h ) 



	end

	

	if ALLCLASSES == nil then return end

	

	for key,v in pairs(ALLCLASSES) do

		local name_security = vgui.Create( "DLabel", scroller )

		name_security:SetText( v.name )

		name_security:SetTextColor( Color( 255, 255, 255 ) )

		name_security:SetFont("HUDFont")

		name_security:SetContentAlignment( 5 )

		name_security:Dock( TOP )

		name_security:SetSize(0,28)

		name_security:DockMargin( 0, 0, 0, 0 )

		name_security.Paint = function( self, w, h )

			draw.RoundedBox( 2, 0, 0, w, h, Color(0, 0, 0) )

			draw.RoundedBox( 2, 1, 1, w - 2, h - 2, v.color )



		end

		for i,cls in ipairs(v.roles) do

			if GetConVar( "br_dclass_keycards" ):GetInt() == 0 and i != 2 or GetConVar( "br_dclass_keycards" ):GetInt() != 0 and i != 1 or v.name != "Class D Personell" then

				local model

				if cls.showmodel == nil then

					model = table.Random(cls.models)

				else

					model = cls.showmodel

				end

			

				local class_panel = vgui.Create( "DButton", scroller )

				class_panel:SetText("")

				class_panel:SetMouseInputEnabled( true )

				class_panel.DoClick = function()

					selectedclass = cls

					selectedclr = v.color

					sclass_model:SetModel( model )

				end

				//class_panel:SetText( cls.name )

				//class_panel:SetFont("MTF_Main")

				class_panel:Dock( TOP )

				class_panel:SetSize(0,50)

				if i != 1 then

					class_panel:DockMargin( 0, 4, 0, 0 )

				end

				

				local level = "Уровень: "

				if cls.level == 6 then

					level = level .. "6"

				else

					level = level .. cls.level

				end


				class_panel.Paint = function( self, w, h )

		local lvl = cls.level

		local clr = Color(255,0,0)

		if ourlevel >= lvl then clr = Color(0,255,0) end

					draw.Text( {

						text = GetLangRole(cls.name),

						font = "HUDFont",

						xalign = TEXT_ALIGN_LEFT,

						yalign = TEXT_ALIGN_CENTER,

						pos = { 10, h / 3.5 },

						color = Color(v.color.r - 1, v.color.g - 1, v.color.b - 1)

					} )

					draw.Text( {

						text = level,

						font = "HUDFont",

						xalign = TEXT_ALIGN_LEFT,

						yalign = TEXT_ALIGN_CENTER,

						pos = { 50, h / 1.4 },

						color = clr

					} )

				end

				

				local class_modelpanel = vgui.Create( "DPanel", class_panel )

				class_modelpanel:Dock( LEFT )

				class_modelpanel.Paint = function( self, w, h )



				end

				







			end

		end

	end


end

