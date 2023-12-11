BREACH.DataBaseSystem = BREACH.DataBaseSystem or {}

require('mysqloo')

DATABASE_HOST = 'localhost'
DATABASE_PORT = 3306
DATABASE_NAME = 'breach'
DATABASE_USERNAME = 'root'
DATABASE_PASSWORD = ''

DB_BREACH = mysqloo.connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)

function BREACH.DataBaseSystem:Connect()
    DB_BREACH.onConnected = function()
        print('[*] BREACH Database successfully connected!')
    end

    DB_BREACH.onConnectionFailed = function(err)
        print('[*] BREACH Database connection failed!', err)
    end

    DB_BREACH:connect()
end

function BREACH.DataBaseSystem:Query(q)
    local query = DB_BREACH:query(q)
    if not query then return end
    query.onData = function(q, d)
        return d
    end
    query.onError = function(db, err)
        error(err)
    end
    query:start()
end

function BREACH.DataBaseSystem:Initialize()
    BREACH.DataBaseSystem:Query([[
        CREATE TABLE IF NOT EXISTS breach_data (
            sid varchar(255),
            level INT,
            exp INT,
            achievements INTEGER,
            hours BIGINT,
            elo INT,
            penalty INT,
            deaths INT
        );
    ]])
end

function BREACH.DataBaseSystem:LoadPlayer(ply, callback)
    if !IsValid(ply) then
        return
    end

	if callback then
        if callback == 'onload' then
            print('fsafsa saffas onload tipo ya hz zachem ono')
        end
        if isfunction(callback) then
            callback()
        end
	end

    --[[BREACH.DataBaseSystem:Query('SELECT level FROM breach_data WHERE sid = "' .. ply:SteamID64() .. '";', function(data)
        if data and data[1] and data[1].level then
            local level = tonumber(data[1].level) or 1
            ply:SetNWInt("PlayerLevel", math.max(1, level))
            print('[*] Player level loaded:', level)
        end
	end)--]]

	CheckPlayerData( ply, "breach_level" )
	ply:SetNLevel( math.max(0, tonumber( ply:GetPData( "breach_level", 0 ) ) ) )
	CheckPlayerData( ply, "breach_exp" )
	ply:SetNEXP( tonumber( ply:GetPData( "breach_exp", 0 ) ) )
	CheckPlayerData(ply, "breach_elo")
	ply:SetElo(tonumber(ply:GetPData("breach_elo", 0)))
	CheckPlayerData(ply, "breach_escapes")
	ply:SetNEscapes(tonumber(ply:GetPData("breach_escapes", 0)))
	CheckPlayerData(ply, "breach_deaths")
	ply:SetNDeaths(tonumber(ply:GetPData("breach_deaths", 0)))
	CheckPlayerData( ply, "breach_penalty" )
	ply:SetPenaltyAmount( tonumber( ply:GetPData( "breach_penalty", 0 ) ) )
end

BREACH.DataBaseSystem:Connect()
BREACH.DataBaseSystem:Initialize()