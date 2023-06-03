if(CLIENT) then
  surface.CreateFont("InfoTitle", {
		font = "Verdana",
		size = 32,
		shadow = false
	})

  surface.CreateFont("InfoBody", {
		font = "Verdana",
		size = 20,
		shadow = false
	})

  surface.CreateFont("BroadcastFont", {
		font = "Impact",
		size = 60,
		shadow = true
	})

  COL_WHITE = Color(255, 255, 255, 255)
  COL_ORANGE = Color(255, 100, 0, 255)

  CurrentY = 50
  FirstTime = true

  BroadcastActive = false
  BroadcastText = ""

  function DrawInfoText(text)
    draw.DrawText(text, "InfoBody", 20, CurrentY, COL_WHITE)
    CurrentY = CurrentY + 20
  end

  function DrawInfoCl()
    if LocalPlayer():GetNWBool("AimingAtEntity") and GetConVar("entinfo_enabled"):GetInt() == 1 then
      if FirstTime then
        notification.AddLegacy("Want to disable entity info? Type entinfo_enabled 0 in your console.", NOTIFY_HINT, 5)
      end
      FirstTime = false
      CurrentY = 50
      local ent = LocalPlayer():GetNWEntity("AimingAt")
      if (!ent:IsValid()) then return end
      local pos = ent:GetPos()
      local rot = ent:GetAngles()

      draw.RoundedBox(2, 10, 10, 500, 150, Color(0, 0, 0, 240))
      -- title
      draw.DrawText("Entity: " .. ent:GetClass(), "InfoTitle", 20, 15, COL_WHITE)
      -- other info
      DrawInfoText("Position: " .. math.floor(pos.x) .. ", " .. math.floor(pos.y) .. ", " .. math.floor(pos.z))
      DrawInfoText("Rotation: " .. math.floor(rot.x) .. ", " .. math.floor(rot.y) .. ", " .. math.floor(rot.z))
      DrawInfoText("Model: " .. ent:GetModel())
      DrawInfoText("Health: " .. ent:Health() .. "/" .. ent:GetMaxHealth())
      DrawInfoText("Gravity Multiplier: " .. ent:GetGravity())
    end

    if BroadcastActive then
      draw.DrawText(BroadcastText, "BroadcastFont", ScrW() / 2, ScrH() / 6, COL_WHITE, TEXT_ALIGN_CENTER)
    end
  end

  function EndBcast()
    BroadcastActive = false
  end

  function DisplayBcast(length, client)
    BroadcastText = net.ReadString()
    BroadcastActive = true
    timer.Create("BroadcastLengthTimer", 10, 1, EndBcast)
  end

  CreateClientConVar("entinfo_enabled", "0", true, true)
  hook.Add("HUDPaint", "DrawInfoCl", DrawInfoCl)

  net.Receive("messageBcast", DisplayBcast)
else
  util.AddNetworkString("messageBcast")
  AddCSLuaFile()

  function DrawInfo()
    for k, v in pairs(player.GetAll()) do
      if (!v:GetNWBool("PhysPickup")) then
        local tr = util.GetPlayerTrace(v, v:GetAimVector())
        local trace = util.TraceLine(tr)
        if (!trace.Hit) then v:SetNWBool("AimingAtEntity", false); return end
        if (!trace.HitNonWorld) then v:SetNWBool("AimingAtEntity", false); return end
        local ent = trace.Entity
        v:SetNWEntity("AimingAt", ent)
        v:SetNWBool("AimingAtEntity", true)
      end
    end
  end

  function DrawInfoPhysPickup(ply, ent)
    ply:SetNWBool("PhysPickup", true)
    ply:SetNWEntity("AimingAt", ent)
    ply:SetNWBool("AimingAtEntity", true)
  end

  function DrawInfoPhysDrop(ply, ent)
    ply:SetNWBool("PhysPickup", false)
    ply:SetNWBool("AimingAtEntity", false)
  end

  function Broadcast(ply, cmd, args, str)
    if ply:IsAdmin() then
      net.Start("messageBcast")
        net.WriteString(str)
      net.Broadcast()
    end
  end

  concommand.Add("bcast", Broadcast)

  hook.Add("Think", "EntInfoDraw", DrawInfo)
  hook.Add("PhysgunPickup", "EntInfoDraw", DrawInfoPhysPickup)
  hook.Add("PhysgunDrop", "EntInfoDraw", DrawInfoPhysDrop)
end
