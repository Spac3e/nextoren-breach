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

	if all_start < 15 then
		
		classd = {['count'] = math.Round(all_start * 0.37), ['roles'] = BREACH.CONFIG.FACTIONS.CLASSD.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.CLASSD.Spawns}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.23), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - security['count']
	
		medicine = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - medicine['count']
	
		technical = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - technical['count']
	
		print("Класс-Д: "..classd['count'], "СБ: "..security['count'], "Мед: "..medicine['count'], "Тех.: "..technical['count'])
		return {classd, security, medicine, technical}

	elseif all_start < 20 then

		classd = {['count'] = math.Round(all_start * 0.34), ['roles'] = BREACH.CONFIG.FACTIONS.CLASSD.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.CLASSD.Spawns}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - security['count']
	
		scientist = {['count'] = math.Round(all_start * 0.06), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - scientist['count']
	
		medicine = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - medicine['count']
	
		technical = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - technical['count']
	
		print("Класс-Д: "..classd['count'], "СБ: "..security['count'], "Уч: "..scientist['count'], "Мед: "..medicine['count'], "Тех.: "..technical['count'])
		return {classd, security, scientist, medicine, technical}

	elseif all_start < 30 then

		classd = {['count'] = math.Round(all_start * 0.34), ['roles'] = BREACH.CONFIG.FACTIONS.CLASSD.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.CLASSD.Spawns}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.15), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - security['count']
	
		scientist = {['count'] = math.Round(all_start * 0.05), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - scientist['count']
	
		medicine = {['count'] = math.Round(all_start * 0.1), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - medicine['count']
	
		service = {['count'] = math.Round(all_start * 0.04), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - service['count']
	
		cancelar = {['count'] = math.Round(all_start * 0.16), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - cancelar['count']
	
		technical = {['count'] = math.Round(all_start * 0.05), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - technical['count']
	
		logist = {['count'] = math.Round(all_start * 0.07), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - logist['count']
	
		admin = {['count'] = all, ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
	
		print("Класс-Д: "..classd['count'], "СБ: "..security['count'], "Уч: "..scientist['count'], "Мед: "..medicine['count'], "Обслуж.: "..service['count'], "Канцеляр.: "..cancelar['count'], "Тех.: "..technical['count'], "Лог.: "..logist['count'], "Админ.: "..admin['count'])
		return {classd, security, scientist, medicine, service, cancelar, technical, logist, admin}

	else

		classd = {['count'] = math.Round(all_start * 0.34), ['roles'] = BREACH.CONFIG.FACTIONS.CLASSD.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.CLASSD.Spawns}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.15), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - security['count']
	
		scientist = {['count'] = math.Round(all_start * 0.05), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - scientist['count']
	
		medicine = {['count'] = math.Round(all_start * 0.1), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - medicine['count']
	
		service = {['count'] = math.Round(all_start * 0.04), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - service['count']
	
		cancelar = {['count'] = math.Round(all_start * 0.16), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - cancelar['count']
	
		technical = {['count'] = math.Round(all_start * 0.05), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - technical['count']
	
		logist = {['count'] = math.Round(all_start * 0.07), ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
		all = all - logist['count']
	
		admin = {['count'] = all, ['roles'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Roles[0]['roles'], ['spawns'] = BREACH.CONFIG.FACTIONS.FOUNDATION.Spawns}
	
		print("Класс-Д: "..classd['count'], "СБ: "..security['count'], "Уч: "..scientist['count'], "Мед: "..medicine['count'], "Обслуж.: "..service['count'], "Канцеляр.: "..cancelar['count'], "Тех.: "..technical['count'], "Лог.: "..logist['count'], "Админ.: "..admin['count'])
		return {classd, security, scientist, medicine, service, cancelar, technical, logist, admin}

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
    
            BREACH.SetupNormal(ply)
            BREACH.ApplyRole(ply, selected)
            ply:SetPos( spawn )
    
            print( "Спавн "..ply:Nick().." за роль: "..selected['name'] )
        end
    end
end

local function PlayerLevelSorter(a, b)
	if a:GetLevel() > b:GetLevel() then return true end
end

