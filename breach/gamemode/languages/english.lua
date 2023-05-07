english = {}

english.roundtype = "Round type: {type}"
english.preparing = "Prepare, round will start in {num} seconds"
english.round = "Game is live, good luck!"
english.specialround = "This is special round"

english.lang_pldied = "{num} player(s) died"
english.lang_descaped = "{num} Class D(s) escaped"
english.lang_sescaped = "{num} SCP(s) escaped"
english.lang_rescaped = "{num} Researcher(s) escaped"
english.lang_dcaptured = "Chaos Insurgency captured {num} Class D(s)"
english.lang_rescorted = "MTF escorted {num} Researcher(s)"
english.lang_teleported = "SCP - 106 caputred {num} victim(s) to the Pocket Dimension "
english.lang_snapped = "{num} neck(s) were snapped by SCP173"
english.lang_zombies = 'SCP - 049 "cured the disease" {num} time(s) '
english.lang_secret_found = "Secret has been found"
english.lang_secret_nfound = "Secret has not been found"

english.class_unknown = "Unknown"

english.escapemessages = {
	{
		main = "Вы сбежали",
		txt = "Вы сбежали из комплекса за {t} минут, отличная робота!",
		txt2 = "Если Вас эвакуирует МТФ, то это даст больше опыта.",
		clr = Color(237, 28, 63),
	},
	{
		main = "Вы сбежали",
		txt = "Вы сбежали из комплекса за {t} минут, отличная робота!",
		txt2 = "Если Вас эвакуирует Хаос, то это даст больше опыта.",
		clr = Color(237, 28, 63),
	},
	{
		main = "Вы эвакуированы",
		txt = "Вы эвакуировались из комплекса за {t} минут, отличная робота!",
		txt2 = "",
		clr = Color(237, 28, 63),
	},
	{
		main = "Вы сбежали",
		txt = "Вы сбежали из комплекса за {t} минут, отличная робота!",
		txt2 = "",
		clr = Color(237, 28, 63),
	}
}


english.NRegistry = {
	scpready = "You can be selected as SCP in next round",
	scpwait = "You have to wait %s rounds to be able to play as SCP"
}

english.NFailed = "Filed to access NRegistry with key: %s"

english.votefail = "You already voted or you are not allowed to vote!"
english.votepunish = "Vote for punish or forgive %s"
english.voterules = [[
	Write !punish to punish player or !forgive to forgive him
	The victim vote = 5 votes
	Normal player vote = 1 vote
	Additional 3 votes are calculated from spectators average votes
	Remember you can vote only once!
]]
english.punish = "PUNISH"
english.forgive = "FORGIVE"
english.voteresult = "Voting result against %s is... %s"
english.votes = "From %s players %s voted for punish and %s for forgive"
english.votecancel = "Last punish vote was canceled by admin"

english.eq_tip = "ЛКМ - Выбрать | ПКМ - Выкинуть"

--ABILITIES
english.abilities_cd = "CD:"
english.abilities_name_thief = "Thief"
english.abilities_thief = "Steal an item that person holds!"
english.abilities_name_bor = "Knockout" --в английском можно knockout
english.abilities_bor = "Your strong body allows you to knock someone down."
english.abilities_name_hitman = "Disguise"
english.abilities_hitman = "Disguise as a body which you're currently looking at."
english.abilities_name_suiu = "Radar"
english.abilities_suiu = "Show distance to targets."
english.abilities_name_scirecruit = "Recruit"
english.abilities_scirecruit = "Turn Class-D into Scientist."
english.abilities_name_cispy = "Focus"
english.abilities_cispy = "Remember people from Class-D."
english.abilities_name_matilda = "AOE Heal" --AOE Heal
english.abilities_matilda = "Heals people around you."
english.abilities_name_speedwone = "Slow down"
english.abilities_speedwone = "Slow down SCPs around you."
english.abilities_name_hedwig = "Special Vision"
english.abilities_hedwig = "You will start seeing SCPs through walls."
english.abilities_name_feelon = "Anti-SCP mine"
english.abilities_feelon = "Set up Anti-SCP mine."
english.abilities_name_invis = "Invisibility"
english.abilities_invis = "Make yourself and people around you invisible."
english.abilities_name_lomao = "Speed up"
english.abilities_lomao = "Speed up yourself and people around you."
english.abilities_name_shield = "Shield"
english.abilities_shield = "Create shield around you that protects from SCPs."
english.abilities_name_buster = "Boost"
english.abilities_buster = "Boost yourself and people around you."
english.abilities_name_kelen = "Increase damage"
english.abilities_kelen = "Increase the damage against SCPs for people around you."
english.abilities_name_engi = "Turret"
english.abilities_engi = "Set up a turret against SCPs."
english.abilities_name_ntfspec = "Stun"
english.abilities_ntfspec = "Freeze SCP for 6 seconds."
english.abilities_name_ntfcom = "Camera scan"
english.abilities_ntfcom = "Find faction on cameras."
english.abilities_name_cicom = "Give equipment"
english.abilities_cicom = "Recruit Class-D"
english.abilities_name_grucom = "Interrogation"
english.abilities_grucom = "None provided."
english.abilities_name_gocspec = "GOC Teleportation"
english.abilities_gocspec = "Place teleportation device and teleport to it on use."
english.abilities_name_goccom = "Cloak"
english.abilities_goccom = "You become invisible"
english.abilities_name_gocjag = "Shield"
english.abilities_gocjag = "Activate shield to protect yourself and your teammates."
english.abilities_name_skpjager = "Expansive bullets"
english.abilities_skpjager = "You will use expansive bullets."
english.abilities_name_shcom = "Portal"
english.abilities_shcom = "Create a portal that can either teleport you in site or immure you."
english.abilities_name_uiucom = "Intelligence"
english.abilities_uiucom = "Highlight people with enabled radios."
english.abilities_name_uiuspec = "Block the door"
english.abilities_uiuspec = "Block the door for some time."
english.abilities_name_uiuclocker = "Rage"
english.abilities_uiuclocker = "Increases your speed for some time."
english.abilities_name_cotskpsycho = "Last chance"
english.abilities_cotskpsycho = "Regain your health, boost yourself and then die after 30 seconds."

english.starttexts = {



	ROLE_SCP173 = {



		"Вы SCP-173",



		{"Ваша задача сбежать из комплекса",



		"Вы не можете двигаться когда на вас кто то смотрит",



		"Запомните, люди моргают!",



		"Правая кнопка мыши: Ослепить всех вокруг"}



	},



	ROLE_SCP682 = {



		"Вы SCP-682",



		{"Ваша задача сбежать из комплекса",



		"Вы медленный, но ваши удари смертельны",



		"Нажав на правую кнопку вы ускоритесь!",



		"Вы можете ускорится только раз в минуту"}



	},



	ROLE_SCP542 = {



		"Вы SCP-542",



		{"Вы мирный СЦП",



		"Бродя по комплексу вы нашли много разных предметов",



		"которыми вы не прочь поделиться!",



		"некоторые из них полезные, некоторые не очень"}



	},



	ROLE_SCP023 = {



		"Вы SCP-023",



		{"Люди которые хоть раз увидят вас, обрекут себя на смерть",



		"Вы достаточно медленны и уязвимы, но смертельны",



		"Нажав на правую кнопку Вы можете ускорится, но это будет стоить вам здоровья",



		"Будьте аккуратнее!"}



	},



	ROLE_SCP106 = {



		"Вы SCP-106",



		{"Ваша задача сбежать из комплекса",



		"Если вы тронете кого то, он телепортируется",



		"в ваше карманное измерение"}



	},



	qqqqq = {



	"Вы один из специальных ученых!",



	{"Поздравляю, роль довольно интересная, но вам нужно быть осторжным",



	"Ваша способность проста, G - Исцеление по области. Используйте ее с умом!"}



    },



	ROLE_SCP2012 = {



		"Вы SCP-2012",



		{"Ваша задача сбежать из комплекса",



		"Вы можете убивать своим криком",



		"Используйте ваш размер чтобы оставаться!",



		"незаметным и помогайте другим SCP"}



	},

    

    ROLE_USACMD = {



		"Вы Командир Отдела Необычных Проишествий",



		{"Вы командуете вашими бойцами ОНП, основной вашей задачей является",

        "похищение данных с комплекса.",

        "Удачи!"}



	},

    

    ROLE_GoPCMD = {



		"Вы Командир Глобальной Оккультной Коалиции",



		{"Вы командуете вашими бойцами ГОК, основной вашей задачей является",

        "подрыв комплекса.",

        "Удачи!"}



	},

    

    ROLE_CHAOSCMD = {



		"Вы Командир Отряда Повстанцев Хаоса",



		{"Вы командуете вашими бойцами ПХ, основной вашей задачей является",

        "подрыв вертолета и эвакуация Класса-Д.",

        "Удачи!"}



	},

    

    ROLE_NTFCMD = {



		"Вы Командир Nine-Tailed-Fox",



		{"Вы командуете вашими бойцами НТФ, основной вашей задачей является",

        "эвакуация научного персонала, убийство СЦП и т.д.",

        "Удачи!"}



	},



	ROLE_SCP457 = {



		"Вы SCP-457",



		{"Ваша задача сбежать из комплекса",



		"Вы всегда горите",



		"Когда вы подхотите к человеку он начинает гореть"}



	},



	ROLE_SCP049 = {



		"Вы SCP-049",



		{"Ваша задача сбежать из комплекса",



		"Так-же, у вас есть способность вербовать игроков в свои отряды,",



	  "создайте свой отряд зомби и штурмуйте оборону МОГа!"}



	},



	ROLE_CHAOSDESTROYER = {



		"Вы Повстанец-Хаоса Класса Подрывник",



		{"Ваша первостепенная задача это штурм и помощь вашим товарищам",



	  "Обратите внимание, в Вашем снаряжении есть РПГ-7, которая сможет эффективно сбить вертолет МОГа"}



	},

	ROLE_CHAOSJUGGERNAUT = {


	},

	ROLE_UIU_Clocker = {


	},


	ROLE_SCP0492 = {



		"Вы SCP-049-2",



		{"Вероятнее всего, вас заразил SCP-049",



		"Теперь вы служите SCP-049, ваша задача довольно проста: помогать ему любой ценой"}



	},



	ROLE_SCP0082 = {



		"Вы SCP-008-2",



		{"Ваша задача прорвать оборону МОГа и заразить как можно больше людей",



		"У вас есть шанс заразить другого игрока, когда вы его атакуете"}



	},



	ROLE_SCP973 = {



		"Вы SCP 973",



		{"Вы коп",



		"Подходя в упор вы можете ввергнуть людяй в ужас,",



		"от чего в скором времени они умрут, однако в момент вашей атаки Вы станете видимым для окружающих"}



	},



	ROLE_SCP811 = {



		"Вы SCP 811",



		{"Вы можете испускать потоки кислоты",



		"которые мгновенно растворяют все биологические объекты"}



	},



	ROLE_RES = {



		"Вы ученый",



		{"Ваша задача сбежать из комплекса",



		"Вы должны найти МТФ-охранников которые вас спасут",



		"Не забывайте про Класс-Д, он может убить вас!"}



	},



	ROLE_RESS = {



		"Вы Испытатель",



		{"Ваша задача сбежать из комплекса",



		"Вы должны найти МТФ-охранников которые вас спасут",



		"Заметьте, у вас в снаряжении есть перцовый баллончик, который к сожалению вам не поможет"}



	},



	ROLE_MEDIC = {



		"Вы Медик",



		{"Ваша задача сбежать из комплекса",



		"Вы должны найти МТФ-охраников которые вас спасут",



		"Не забывайте про Класс-Д, он может убить вас!",



		"Если у кого то начнется кровотечение, вы можете вылечить его"}



	},



	ROLE_CLASSD = {



		"Вы Класс-Д",



		{"Ваша задача сбежать из комплекса",



		"Вы можете объединиться с другими классами-Д",



		"Ищите ключ-карты и будьте аккуратнее с СЦП и МТФ"}



	},



	ROLE_VETERAN = {



		"Вы ветеран Класс Д",



		{"Ваша задача покинуть комплекс",



		"Вы должны скооперироваться с другими классами-Д",



		"Ищите ключ-карты и будьте аккуратнее с СЦП и МТФ"}



	},



	ROLE_SECURITY = {



		"Вы офицер Службы Безопасности",



		{"Ваша задача найти и эвакуировать всех",



		"ученых которые остались в комплексе",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Слушайте своего командира",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_CSECURITY = {



		"Вы командир Службы Безопасности",



		{"Ваша задача найти и эвакуировать всех",



		"ученых которые остались в комплексе",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Приказывайте своим офицерам и продвигайтесь дальше",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFGUARD = {



		"Вы МОГ Охранник",



		{"Ваша задача найти и эвакуировать всех",



		"ученых которые остались в комплексе",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Слушайте командира и будьте хорошим мальчиком",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFMEDIC = {



		"Вы МОГ Медик",



		{"Ваша задача помогать своим сослуживцам",



		"Если у кого то кровотечение, вы обязаны вылечить его",



		"Слушайте командира и держитесь вместе с командой",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFCHEMIST = {



		"Вы спец. юнит МОГ ",



		{"Ваша задача помогать своим сослуживцам",



		"Слушайте командира и держитесь вместе с командой",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFL = {



		"Вы МОГ Лейтенант",



		{"Ваша задача найти и эвакуировать всех",



		"ученых которые остались в комплексе",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Отдавайте приказы МТФ-Охранникам",



		"Слушайте МТФ Командира и Директора",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFSHOCK = {



		"Вы МОГ Штурмовик",



		{"Ваша задача найти и эвакуировать всех",



		"ученых которые остались в комплексе",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Слушайте МТФ Командира и Директора",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_USA = {



	"Вы сотрудник ОНП",



		{"Ваша цель устранить весь вооруженый персонал",



		"и любого у кого есть оружие",



		"Ученый и Класс-Д могут быть спасены по выбору!"}



	},



	ROLE_SD = {



		"Вы директор комплекса",



		{"Ваша задача давать приказы всему персоналу",



		"Вы обязаны дать приказ Службам Безопасности",



		"Вы должны сделать так, чтобы весь мир не узнал о произошедшем"}



	},



	ROLE_MTFNTF = {



		"Вы отряд Девятихвостая лиса",



		{"Ваша задача эвакуировать",



		"ученых которые остались внутри",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Бегите в комплекс и помогите Службе Безопасности",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFNTF_SNIPER= {



		"Вы отряд Девятихвостая лиса",



		{"Ваша задача эвакуировать",



		"ученых которые остались внутри",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Бегите в комплекс и помогите Службе Безопасности",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_MTFCOM = {



		"Вы МОГ Командир",



		{"Ваша задача найти всех и эвакуировать",



		"ученых которые остались в комплексе",



		"Вы можете убивать класс-Д и СЦП которых вы найдете",



		"Раздавайте приказы чтобы лучше выполнить поставленную задачу",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_CHAOS = {



		"Вы Повстанец Хаоса",



		{"Ваша задача спасти все Классы-Д",



		"Эвакуируйте их на посадочную площадку",



		"Вы можете убивать всех кто будет вам препятствовать"}



	},



	ROLE_CHAOSSPY = {



		"Вы шпион Повстанцев Хаоса",



		{"Ваша задача скрытно уничтожить службу безопасности изнутри",



		"Они не знают о вашей маскировки",



		"Не дайте себя рассекретить",



		"Работайте сообща вместе со своими товарищами"}



	},



	ROLE_CHAOSCOM = {



		"Вы командир Повстанцев Хаоса",



		{"Давайте приказы своим товарищам",



		"Убивайте всех кто вам будет мешать"}



	},



	ROLE_SPEC = {



		"Вы наблюдайте",



		{'Ожидайте начала раунда'}



	},



	ROLE_SCP035 = {



		"Вы SCP-035",



		{"Вы разумный SCP",



		"Вы можете использовать предметы, но как кажется оружие вам не по рукам",



		"Сотрудничайте с Классом-Д или SCP",



		"Изменять режим разговора можно кнопкой H"}



	},



	ROLE_SCP966 = {



		"Вы SCP-966",



		{"Вы лишаете людей сна",



		"Чем ближе вы стоите к человеку, тем больнее ему становиться",



		"Вы невидимы для человеческого глаза",



		"Лишайте людей сна и продвигайтесь к выходу."}



	},



	ROLE_SCP1903 = {



		"Вы SCP-1903",



		{"Вы способны влиять на подсознание человека с помощью галлюцинаций",



		"Чем ближе вы находитесь к вашей жертве, тем дольше она будет испытывать галлюцинации и получать от них урон",



		"Атака на ПКМ - массовый приступ страха, но надо находиться на близкой дистанции к игрокам",



		"РОЛЬ: Саппорт"}



	},



	ROLE_GuardSci = {



	"Вы Охранник Ученых",



		{"Ваша задача сопроводить ученых до охраны",



		"Вы имеете право бить Класс-Д шокером",



		"Спасите всех ученых и выбирайтесь сами",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_GoP = {



	"Вы Оперативник Глобальной Оккультной Коалиции",



		{"Ваша задача уничтожить корень проблемы",



		"Уничтожьте все, что видите",



		"Главное спасение мира!",



		"Цели: ВСЕ."}



	},

	ROLE_GOC_JAG = {

	
	
		},
	



	ROLE_GOCSPY = {



	"Вы Шпион Глобальной Оккультной Коалиции",



		{"Ваша задача найти снаряжение, которая оставила для вас организация",



		"Снаряжение спрятано на просторах комплекса, найти его будет не просто",



		"Пока Вы не нашли свое снаряжение, вы можете сотрудничать с Классом-Д и другими фракциями",



		"Цели: Найти снаряжение -> Найти вход к боеголовке -> Взорвать комплекс"}



	},



	ROLE_VOR = {



	"Вы Класс Д Вор",



		{"Ваш дед научил вас воровать хлеб во время второй мировой войны",



		"Теперь вы можете загонять ученых в угол и отбирать карточку",



		"Главное не спалитесь, как вас учил ваш дед"}



	},



	ClassD_Probitiy = {



	"Класс-Д Проныра",



 		{"Вы провели много времени в заключении",



		"За это время многое произшло и вы раздобыли",



		"фонарик и украли карточку у сотрудника фонда"}



	},
	ClassD_Pron = {



		"Класс-Д Проныра",
	
	
	
			 {"Вы провели много времени в заключении",
	
	
	
			"За это время многое произшло и вы раздобыли",
	
	
	
			"фонарик и украли карточку у сотрудника фонда"}
	
	
	
		},


	ROLE_Killer = {



	"Вы Класс Д Убийца",



		{"Вам удалось найти нож когда вы чистили туалет, но он был поломан",



		"и годен только на один удар",



		"Убить своего обидчика вы сможете, но у вас будет только одна попытка!"}



	},







	ClassD_Bor = {



	"Вы Класс Д Качек",



		{"Пока другие жрали баланду вы подтягивались и отжимались",



		"теперь вы на массе и ваши мускулы удержат пулю",



		"или нет!"}



	},







	ROLE_Sport = {



	"Вы Класс Д Спортсмен",



		{"Несмотря на заключение вы смогли сохранить свою физ. форому",



		"Вы быстрее и выносливее своих сокамерников,",



		"но вам это не поможет"}



	},





	ROLE_SCP939 = {



	"Вы SCP 939",



		{"Вы очень голодны и предпочитаете если убьете",



		"людей сжирать их трупы",



		"Убивайте всех и продвигайтесь к выходу!"}



	},



	ROLE_SCP8602 = {



	"Вы SCP 860-2",



		{"Вы хранитель леса, пришло время уничтожить захватчиков в их же логове",



		"Ваши атаки наносят слабый урон, однако если ваша цель будет стоять рядом со стеной, ударив ее вы вместе с ней отправитесь в лес",



		"где вы сможете легко ее уничтожить!"}



	},



	ROLE_SCP062DE = {



	"Вы SCP 062DE",



		{"Der Wille des Führers muss ausgeführt werden! Angriff",



		"Вы должны отвоевать это место во славу Рейха!",



		"Убивайте всех и продвигайтесь к выходу!"}



	},



	ROLE_SCP076 = {



	"Вы SCP 076-2",



		{"Вы САМУРАЙ, очень быстры и ловки",



		"На вооружении у вас есть Катана и Сюрикен на кнопку R",



		"Убивайте всех и продвигайтесь к выходу!"}



	},



	ROLE_Can = {



		"Вы Класс-Д Каннибал",



		{"Вы сидели в одиночной камере",



		"вы кажется тронулись умом",



		"теперь вы можете поедать трупы",



		"кажется вы больны"}



	},



	ROLE_FARTINHALER = {



	"Вы XyeCoc",



		{"Вы КСАЙКОК, очень быстры и ловки",



		"На вооружении у вас есть Катана и Сюрикен на кнопку R",



		"Убивайте всех и продвигайтесь к выходу!"}



	},



	ROLE_BIO = {



	"Вы оперативник войск химической обороны",



		{"ВЫ оборона всей охране",



		"У вас на вооружении самые опасные гранаты в комплексе",



		"Вы сильнее и быстрее чем все оперативники МОГа",



		"Слушайтесь командира, и используйте с умом ваше снаряжение",



		"Цели: ВСЕ SCP, ВСЕ люди под воздействием книги, Класс-Д."}



	},



	ROLE_DZ = {



	"Информация засекречена",



		{"Внимание!",



		"В этом комплексе произошла авария и наши друзья объекты вырвались на свободу",



		"Будьте аккуратнее с ними",



		"Ваша задача как можно быстрее сопроводить до выхода СЦП объекты убив всех кто стоит на их пути",



		"Цели: ВСЕ кроме SCP"}



	},
	ROLE_DZCMD = {



		"Информация засекречена",
	
	
	
			{"Внимание!",
	
	
	
			"В этом комплексе произошла авария и наши друзья объекты вырвались на свободу",
	
	
	
			"Будьте аккуратнее с ними",
	
	
	
			"Ваша задача как можно быстрее сопроводить до выхода СЦП объекты убив всех кто стоит на их пути",
	
	
	
			"Цели: ВСЕ кроме SCP"}
	
	
	
		},


	ROLE_LEL = {



	"Вы Глава Ученых",



	    {"Ваша задача управлять персоналом",



		"Вы уже передали по диспетчеру о произошедшем",



		"Бегите, спасайтесь, убивайте если надо.",



		"Командуйте персоналом и продвигайтесь к выходу"}



    },



    ROLE_LESSION = {



    "Вы Fellon",



    {"Ваши мины очень сильны против объектов",



	"Ставьте их так, чтобы создать объектам неожиданный сюрприз",



"Так-же, ваша мина обладает способностью отображать жертв мины сквозь стены"}



    },



	ROLE_SCP999 = {



	"Вы SCP-999-2",



		{"Вы можете лечить абсолютно все раны",



		"С кем кооперироваться это далеко ваше дело",



		"Вы можете дружить с персоналом, можете с СЦП",



		"ВЫ мирный объект"}



	},



	ROLE_SCP062FR = {



	"Вы SCP-062-FR",



		{"Сейчас Вы очень слабы, но пожирая плоть своих жертв, вы можете перейти на следующию стадию",



		"Чем больше ваша стадия, тем больше ваша опасность по отношению к людям",



		"Следите за значем в левой части экрана, он показывает, невидим вы или нет",



		"ПКМ - Начать пожирать труп"}



	},



	ROLE_DZDD = {



	"Вы Шпион Длани Змея",



		{"Ваша задача оставшись незамечиным помогать SCP-Объектам",



		"Помогайте им находите своих жертв, открывайте для них двери",



		"В конце раунда Вы сможете сбежать вместе с объектами",



		"Удачи!"}



	},



	ROLE_SCP542 = {



	"Вы SCP-542",



		{"Раньше Вы были доктором",



		"Ваше снаряжение довольно простое, но очень интересное",



		"Атака на человека с помощью ПКМ приведет к тому, что он потеряет над собой контроль",



		"Обычные же атаки дают вам здоровье, может лучше перед штурмом МОГа пойти и съесть побольше Класса-Д?"}



	},


	ROLE_FAT = {
		"Класс Д Жирный",
		{"Вы сотрудник Класса-Д. В детстве вы много ели, из-за чего у вас в взрослом возрасте крайне\nширокая кость. Вы имеете сопротивление к урону, но есть один недостаток. Вы быстро устаёте.\nКооперируйтесь с другими Классами-Д и сбегите!"}
	},


	ROLE_MTFJAG = {



	"Вы оперативник тяжелых войск комплекса",



		{"Ваше оружие самое мощное в комплексе",



		"Броня высокого качества и дает вам сопротивляемость к пулям",



		"У вас есть единственный минус, который может вам помешать - ваша скорость",



		"Но скорость это ладно, вам же никто не запрещает стрелять и у вас есть товарищи",



		"Ваш самый страшный враг - невидимые объекты, по этому у Вас есть эффективное оружие против них",



		"Какое? Это ваш ПНВ, которое должно было проходить испытание, но появился момент",



		"Когда ему придется пройти не просто техническое испытание, а самое настоящие полевое"}



	},



	ROLE_SCP096 = {



	"Вы SCP-096",



		{"Когда на вас смотрит человек вы приходите в бешенство",



		"У вас очень низкая скорость до того, как на вас посмотрит игрок",



		"Пытайтесь быть замеченым, чтобы стать сильнее",



		"Когда вы в ярости, то у вас есть ваншотющий удар!"}



	},



	ROLE_hacker = {



	"Вы Класс-Д Хакер",



		{"У вас есть специальное устройство взламывающие систему фонда",



		"Вам повезло, ибо совсем чуть-чуть и Вы бы уже были обнаружены",



		"Бегите как можно быстрее, откройте оружейку и т.д",



		"Покажите ученым, что Класс-Д это не шутки!"}



	},



	ROLE_Engi = {



	"Вы МОГ Инженер",



		{"Работая над новым прототипом ИИ, Вы создали Турель, которая была на высшем уровне, что могла отличить объекта от обычного человека",



		"И вот, внезапное отключение электричества прервало вашу работу, пора начинать",



		"Постройте оборону, и сделайте вашей турели настоящие боевое крещение, но не забывайте про товарищей",



		"Ваша турель стреляет взрывоопасными патронами, что может создать проблемы для ваших товарищей при бойне!",



		"Сделайте все так, чтобы ваши товарищи не пострадали, а СЦП объекты не прошли внутрь!",



		"Помните, для ВАС главная задача не эвакуация персонала, а постройка обороны!"}



	},



	ROLE_SCP082 = {



	"Вы SCP-082",



		{"Вы добродушный человек, но очень психически неуравновешенный",



		"Вас всячески пытали и не давали свободно жить, обостряя вашу болезнь",



		"Сегодня на вас - обычная одежда, может пригласить персонал выпить чайку?",



		"Нет, лучшее съесть все и вся, и быть сытым и здоровым.",



		"Чем больше людей вы съедите, тем больше у вас будет сил!",



		"Вы очень не любите, когда люди в вас стреляют или применяют какую либо силу!"}



	},



	ROLE_SCP1027 = {



	"Вы SCP-082",



		{"Вы добродушный человек, но очень психически неуравновешенный",



		"Вас всячески пытали и не давали свободно жить, обостряя вашу болезнь",



		"Сегодня на вас - обычная одежда, может пригласить персонал выпить чайку?",



		"Нет, лучшее съесть все и вся, и быть сытым и здоровым.",



		"Чем больше людей вы съедите, тем больше у вас будет сил!",



		"Вы очень не любите, когда люди в вас стреляют или применяют какую либо силу!"}



	},



	ROLE_SPECIALRESS = {



	"Вы Специальный Ученый-Xs",



	    {"Ваша способность обнаруживать всех живых SCP объектов",



	    "Используйте вашу способность с умом и Вы с легкостью выживите до прибытия вертолета!"}



	},



	ROLE_SPECIALRESSSS = {



	"Вы Спедваун",



	    {"Ваша способность замедлять СЦП объектов",



	    "Ваша способность очень поможет другим людям убежать от СЦП объетов!",



			"Рекомендуем помочь другим ученым встретить отряд МОГа"}



	},



	ROLE_SPECIALRESSS = {



	"Вы Специальный Ученый-XX",



	    {"Ваша способность увеличивать урон по SCP-Объектам",



	    "Рекомендуется как можно скорее присоединиться к ближайшему отряду МОГа!"}



	},



	ROLE_SPEEED = {



	"Вы Ломао",



	{"Ваша способность увеличивать скорость всем союзникам в радиусе"}



},



	ROLE_SPECIALRES = {



	"Вы Матильда",



	    {"Ваша способность - лечение людей в небольшом радиусе вокруг себя",



	    "Рекомендуется как можно скорее присоединиться к ближайшему отряду МОГа!"}



	},



	ROLE_SHIELD = {



	"Вы Shieldmeh",



	    {"Ваша способность - создавать защитный купол вокруг союзников",



	    "Ваш купол небесконечный, используйте его с умом! И не двигайтесь на объектов, тогда они смогут зайти в ваш круг!"}



	},



	--ROLE_FOCKYOU = {



	--"Вы Отряд Быстрого Реагирования",



	--	{"Ваша задача как можно быстрее убить объектов",



	--	"Вы должны сдержать основную волну, чтобы помочь персоналу пройти тяжелую зону невредимыми",



	--	"У вас есть товарищи, и вы можете спокойно при подготовке передвигаться по тяжелой зоне",



	--	"Распределитесь, и сделайте так, чтобы эти твари запомнили этот день навсегда!"}



	--},



	ROLE_HOF = {



	"Вы Глава Комплекса",



		{"Ваша задача командывать ВСЕМИ",



		"Кто вас не слушается может быть расстрелян!",



		"Постарайтесь, чтобы весь класс-д был убит и никто не вырвался на свободу",



		"Вы можете проверять все и вся, будьте аккуратнее, за вами охотятся Шпионы Хаоса!"}



	},



	ROLE_SCP638 = {



	"Вы SCP-638",



		{"КРИЧИТЕ КАК УПАВШИЙ ГРОБ",



		"Ваша способность кричать, очень сильно кричать",



		"Ваш крик наносит урон по области и оглушает игроков",



		"Помогайте другим объектам и покиньте как можно скорее комплекс"}



	},



	ROLE_SCP050 = {



	"Вы SCP050-FR",



	    {"Ваша способность создавать туман и скрываться в нем",



		"Специальная способность - создать токсичное облако в котором люди задыхаются"}



	},



	ADMIN = {



		"Вы в Админ-Моде",



		{'Используйте команду "br_admin_mode" чтобы вернуться в след. раунде'}



	},



	ROLE_INFECTD = {



		"Вы Класс-Д",



		{'Это специальный раунд "Заражение"',



		"Вы должны кооперироваться с МОГами, чтобы остановить заражение!",



		"Если вас ударит зомби, Вы станите одним из них"}



	},



	ROLE_INFECTMTF = {



		"Вы МОГ",



		{'Это специальный раунд "Заражение"',



		"Вы должны кооперироваться с Классом Д, чтобы остановить заражение!",



		"Если вас ударит зомби, Вы станите одним из них"}



	},



	ROLE_USSR = {



		"Вы Солдат Красной Армии",



		{"Вы должны одолеть вражеские силы Нацистской Германии",



		"Стреляйте метко и кооперируйтесь с вашими товарищами!"}



	},



	ROLE_NAZI = {



		"Вы Солдат Нацистской Германии",



		{"Уничтожьте Красную Армию",



		"Работайте сообща с вашими сокомандниками!"}



	},



}


english.ROLES = {}







english.ROLES.ADMIN = "ADMIN MODE"



english.ROLES.ROLE_INFECTD = "Класс-Д"



english.ROLES.ROLE_INFECTMTF = "Выживший МОГ"



english.ROLES.ROLE_USSR = "Солдат Кр. Армии"



english.ROLES.ROLE_NAZI = "Солдат Германии"







english.ROLES.ROLE_SPEEED = "Ломао"



english.ROLES.ROLE_SCP173 = "SCP-173"



english.ROLES.ROLE_SCP106 = "SCP-106"



english.ROLES.ROLE_SCP973 = "SCP-973"



english.ROLES.ROLE_SCP096 = "SCP-096"



english.ROLES.ROLE_SCP049 = "SCP-049"



english.ROLES.ROLE_DZDD = "ШДЗ"



english.ROLES.ROLE_SCP2012 = "SCP-2012"



english.ROLES.ROLE_SCP542 = "SCP-542"



english.ROLES.ROLE_SCP457 = "SCP-457"



english.ROLES.ROLE_SCP811 = "SCP-811"



english.ROLES.ROLE_SCP050 = "SCP-050-FR"



english.ROLES.ROLE_SHIELD = "Shieldmeh"



english.ROLES.ROLE_SCP638 = "SCP-638"



english.ROLES.ROLE_SCP1027 = "SCP-1027-RU"



english.ROLES.ROLE_LESSION = "Feelon"

english.ROLES.ROLE_SPECIALRES = "Matilda Moore"



english.ROLES.ROLE_SPECIALRESSSS = "Спедваун"



english.ROLES.ROLE_SPECIALRESS = "Hedwig Kirchmaier"



english.ROLES.ROLE_SPECIALRESSS = "Келен"



english.ROLES.ROLE_SCP062FR = "SCP-062-FR"



english.ROLES.ROLE_SCP082 = "SCP-082"

english.ROLES.ROLE_SCP999 = "SCP-999"


english.ROLES.ROLE_GOCSPY = "Шпион ГОКа"



english.ROLES.ROLE_SCP1903 = "SCP-1903"



english.ROLES.ROLE_SCP062DE = "SCP-062DE"



english.ROLES.ROLE_SCP8602 = "SCP-860-2"


english.ROLES.ROLE_SCP076 = "SCP-076-2"



english.ROLES.ROLE_SCP939 = "SCP-939"



english.ROLES.ROLE_DZ = "Солдат ДЗ"

english.ROLES.ROLE_DZCMD = "Командир ДЗ"


english.ROLES.ROLE_SCP542 = "SCP-542"



english.ROLES.ROLE_USA = "Солдат ОНП"

english.ROLES.ROLE_USACMD = "Командир ОНП"

english.ROLES.ROLE_UIU_Clocker = "Устранитель ОНП"




english.ROLES.ROLE_GoPCMD = "Командир ГОК"

english.ROLES.ROLE_GOC_JAG = "Джаггернаут ГОК"


english.ROLES.ROLE_NTFCMD = "Командир Эпсилон-11"



english.ROLES.ROLE_SCP682 = "SCP-682"



english.ROLES.ROLE_SCP035 = "SCP-035"



english.ROLES.ROLE_SCP966 = "SCP-966"



english.ROLES.ROLE_SCP0492 = "SCP-049-2"



english.ROLES.ROLE_SCP0082 = "SCP-008-2"



english.ROLES.ROLE_RES = "Ученый"



english.ROLES.ROLE_RESS = "Испытатель"







english.ROLES.ROLE_LEL = "Глава Персонала"



english.ROLES.ROLE_GuardSci = "Охранник ученых"



english.ROLES.ROLE_MEDIC = "Медик"



english.ClassD = "Class-D Personnel"
english.SCP = "SCP"
english.SCI = "Scientific Department"
english.SECURITY = "Security Department"
english.GRU = "GRU ''P'' Division"
english.UIU = "Unusual Incidents Unit"
english.SKP = "Sonderkommando für Paranormales"
english.DZ = "Serpent's Hand"
english.Goc = "Global Occult Coalition"
english.QRT = "Quick Response Team"
english.STS = "Special Task Squad"
english.MTF = "Mobile Task Force"
english.NTF = "MTF Epsilon-11 ''Nine Tailed Fox''"
english.Chaos = "Chaos Insurgency"
english.SCI_SPECIAL = "Special Scientists"
english.Cult = "Children of The Scarlet King"

english.ROLES.ROLE_CLASSD = "Класс-Д Персонал"

english.ROLES.ClassD_Pron = "Класс-Д Проныра"


english.ROLES.ROLE_FAT = "Класс-Д Мясистый"



english.ROLES.ROLE_VETERAN = "Класс-Д Ветеран"







english.ROLES.ROLE_SECURITY = "Служба Безопасности"



english.ROLES.ROLE_SPECIALIST = "МОГ Специалист"



english.ROLES.ROLE_HOF = "Глава Комплекса"



english.ROLES.ROLE_MTFJAG = "МОГ Джаггернаут"



english.ROLES.ROLE_VOR = "Класс-Д Вор"



english.ROLES.ClassD_Probitiy = "Класс-Д Пробитый"

english.ROLES.ClassD_Probitiy = "Класс-Д Пробитый"


english.ROLES.ClassD_Bor = "Класс-Д Качок"



english.ROLES.ROLE_hacker = "Класс-Д Хакер"



english.ROLES.ROLE_Sport = "Класс-Д Cпортсмен"



english.ROLES.ROLE_MTFGUARD = "МОГ Охранник"



english.ROLES.ROLE_MTFMEDIC = "МОГ Медик"



english.ROLES.ROLE_Can = "Класс-Д Каннибал"



english.ROLES.ROLE_FARTINHALER = "Класс-Д Водолаз"



english.ROLES.ROLE_MTFL = "МОГ Лейтенант"



english.ROLES.ROLE_Killer = "Класс-Д Убийца"



english.ROLES.ROLE_MTFNTF = "МОГ Эпсилон-11"



english.ROLES.ROLE_MTFCHEMIST = "МОГ Химик"



english.ROLES.ROLE_MTFNTF_SNIPER = "NTF Снайпер"



english.ROLES.ROLE_Engi = "МОГ Инженер"



english.ROLES.ROLE_CSECURITY = "Шеф СБ"



english.ROLES.ROLE_MTFCOM = "МОГ Командир"



english.ROLES.ROLE_SD = "Директор Комплекса"



english.ROLES.ROLE_MTFSHOCK = "МОГ Штурмовик"







english.ROLES.ROLE_CHAOSSPY = "ШПХ"



english.ROLES.ROLE_GoP = "ГОК"



english.ROLES.ROLE_CHAOS = "Солдат ПХ"

english.ROLES.ROLE_CHAOSCMD = "Командир ПХ"

english.ROLES.ROLE_CHAOSDESTROYER = "Подрывник ПХ"

english.ROLES.ROLE_CHAOSJUGGERNAUT = "Джаггернаут ПХ"



english.ROLES.ROLE_SPEC = "Наблюдатель"


english.credits_orig = "Created by:"
english.credits_edit = "Modified and repaired by:"
english.settings = "Settings"
english.updateinfo = "Show changes after update"
english.done = "Ready"
english.repe = "Write br_reset_intro to show intro again"

english.author = "Author"
english.helper = "Assistant"
english.originator = "Collaborator"

english.version_title = "[VAULT] Breach 2.6.0"
english.version = "Alpha Testing Stage"
english.bugs = ""

english.weaponry = {}

english.weaponry["breach_keycard_1"] = "Key-Card Level 1"
english.weaponry["breach_keycard_2"] = "Key-Card Level 2"
english.weaponry["breach_keycard_3"] = "Key-Card Level 3"
english.weaponry["breach_keycard_4"] = "Key-Card Level 4"
english.weaponry["breach_keycard_5"] = "Key-Card Level 5"

english.weaponry["breach_keycard_6"] = "Key-Card Level Omni"
english.weaponry["breach_keycard_7"] = "Key-Card Level O5"
english.weaponry["breach_keycard_crack"] = "Key-Card Level ?"
english.weaponry["breach_keycard_support"] = "Key-Card Level ?"

english.weaponry["breach_keycard_sci_1"] = "Scientist Key-Card Level 1"
english.weaponry["breach_keycard_sci_2"] = "Scientist Key-Card Level 2"
english.weaponry["breach_keycard_sci_3"] = "Scientist Key-Card Level 3"
english.weaponry["breach_keycard_sci_4"] = "Scientist Key-Card Level 4"

english.weaponry["breach_keycard_security_1"] = "Security Key-Card Level 1"
english.weaponry["breach_keycard_security_2"] = "Security Key-Card Level 2"
english.weaponry["breach_keycard_security_3"] = "Security Key-Card Level 3"
english.weaponry["breach_keycard_security_4"] = "Security Key-Card Level 4"

english.weaponry["breach_keycard_guard_1"] = "Guard Key-Card Level 1"
english.weaponry["breach_keycard_guard_2"] = "Guard Key-Card Level 2"
english.weaponry["breach_keycard_guard_3"] = "Guard Key-Card Level 3"
english.weaponry["breach_keycard_guard_4"] = "Guard Key-Card Level 4"

english.weaponry["item_drink_dado_fire"] = "DADO Juice «Carefully, HOT»"
english.weaponry["item_drink_dado_radioactive"] = "DADO Juice «Radiation taste»"
english.weaponry["item_drink_energy"] = "Energy drink"
english.weaponry["item_drink_soda"] = "Soda can"
english.weaponry["item_drink_water"] = "Water can"
english.weaponry["item_drink_coffee"] = "Coffee drink"

english.weaponry["item_eyedrops_1"] = "Eye drops"
english.weaponry["item_eyedrops_2"] = "Improved Eye drops"
english.weaponry["item_eyedrops_3"] = "Experimental Eye drops"

english.weaponry["item_hamburger"] = "Hamburger"

english.weaponry["item_keys"] = "Keys for car"
english.weaponry["item_knife"] = "Pocket knife"

english.weaponry["item_medkit_1"] = "First Aid Kit"
english.weaponry["item_medkit_2"] = "Office Medkit"
english.weaponry["item_medkit_3"] = "Special Care Medkit"
english.weaponry["item_medkit_4"] = "Universal Medkit"
english.weaponry["item_pills"] = "Pills"

english.weaponry["item_nightvision_green"] = "NVG"
english.weaponry["item_nightvision_blue"] = "Improved NVG"
english.weaponry["item_nightvision_red"] = "Thermal NVG"
english.weaponry["item_nightvision_goc"] = "Prototype NVG"
english.weaponry["item_nightvision_white"] = "Prototype NVG"

english.weaponry["item_radio"] = "Radio"
english.weaponry["item_chaos_radio"] = "Unique Radio"

english.weaponry["item_adrenaline"] = "Adrenaline"
english.weaponry["item_syringe"] = "Amplifier"

english.weaponry["item_deffib_medic"] = "Defibrillator"

english.weaponry["item_screwdriver"] = "Screwdriver"
english.weaponry["item_tazer"] = "Stun gun"
english.weaponry["item_toolkit"] = "Toolkit"

english.weaponry["copper_coin"] = "Copper Coin"
english.weaponry["silver_coin"] = "Silver Coin"
english.weaponry["gold_coin"] = "Gold Coin"

english.weaponry["weapon_special_gaus"] = "Gauss"

english.weaponry["br_holster"] = "Hands"

english.weaponry["weapon_flashlight"] = "Flashlight"

english.weaponry["weapon_pass_guard"] = "ID-Card \"Military Personnel\""
english.weaponry["weapon_pass_medic"] = "ID-Card \"Medical Personnel\""
english.weaponry["weapon_pass_sci"] = "ID-Card \"Science Personnel\""

english.weaponry["weapon_breachmelee_crowbar"] = "Crowbar"
english.weaponry["weapon_breachmelee_pipe"] = "Wrench"
english.weaponry["weapon_breachmelee_hammer"] = "Hammer"
english.weaponry["weapon_breachmelee_fireaxe"] = "Fire Axe"

english.weaponry["weapon_cannibal"] = "Action: Cannibalism"
english.weaponry["weapon_checker"] = "Action: Class Check"
english.weaponry["weapon_cqc"] = "Action: Disarm"


english.updates = {
	"english",
	"Update notes",
	"Update notes of version %s are unavailable",
	"Server version",
}

ALLLANGUAGES.english = english
