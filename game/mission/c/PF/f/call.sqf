params["_B","_T"];
PF_LB pushBack _B;

if ( isServer ) then
{
	if ( isDedicated ) then
	{
		switch(_T)do
		{
			//ALTIS / MALDEN / STRATIS
			//

			//LIVONIA
			//

			//TANOA
			//

			//MILITARY
			//

			//VIETNAM
			case"land_vn_b_trench_20_01":{[_B,_T] call PF_vn_m14_1};
			case"land_vn_b_trench_90_01":{[_B,_T] call PF_vn_m10_1};
			//default{_B setVariable["PF",nil];_B setVariable["PF_B",nil];PF_LB=PF_LB-[_B];};
			default{};
		};
	} else {
		switch(_T)do
		{
			//ALTIS / MALDEN / STRATIS
			//

			//LIVONIA
			//

			//TANOA
			//

			//MILITARY
			//

			//VIETNAM
			case"land_vn_hootch_02_02":{_B call PF_vn_m1_1};
			case"land_vn_barracks_03_03":{_B call PF_vn_m2_1};
			case"land_vn_hootch_01_11":{_B call PF_vn_m3_1};
			//case"land_vn_barracks_03_01":{_B call PF_vn_m4_1};
			case"land_vn_latrine_01":{_B call PF_vn_m5_1};
			case"land_vn_shower_01":{_B call PF_vn_m6_1};
			case"land_vn_airport_01_terminal_f":{_B call PF_vn_m7_1};
			case"land_vn_hootch_03_02":{[_B,[]] call PFL_vn_oFind;_B call PF_vn_m8_1};
			case"land_vn_b_tower_01":{_B call PF_vn_m1_2};
			//case"land_vn_b_trench_bunker_05_02":{[_B,[]] call PFL_vn_oFind};
			case"land_vn_guardhouse_01":{[_B,_T] call PF_vn_m13_1};
			case"land_vn_b_trench_bunker_05_02":{_B call PF_vn_m12_1};
			case"land_vn_b_trench_bunker_04_01":{_B call PF_vn_m2_2};
			case"land_vn_b_trench_bunker_06_02":{_B call PF_vn_m9_1};
			case"land_vn_b_trench_20_01":{[_B,_T] call PF_vn_m14_1};
			case"land_vn_b_trench_90_01":{[_B,_T] call PF_vn_m10_1};
			case"land_vn_b_foxhole_01":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_b_trench_firing_01":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_b_trench_firing_04":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_b_trench_firing_05":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_barracks_02_01":{[_B,[]] call PFL_vn_oFind};
			case"land_vn_barracks_02_02":{[_B,[11,25,26,33,34,41,42]]call PFL_vn_oFind};
			case"land_vn_quonset_02_01":{[_B,[3]] call PFL_vn_oFind};
			//case"land_vn_hootch_02_03":{[_B,[0]]call PFL_vn_oFind};
			case"land_vn_barracks_03_04":{[_B,[0,1,8]]call PFL_vn_oFind};
			case"land_vn_barracks_04_01":{[_B,[14,15]]call PFL_vn_oFind};
			case"land_vn_barracks_04_02":{[_B,[4,13]]call PFL_vn_oFind};
			default{[_B,[]] call PFL_vn_oFind};
		};
	};
} else {
		switch(_T)do
		{
			//ALTIS / MALDEN / STRATIS
			//

			//LIVONIA
			//

			//TANOA
			//

			//MILITARY
			//

			//VIETNAM
			case"land_vn_hootch_02_02":{_B call PF_vn_m1_1};
			case"land_vn_barracks_03_03":{_B call PF_vn_m2_1};
			case"land_vn_hootch_01_11":{_B call PF_vn_m3_1};
			//case"land_vn_barracks_03_01":{_B call PF_vn_m4_1};
			case"land_vn_latrine_01":{_B call PF_vn_m5_1};
			case"land_vn_shower_01":{_B call PF_vn_m6_1};
			case"land_vn_airport_01_terminal_f":{_B call PF_vn_m7_1};
			case"land_vn_hootch_03_02":{[_B,[]] call PFL_vn_oFind;_B call PF_vn_m8_1};
			case"land_vn_b_tower_01":{_B call PF_vn_m1_2};
			//case"land_vn_b_trench_bunker_05_02":{[_B,[]] call PFL_vn_oFind};
			case"land_vn_guardhouse_01":{[_B,_T] call PF_vn_m13_1};
			case"land_vn_b_trench_bunker_05_02":{_B call PF_vn_m12_1};
			case"land_vn_b_trench_bunker_04_01":{_B call PF_vn_m2_2};
			case"land_vn_b_trench_bunker_06_02":{_B call PF_vn_m9_1};
			case"land_vn_b_foxhole_01":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_b_trench_firing_01":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_b_trench_firing_04":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_b_trench_firing_05":{[_B,_T] call PF_vn_m11_1};
			case"land_vn_barracks_02_01":{[_B,[]] call PFL_vn_oFind};
			case"land_vn_barracks_02_02":{[_B,[11,25,26,33,34,41,42]]call PFL_vn_oFind};
			case"land_vn_quonset_02_01":{[_B,[3]] call PFL_vn_oFind};
			//case"land_vn_hootch_02_03":{[_B,[0]]call PFL_vn_oFind};
			case"land_vn_barracks_03_04":{[_B,[0,1,8]]call PFL_vn_oFind};
			case"land_vn_barracks_04_01":{[_B,[14,15]]call PFL_vn_oFind};
			case"land_vn_barracks_04_02":{[_B,[4,13]]call PFL_vn_oFind};
			default{[_B,[]] call PFL_vn_oFind};
		};
};
	//default{_B setVariable["PF",nil];_B setVariable["PF_B",nil];PF_LB=PF_LB-[_B]}}