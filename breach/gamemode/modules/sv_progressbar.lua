local mply = FindMetaTable("Player")
util.AddNetworkString("StartBreachProgressBar")
util.AddNetworkString("progressbarstate")
util.AddNetworkString("StopBreachProgressBar")
util.AddNetworkString("progress_bar")

function mply:ProgressBar(display_string, time, icon, target, canmove, startcallback, stopcallback, finishcallback)

    self.ProgressBarData = {
        canmove = canmove == true,
        target = target,
        stop = stopcallback,
        finish = finishcallback
    }

    if isfunction(startcallback) then startcallback() end    

    net.Start("progress_bar")
    net.WriteFloat(time)
    net.WriteString(display_string || "")
    if icon then net.WriteString(icon) end
    net.Send(self)

    timer.Create("progress_bar_"..self:SteamID64(), time, 1, function()

        if isfunction(self.ProgressBarData.finish) then self.ProgressBarData.finish() end
        self.ProgressBarData = nil

    end)

    if canmove != true then
        local uniq = "can_move_think_"..self:SteamID64()
        hook.Add("Think", uniq, function()
            if IsValid(self) and self.ProgressBarData and self.ProgressBarData.canmove != true then
                if self:GetVelocity():Length2D() > 0.25 then
                    self:StopProgressBar()
                    hook.Remove("Think", uniq)
                end
            else
                hook.Remove("Think", uniq)
            end
        end)
    end

    if IsValid(target) then
        local uniq = "target_progress_think_"..self:SteamID64()
        hook.Add("Think", uniq, function()
            if IsValid(self) and self.ProgressBarData and IsValid(self.ProgressBarData.target) then
                if self:GetEyeTrace().Entity != self.ProgressBarData.target then
                    self:StopProgressBar()
                    hook.Remove("Think", uniq)
                end
            else
                hook.Remove("Think", uniq)
            end
        end)
    end

end
