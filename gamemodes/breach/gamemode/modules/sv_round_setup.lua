function BREACH.GetRoleTable( all )
	local classd = 0
	local security = 0 --сб
	local scientist = 0  --уч
	local medicine = 0  --мед
	local service = 0  --обслуж (повар и уборщ)
	local cancelar = 0  --канц
	local technical = 0  --инж
	local logist = 0  --логисты
	local admin = 0  --админы

	local all_start = all

	if all_start < 20 then
		
		classd = {['count'] = math.Round(all_start * 0.37), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.23), ['roles'] = BREACH_ROLES.SECURITY.security['roles'], ['spawns'] = SPAWN_SECURITY}
		all = all - security['count']
	
		scientist = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']
		
		print("Класс-Д: "..classd['count'], "СБ: "..security['count'], "Научный Персонал: "..scientist['count'])
		return {classd, security, scientist}
	end
end

function BREACH.SetupPlayers( tab )
    local players = player.GetAll()

    for _, v in ipairs(tab) do
        local inuse = {}
        local spawns = table.Copy( v['spawns'] )
    
        for i = 1, v['count'] do
            local ply = table.Random( players )
    
            local roles = table.Copy( v['roles'] )
            local selected
    
            repeat
                local role = table.remove( roles, math.random( #roles ) )
                inuse[role['name']] = inuse[role['name']] or 0
    
                if role['max'] == 0 or inuse[role['name']] < role['max'] then
                    if role['level'] <= ply:GetLevel() then
                        selected = role
                        break
                    end
                end
            until #roles == 0
    
            if !selected then
                ErrorNoHalt( "Something went wrong! Error code: 003" )
                selected = v['roles'][0]
            end
    
            inuse[selected['name']] = inuse[selected['name']] + 1
    
            table.RemoveByValue( players, ply )
    
            if #spawns == 0 then spawns = table.Copy( v['spawns'] ) end
            local spawn = table.remove( spawns, math.random( #spawns ) )
    
		    ply:SetupNormal()
            ply:ApplyRoleStats(selected)
            ply:SetPos( spawn )
    
            print( "Спавн "..ply:Nick().." за роль: "..selected['name'] )
        end
    end
end

local function PlayerLevelSorter(a, b)
	if a:GetLevel() > b:GetLevel() then return true end
end

