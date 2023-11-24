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
	local specials = 0

	local all_start = all

	if all_start < 15 then
		
		scp = {['count'] = 1, ['roles'] = BREACH_ROLES.SCP.scp['roles'], ['spawns'] = SPAWN_SCP_RANDOM}
		all = all - scp['count']

		classd = {['count'] = math.Round(all_start * 0.43) , ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		scientist = {['count'] = math.Round(all_start * 0.26) , ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']

		mtf = {['count'] = math.Round(all_start * 0.19), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']
		
		print("Класс-Д: "..classd['count'], "Уч: "..scientist['count'], "МОГ: "..mtf['count'])
		return {scp, classd, scientist, mtf}

	elseif all_start < 20 then
		scp = {['count'] = 1, ['roles'] = BREACH_ROLES.SCP.scp['roles'], ['spawns'] = SPAWN_SCP_RANDOM}
		all = all - scp['count']

		classd = {['count'] = math.Round(all_start * 0.34) , ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.19), ['roles'] = BREACH_ROLES.SECURITY.security['roles'], ['spawns'] = SPAWN_SECURITY}
		all = all - security['count']
	
		mtf = {['count'] = math.Round(all_start * 0.17), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']

		scientist = {['count'] = math.Round(all_start * 0.17) , ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']
	
		print("Класс-Д: "..classd['count'],"МОГ: "..mtf['count'], "СБ: "..security['count'], "Уч: "..scientist['count'])
		return {scp, classd, security, mtf, scientist}

	elseif all_start < 30 then

		scp = {['count'] = 2, ['roles'] = BREACH_ROLES.SCP.scp['roles'], ['spawns'] = SPAWN_SCP_RANDOM}
		all = all - scp['count']

		classd = {['count'] = math.Round(all_start * 0.37) , ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.19), ['roles'] = BREACH_ROLES.SECURITY.security['roles'], ['spawns'] = SPAWN_SECURITY}
		all = all - security['count']
	
		mtf = {['count'] = math.Round(all_start * 0.21), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']

		scientist = {['count'] = math.Round(all_start * 0.31) , ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']

		specials = {['count'] = 1, ['roles'] = BREACH_ROLES.SPECIAL.special['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - specials['count']
	
		print("Класс-Д: "..classd['count'],"МОГ: "..mtf['count'], "СБ: "..security['count'], "Уч: "..scientist['count'], "Спец.Уч: "..specials['count'])
		return {scp, classd, security, mtf, scientist, specials}
	else

		scp = {['count'] = 3, ['roles'] = BREACH_ROLES.SCP.scp['roles'], ['spawns'] = SPAWN_SCP_RANDOM}
		all = all - scp['count']

		classd = {['count'] = math.Round(all_start * 0.37) , ['roles'] = BREACH_ROLES.CLASSD.classd['roles'], ['spawns'] = SPAWN_CLASSD}
		all = all - classd['count']

		security = {['count'] = math.Round(all_start * 0.19), ['roles'] = BREACH_ROLES.SECURITY.security['roles'], ['spawns'] = SPAWN_SECURITY}
		all = all - security['count']
	
		mtf = {['count'] = math.Round(all_start * 0.21), ['roles'] = BREACH_ROLES.MTF.mtf['roles'], ['spawns'] = SPAWN_GUARD}
		all = all - mtf['count']

		scientist = {['count'] = math.Round(all_start * 0.31) , ['roles'] = BREACH_ROLES.SCI.sci['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - scientist['count']

		specials = {['count'] = 2, ['roles'] = BREACH_ROLES.SPECIAL.special['roles'], ['spawns'] = SPAWN_SCIENT}
		all = all - specials['count']
	
		print("Класс-Д: "..classd['count'],"МОГ: "..mtf['count'], "СБ: "..security['count'], "Уч: "..scientist['count'], "Спец.Уч: "..specials['count'])
		return {scp, classd, security, mtf, scientist, specials}

	end
end

function SetupPlayers( tab )
    local players = player.GetAll()

    for _, v in ipairs(tab) do
		if v['spawns'] == SPAWN_SCP_RANDOM then
			local ply = table.Random( players )
			local SCP = table.Copy( SCPS )
			local scp = GetSCP( table.remove( SCP, math.random( #SCP ) ) )
			scp:SetupPlayer( ply )
			table.RemoveByValue( players, ply )
		else
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
						if ply == nil then return end
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
end

local function PlayerLevelSorter(a, b)
	if a:GetLevel() > b:GetLevel() then return true end
end