GAS_AdminSits_PreventTransmit = GAS_AdminSits_PreventTransmit or {}

local entMeta = FindMetaTable("Entity")

GAS_AdminSits_SetPreventTransmit = GAS_AdminSits_SetPreventTransmit or entMeta.SetPreventTransmit

function entMeta:SetPreventTransmit(ply, preventTransmit)
	local preventDefault = false

	if (IsValid(self) and IsValid(ply) and ply:IsPlayer()) then
		if (preventTransmit) then
			if (not GAS_AdminSits_PreventTransmit[self] or not GAS_AdminSits_PreventTransmit[self][ply]) then
				if (hook.Run("GAS.AdminSits.TransmitStateChanged", self, ply, true) ~= false) then
					GAS_AdminSits_PreventTransmit[self] = GAS_AdminSits_PreventTransmit[self] or {}
					GAS_AdminSits_PreventTransmit[self][ply] = true
				else
					preventDefault = true
				end
			end
		else
			if (GAS_AdminSits_PreventTransmit[self] and GAS_AdminSits_PreventTransmit[self][ply]) then
				if (hook.Run("GAS.AdminSits.TransmitStateChanged", self, ply, false) ~= false) then
					GAS_AdminSits_PreventTransmit[self][ply] = nil
					if (table.IsEmpty(GAS_AdminSits_PreventTransmit[self])) then
						GAS_AdminSits_PreventTransmit[self] = nil
					end
				else
					preventDefault = true
				end
			end
		end
	end

	if (not preventDefault) then return GAS_AdminSits_SetPreventTransmit(self, ply, preventTransmit) end
end