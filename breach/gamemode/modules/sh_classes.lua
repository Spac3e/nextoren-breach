RESEARCHERMODELS = {
"models/cultist/humans/sci/scientist.mdl",
"models/cultist/humans/sci/scientist_female.mdl",
}
SPECIAL1 = {
	"models/cultist/humans/scp_special_scp/special_1.mdl"
}
SPECIAL2 = {
	"models/cultist/humans/scp_special_scp/special_2.mdl"
}
SPECIAL3 = {
	"models/cultist/humans/scp_special_scp/special_3.mdl"
}
SPECIAL4 = {
"models/cultist/humans/scp_special_scp/special_4.mdl"
}
SPECIAL5 = {
"models/cultist/humans/scp_special_scp/special_5.mdl"
}
SPECIAL6 = {
"models/cultist/humans/scp_special_scp/special_6.mdl"
}
SPECIAL7 = {
"models/cultist/humans/scp_special_scp/special_7.mdl"
}
		
NTFMODELS = {
"models/cultist/humans/ntf/ntf.mdl"
}
CHAOSMODELS = {
"models/cultist/humans/chaos/chaos.mdl"
}
GOCMODELS = {
"models/cultist/humans/goc/goc.mdl"
}
USAMODELS = {
"models/cultist/humans/fbi/fbi.mdl"
}
	
	
	
	DZMODELS = {
	
	"models/cultist/humans/dz/dz.mdl"
	
	}
	
	
	
	SECURITYMODELS = {
	
	"models/cultist/humans/security/security.mdl"
	
	}
	
	
	
	GK = {
	
	"models/cultist/humans/mog/head_site.mdl"
	
	}
	
	
	
	JAG = {
	
	"models/cultist/humans/mog/mog_jagger.mdl"
	
	}
	
	
	
	CHLENIST = {
	
	"models/cultist/humans/mog/mog_hazmat.mdl"
	
	}
	
	MTFMODEL = {
	
	"models/cultist/humans/mog/mog.mdl"
	
	}

	
	HEADPERSONNEL = {
	
	"models/cultist/humans/sci/scientist_boss.mdl"
	
	}
	
	
	TOPKEK = {
	
	"models/cultist/humans/class_d/class_d_bor_new.mdl"
	
	}
	
	
	
	TOPFAT = {
	
	"models/cultist/humans/class_d/class_d_fat_new.mdl"
	
	}
	
	TOPHACKER = {
	
	"models/cultist/humans/class_d/class_d_hacker_new.mdl"
	
	}
	
	
CLASSDMODELS = {
	"models/cultist/humans/class_d/class_d.mdl",
	"models/cultist/humans/class_d/class_d_female.mdl",
}
	
	CLASSDMODELSMALES = {
	"models/cultist/humans/class_d/class_d.mdl",
	}
	ALLCLASSES = {
	
		classds = {
	
			name = "Класс Д персонал",
	
			color = Color(255, 130, 0),
	
			roles = {
	
				{name = ROLES.ROLE_CLASSD,
	
				 team = TEAM_CLASSD,
	
				 weapons = {"br_holster"},
	
				 showweapons = {},
	
				ammo = {},
	
				 health = 110,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,
	
				 rsdm = true,

				 level = 0,
	
		   staminascale = 2,
	
				 customcheck = nil,
	
				 flashlight = false,
	
				 max = 64
	
				},
	
				{name = ROLES.ROLE_VOR,
	
				 team = TEAM_CLASSD,
	
				 weapons = {"br_holster", "gm_pickpocket_scp"},
	
				 showweapons = {},
	
				ammo = {},
	
				 health = 100,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,
	
				 level = 5,

				 rsdm = true,
	
				 customcheck = nil,
	
				 flashlight = false,

				 
				 ability = {"Thief", 45, "Украдите у человека предмет который он держит на данный момент!", "nextoren/gui/special_abilities/ability_placeholder.png", false},
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_GOCSPY,
	
				 team = TEAM_GOC,
	
				 weapons = {"br_holster", "breach_keycard_2", "item_knife"},
	
				 showweapons = {"Фонарик", "Заточка", "Сканер"},
	
				ammo = {},
	
				 health = 200,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELSMALES,
	
				 showmodel = nil,
	
				 level = 15,
	
				 customcheck = nil,
	
				 flashlight = false,

				 rsdm = true,
	
				 max = 2
	
				},
	
				{name = ROLES.ROLE_GAY,
	
				 team = TEAM_CLASSD,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Ключ карта Ученого", "Фонарик"},
	
				 ammo = {},
	
				 health = 110,
	
	
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,

				 rsdm = true,
	
				 level = 9,
	
				 customcheck = nil,
	
				 flashlight = false,
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_Killer,
	
				 team = TEAM_CLASSD,
	
				 weapons = {},
	
				 showweapons = {"Нож"},
	
				ammo = {},
	
				 health = 110,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 weapons = {"br_holster", "item_knife"},
	
				 runspeed = 1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,

				 rsdm = true,
	
				 level = 12,
	
				 customcheck = nil,
	
				 flashlight = false,
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_hacker,
	
				 team = TEAM_CLASSD,
	
				 weapons = {},
	
				 showweapons = {"Телефон для взлома"},
	
				ammo = {},
	
				 health = 120,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 weapons = {"br_holster", "hacking_doors"},
	
				 runspeed = 1.2,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = TOPHACKER,
	
				 showmodel = nil,
	
				 level = 8,
	
				 customcheck = nil,
	
				 flashlight = false,
	
				 max = 1
	
				},
	
				{name = ROLES.ROLE_Can,
	
				 team = TEAM_CLASSD,
	
				 weapons = {},
	
				 showweapons = {},
	
				ammo = {},
	
				 health = 50,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 weapons = {"br_holster", "weapon_cannibal"},
	
				 runspeed = 1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,
	
				 level = 6,
	
				 customcheck = nil,
	
				 flashlight = false,

				 rsdm = true,
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_Sport,
	
				 team = TEAM_CLASSD,
	
				 weapons = {},
	
				 showweapons = {},
	
				ammo = {},
	
				 health = 140,
	
				 armor = 0,
	
				 walkspeed = 1.10,
	
				 weapons = {"br_holster"},
	
				 runspeed = 1.30,
	
				 jumppower = 1.5,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,
	
				 level = 19,
	
				 customcheck = nil,
	
				 flashlight = false,

				 rsdm = true,
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_TOPKEK,
	
				 team = TEAM_CLASSD,
	
				 weapons = {},
	
				 showweapons = {},
	
				ammo = {},
	
				 health = 200,
	
				 armor = 0,
	
				 walkspeed = 0.98,
	
				 weapons = {"br_holster"},
	
				 runspeed = 1.02,
	
				 jumppower = 0.87,
	
				 vest = nil,
	
				 models = TOPKEK,
	
				 showmodel = nil,
	
				 level = 4,
	
				 customcheck = nil,
	
				 flashlight = false,

				 ability = {"Бросок", 45, "Вы кидаете на прогиб человека напротив вас.", "nextoren/gui/special_abilities/special_bor_takedown.png", false},
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_FAT,
	
				 team = TEAM_CLASSD,
	
				 weapons = {},
	
				 showweapons = {},
	
				   ammo = {},
	
				 health = 250,
	
				 armor = 0,
	
				 walkspeed = 0.86,
	
				 weapons = {"br_holster", "item_hamburger"},
	
				 runspeed = 0.90,
	
				 jumppower = 0.69,
	
				 vest = nil,
	
				 models = TOPFAT,
	
				 showmodel = nil,
	
				 level = 2,
	
				 customcheck = nil,
	
				 flashlight = false,
	
				 max = 4
	
		 },
	
				{name = ROLES.ROLE_FARTINHALER,
	
				 team = TEAM_CLASSD,
	
				 weapons = {"lods"},
	
				 showweapons = {},
	
				 ammo = {},
	
				 health = 200,
	
				 armor = 50,
	
				 walkspeed = 1.12,
	
				 runspeed = 1.30,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = CLASSDMODELS,
	
				 showmodel = nil,
	
				 level = 800,
	
				 customcheck = nil,
	
				 flashlight = false,
	
				 max = 1
	
				},
	
			}
	
		},
	
		researchers = {
	
			name = "Персонал/Служба Безопасности",
	
			color = Color(66, 188, 244),
	
			roles = {
	
				{name = ROLES.ROLE_RES,
	
				 team = TEAM_SCI,
	
				 weapons = {"br_holster", "weapon_pass_sci", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Ключ карта ученого"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 100,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = RESEARCHERMODELS,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 0,

				 bodygroup = "001",
	
				 max = 36
	
				},
	
				{name = ROLES.ROLE_DZDD,
	
				 team = TEAM_DZ,
	
				 weapons = {"br_holster", "weapon_pass_sci", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Ключ карта ученого"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 180,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.20,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = RESEARCHERMODELS,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 20,

				 bodygroup = "001",
	
				 max = 1
	
				},
	
	
	
				{name = ROLES.ROLE_MEDIC,
	
				 team = TEAM_SCI,
	
				 weapons = {"br_holster", "weapon_pass_medic", "medicmedkit", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Ключ карта ученого", "Аптечка", "Фонарик"},
	
				 ammo = {{"Pistol", 20}},
	
				 health = 125,
	
				 armor = 0,
	
				 walkspeed = 1.1,
	
				 runspeed = 1.15,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = RESEARCHERMODELS,
	
				 showmodel = nil,
	
				flashlight = false,
	
				 level = 4,

				 bodygroup = "010111",
	
				max = 3
	
				},
	
				{name = ROLES.ROLE_RESS,
	
				 team = TEAM_SCI,
	
				 weapons = {"br_holster", "weapon_pass_sci", "weapon_pepperspray", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Ключ карта ученого", "Перцовый баллончик"},
	
				 ammo = {{"Pistol", 20}},
	
				 health = 105,
	
				 armor = 0,
	
	
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = RESEARCHERMODELS,
	
				 showmodel = nil,
	
				flashlight = false,
	
				 level = 2,

				 bodygroup = "021",
	
				max = 3
	
				},
	
				{name = ROLES.ROLE_GuardSci,
	
				 team = TEAM_SCI,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "weapon_stungun", "weapon_flashlight", "item_nvg", "br_keycard_3"},
	
				 showweapons = {"Рация", "Шокер", "Ключ-карта ученого", "ПНВ"},
	
				 ammo = {{"Pistol", 5}},
	
				 health = 150,
	
				 armor = 0,
	
				 walkspeed = 1,
	
	
				 runspeed = 1.01,
	
				 jumppower = 0.9,
	
				 vest = nil,
	
				 models = SECURITYMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = false,
	
				 level = 6,

				 bodygroups = "120004100",
	
				 max = 3,
	
				},
	
				{name = ROLES.ROLE_CSECURITY,
	
				 team = TEAM_SCI,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "weapon_flashlight", "cw_kk_ins2_m1911", "item_nvg", "br_keycard_3"},
	
				 showweapons = {"Радио", "Ключ-карта ученого", "Пистолет M1911", "ПНВ"},
	
				 ammo = {{"Pistol", 20}},
	
				 health = 180,
	
				 armor = 80,
	
				 walkspeed = 0.9,
	
				 runspeed = 0.95,
	
				 jumppower = 0.9,
	
				 vest = nil,
	
				 models = SECURITYMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = false,
	
				 level = 13,
	
				 max = 1,
	
				 sorting = 5,

				 bodygroups = "042110",
	
				 importancelevel = 2
	
				},
	
				{name = ROLES.ROLE_LEL,
	
				 team = TEAM_SCI,
	
				 weapons = {"br_holster", "weapon_pass_sci", "cw_kk_ins2_cstm_cobra", "weapon_flashlight", "wep_jack_job_drpradio", "item_nvg", "br_keycard_4"},
	
				 showweapons = {"Ключ-карта 3 уровня", "Револьвер King Cobra", "Рация", "ПНВ"},
	
				 ammo = {{"Pistol", 7}},
	
				 health = 140,
	
	
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = HEADPERSONNEL,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 21,
	
				 max = 1
	
				}
	
			}
	
		},
	
		security = {
	
			name = "Охрана",
	
			color = Color(0, 100, 255),
	
			roles = {
	
				{name = ROLES.ROLE_MTFGUARD,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "cw_kk_ins2_cstm_mp7", "weapon_flashlight", "br_keycard_5", "item_nightvision_blue"},
	
				 showweapons = {"Ключ карта 3", "Радио", "MP7",},
	
				 ammo = {{"SMG1", 400}},
	
				 health = 120,
	
				 armor = 30,
	
		         walkspeed = 1,
	
				 runspeed = 1.2,
	
				 jumppower = 0.87,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 0,
	
				 max = 3,
	
				 sorting = 0,
	
				 bodygroups = "1110000001",

				 importancelevel = 1
	
				},
	
				{name = ROLES.ROLE_MTFMEDIC,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "medicmedkit", "cw_kk_ins2_cstm_famas", "weapon_flashlight", "br_keycard_5", "item_nvg"},
	
				 showweapons = {"Ключ карта 3", "Радио", "Medkit", "famas"},
	
				 ammo = {{"SMG1", 400}},
	
		   health = 120,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.16,
	
				 jumppower = 0.87,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 2,
	
				 max = 1,
	
				 sorting = 3,

				 skin = 1,

				 bodygroups = "1110000001",
	
				 importancelevel = 1
	
				},
	
				{name = ROLES.ROLE_MTFL,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "cw_kk_ins2_mp5k", "br_keycard_10", "item_nvg"},
	
				 showweapons = {"Kлюч-карта командира", "Рация", "MP5K"},
	
				 ammo = {{"SMG1", 400}},
	
	
	
				 health = 135,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 0.9,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 1,
	
				 max = 1,
	
				 sorting = 4,

				 bodygroups = "01211002",
	
				 importancelevel = 1
	
				},
				{name = ROLES.ROLE_MTFCOM,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "cw_kk_ins2_cstm_scar", "weapon_flashlight", "br_keycard_10"},
	
				 showweapons = {"Ключ-карта командира", "Рация", "SCAR"},
	
				 ammo = {{"AR2", 380}},
	
				 health = 150,
	
	
	
				 armor = 50,
	
				 walkspeed = 1.1,
	
				 runspeed = 1.08,
	
				 jumppower = 0.9,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 10,
	
				 max = 1,
	
				 sorting = 6,

				 bodygroups = "31201",
	
				 importancelevel = 3
	
				},
	
				{name = ROLES.ROLE_MTFSHOCK,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "item_radio", "cw_kk_ins2_cstm_ksg", "weapon_flashlight", "cw_kk_ins2_nade_anm14", "br_keycard_5"},
	
				 showweapons = {"Ключ карта МОГа", "Рация", "Дробовик KSG"},
	
				 ammo = {{"AR2", 380}},
	
	
	
				 health = 180,
	
				 armor = 20,
	
				 walkspeed = 1.1,
	
				 runspeed = 1.17,
	
				 jumppower = 0.9,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 12,
	
				 max = 1,
	
				 sorting = 4,
	
				 importancelevel = 3,

				 bodygroups = "122011110"
	
				},
	
				{name = ROLES.ROLE_Engi,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "engi_torret", "cw_kk_ins2_m40a1", "weapon_flashlight", "br_keycard_5", "item_nvg"},
	
				 showweapons = {"Ключ карта МОГа", "Рация", "Установка турели"},
	
				 ammo = {{"AR2", 60}},
	
	
	
				 health = 140,
	
				 armor = 20,
	
				 walkspeed = 0.9,
	
				 runspeed = 0.94,
	
				 jumppower = 0.9,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 14,
	
				 max = 1,
	
				 sorting = 4,

				 ability = {"Anti-SCP Turret", 1, "Вы ставите турель.", "nextoren/gui/special_abilities/engineer_turret.png", true},

				 ability_max = 1,

				 bodygroups = "4131000001",
	
				 importancelevel = 3
	
				},
	
				{name = ROLES.ROLE_MTFCHEMIST,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "item_cameraview", "cw_kk_ins2_cstm_g36c", "weapon_flashlight", "br_keycard_5"},
	
				 showweapons = {"Ключ карта охраны", "Радио", "Camera View", "G36C"},
	
				 ammo = {{"AR2", 600}},
	
	
	
				 health = 170,
	
				 armor = 50,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 0.92,
	
				 vest = nil,
	
				 models = CHLENIST,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 16,
	
				 max = 2,
	
				 sorting = 1,

				 bodygroups = "1",
	
				 importancelevel = 1
	
				},
	
				{name = ROLES.ROLE_SPECIALIST,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "cw_kk_ins2_cstm_mp5a4", "weapon_sh_electricgrenade", "weapon_sh_percussiongrenade", "weapon_sh_healgrenade", "weapon_sh_cryogrenade", "br_keycard_5"},
	
				 showweapons = {"Ключ карта 3", "Радио", "Medkit", "ACR", "Химические гранаты"},
	
				 ammo = {{"SMG1", 360}},
	
	
	
				 health = 190,
	
				 armor = 70,
	
				 walkspeed = 1.05,
	
				 runspeed = 1.07,
	
				 jumppower = 0.87,
	
				 vest = nil,
	
				 models = MTFMODEL,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 18,
	
				 max = 1,
	
				 sorting = 3,

				 bodygroups = "21201",
	
				 importancelevel = 1
	
				},
	
				{name = ROLES.ROLE_MTFJAG,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "cw_kk_ins2_m249", "br_keycard_5"},
	
				 showweapons = {"Ключ карта 3", "Радио", "M249"},
	
				 ammo = {{"AR2", 850}},
	
	
	
				 health = 310,
	
				 armor = 150,
	
				 walkspeed = 0.8,
	
				 runspeed = 0.82,
	
				 jumppower = 0.8,
	
				 vest = nil,
	
				 models = JAG,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 23,
	
				 max = 1,
	
				 sorting = 1,
	
				 importancelevel = 3
	
				},
	
				{name = ROLES.ROLE_HOF,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "weapon_pass_guard", "wep_jack_job_drpradio", "item_nvg", "br_keycard_6"},
	
				 showweapons = {"Ключ карта 5", "Радио"},
	
				 ammo = {{"AR2", 800}},
	
	
	
				 health = 180,
	
				 armor = 80,
	
				 walkspeed = 1,
	
				 runspeed = 1.16,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = GK,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 26,
	
				 max = 1,
	
				 sorting = 6,
	
				 importancelevel = 3
	
				}
	
			}
	
		},
	
		support = {
	
			name = "Поддержка",
	
			color = Color(29, 81, 56),
	
			roles = {
	
				{name = ROLES.ROLE_MTFNTF,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "cw_kk_ins2_p90", "wep_jack_job_drpradio",  "weapon_flashlight", "br_keycard_ntf", "item_nvg", "cw_kk_ins2_nade_f1"},
	
				 showweapons = {"Командирская КЛЮЧ-КАРТА", "Радио", "P90", "Граната", "ПНВ"},
	
				 ammo = {{"SMG1", 1200}},
	
				 health = 200,
	
	
	
				 armor = 50,
	
				 walkspeed = 1,
	
				 runspeed = 1.12,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = NTFMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 0,

				 bodygroups = "1011111111",
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_NTFCMD,
	
				 team = TEAM_GUARD,
	
				 weapons = {"br_holster", "cw_kk_ins2_m40a1", "wep_jack_job_drpradio",  "weapon_flashlight", "br_keycard_ntf", "item_nvg", "cw_kk_ins2_nade_f1", "cw_kk_ins2_deagle"},
	
				 showweapons = {"Командирская КЛЮЧ-КАРТА", "Радио", "P90", "Граната", "ПНВ"},
	
				 ammo = {{"AR2", 600}, {"pistol", 7*6}},
	
				 health = 180,
	
	
	
				 armor = 35,
	
				 walkspeed = 1,
	
				 runspeed = 1.32,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
		         models = NTFMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 16,

				 ability = {"Cameras Scan", 120, "None Provided", "nextoren/gui/special_abilities/special_ntf_commander.png", false},

				 bodygroups = "1021110111",
	
				 max = 1
	
				},
	
	
	
				{name = ROLES.ROLE_CHAOS,
	
				 team = TEAM_CHAOS,
	
				 weapons = {"br_holster", "cw_kk_ins2_rpk", "cw_kk_ins2_mel_bayonet", "wep_jack_job_drpradio", "weapon_flashlight", "br_keycard_8", "cw_kk_ins2_nade_c4",},
	
				 showweapons = {"Ключ карта 5", "Радио", "RPK", "С4"},
	
				 ammo = {{"AR2", 560}},
	
				 health = 200,
	
				 armor = 80,
	
		   walkspeed = 1,
	
	
	
				 runspeed = 1.15,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = CHAOSMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 0,

                 bodygroups = "0101111",
	
				 max = 3
	
				},
	
				
	
				{name = ROLES.ROLE_CHAOSCMD,
	
				 team = TEAM_CHAOS,
	
				 weapons = {"br_holster", "cw_kk_ins2_akm", "cw_kk_ins2_nade_ied","cw_kk_ins2_at4", "wep_jack_job_drpradio", "weapon_flashlight", "br_keycard_8", "cw_kk_ins2_nade_c4",},
	
				 showweapons = {"Ключ карта 5", "Радио", "RPK", "С4"},
	
				 ammo = {{"AR2", 560}, {"PG-7VM Grenade", 2}},
	
				 health = 189,
	
				 armor = 66,
	
		   walkspeed = 1,
	
	
	
				 runspeed = 1.05,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = CHAOSMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 20,

				 bodygroups = "0001201",
	
				 max = 1
	
				},
	
		  {name = ROLES.ROLE_CHAOSDESTROYER,
	
				 team = TEAM_CHAOS,
	
				 weapons = {"br_holster", "cw_kk_ins2_cstm_spas12", "cw_kk_ins2_nade_molotov", "wep_jack_job_drpradio", "weapon_flashlight", "br_keycard_8", "cw_kk_ins2_rpg", "cw_kk_ins2_rpg"},
	
				 showweapons = {"Ключ карта 5", "RPG", "C4", "Дробовик"},
	
				 ammo = {{"SMG1", 560}},
	
				 health = 220,
	
				 armor = 80,
	
			     walkspeed = 0.9,
		
				 runspeed = 1.2,
	
				 jumppower = 0.90,
	
				 vest = nil,
	
				 models = CHAOSMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 0,

				 bodygroups = "1002001",

				 ability = {"Claymore", 1, "Вы ставите мину на пол.", "nextoren/gui/special_abilities/special_chaos_claymore.png", true},

				 ability_max = 3,

	
				 max = 1
	
				},
	
				{name = ROLES.ROLE_GoP,
	
				 team = TEAM_GOC,
	
				 weapons = {"br_holster",  "wep_jack_job_drpradio",  "cw_cultist_semisniper_arx160", "weapon_ai_scanner", "weapon_flashlight", "br_keycard_9"},
	
				 showweapons = {"Ключ-карта ГОКа", "Рация", "Дубинка", "Скар и сканнер"},
	
				 ammo = {{"Pistol", 800}},
	
	
	
				 health = 240,
	
				 armor = 80,
	
				 walkspeed = 0.92,
	
				 runspeed = 0.96,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = GOCMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 5,
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_GoPCMD,
	
				 team = TEAM_GOC,
	
				 weapons = {"br_holster",  "wep_jack_job_drpradio",  "cw_kk_ins2_nv4", "weapon_ai_scanner", "weapon_flashlight", "br_keycard_9"},
	
				 showweapons = {"Ключ-карта ГОКа", "Рация", "Дубинка", "Скар и сканнер"},
	
				 ammo = {{"AR2", 800}},
	
	
	
				 health = 270,
	
				 armor = 131,
	
				 walkspeed = 0.85,
	
				 runspeed = 0.88,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = GOCMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 14,

				 bodygroups = "33",

				 ability = {"Cloak", 80, "None Provided", "nextoren/gui/special_abilities/special_goc_invisibility.png", false},
	
				 max = 1
	
				},
	
				{name = ROLES.ROLE_USA,
	
				 team = TEAM_USA,
	
				 weapons = {"br_holster",  "wep_jack_job_drpradio", "cw_kk_ins2_cstm_l85", "cw_kk_ins2_nade_m84", "br_keycard_fbi", "item_nvg"},
	
				 showweapons = {"Ключ-карта КПП", "Рация"},
	
				 ammo = {{"AR2", 800}},
	
	
	
				 health = 200,
	
				 armor = 90,
	
				 walkspeed = 1.05,
	
				 runspeed = 1.10,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = USAMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 5,

				 bodygroups = "1001",
	
				 max = 3
	
				},
	
				{name = ROLES.ROLE_USACMD,
	
				 team = TEAM_USA,
	
				 weapons = {"br_holster",  "wep_jack_job_drpradio", "cw_kk_ins2_m4a1", "cw_kk_ins2_nade_m67", "br_keycard_fbi", "item_nvg"},
	
				 showweapons = {"Ключ-карта КПП", "Рация"},
	
				 ammo = {{"SMG1", 800}},
	
	
	
				 health = 215,
	
				 armor = 35,
	
				 walkspeed = 1.05,
	
				 runspeed = 1.25,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = USAMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 7,

				 bodygroups = "2001",

				 ability = {"Intelligence", 45, "None Provided", "nextoren/gui/special_abilities/special_fbi_commander.png", false},
	
				 max = 1
	
				},
	
		  {name = ROLES.ROLE_DZCMD,
	
				 team = TEAM_DZ,
	
				 weapons = {"br_holster",  "wep_jack_job_drpradio", "cw_kk_ins2_mk18", "weapon_flashlight", "br_keycard_8"},
	
				 showweapons = {"???", "Ключ-карта ???", "Информация недоступна", "████████████"},
	
				 ammo = {{"SMG1", 800}},
	
	
	
				 health = 210,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.2,
	
				 jumppower = 0.85,
	
				 vest = nil,
	
				 models = DZMODELS,
	
				 showmodel = nil,
	
				 pmcolor = nil,
	
				 flashlight = true,
	
				 level = 5,

				 bodygroups = "12001",
	
				 max = 4
	
				},
				{name = ROLES.ROLE_DZCMD,
	
				team = TEAM_DZ,
   
				weapons = {"br_holster",  "wep_jack_job_drpradio", "cw_kk_ins2_mk18", "weapon_flashlight", "br_keycard_8"},
   
				showweapons = {"???", "Ключ-карта ???", "Информация недоступна", "████████████"},
   
				ammo = {{"SMG1", 800}},
   
   
   
				health = 210,
   
				armor = 0,
   
				walkspeed = 1,
   
				runspeed = 1.2,
   
				jumppower = 0.85,
   
				vest = nil,
   
				models = DZMODELS,
   
				showmodel = nil,
   
				pmcolor = nil,
   
				flashlight = true,
   
				level = 7,

				ability = {"Portal", 45, "None Provided", "nextoren/gui/special_abilities/special_dz_portal.png", false},

				bodygroups = "12001",
   
				max = 1
   
			   }
	
			}
	
		},
	
		special = {
	
			name = "Сюжетные ученые",
	
			color = Color(238, 130, 238),
	
			roles = {
	
			  {name = ROLES.ROLE_SPECIALRES,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3", "item_nvg"},
	
				 showweapons = {"Специальная способность - Исцеление по области"},
	
				 ammo = {{"Pistol", 20}},
		
				 health = 120,
	
				 armor = 0,
	
				 walkspeed = 0.85,
	
				 runspeed = 0.90,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = SPECIAL4,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 0,

				 ability = {"AOE Heal", 75, "Исцеляет людей в некотором радиусе от вас.", "nextoren/gui/special_abilities/special_heal.png", false},
	
				 max = 1
	
				},
	
	
	
				{name = ROLES.ROLE_SPECIALRESS,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Специальная способность - Обнаружение всех живых СЦП объектов в течении 10 секунд"},
	
				 ammo = {{"Pistol", 20}},
	
				 health = 110,
	
				 armor = 0,
	
				 walkspeed = 0.91,
	
				 runspeed = 0.95,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = SPECIAL2,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 0,

				 ability = {"Special Vision", 60, "Вы начинаете видеть SCP через стены.", "nextoren/gui/special_abilities/spy_chaos_focus.png", false},
	
				 max = 1
	
				},
	
				
	
				{name = ROLES.ROLE_SPECIALRESSSS,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3", "item_nvg"},
	
				 showweapons = {"Специальная способность",  "Замедление SCP-Объектов"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 150,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = SPECIAL3,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 8,

				 ability = {"Slow", 85, "Замедляет SCP в некотором радиусе от вас.", "nextoren/gui/special_abilities/special_slow.png", false},
	
				 max = 1
	
				},
	
				
	
				{name = ROLES.ROLE_SHIELD,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_hexshield_local", "weapon_flashlight", "br_keycard_3"},
	
				 showweapons = {"Специальная способность",  "Защитный купол"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 210,
	
				 armor = 0,
	
				 walkspeed = 0.89,
	
				 runspeed = 0.94,
	
				 jumppower = 0.90,
	
				 vest = nil,
	
				 models = SPECIAL7,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 24,

				 ability = {"Special Shield", 80, "Вы создаёте вокруг себя щит, не пропускающий SCP-объекты.", "nextoren/gui/special_abilities/special_shield.png", false},
	
				 max = 1
	
		 },
	
		 
	
				{name = ROLES.ROLE_SPEEED,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3", "item_nvg"},
	
				 showweapons = {"Специальная способность",  "Ускорение"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 120,
	
				 armor = 0,
	
				 walkspeed = 1.1,
	
				 runspeed = 1.2,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = SPECIAL1,
	
				 showmodel = nil,
	
				 flashlight = false,
	            
				 ability = {"Speed Boost", 45, "Вы делаете себя и людей в радиусе быстрыми.", "nextoren/gui/special_abilities/special_sprint.png", false},
				 
				 level = 10,
	
				 max = 1
	
				},
	
				
	
				{name = ROLES.ROLE_LESSION,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3", "item_nvg"},
	
				 showweapons = {"Специальная способность",  "Мины XCX"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 130,
	
				 armor = 0,
	
				 walkspeed = 0.96,
	
				 runspeed = 1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = SPECIAL6,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 22,

				 ability = {"Anti-SCP mine", 3, "Вы ставите Anti-SCP мину.", "nextoren/gui/special_abilities/special_mine.png", true},

				 ability_max = 3,
	
				 max = 1
	
				},
	
				
	
				{name = ROLES.ROLE_SPECIALRESSS,
	
				 team = TEAM_SPECIAL,
	
				 weapons = {"br_holster", "weapon_flashlight", "br_keycard_3", "item_nvg"},
	
				 showweapons = {"Специальная способность - Увелечение пассивного урона по SCP-Объектам"},
	
				 ammo = {{"Pistol", 20}},
	
	
	
				 health = 210,
	
				 armor = 0,
	
				 walkspeed = 1,
	
				 runspeed = 1.1,
	
				 jumppower = 1,
	
				 vest = nil,
	
				 models = SPECIAL5,
	
				 showmodel = nil,
	
				 flashlight = false,
	
				 level = 19,

				 ability = {"Damage Boost", 75, "Вы увеличиваете урон людям в радиусе, урон по SCP.", "nextoren/gui/special_abilities/special_debuffscp.png", false},
	
				 max = 1
	
				}
	
			}
	
		}
	
	}
	
	
	
	
	
	