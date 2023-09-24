function GetRoleTable( all ) -- для бибязан поясняю, больше игроков, больше шанс на роли мусорки чтобы распределилась роль
	// Если allstart[role] у нас 0 то мы её умножаем на желаемый шанс, число ближе, больше игроков которые могут заспавнится за нее, т.е у могов 0.17 ибо у них максимум 2 солдата
	// в коротких раундах, но! бывает и 1. у ученых до 4 человек, а у дешек до 6
	// Как настроить? ебаш шансы вниз/вверх пока не избавишься от челиков наблюдателей, но еще проверь пару раз на всякий (рестартай раунд!!!)
	// TODO: СЦП Впихнуть
	local classd = 0
	local security = 0 --сб
	local scientist = 0  --уч
	local medicine = 0  --мед
	local service = 0  --обслуж (повар и уборщ)
	local cancelar = 0  --канц
	local technical = 0  --инж
	local logist = 0  --логисты
	local admin = 0  --админы
	local scp = 0 -- SOSUNOKS
	local mtf = 0 -- ULTRA SOSUNOKS

	local all_start = all

	if all_start < 15 then
		
		classd = {['count'] = math.Round(all_start * 0.45), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		scientist = {['count'] = math.Round(all_start * 0.27), ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']

		mtf = {['count'] = math.Round(all_start * 0.17), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']
		
		print("Класс-Д: "..classd['count'], "Уч: "..scientist['count'], "МОГ: "..mtf['count'])
		return {classd, scientist, mtf}

	elseif all_start < 20 then

		classd = {['count'] = math.Round(all_start * 0.34), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH_ROLES.SECURITY.security['roles'], ['spawns'] = SPAWN_SECURITY}
		all = all - security['count']
	
		mtf = {['count'] = math.Round(all_start * 0.17), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']

		scientist = {['count'] = math.Round(all_start * 0.06), ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']
	
		print("Класс-Д: "..classd['count'],"МОГ: "..mtf['count'], "СБ: "..security['count'], "Уч: "..scientist['count'])
		return {classd, security, mtf, scientist}

	elseif all_start < 30 then

		classd = {['count'] = math.Round(all_start * 0.39), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.2), ['roles'] = BREACH_ROLES.SECURITY.security['roles'], ['spawns'] = SPAWN_SECURITY}
		all = all - security['count']
	
		mtf = {['count'] = math.Round(all_start * 0.3), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']

		scientist = {['count'] = math.Round(all_start * 0.1), ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']
	
		print("Класс-Д: "..classd['count'],"МОГ: "..mtf['count'], "СБ: "..security['count'], "Уч: "..scientist['count'])
		return {classd, security, mtf, scientist}

	else

		classd = {['count'] = math.Round(all_start * 0.34), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.15), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - security['count']
	
		scientist = {['count'] = math.Round(all_start * 0.05), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - scientist['count']
	
		medicine = {['count'] = math.Round(all_start * 0.1), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - medicine['count']
	
		service = {['count'] = math.Round(all_start * 0.04), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - service['count']
	
		cancelar = {['count'] = math.Round(all_start * 0.16), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - cancelar['count']
	
		technical = {['count'] = math.Round(all_start * 0.05), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - technical['count']
	
		logist = {['count'] = math.Round(all_start * 0.07), ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - logist['count']
	
		admin = {['count'] = all, ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
	
		print("Класс-Д: "..classd['count'], "СБ: "..security['count'], "Уч: "..scientist['count'], "Мед: "..medicine['count'], "Обслуж.: "..service['count'], "Канцеляр.: "..cancelar['count'], "Тех.: "..technical['count'], "Лог.: "..logist['count'], "Админ.: "..admin['count'])
		return {classd, security, scientist, medicine, service, cancelar, technical, logist, admin}

	end
end

function SetupPlayers( tab )
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