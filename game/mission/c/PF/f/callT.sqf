params["_B","_T","_ID"];
PF_B pushBack _B;
switch(_T)do{
//VIETNAM
	case"vn_pen_village_01.p3d":{[_B,_T,_ID] call PF_vn_e1};
	case"vn_campfire_f.p3d":{[_B,_T,_ID] call PF_vn_e2};
	case"vn_fireplace_f.p3d":{[_B,_T,_ID] call PF_vn_e2};
	case"vn_clothesline_01_short_f.p3d":{[_B,_T,_ID] call PF_vn_e3};
	case"vn_rice_plant_sapling_02.p3d":{[_B,_T,_ID] call PF_vn_e4};
	case"vn_rice_plant_med_02.p3d":{[_B,_T,_ID] call PF_vn_e4};
	//case"vn_rice_plant_med_03.p3d":{[_B,_T,_ID] call PF_vn_e4};
	//case"vn_rice_plant_03.p3d":{[_B,_T,_ID] call PF_vn_e4};
	//case"vn_rice_plant_sapling_03.p3d":{[_B,_T,_ID] call PF_vn_e4};
	case"vn_dyke_10.p3d":{[_B,_T,_ID] call PF_vn_e5};

	default{systemChat format [ "callT Fail: %1 ~ %2 ~ %3" , _b , _t , _id ];};}