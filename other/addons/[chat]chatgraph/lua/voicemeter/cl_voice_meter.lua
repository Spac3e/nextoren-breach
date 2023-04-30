--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   addons/[chat]_voicechatmeter/lua/voicemeter/cl_voice_meter.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

surface.CreateFont( "Jack_VoiceFont", {
 font = "Arial",
 size = VoiceChatMeter.FontSize or 17,
 weight = 550,
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
 outline = true
} )

local isgradientenabled = CreateClientConVar("br_gradient_voice_chat", 0, true, false, "", 0, 1)

/*---------------------------------------------------------------------------
           Starting DarkRP specific stuff
---------------------------------------------------------------------------*/
surface.CreateFont ("DarkRPHUD1", { -- Just incase the font doesn't exist
size = 16,
weight = 600,
antialias = true,
shadow = true,
font = "DejaVu Sans"})

local receivers = receivers
local currentChatText = currentChatText || {}
local receiverConfigs = receiverConfigs || {
	[""] = { -- The default config decides who can hear you when you speak normally
		text = "talk",
		hearFunc = function(ply)
			if GAMEMODE.Config.alltalk then return nil end

			return LocalPlayer():GetPos():Distance(ply:GetPos()) < 250
		end
	}
}

local currentConfig = currentConfig || receiverConfigs[""] -- Default config is normal talk

local function AddChatReceiver(prefix, text, hearFunc)
	receiverConfigs[prefix] = {
		text = text,
		hearFunc = hearFunc
	}
end

AddChatReceiver("speak", "speak", function(ply)
	if not LocalPlayer().DRPIsTalking then return nil end
	if LocalPlayer():GetPos():Distance(ply:GetPos()) > 550 then return false end

	return not GAMEMODE.Config.dynamicvoice or ((ply.IsInRoom and ply:IsInRoom()) or (ply.isInRoom and ply:isInRoom()))
end)

local function drawChatReceivers()
	if not receivers then return end

	local x, y = chat.GetChatBoxPos()
	y = y - 21

	-- No one hears you
	if #receivers == 0 then
		draw.WordBox(2, x, y, "Noone can hear you speak", "DarkRPHUD1", Color(0,0,0,160), Color(255,0,0,255))
		return
	-- Everyone hears you
	elseif #receivers == #player.GetAll() - 1 then
		draw.WordBox(2, x, y, "Everyone can hear you speak", "DarkRPHUD1", Color(0,0,0,160), Color(0,255,0,255))
		return
	end

	draw.WordBox(2, x, y - (#receivers * 21), "Players who can hear you speak:", "DarkRPHUD1", Color(0,0,0,160), Color(0,255,0,255))
	for i = 1, #receivers, 1 do
		if not IsValid(receivers[i]) then
			receivers[i] = receivers[#receivers]
			receivers[#receivers] = nil
			continue
		end

		draw.WordBox(2, x, y - (i - 1)*21, receivers[i]:Nick(), "DarkRPHUD1", Color(0,0,0,160), Color(255,255,255,255))
	end
end

local function chatGetRecipients()
	if not currentConfig then return end

	receivers = {}
	for _, ply in pairs(player.GetAll()) do
		if not IsValid(ply) or ply == LocalPlayer() then continue end

		local val = currentConfig.hearFunc(ply, currentChatText)

		-- Return nil to disable the chat recipients temporarily.
		if val == nil then
			receivers = nil
			return
		elseif val == true then
			table.insert(receivers, ply)
		end
	end
end
/*---------------------------------------------------------------------------
            End DarkRP Specific stuff
---------------------------------------------------------------------------*/

local Jack = Jack || {}
Jack.Talking = Jack.Talking || {}

local clr_white_gray = Color( 210, 210, 210 )

local function PickColorForPlayer(ply)
	local color = gteams.GetColor(ply:GTeam())
	if !isgradientenabled:GetBool() then
		return false
	end
	if ply:GTeam() == TEAM_SPEC then if ply:IsSuperAdmin() then return Color(0,255,255) elseif ply:IsAdmin() then return Color(255,0,0) else return Color(255,255,255,0) end end
	if ply:GTeam() == TEAM_SCP then return gteams.GetColor(TEAM_SCP) end
	if LocalPlayer():GTeam() == TEAM_GOC and ply:GTeam() == TEAM_GOC then return gteams.GetColor(TEAM_GOC) end
	if ( LocalPlayer():GTeam() == TEAM_SCP or LocalPlayer():GTeam() == TEAM_DZ ) and ply:GTeam() == TEAM_DZ then return gteams.GetColor(TEAM_DZ) end
	if LocalPlayer():GTeam() == TEAM_CHAOS and ply:GTeam() == TEAM_CHAOS then return gteams.GetColor(TEAM_CHAOS) end
	if ply:GetModel():find("/goc/") then color = gteams.GetColor(TEAM_GOC) end
	if ply:GetModel():find("/sci/") and ply:GTeam() != TEAM_GUARD then color = gteams.GetColor(TEAM_SCI) end
	if ply:GetModel():find("class_d_cleaner") then return gteams.GetColor(TEAM_SCI) end
	if ply:GetModel():find("/class_d/") then color = gteams.GetColor(TEAM_CLASSD) end
	if ply:GetModel():find("/mog/") then color = gteams.GetColor(TEAM_GUARD) end
	if ply:GetModel():find("/security/") then color = gteams.GetColor(TEAM_CB) end
	if ply:GTeam() == TEAM_USA then color = Color(255,255,255) end
	return color
end

function Jack.StartVoice(ply)

	if !ply:IsValid() or !ply.Team then return false end
	for k,v in pairs(Jack.Talking) do if v.Owner == ply then v:Remove() Jack.Talking[k] = nil break end end
	if ply != LocalPlayer() and LocalPlayer():GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP and LocalPlayer():GTeam() != TEAM_SCP and !LocalPlayer():CanSeeEnt(ply) then return false end

	local plyteam = ply:GTeam()
	local IsSeen = ( ( LocalPlayer():CanSeeEnt(ply) and !ply:GetNoDraw() ) or ply == LocalPlayer() or ( ply:GTeam() == TEAM_SCP and LocalPlayer():GTeam() == TEAM_SCP ) )
	local CurID = 1
	local client = LocalPlayer()
	local plycol = PickColorForPlayer(ply)
	local gradient = Material("vgui/gradient-l")
	local W,H = VoiceChatMeter.SizeX or 250,VoiceChatMeter.SizeY or 40
	local TeamClr,CurName = team.GetColor(ply:Team()),ply:Name()

	// The name panel itself
	local ToAdd = 0

	if #Jack.Talking != 0 then
		for i=1,#Jack.Talking+3 do
			if !Jack.Talking[i] or !Jack.Talking[i]:IsValid() then
				ToAdd = -(i-1)*(H+4)
				CurID = i
				break
			end
		end
	end

	if !VoiceChatMeter.StackUp then ToAdd = -ToAdd end

	local NameBar,Fade,Go = vgui.Create("DPanel"),0,1
	NameBar:SetSize(W,H)
	local StartPos = (VoiceChatMeter.SlideOut and ((VoiceChatMeter.PosX < .5 and -W) or ScrW())) or (ScrW()*VoiceChatMeter.PosX-(VoiceChatMeter.Align == 1 and 0 or W))
	NameBar:SetPos(StartPos,ScrH()*VoiceChatMeter.PosY+ToAdd)
	local colalph = 20
	if plyteam == TEAM_USA then colalph = 45 end
	if VoiceChatMeter.SlideOut then NameBar:MoveTo((ScrW()*VoiceChatMeter.PosX-(VoiceChatMeter.Align == 1 and 0 or W)),ScrH()*VoiceChatMeter.PosY+ToAdd,VoiceChatMeter.SlideTime) end
	NameBar.Paint = function(s,w,h)
		draw.RoundedBox(VoiceChatMeter.Radius,0,0,w,h,Color(0,0,0,180*Fade))
		draw.RoundedBox(VoiceChatMeter.Radius,2,2,w-4,h-4,Color(0,0,0,180*Fade))
		if plycol then
			if plyteam != TEAM_SPEC and IsSeen then
				surface.SetDrawColor(ColorAlpha(plycol, colalph))
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(2, 2, w-4,h-4)
			elseif plyteam == TEAM_SPEC then
				surface.SetDrawColor(ColorAlpha(plycol, colalph))
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(2, 2, w-4,h-4)
			end
		end
	end
	NameBar.Owner = ply

	// Initialize stuff for this think function
	local NameTxt = vgui.Create("DLabel",NameBar)
	local Av
	if ply:GTeam() == TEAM_SPEC then
		Av = vgui.Create("AvatarImage",NameBar)
	else
		Av = vgui.Create("DModelPanel",NameBar)
	end

	// How the voice volume meters work
	local angle_front = Angle( 0, 90, 0 )
	local vec_offset = Vector( 0, 0, -30 )
	function NameBar:Think()
		if !ply:IsValid() then NameBar:Remove() Jack.Talking[CurID] = nil return false end
		if !Jack.Talking[CurID] then NameBar:Remove() return false end
		if self.Next and CurTime()-self.Next < .02 then return false end
		if Jack.Talking[CurID].fade then if Go != 0 then Go = 0 end if Fade <= 0 then Jack.Talking[CurID]:Remove() Jack.Talking[CurID] = nil end end
		if Fade < Go and Fade != 1 then Fade = Fade+VoiceChatMeter.FadeAm NameTxt:SetAlpha(Fade*255) if plyteam == TEAM_SPEC then Av:SetAlpha(Fade*255) end elseif Fade > Go and Go != 1 then Fade = Fade-VoiceChatMeter.FadeAm NameTxt:SetAlpha(Fade*255) if plyteam == TEAM_SPEC then Av:SetAlpha(Fade*255) end end

		self.Next = CurTime()
		local CurVol = ply:VoiceVolume()*1.05

		local VolBar,Clr = vgui.Create("DPanel",NameBar),Color(255*(CurVol),255*(1-CurVol),0,190)
		VolBar:SetSize(5,(self:GetTall()-6)*(CurVol))
		VolBar:SetPos(self:GetTall()-6,(self:GetTall()-6)*(1-CurVol)+3)
		VolBar.Think = function(sel)
			if sel.Next and CurTime()-sel.Next < .02 then return false end
			sel.Next = CurTime()

			local X,Y = sel:GetPos()
			if X > NameBar:GetWide()+14 then sel:Remove() return end

			sel:SetPos(X+6,Y)
		end
		VolBar.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(Clr.r,Clr.g,Clr.b,Clr.a*Fade))

		end
		VolBar:MoveToBack()
		VolBar:SetZPos(5)
	end

	-- The player's avatar

	if plyteam == TEAM_SPEC then
		Av:SetPos(4,4)
		Av:SetSize(NameBar:GetTall()-8,NameBar:GetTall()-8)
		Av:SetPlayer(ply)
	else
		Av:SetPos(4,4)
		Av:SetSize(NameBar:GetTall()-8,NameBar:GetTall()-8)
		if IsSeen then
			Av:SetModel(ply:GetModel())
			Av.Entity:SetSkin(ply:GetSkin())
			for i = 0, 9 do
				Av.Entity:SetBodygroup(i, ply:GetBodygroup(i))
			end
		else
			Av:SetModel("models/cultist/humans/class_d/class_d.mdl")
			Av.Entity:SetMaterial("lights/white001")
			Av:SetColor( clr_white_gray )
		end
		local iSeq = Av.Entity:LookupSequence("idle_all_01")
		if iSeq <= 0 then iSeq = Av.Entity:LookupSequence("idle_all_01") end
		if iSeq <= 0 then iSeq = Av.Entity:LookupSequence("idle_all_01") end
		if iSeq > 0 then Av.Entity:ResetSequence(iSeq) end
		Av:SetFOV( 10 );

		--Av.__LayoutEntity = Av.__LayoutEntity or Av.LayoutEntity;

			function Av:LayoutEntity(ent)

				--self.__LayoutEntity(self, ent)

			end

			local eyepos = Av.Entity:GetBonePosition(Av.Entity:LookupBone("ValveBiped.Bip01_Head1") || 0)

			if !isnumber(Av.Entity:LookupBone("ValveBiped.Bip01_Head1")) then eyepos = Av.Entity:GetAttachment(Av.Entity:LookupAttachment("eyes")) and Av.Entity:GetAttachment(Av.Entity:LookupAttachment("eyes")).Pos || Vector(0, 0, 0) end

			eyepos:Add(Vector(0, 0, 2))	-- Move up slightly

			Av.Entity:SetAngles(Angle(0,0,0))

			Av:SetCamPos(eyepos-Vector(-65, 0, 0))	-- Move cam in front of eyes

			Av:SetLookAt(eyepos)

			Av.Entity:SetEyeTarget(eyepos-Vector(-65, 0, 0))

			local bnmrgtable = ents.FindByClassAndParent("ent_bonemerged", ply)
			if !IsSeen then
				Av:BoneMerged("models/cultist/heads/male/head_main_1.mdl")
				for i = 1, #Av.Entity.BoneMergedEnts do
					local bnmrg = Av.Entity.BoneMergedEnts[i]
					bnmrg:SetMaterial("lights/white001")
					bnmrg:SetColor( clr_white_gray )
				end
			end
			if istable(bnmrgtable) and IsSeen then
				for _, bnmrg in pairs(bnmrgtable) do
					if !IsValid(bnmrg) then continue end
					local headface = nil
					if bnmrg:GetModel():find("head_main_1") or bnmrg:GetModel():find("balaclava") then headface = bnmrg:GetSubMaterial(0) end
					local bnmrg_av = Av:BoneMerged(bnmrg:GetModel(), headface, bnmrg:GetInvisible())

				end
			end
	end
  
  if plyteam == TEAM_SPEC then
	    Av:SetPaintedManually(true)
	end
  siz = NameBar:GetTall()-8,NameBar:GetTall()-8
	local hsiz = siz * 0.5
  local sin, cos, rad = math.sin, math.cos, math.rad
  local rad0 = rad(0)
  local function DrawCircle(x, y, radius, seg)
  	local cir = {
  		{x = x, y = y}
  	}

  	for i = 0, seg do
  		local a = rad((i / seg) * -360)
  		table.insert(cir, {x = x + sin(a) * radius, y = y + cos(a) * radius})
  	end

  	table.insert(cir, {x = x + sin(rad0) * radius, y = y + cos(rad0) * radius})
  	surface.DrawPoly(cir)
  end
  local pnl = vgui.Create("DPanel", NameBar)
  pnl:SetSize(NameBar:GetTall()-2,NameBar:GetTall()-2)
  pnl:SetPos(4,4)
  pnl:SetDrawBackground(true)
  pnl.Paint = function(w,h)
  	--[[
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    draw.NoTexture()
    surface.SetDrawColor(color_black)
    DrawCircle(hsiz, hsiz, hsiz, hsiz)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)]]

   --if plyteam == TEAM_SPEC then
	    Av:PaintManual()
	--end

    --render.SetStencilEnable(false)
    --render.ClearStencil()
  end


	// Admin tags and the such
	local NameStr = ply:Name()
	if VoiceChatMeter.UseTags then
		local Is
    local rankd = ply:GetUserGroup()
    local steamid = ply:SteamID64()
		for k,v in pairs(VoiceChatMeter.Tags) do if ply:IsUserGroup(k) then Is = v end end
		--if !Is and ply:IsSuperAdmin() then Is = "[СА]" --[[elseif !Is and ply:IsAdmin() then Is = "[А]"]] end

		if Is then NameStr = Is .. " " .. NameStr end
	end
  local rankdс = ply:GetUserGroup()
  local clr = Color(255,255,255,240)
  --[[
  if ply:IsAdmin() then
    clr = Color(255,0,0,240)
  end
  --]]
  if ply:IsAdmin() then clr = Color(255,0,0,240) end
  if ply:IsSuperAdmin() then clr = Color(0, 255, 255, 240) end

  if plyteam != TEAM_SPEC and plyteam != TEAM_SCP then
  	if IsSeen then
	  NameStr = ply:GetName()
	else
		NameStr = "Неизвестный"
		if client:GetPos():DistToSqr(ply:GetPos()) > 562500 then NameStr = "Неизвестный #"..tostring(math.floor(util.SharedRandom(ply:GetName(), 100, 999))) end
		if ply:GetNWBool("IntercomTalking", false) then NameStr = "(INTERCOM) Неизвестный" end
	end
	if LocalPlayer():IsAdmin() and ply != LocalPlayer() then NameStr = NameStr.." ("..ply:Nick()..")" end
  	clr = Color(255,255,255, 240)
  end

	-- The player's name
	NameTxt:SetPos(NameBar:GetTall()+4,H*.25)
	NameTxt:SetAlpha(0)
	NameTxt:SetFont("Jack_VoiceFont")
	NameTxt:SetText(NameStr)
	NameTxt:SetSize(W-NameBar:GetTall()-9,20)
	NameTxt:SetColor(clr)
	NameTxt:SetZPos(8)
	NameTxt:MoveToFront()
	NameBar:MoveToBack()

	-- Hand up-to-face animation



	Jack.Talking[CurID] = NameBar

	return false
end
hook.Add("PlayerStartVoice","Jack's Voice Meter Addon Start",Jack.StartVoice)

function Jack.EndVoice(ply)
	for k,v in pairs(Jack.Talking) do if v.Owner == ply then Jack.Talking[k].fade = true break end end

	if DarkRP and ply == LocalPlayer() then
		hook.Remove("Think", "DarkRP_chatRecipients")
		hook.Remove("HUDPaint", "DarkRP_DrawChatReceivers")
		ply.DRPIsTalking = false
	end

	// More TTT specific stuff
	if (VOICE and VOICE.SetStatus) then
		if IsValid(ply) and not no_reset then
			ply.traitor_gvoice = false
		end

		if ply == LocalPlayer() then
			VOICE.SetSpeaking(false)
		end
	end
end
hook.Add("PlayerEndVoice","Jack's Voice Meter Addon End",Jack.EndVoice)

hook.Add("HUDShouldDraw","Remove old voice cards",function(elem) if elem == "CHudVoiceStatus" || elem == "CHudVoiceSelfStatus" then return false end end)


