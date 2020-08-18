groups[] =
{
	{"MikeForce","uns_men_RAR_65_COM"},
	{"SpikeTeam","uns_men_RAR_65_COM"},
	{"ACAV","uns_men_RAR_65_COM"},
	{"GreenHornets","uns_men_RAR_65_COM"}
};

class teams
{
    //["Regular Name", "path to Icon", "Shortname"]
    ACAV[] = {"Armored Cavalry [Ground Support] /loc", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_ACAV_HL.paa", "ACAV /loc"};
    GreenHornets[] = {"Green Hornets [Air Support]/loc", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_Hornets_HL.paa", "Green Hornets /loc"};
    MikeForce[] = {"Mike Force [Infantry]/loc", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_MikeForce_HL.paa", "Mike Force /loc"};
    SpikeTeam[] = {"Spike Team [Special Forces]/loc", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_SpikeTeam_HL.paa", "Spike Team /loc"};
    FAILED[] = {"NO TEAM /loc","\vn\ui_f_vietnam\ui\taskroster\img\icons\vn_icon_task_secondary.paa", "FAILED /loc"};
};

snakebitechance[] = {0.5,1};  // 50% chance to get bit if closer than 1m, 0.1 = 10%
snakebitefrequency[] = {600,300}; // Restrict snakes to biting once every 600s, with another 300s of reduced chance.

dbprefix = "mf_db_";
