if(!isServer)exitWith{};
if ( !isNil"PFCrun" ) exitWith {};
PFCrun = true;
if ( isNil "server" ) then
{
	private _cLogic = createCenter sideLogic;
	private _grpLogic = createGroup _cLogic;
	private _logicPos = [worldSize/2,worldSize/2,0];
	server = _grpLogic createUnit [ "LOGIC" , _logicPos , [] , 0 , "can_collide" ];
	server setVehicleVarName "server";
};



waitUntil { !isNil "server" };

server setVariable["civ_t",[]];
server setVariable["civs",[]];
server setVariable["civB",[]];
civB=[];
civRegion="";
civs=[];
ins=[];

waitUntil{ !isNil "ins" };

switch(true)do{
case(toLowerANSI worldName in["altis","chernarus","livonia","malden","stratis"]):{civRegion="Default"};
case(toLowerANSI worldName in["desert","kunduz","takistan","zargabad"]):{civRegion="Arab"};
case(toLowerANSI worldName in["cam_lao_nam","vn_khe_sanh"]):{civRegion="Viet"};
case(toLowerANSI worldName in["n'ziwasogo","tanoa"]):{civRegion="Jungle"};
default{civRegion="Default"};
};



PF_WN = worldName;
waitUntil { !isNil "PF_Houses" };
PF_Civ_Houses = PF_Houses +
[
"Land_vn_hut_mont_02",
"Land_vn_hut_mont_05",
"Land_vn_hut_mont_03",
"Land_vn_hut_mont_01",
"Land_vn_hut_mont_04",
"Land_vn_hut_river_02",
"Land_vn_hut_river_03",
"Land_vn_hut_river_01",
"Land_vn_hut_tower_01",
"Land_vn_hut_tower_03",
"Land_vn_hut_tower_02"
] - ["land_vn_b_tower_01","land_vn_b_trench_bunker_04_01"];



private _dbug = false;
//private _bTypes=["land_vn_market_stalls_01_ep1","land_vn_market_stalls_02_ep1","land_vn_house_l_1_ep1","land_vn_house_l_3_ep1","land_vn_house_l_4_ep1","land_vn_house_l_6_ep1","land_house_l_7_ep1","land_house_l_8_ep1","land_house_l_9_ep1","land_house_k_1_ep1","land_house_k_3_ep1","land_house_k_5_ep1","land_house_k_6_ep1","land_house_k_7_ep1","land_house_k_8_ep1","land_house_c_1_ep1","land_house_c_1_v2_ep1","land_house_c_2_ep1","land_house_c_3_ep1","land_house_c_4_ep1","land_house_c_5_ep1","land_house_c_5_v1_ep1","land_house_c_5_v2_ep1","land_house_c_5_v3_ep1","land_house_c_9_ep1","land_house_c_10_ep1","land_house_c_11_ep1","land_house_c_12_ep1","land_a_villa_ep1","land_a_mosque_small_1_ep1","land_a_mosque_small_2_ep1","land_a_mosque_big_addon_ep1","land_a_mosque_big_hq_ep1","land_ind_fuelstation_build_ep1","land_ind_garage01_ep1","land_ind_coltan_main_ep1","land_ind_oil_tower_ep1"];
//private _sTypes=["land_house_c_4_ep1","land_house_c_12_ep1","land_house_c_9_ep1","land_house_c_3_ep1","land_house_c_2_ep1","land_house_c_1_ep1","land_house_c_1_v2_ep1"];
//private _mkrs=["mkr0","mkr1","mkr2","mkr3","mkr4","mkr5","mkr6","mkr7","mkr8","mkr9","mkr10","mkr11","mkr12","mkr13","mkr14","mkr15","mkr16","mkr17","mkr18","mkr19","mkr20","mkr21","mkr22","mkr23","mkr24","mkr25","mkr26","mkr27","mkr28","mkr29","mkr30","mkr31","mkr32"];
//private _mkrs=allMapMarkers select{_x in _mkrs};
//private _rMkrs = allMapMarkers select {_x in["mkrN","mkrNE","mkrSE","mkrSW"]};
//{_x setMarkerAlpha 0}forEach _rMkrs;



{
	_x params [ [ "_fn" , "" ] , [ "_file" , "" ] ];
	private _code = compileFinal ( preprocessFile _file );
	missionNamespace setVariable [ _fn , _code ];
}forEach[
["civF","s\civ\f\f.sqf"],
["civInit","s\civ\f\z.sqf"],
["civG","s\civ\f\g.sqf"],
["civH","s\civ\f\h.sqf"],
["civU","s\civ\f\u.sqf"],
["civUW","s\civ\f\uW.sqf"],
["civV","s\civ\f\v.sqf"],
["civJihad","s\civ\f\jihad.sqf"],
["civAI","s\civ\f\ai.sqf"],
["civAnim","s\civ\f\anim.sqf"],
["civCall","s\civ\f\call.sqf"]];



waitUntil { !isNil "civCall" };
sleep 1;
0 spawn compileFinal(preprocessFile"s\civ\f\find.sqf");0 spawn compileFinal(preprocessFile"s\civ\f\clean.sqf");
0 execFSM "s\civ\f\civ1.fsm";
//0 execFSM "s\civ\f\civ3.fsm";//All this does is make civs run when it rains; kinda pointless in Vietnam...



//MISSION EH: Punishment for killing unarmed combatants / civilians
addMissionEventHandler [ "EntityKilled" ,
{
	params [ "_man" , "_killer" , "_instigator" ];
	if ( isNull _instigator ) then { _instigator = UAVControl vehicle _killer # 0 };//UAV/UGV player operated road kill
	if ( isNull _instigator ) then { _instigator = _killer };//Player driven vehicle road kill
	if ( isPlayer _killer && { _man isKindOf"SoldierWB" } ) exitWith
	{
		//Teamkill sound
		"faction_blufor_x01_b_safetyregs_EXB_1" remoteExecCall [ "playSound" , _killer ];
	};

	if ( currentWeapon _man isEqualTo "" && { ( toLowerANSI typeOf _man ) isEqualTo "c_soldier_vr_f" } ) then
	{
		if ( vest _man isEqualTo "vn_o_vest_08" ) exitWith {};//V_RebreatherB

		[
			_killer ,
			{
				systemChat format
				[
					"Civilian casualty inflicted by %1! %2" ,
					name _this ,
					""
					// ,
					//if ( count ( server getVariable "intelMarkers" ) > 0 ) then
					//{
					//	"1 clue marker lost."
					//}else{
					//	""
					//}
				]
			}
		] remoteExec [ "call" , 0 , _man ];

/*
	if ( count ( server getVariable "intelMarkers" ) > 0 ) then
	{
		"addItemFailed" remoteExec [ "playSound" , 0 , _man ];
		private _m = selectRandom ( server getVariable"intelMarkers" );
		private _find = (server getVariable"intelMarkers") find _m;
		( server getVariable "intelMarkers" ) deleteAt _find;
		deleteMarker _m;
	};
*/
		if !( isNil{ _man getVariable "FSM" }) then
		{
			private _civs = server getVariable"civs";
			if ( _man in _civs ) then
			{
				( server getVariable "civs" ) deleteAt ( _civs find _man );
			};
			_man setVariable [ "FSM" , nil ];
		};
	};
}];



/*
//Code for players to interact with civilians, need to rewrite
#include "f\actC.sqf"
#include "f\interact.sqf"
if(isDedicated)exitWith{};
sleep 5;
0 call compileFinal(preprocessFile"s\civ\f\actC.sqf");
sleep 2;
0 call compileFinal(preprocessFile"s\civ\f\interact.sqf")
*/