concommand.Add( "heli_test", function( ply, cmd, args )
	    ratio = speed + ratio
	    time = time + FrameTime()
	    self:SetPos(LerpVector(ratio, startpos, endpos))
end )