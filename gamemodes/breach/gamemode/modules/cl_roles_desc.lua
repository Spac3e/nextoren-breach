BREACH = BREACH || {}
BREACH.Descriptions = BREACH.Descriptions || {}
BREACH.Descriptions.russian = BREACH.Descriptions.russian || {}
BREACH.Descriptions.english = BREACH.Descriptions.english || {}

function BREACH.GetDescription(rolename)

	local mylang = langtouse

	if !mylang then mylang = "english" end

	local langtable = BREACH.Descriptions[mylang]
	if !langtable then
		if mylang == "ukraine" then
			langtable = BREACH.Descriptions.russian
		else
			langtable = BREACH.Descriptions.english
		end
	end

	if !langtable[rolename] and rolename:find("SCP") then
		if mylang == "russian" or mylang == "ukraine" then
			return "Вы - Аномальный SCP-Объект\n\nСкооперируйтесь с другими SCP, убейте всех людей кроме Длани Змей и сбегите!"
		else
			return "You - Are the SCP-Object\n\nCooperate with others SCP, kill everyone except of the Serpent Hands and escape from the Facility!"
		end
	elseif !langtable[rolename] then
		if mylang == "russian" or mylang == "ukraine" then
			return "Вы - "..GetLangRole(rolename).."\n\nВыполняйте свою нынешнюю задачу."
		else
			return "You - "..GetLangRole(rolename).."\n\nComplete your current task."
		end
	else
		return langtable[rolename]
	end

end

// Повстанцы Хаоса

BREACH.Descriptions.russian[ROLES.ROLE_CHAOS] = "Вы - Солдат Повстанцев-Хаоса\n\nСлушайтесь Командира и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_CHAOS] = "You - are the Chaos Insurgency\n\nFollow the orders of your Commander and complete the tasks!"

BREACH.Descriptions.russian[ROLES.ROLE_CHAOSDESTROYER] = "Вы - Подрывник Повстанцев-Хаоса\n\nВы имеете при себе РПГ с двумя снарядми, с помощью которого вы можете подорвать вертолет/врагов, используйте с умом!\n\nСлушайтесь Командира и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_CHAOSDESTROYER] = "You - are the Chaos Insurgency Specialist\n\nYou have a RPG with 2 rounds, use it to explode the helicopter/your enemies, it's your choice!\n\nFollow the orders of your Commander and complete the tasks!"

BREACH.Descriptions.russian[ROLES.ROLE_CHAOSJUGGERNAUT] = "Вы - Тяжеловес Повстанцев-Хаоса\n\nВы имеете при себе скорострельный Пулемет М60 и хорошую броню, убивайте всех врагов на своем пути!\n\nСлушайтесь Командира и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_CHAOSJUGGERNAUT] = "You - are the Chaos Insurgency Juggernaut\n\nYou have a M60 Machine gun and a pretty good armour, kill every enemy you see!\n\nFollow the orders of your Commander and complete the tasks!"

BREACH.Descriptions.russian[ROLES.ROLE_CHAOSCMD] = "Вы - Командир Повстанцев-Хаоса\n\nВы имеете при себе оружие SCAR, своей способностью вы можете выдавать снаряжение Повстанца Хаоса Классу-Д\n\nВыдавайте приказы своим солдатам и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_CHAOSCMD] = "You - are the Chaos Insurgency Commander\n\nYou have a SCAR and ability to give a Chaos uniform to Class-D Personnel\n\nGive the orders to your soldiers and complete the tasks!"

// НТФ

BREACH.Descriptions.russian[ROLES.ROLE_MTFNTF] = "Вы - Солдат НТФ\n\nСлушайтесь Командира и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_MTFNTF] = "You - are the Nine-Tailed Fox Grunt\n\nFollow the orders of your Commander and complete the tasks!"

BREACH.Descriptions.russian[ROLES.ROLE_NTFCMD] = "Вы - Командир НТФ\n\nВыдавайте приказы своим солдатам и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_NTFCMD] = "You - are the Nine-Tailed Fox Commander\n\nyou can't go far from helipad, your objective is to protect the helicopter at all cost!"

// ОНП

BREACH.Descriptions.russian[ROLES.ROLE_USA] = "Вы - Солдат Отдела Необычных Происшествий\n\nСлушайтесь Командира и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_USA] = "You - are the Unusual Incidents Unit Grunt\n\nFollow the orders of your Commander and complete the tasks!"

BREACH.Descriptions.russian[ROLES.ROLE_USACMD] = "Вы - Командир Отдела Необычных Происшествий\n\nВыдавайте приказы своим солдатам и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_USACMD] = "You - are the Unusual Incidents Unit Commander\n\nGive the orders to your soldiers and complete the tasks!"

BREACH.Descriptions.russian[ROLES.ROLE_UIU_Clocker] = "Вы - Устранитель Отдела Необычных Происшествий\n\nВы крайне быстры и опасны, ваш нож крайне хорошо заточен и может пронзить даже SCP\n\nСлушайтесь Командира и Выполняйте задачу!"
BREACH.Descriptions.english[ROLES.ROLE_UIU_Clocker] = "You - are the Unusual Incidents Unit Inflitrator\n\nYou are a fast and dangerous, your knife is extremely sharpened, it even can peice the SCPs\n\nFollow the orders of your Commander and complete the tasks!"


// Глобальная Оккультная Коалация

BREACH.Descriptions.russian[ROLES.ROLE_GoP] = "Вы - Солдат Глобальной Оккультной Коалиции\n\nВзорвите Боеголовку любой ценой!"
BREACH.Descriptions.english[ROLES.ROLE_GoP] = "You - are the Global Occult Coalition Grunt\n\nDetonate the Alpha Warhead at all cost!"

BREACH.Descriptions.russian[ROLES.ROLE_GoPCMD] = "Вы - Командир Глобальной Оккультной Коалиции\n\nВы можете становиться невидимым на некоторое время\n\nВзорвите Боеголовку любой ценой!"
BREACH.Descriptions.english[ROLES.ROLE_GoPCMD] = "You - are the Global Occult Coalition Commander\n\nYou have the ability to become invisible for some time\n\nDetonate the Alpha Warhead at all cost!"

--BREACH.Descriptions.russian[role.Goc_Special] = "Вы - Специалист Глобальной Оккультной Коалиции\n\nВзорвите Боеголовку любой ценой!"
--BREACH.Descriptions.english[role.Goc_Special] = "You - are the Global Occult Coalition Specialist\n\nDetonate the Alpha Warhead at all cost!"

BREACH.Descriptions.russian[ROLES.ROLE_GOC_JAG] = "Вы - Джаггернаут Глобальной Оккультной Коалиции\n\nВы можете призвать специальный щит через который вы сможете простреливтаь, а остальные нет\n\nВзорвите Боеголовку любой ценой!"
BREACH.Descriptions.english[ROLES.ROLE_GOC_JAG] = "You - are the Global Occult Coalition Juggernaut\n\nYou have the ability to enable special shield that you can shoot through, while others can't.\n\nDetonate the Alpha Warhead at all cost!"

// Длань Змей

BREACH.Descriptions.russian[ROLES.ROLE_DZ] = "Вы - Солдат Длани Змей\n\nЗащитите и Эвакуируйте SCP!"
BREACH.Descriptions.english[ROLES.ROLE_DZ] = "You - are the Serpent Hands Grunt\n\nHelp and Evacuate SCPs!"
BREACH.Descriptions.russian[ROLES.ROLE_DZCMD] = "Вы - Командир Длани Змей\n\nУ вас есть специальный телепорт, который может вас телепортировать в случайную точку.\n\nбудьте осторожны, кто знает куда вас забросит..\n\nЗащитите и Эвакуируйте SCP!"
BREACH.Descriptions.english[ROLES.ROLE_DZCMD] = "You - are the Serpent Hands Commander\n\nYou have the ability to summon a portal to random location\n\nbe careful, who know where it will teleport you..\n\nHelp and Evacuate SCPs!"

// СПЕЦ УЧЕНЫЕ

BREACH.Descriptions.russian[ROLES.ROLE_SPECIALRESSS] = "Вы - Спец. Сотрудник Фонда\n\nВы можете повышать урон по СЦП людям близким к вам\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SPECIALRESSS] = "You - are the Spec. Scientist\n\nYou have the ability to increase the Damage to SCP for people nearby\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SPECIALRES] = "Вы - Спец. Сотрудник Фонда\n\nВы можете лечить людей поблизости\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SPECIALRES] = "You - are the Spec. Scientist\n\nYou have the ability to heal people nearby\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SPECIALRESSSS] = "Вы - Спец. Сотрудник Фонда\n\nВы можете замедлить движение SCP поблизости\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SPECIALRESSSS] = "You - are the Spec. Scientist\n\nYou have the ability to slow the movement for the SCPs nearby\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SPEEED] = "Вы - Спец. Сотрудник Фонда\n\nВы можете увеличивать скорость игрокам поблизости\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SPEEED] = "You - are the Spec. Scientist\n\nYou have the ability to increase the speed for the people nearby\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_LESSION] = "Вы - Спец. Сотрудник Фонда\n\nВы можете ставить специальным мины против SCP\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_LESSION] = "You - are the Spec. Scientist\n\nYou have the ability to place special Anti-SCP Mines\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SHIELD] = "Вы - Спец. Сотрудник Фонда\n\nВы можете включить специальный щит против пуль\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SHIELD] = "You - are the Spec. Scientist\n\nYou have the ability to enable special shield against the bullets\n\nCooperate with fellow scientist and guards to escape from the facility!"

--BREACH.Descriptions.russian[role.SCI_SPECIAL_INVISIBLE] = "Вы - Спец. Сотрудник Фонда\n\nВы можете сделать себя и людей поблизости невидимым на время\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
--BREACH.Descriptions.english[role.SCI_SPECIAL_INVISIBLE] = "You - are the Spec. Scientist\n\nYou have the ability to make yourself and people nearby invisible\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SPECIALRESS] = "Вы - Спец. Сотрудник Фонда\n\nБлагодаря вашим очкам, вы можете узнать расположение всех СЦП\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SPECIALRESS] = "You - are the Spec. Scientist\n\nUsing your glasses, you can know where all SCPs are\n\nCooperate with fellow scientist and guards to escape from the facility!"

// УЧЕНЫЕ
// УЧЕНЫЕ

BREACH.Descriptions.russian[ROLES.ROLE_SCI_ASSISTANT] = "Вы - Научный Сотрудник Фонда\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SCI_ASSISTANT] = "You - are the Science Personnel\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_DZ_SPY] = "Вы - Шпион Длани Змей\n\nВы шпион организации \"Длань Змей\" под маскировкой обычного Ученого\n\nЗаберите все возможные СЦП Предметы и помогите живым СЦП выжить и сбежать!"
BREACH.Descriptions.english[ROLES.ROLE_DZ_SPY] = "You - are a Serpent Hands spy\n\nYou are a spy of the organisation \"Serpent Hands\" disguised as a Scientist\n\nTake all SCP Items you can and help other SCP to escape and survive!"

BREACH.Descriptions.russian[ROLES.ROLE_SCI_RES] = "Вы - Научный Сотрудник Фонда\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SCI_RES] = "You - are the Science Personnel\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SCI_TESTER] = "Вы - Научный Сотрудник Фонда\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SCI_TESTER] = "You - are the Science Personnel\n\nCooperate with fellow scientist and guards to escape from the facility!"

--BREACH.Descriptions.russian[role.SCI_Recruiter] = "Вы - Научный Сотрудник Фонда\n\nВы можете превращать Класс-Д в Научный Персонал\n\nКооперируйтесь с другими учеными и Охраниками для побега!"
--BREACH.Descriptions.english[role.SCI_Recruiter] = "You - are the Science Personnel\n\nYou have the ability to turn Class-D to Science Personnel\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SCI_MEDIC] = "Вы - Медик Фонда\n\nЛечите и кооперируйтесь с другими учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SCI_MEDIC] = "You - are the Medic Personnel\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SCI_CLEANER] = "Вы - Уборщик\n\nПока вы чистили дерьмо из унитазов началось Нарушений Условий Содержания\n\nКооперируйтесь с учеными и Охраниками для побега!"
BREACH.Descriptions.english[ROLES.ROLE_SCI_CLEANER] = "You - are the Cleaner\n\nCooperate with fellow scientist and guards to escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SCI_HEAD] = "Вы - Глава Персонала\n\nКомандуйте Научным Персоналом и совершите побег из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SCI_HEAD] = "You - are the Head Of Personnel\n\nCooperate with fellow scientist and guards to escape from the facility!"

// Класс-Д

BREACH.Descriptions.russian[ROLES.ROLE_CLASSD] = "Вы - Сотрудник Класса-Д\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_CLASSD] = "You - are the Class-D Personnel\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_GOCSPY] = "Вы - Шпион ГОК\n\nВы посланный шпион организации \"Глобальная Оккультная Коалиция\" под маскировкой Класса-Д\n\nНайдите форму в Офисной Зоне и активируйте Боеголовку!"
BREACH.Descriptions.english[ROLES.ROLE_GOCSPY] = "You - are the GOC Spy\n\nYou are a special spy of organisation \"Global Occult Coalition\" disguised as a Class-D\n\nFind the uniform in entrance zone and enable the Warhead!"

BREACH.Descriptions.russian[ROLES.ROLE_FARTINHALER] = "Вы сотрудник Д.... В течение долгих лет вы нюхали пердеж качка и жирного, поэтому ваш нос больше не ощущает никакие запахи\n\nКажется, что даже токсичный газ не в силах вас остановить.\n\nИспользуйте это преимущество с умом."
BREACH.Descriptions.english[ROLES.ROLE_FARTINHALER] = "Вы сотрудник Д.... В течение долгих лет вы нюхали пердеж качка и жирного, поэтому ваш нос больше не ощущает никакие запахи\n\nКажется, что даже токсичный газ не в силах вас остановить.\n\nИспользуйте это преимущество с умом."

BREACH.Descriptions.russian[ROLES.ROLE_VOR] = "Вы - Сотрудник Класса-Д\n\nВы довольно проворны, поэтому вы можете воровать предметы у других людей\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_VOR] = "You - are the Class-D Personnel\n\nYou are a thief, so you have good skills to steal items from the players\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_FAT] = "Вы - Сотрудник Класса-Д\n\nУ вас очень широкая кость, что дает Вам ряд преимуществ, но в то же время ряд недостатков\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_FAT] = "You - are the Class-D Personnel\n\nYou are a fatty one, which gives you some advantages and disadvantages\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ClassD_Bor] = "Вы - Сотрудник Класса-Д\n\nВремя вы зря не теряли, и достаточно хорошо подкачались за время в комплексе\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ClassD_Bor] = "You - are the Class-D Personnel\n\nYou didn't waste your time sitting here, so you trained every day to get muscles\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_hacker] = "Вы - Сотрудник Класса-Д\n\nВы довольно умны, и можете взламывать двери своим устройством, который незаметно смастерили\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_hacker] = "You - are the Class-D Personnel\n\nYou are a smart one, you can hack the doors using your tool you secretly made while you was here\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_Can] = "Вы - Сотрудник Класса-Д\n\nПохоже вы слетели с катушек находясь здесь, и теперь вы достаточно безумны что бы съесть даже трупы..\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_Can] = "You - are the Class-D Personnel\n\nLook's like you gone insane while you was here, you are so insane that you could eat a corpse...\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ClassD_Probitiy] = "Вы - Сотрудник Класса-Д\n\nПохоже ваши карманы намного больше чем у остальных\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ClassD_Probitiy] = "You - are the Class-D Personnel\n\nLook's like your pockets are bigger that from the others\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"
BREACH.Descriptions.russian[ROLES.ClassD_Pron] = "Вы - Сотрудник Класса-Д\n\nТайком вы успели украсть Ключ-Карту у сотрудника, пока он не видел\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ClassD_Pron] = "You - are the Class-D Personnel\n\nSecretly you stole the keycard from the scientist, while he wasn't watching\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_Sport] = "Вы - Сотрудник Класса-Д\n\nВы достаточно хороший бегун\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_Sport] = "You - are the Class-D Personnel\n\nYou are a pretty fast runner\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

BREACH.Descriptions.russian[ROLES.ROLE_Killer] = "Вы - Сотрудник Класса-Д\n\nПока вы находились в комплексе, вы смогли смастерить из говна и палок заточку, правда она не особо прочная..\n\nКооперируйтесь с другими Классами-Д для успешного побега из этого комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_Killer] = "You - are the Class-D Personnel\n\nWhile you were in the complex, you were able to make pocket knife out of shit and sticks, although it is not that durable..\n\nCooperate with other Class-D Personnel to successfully escape from the facility!"

// Мобильная Оперативная Группа
BREACH.Descriptions.russian[ROLES.ROLE_MTFGUARD] = "Вы - Охранник Мобильной Оперативной группы, при себе вы имеете Автомат\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFGUARD] = "You - are the Mobile Task Force Grunt\n\nFollow the orders of your commanders and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_MTFMEDIC] = "Вы - Медик Мобильной Оперативной группы, при себе вы имеете Автомат, дефибрилятор и аптечку\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFMEDIC] = "You - are the Mobile Task Force Medic\n\nFollow the orders of your commanders and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_MTFL] = "Вы - Лейтенант Мобильной Оперативной группы, вы ниже всех командиров МОГ по званию\n\nСлушайтесь Командиров выше рангом, выдавайте приказы и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFL] = "You - are the Mobile Task Force Leutenant\n\nFollow the orders of higher rank commanders, give the orders to your Grunts\n\ncomplete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_MTFCHEMIST] = "Вы - Химик Мобильной Оперативной группы, на вас одет химический костюм\n\nПоэтому вам не страшен газ в Легкой Зоне и вы имеете иммунитет к SCP-409\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFCHEMIST] = "You - are the Mobile Task Force Chemist, you are wearing chemical suit\n\nSo you dont fear the gas in the Light Zone, and you have immunity to SCP-409\n\nFollow the orders of your commanders and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_MTFSHOCK] = "Вы - Штурмовик Мобильной Оперативной группы, при себе вы имеете Зажигательную гранату\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFSHOCK] = "You - are the Mobile Task Force ShockTrooper, you have incendiary grenade\n\nFollow the orders of your commanders and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_SPECIALIST] = "Вы - Специалист Мобильной Оперативной группы, при себе вы имеете Автомат \"Blackout\"\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_SPECIALIST] = "You - are the Mobile Task Force Specialist, you have \"Blackout\" Rifle\n\nFollow the orders of your commanders and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_MTFCOM] = "Вы - Командир Мобильной Оперативной группы, вы можете приказывать своим солдатам и Лейтенанту МОГ\n\nСлушайтесь своего Главы Комплекса и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFCOM] = "You - are the Mobile Task Force Commander, you can give orders to the Leutenant and your soldiers\n\nFollow the orders of the Head Of Facility and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_Engi] = "Вы - Инженер Мобильной Оперативной группы, при себе вы имеете Турель\n\nПочините 5 генераторов, разбросанные по всей карты что бы восстановить свет по всему комплексу\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_Engi] = "You - are the Mobile Task Force Engineer, you have the special turret against the SCPs\n\nFix all 5 generators, to recover the light all around the facility\n\nFollow the orders of your commanders and complete your tasks"

BREACH.Descriptions.russian[ROLES.ROLE_HOF] = "Вы - Глава Комплекса\n\nВы можете приказывать любому сотруднику фонда кроме оперативников НТФ\n\nВыполняйте поставленную задачу и по желанию призовите дополнительный Спец. Отряд ОСН"
BREACH.Descriptions.english[ROLES.ROLE_HOF] = "You - are the head of facility\n\nYou can give orders to anyone except of the NTF\n\nComplete your tasks and optionally summon a Spec. Squad STS"

BREACH.Descriptions.russian[ROLES.ROLE_MTFJAG] = "Вы - Тяжеловес Мобильной Оперативной группы, при себе вы имеете Пулемет и броню высокой защиты\n\nВы специальная оборона МОГ с очень сильной защитой\n\nСлушайтесь своего Командира и Выполняйте поставленную задачу"
BREACH.Descriptions.english[ROLES.ROLE_MTFJAG] = "You - are the Mobile Task Force Juggernaut\n\nFollow the orders of your commanders and complete your tasks"

// Служба Безопасности

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYRECRUIT] = "Вы - Рядовой Службы Безопасности\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYRECRUIT] = "You - are the Security Rookie\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYSERG] = "Вы - Сержант Службы Безопасности\n\nВы можете давать приказы Смотрителю СБ и другим Охранникам Службы Безопасности\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYSERG] = "You - are the Security Sergeant\n\nYou can give orders to Security Warden and other Security Staff\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYOFFICER] = "Вы - Офицер Службы Безопасности\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYOFFICER] = "You - are the Security Officer\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYWARDEN] = "Вы - Смотритель Службы Безопасности\n\nВы можете давать приказы Охранникам Службы Безопасности\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYWARDEN] = "You - are the Security Warden\n\nYou can give orders to Security Staff\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYSTORMTROOPER] = "Вы - Штурмовик Службы Безопасности\n\nВ отличие от других охранников, вы имеет полу-автоматическое оружие\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYSTORMTROOPER] = "You - are the Security Shock Trooper\n\nUnlike the others Security Staff, you have the semi-automatic weapon\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYIMV] = "Вы - Специалист Службы Безопасности\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYIMV] = "You - are the Security Specialist\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYCHIEF] = "Вы - Шеф Службы Безопасности\n\nВы можете давать приказы любому сотруднику Службы Безопасности\n\nЗащитите ученых и сбегите с комплекса!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYCHIEF] = "You - are the Security Chief\n\nYou can give orders to every Security Staff\n\nProtect scientists and escape from facility!"

BREACH.Descriptions.russian[ROLES.ROLE_SECURITYSPY] = "Вы - Шпион Повстанцев Хаоса\n\nВы секретный агент Повстанцев-Хаоса под маскировкой сотрудника Службы Безопасности\n\nЭвакуируйте Класс-Д любым возможным способом!"
BREACH.Descriptions.english[ROLES.ROLE_SECURITYSPY] = "You - are the Security Rookie\n\nYou are the Chaos Insurgency secret agent, disguised as a Security Personnel\n\nEvacuate Class-Ds any way possible!"
