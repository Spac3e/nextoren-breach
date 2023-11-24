include("discord/sv_relay.lua")

for _, file in ipairs(file.Find( 'discord/commands/' .. "*", "LUA" )) do
	include("discord/commands/"..file)
end

print("RELAY | READY")