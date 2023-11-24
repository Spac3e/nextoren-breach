Discord = {
	['webhook'] = "https://discord.com/api/webhooks/1171127358976176178/gAEWltl-ii4_ePoCijhFm3j5AVMqISDgFZ64zrzenXTKNIJ5_g-76V6eWVRPlxH6AzEd",
	['hookname'] = "[BREACH] UIU Informator",
	['readChannelID'] = "1124780502994391214",
	['botToken'] = 'MTEyNDc3MjY0NDY0Mjg4OTcyOA.GMe__i.6RMliOeFBs0HioYrps_EX-wEP8_t14zb_eqsAs',
	["botPrefix"] = "$",
	['debug'] = false,
	['commands'] = {}
}

require("gwsockets")
util.AddNetworkString("!!discord-receive")

Discord.isSocketReloaded = false

if Discord.socket != nil then Discord.isSocketReloaded = true; Discord.socket:closeNow(); end

Discord.socket = Discord.socket or GWSockets.createWebSocket("wss://gateway.discord.gg/?encoding=json", false)
local socket = Discord.socket

local function broadcastMsg(msg)
    print( '[Discord] ' .. msg.author..': '.. msg.content )

    net.Start( '!!discord-receive' )
        net.WriteTable( msg )
    net.Broadcast()
end

local function heartbeat()
    socket:write([[
    {
        "op": 1,
        "d": null
    }
    ]])
end

local function createHeartbeat()
    timer.Create( '!!discord_hearbeat', 10, 0, function()
        heartbeat()
    end )
end

function socket:onMessage( txt )
    local resp = util.JSONToTable( txt )
    if not resp then return end

    if Discord.debug then
        print( '[Discord] Received: ' )
        PrintTable(resp)
    end

    if resp.op == 10 and resp.t == nil then createHeartbeat() end
    if resp.op == 1 then heartbeat() end
    if resp.d then
        if resp.t == 'MESSAGE_CREATE' && resp.d.channel_id == Discord.readChannelID && resp.d.content != '' then
            if resp.d.author.bot == true then return end
            if string.sub( resp.d.content, 0, 1 ) == Discord.botPrefix then
              command = string.sub( resp.d.content, 2 )

              if Discord.commands[command] then Discord.commands[command]() end

              return
            end
            broadcastMsg({
                [ 'author' ] = resp.d.author.username,
                [ 'content' ] = resp.d.content
            })
        end
    end
end

function socket:onError( txt )
    print( '[Discord] Error: ', txt )
end

function socket:onConnected()
	print( '[Discord] connected to Discord server' )
    local req = [[
    {
      "op": 2,
      "d": {
        "token": "]]..Discord.botToken..[[",
        "compress": true,
        "intents": 512,
        "properties": {
          "os": "linux",
          "browser": "gmod",
          "device": "pc"
        },
        "presence": {
          "activities": [{
            "name": "Garry's Mod",
            "type": 0
          }]
        }
      }
    }
    ]]

    heartbeat()
    timer.Simple( 3, function() socket:write(req) end )
end

function socket:onDisconnected()
    print( '[Discord] WebSocket disconnected' )
    timer.Remove( '!!discord_hearbeat' )

    if Discord.isSocketReloaded != true then
        print( '[Discord] WebSocket reload in 5 sec...' )
        timer.Simple( 5, function() socket:open() end )
    end
end

print( '[Discord] Socket init...' )
timer.Simple( 3, function()
    socket:open()
    Discord.isSocketReloaded = false
end )

require("chttp")

local tmpAvatars = {}
-- for bots
tmpAvatars['0'] = 'https://images-ext-2.discordapp.net/external/YwK72LAZl5Vw_SEO2s5NWMwXY4hDB1VJ-aAZqV0fkyo/https/i.pinimg.com/236x/28/29/90/2829903219dd1c4b94e0a3528862a940.jpg'

local IsValid = IsValid
local util_TableToJSON = util.TableToJSON
local util_SteamIDTo64 = util.SteamIDTo64
local http_Fetch = http.Fetch
local coroutine_resume = coroutine.resume
local coroutine_create = coroutine.create
local string_find = string.find

function Discord.send(form) 
	if type( form ) ~= "table" then Error( '[Discord] invalid type!' ) return end

	CHTTP({
		["failed"] = function( msg )
			print( "[Discord] "..msg )
		end,
		["method"] = "POST",
		["url"] = Discord.webhook,
		["body"] = util_TableToJSON(form),
		["type"] = "application/json; charset=utf-8"
	})
end

local function getAvatar(id, co)
	http_Fetch( "https://steamcommunity.com/profiles/"..id.."?xml=1", 
	function(body)
		local _, _, url = string_find(body, '<avatarFull>.*.(https://.*)]].*\n.*<vac')
		tmpAvatars[id] = url

		coroutine_resume(co)
	end, 
	function (msg)
		Error("[Discord] error getting avatar ("..msg..")")
	end )
end

local function formMsg( ply, str )
	local id = tostring( ply:SteamID64() )

	local co = coroutine_create( function() 
		local form = {
			["username"] = ply:Nick(),
			["content"] = str,
			["avatar_url"] = tmpAvatars[id],
			["allowed_mentions"] = {
				["parse"] = {}
			},
		}
		
		Discord.send(form)
	end )

	if tmpAvatars[id] == nil then 
		getAvatar( id, co )
	else 
		coroutine_resume( co )
	end
end

local function playerConnect( ply )
	local steamid64 = util_SteamIDTo64( ply.networkid )

	local co = coroutine_create( function()
		local form = {
			["username"] = Discord.hookname,
			["embeds"] = {{
				["author"] = {
					["name"] = ply.name .. " подключается...",
					["icon_url"] = tmpAvatars[steamid64],
					["url"] = 'https://steamcommunity.com/profiles/' .. steamid64,
				},
				["color"] = 16763979,
				["footer"] = {
					["text"] = ply.networkid,
				},
			}},
			["allowed_mentions"] = {
				["parse"] = {}
			},
		}

		Discord.send(form)
	end)

	if tmpAvatars[steamid64] == nil then 
		getAvatar( steamid64, co )
	else 
		coroutine_resume( co )
	end
end

local function plyFrstSpawn(ply)
	if IsValid(ply) then
		local steamid = ply:SteamID()
		local steamid64 = util_SteamIDTo64( steamid )

		local co = coroutine_create(function()
			local form = {
				["username"] = Discord.hookname,
				["embeds"] = {{
					["author"] = {
						["name"] = ply:Nick() .. " подключился",
						["icon_url"] = tmpAvatars[steamid64],
						["url"] = 'https://steamcommunity.com/profiles/' .. steamid64,
					},
					["color"] = 4915018,
					["footer"] = {
						["text"] = steamid,
					},
				}},
				["allowed_mentions"] = {
					["parse"] = {}
				},
			}

			Discord.send(form)
		end)

		if tmpAvatars[steamid64] == nil then 
			getAvatar( steamid64, co )
		else 
			coroutine_resume( co )
		end
	end
end

local function plyDisconnect(ply)
	local steamid64 = util_SteamIDTo64( ply.networkid )

	local co = coroutine_create(function()
		local form = {
			["username"] = Discord.hookname,
			["embeds"] = {{
				["author"] = {
					["name"] = ply.name .. " отключился",
					["icon_url"] = tmpAvatars[steamid64],
					["url"] = 'https://steamcommunity.com/profiles/' .. steamid64,
				},
				["description"] = '```' .. ply.reason .. '```',
				["color"] = 16730698,
				["footer"] = {
					["text"] = ply.networkid,
				},
			}},
			["allowed_mentions"] = {
				["parse"] = {}
			},
		}

		Discord.send(form)

		tmpAvatars[steamid64] = nil
	end)

	if tmpAvatars[steamid64] == nil then 
		getAvatar( steamid64, co )
	else 
		coroutine_resume( co )
	end

end

hook.Add("PlayerSay", "!!discord_sendmsg", formMsg)
gameevent.Listen( "player_connect" )
hook.Add("player_connect", "!!discord_plyConnect", playerConnect)
hook.Add("PlayerInitialSpawn", "!!discordPlyFrstSpawn", plyFrstSpawn)
gameevent.Listen( "player_disconnect" )
hook.Add("player_disconnect", "!!discord_onDisconnect", plyDisconnect)

local time = os.date("%H:%M:%S - %d/%m/%Y", os.time())
local info = 'Время: '..time..'\n'..'Хост: '..GetHostName().."\n"..'Подключение: '..game.GetIPAddress().."\n"..'Режим '..engine.ActiveGamemode().."\n"..'Карта: '..game.GetMap()

hook.Add("Initialize", "!!discord_srvStarted", function() 
	local form = {
		["username"] = Discord.hookname,
		["embeds"] = {{
			["title"] = "🖥 Сервер Запущен",
			["description"] = info,
			["color"] = 65280
		}}
	}
	Discord.send(form)
	hook.Remove("Initialize", "!!discord_srvStarted")
end)

hook.Add( "ShutDown", "ServerShuttingDown", function()
	local form = {
		["username"] = Discord.hookname,
		["embeds"] = {{
			["title"] = "Сервер выключен",
			["color"] = 16711680
		}}
	}
	Discord.send(form)
end)
