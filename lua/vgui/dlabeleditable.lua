--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dlabeleditable.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_bStretch", "AutoStretch", FORCE_BOOL )

function PANEL:Init()

	self:SetAutoStretch( false )

end

function PANEL:SizeToContents()

	local w, h = self:GetContentSize()
	self:SetSize( w + 16, h ) -- Add a bit more room so it looks nice as a textbox :)

end

function PANEL:GetContentSize()

	local w, h = DLabel.GetContentSize( self )

	-- Expand the label to fit our text
	if ( self:IsEditing() && self:GetAutoStretch() ) then
		surface.SetFont( self:GetFont() )
		w, h = surface.GetTextSize( self._TextEdit:GetText() )
	end

	return w, h

end

function PANEL:DoDoubleClick()

	if ( !self:IsEnabled() ) then return end

	local TextEdit = vgui.Create( "DTextEntry", self )
	TextEdit:Dock( FILL )
	TextEdit:SetText( self:GetText() )
	TextEdit:SetFont( self:GetFont() )

	TextEdit.OnTextChanged = function()

		self:SizeToContents()

	end

	TextEdit.OnEnter = function()

		local text = self:OnLabelTextChanged( TextEdit:GetText() ) or TextEdit:GetText()
		if ( text:byte() == 35 ) then text = "#" .. text end -- Hack!

		self:SetText( text )
		hook.Run( "OnTextEntryLoseFocus", TextEdit )
		TextEdit:Remove()

	end

	TextEdit.OnLoseFocus = function()

		hook.Run( "OnTextEntryLoseFocus", TextEdit )
		TextEdit:Remove()

	end

	TextEdit:RequestFocus()
	TextEdit:OnGetFocus() -- Because the keyboard input might not be enabled yet! (spawnmenu)
	TextEdit:SelectAllText( true )

	self._TextEdit = TextEdit

end

function PANEL:IsEditing()

	if ( !IsValid( self._TextEdit ) ) then return false end

	return self._TextEdit:IsEditing()

end

function PANEL:OnLabelTextChanged( text )

	return text

end

derma.DefineControl( "DLabelEditable", "A Label", PANEL, "DLabel" )
