class deaths
{
	class purple_heart
	{
		// KIA while serving in ACAV / Green Hornets
		count = 1;
		required_teams[] = {"ACAV","GreenHornets"};
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
		// requires 1 death while a member of  ACAV / Green Hornets
	};
	class rvn_wound_medal
	{
		// KIA while operating in Mike Force / Spike team
		count = 1;
		required_teams[] = {"MikeForce","SpikeTeam"};
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
		// requires 1 death while a member of  Mike Force / Spike team
	};

	class distinguished_service_cross
	{
		// KIA while carrying or dragging a wounded comrade. Award levels for repeated actions.
		count = 1;
		required_code = "_player getVariable ['vn_revive_dragging',false]";
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 2}, // Bronze Oak Leaf Cluster
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 3}  // Silver Oak Leaf Cluster
		};
	};

};

class revives
{
	class vietnam_gallantry_cross
	{
		// Conducted 20 revives per level of award
		count = 20;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 40}, // "Bronze Palm",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 60}, //"Bronze Star",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 80}, //"Silver Star",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 100}, //"Gold Star",
		};
	};

};

class zonesentered
{
	class rvn_defense_medal
	{
		// Entered an active zone
		count = 1;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};
};

class kills
{
	class combat_infantryman_badge
	{
		// 1 kill
		count = 1;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};
	class bronze_star
	{
		// 1 kill
		required_teams[] = {"ACAV","MikeForce","SpikeTeam"};
		count = 150;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 150}
		};
	};
	class silver_star
	{
		// 1 kill
		required_teams[] = {"ACAV","MikeForce","SpikeTeam"};
		count = 300;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 300}
		};
	};
	class air_medal
	{
		// 300 kills GreenHornets
		required_teams[] = {"GreenHornets"};
		count = 300;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 300}
		};
	};
	class distinguished_service_order
	{
		// 500 kills
		count = 500;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 500}
		};
	};
	class congressional_medalofhonor
	{
		// 500 kills
		count = 500;
		required_code = "_player getVariable ['vn_mf_revives',0] > 100 && _player getVariable ['vn_mf_zonescaptured',0] > 5 && _player getVariable ['vn_mf_taskscomplete',0] > 100 && _player getVariable ['vn_mf_supporttaskscomplete',0] > 50";
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 500}
		};
	};


};


class atoakills
{
	class air_cross_of_gallantry
	{
		// 10 air to air kills
		required_teams[] = {"GreenHornets"};
		count = 10;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20},// "Silver Wing",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30} // "Gold Wing"
		};
	};
};

class taskscomplete
{
	class vietnam_tet_campaign_commemorative_medal
	{
		// 1 Primary objective completed
		count = 1;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};
	class rvn_special_service_medal
	{
		// 10 Primary objective completed
		count = 10;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10}
		};
	};
	class national_defense_service_medal
	{
		// 30 Primary objective completed
		count = 30;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30}
		};
	};
};

class teamtaskscomplete
{
	class distinguished_flying_cross
	{
		// Completion of 5 GH team tasks generates each level of award
		required_teams[] = {"GreenHornets"};
		count = 5;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 5},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10}, //"1x Bronze Oak Leaf Cluster",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 15}, //"2x Bronze Oak Leaf Cluster",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20}, //"3x Bronze Oak Leaf Cluster",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 25}, //"Silver Oak Leaf Cluster"
		};
	};
	class army_commendation_medal
	{
		// Completion of 20 (secondary) Team tasks
		required_teams[] = {"ACAV","SpikeTeam","MikeForce"};
		count = 20;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20}
		};
	};
	class air_force_good_conduct_medal
	{
		// Completion of 20 (secondary) Team tasks
		required_teams[] = {"GreenHornets"};
		count = 20;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20}
		};
	};
	class air_force_cross
	{
		// Completion of 10 Team tasks at specified rank
		required_teams[] = {"GreenHornets"};
		count = 10;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10, "rank _player isEqualTo 'CAPTAIN'"},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20, "rank _player isEqualTo 'MAJOR'"}, 	// Bronze Oak Leaf Cluster
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30, "rank _player isEqualTo 'COLONEL'"} 	// Silver OLC
		};
	};
	class special_operations_medal
	{
		// Completion of 1 Team Task
		required_teams[] = {"MikeForce","SpikeTeam"};
		count = 1;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};
	class army_presidential_unit_citation
	{
		// Completion of 30 Spike Team tasks
		required_teams[] = {"SpikeTeam"};
		count = 30;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30}
		};
	};

	class usaf_outstanding_unit_award
	{
		// Completion of 30 GH Team tasks
		required_teams[] = {"GreenHornets"};
		count = 30;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30}
		};
	};
	class meritorious_unit_citation
	{
		// Completion of 30 Team tasks
		required_teams[] = {"MikeForce", "ACAV"};
		count = 30;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30}
		};
	};
};


class supplytaskscomplete
{
	class meritorious_service_medal
	{
		// 10 air to air kills
		required_teams[] = {"ACAV","GreenHornets"};
		count = 10;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10}
		};
	};
};


class supporttaskscomplete
{
	class joint_service_commendation_medal
	{
		// Completion of 5 support tasks
		count = 5;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 5}
		};
	};
	class legion_of_merit
	{
		// Completion of 25 support tasks
		count = 25;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 25}
		};
	};
};

class zonescaptured
{
	class vietnam_service_medal
	{
		// A new bronze star for being present when each zone is completed
		count = 1;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 2}, // "Metal2",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 3}, // "Metal3",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 4}, // "Metal4",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 5}, // "Metal5",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 6}, // "Metal6",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 7}, // "Metal7",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 8}, // "Metal8",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 9}, // "Metal9",
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10}, // "Metal10"
		};
	};
	class republic_of_vietnam_campaign_medal
	{
		// present when 5 zones were completed
		count = 5;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 5}
		};
	};
};

class boatkills
{
	class gulf_of_tonkin_vietnam_commemorative_medal
	{
		// Destruction of 5 enemy boats
		count = 5;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 5}
		};
	};
	class navy_cross
	{
		// Destruction of 10 enemy boats
		count = 10;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 10},
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 20, "rank _player isEqualTo 'CAPTAIN'"}, 	// Silver Star
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 30, "rank _player isEqualTo 'MAJOR'"} 	// Silver OLC
		};
	};
};

class rank
{
	class rvn_training_service_medal
	{
		// Achieving LT rank in Mike Force/ Spike Team
		required_teams[] = {"MikeForce","SpikeTeam"};
		count = 1;
		required_code = "rank _player isEqualTo 'LIEUTENANT'";
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};
	class rvn_technical_service_medal
	{
		// Achieving LT rank in ACAV Team
		required_teams[] = {"ACAV"};
		count = 1;
		required_code = "rank _player isEqualTo 'LIEUTENANT'";
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};

};

class hqdestroyed
{
	class rvn_military_merit_first_republic_medal
	{
		// Completed destruction of VC HQ task
		count = 1;
		levels[] =
		{
			{"\vn\ui_f_vietnam\ui\taskroster\img\medal_placeholder.paa", 1}
		};
	};
};

/* TODO
	RVN Civil Action Unit Citation

*/
