/*	AUTHOR: Phronk
	OBJECT FINDER
	Description: Spawns local AI on objects in buildings.
	Params: [ _buildingObject , _arrayOfExcludedIndexes ]
	Example: [ _b , [ 2,7,8 ] ] call PFL_vn_oFind;


	TODO:
		• Adjust position of agent, based on animation & model *
		• Vary offset & direction facing also, based on animation & model *
		• Music and radio chatter coming from radios *
		• Medical bay / morgue / dead bodies / wounded
		• Supply
		• Only spawn VR block when absolutely necessary (based on animation played)

*/



isNil{params[ "_b" , "_exclude" ];
_b setVariable["PF",[]];
private _bDir = getDir _b;

	private _eh =
	{
		params [ "_a" ];
		_a addEventHandler [ "AnimDone" ,
		{
			params["_a","_an"];
			_a switchMove _an;
		}];
	};




private _fiSel =
{

	private _arr =
	[
	"vn_ch_mod_c",
	"vn_bar_01_campchair_01",
	"vn_b_prop_cot_01",
	"vn_b_prop_cot_02",
	"vn_us_common_bench_01",
	"vn_bar_01_lawnchair_01",
	"vn_radio",
	"vn_b_prop_fmradio_01",
	"vn_b_prop_prc77_01"
	];
	
	private _fi = _arr findIf{ _x in _this };
	
	[ _arr#_fi , (_fi > -1) , _fi ];
};

private _selections = ( selectionNames _b ) select { ( ( _x call _fiSel ) # 1 ) };

private _selections = if ( count _selections > 1 ) then
{
	_selections - ( _exclude apply { ( _selections # _x ) } );
} else {
	_selections
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private _anim =
{
	//TODO: Also return X, Y, and Z offset changes based on animation & mdl
	params [ "_bType" , "_mdl" ];
	
	private _chair =
	[
		"CoDriver_Van_02",
		"gunner01_vtol01_vehicle",
		"gunner02_vtol01_vehicle",
		"passenger_generic01_foldhands",
		"passenger_apc_generic01",
		"passenger_apc_generic02",
		"passenger_apc_generic03",
		"passenger_apc_generic04",
		"passenger_apc_generic04still",
		"passenger_apc_narrow_generic01",
		"passenger_apc_narrow_generic02",
		"passenger_apc_narrow_generic03",
		"passenger_apc_narrow_generic03still",
		"Passenger_Van_02_Transport_Middle_3",
		"passenger_VAN_codriver02",
		"Passenger_Van_02_Transport_Left_1",
		"Passenger_Van_02_Transport_Left_2",
		"Passenger_Van_02_Transport_Left_3",
		"Passenger_Van_02_Transport_Right_1",
		"Passenger_Van_02_Transport_Right_2",
		"Passenger_Van_02_Transport_Right_3",
		"passenger_inside_3_Idle_Unarmed_Idling",
		"passenger_inside_7_Idle_Unarmed_Idling",
		"passenger_inside_8_Idle_Unarmed_Idling",
		"vn_passenger_inside_4_Idle_Unarmed_Idling"
	];

	private _beachChair =
	[
		//"Pilot_Plane_Civil_01",
		"passenger_sdv",
		"ChopperLight_RP_idleBored_H",
		"ChopperLight_RP_idleBoredB_H",
		"ChopperLight_RP_idleCtalk_H",
		"ChopperLight_RP_idleDtalk_H",
		"ChopperLight_RP_idleA_H",
		"ChopperLight_RP_idleE_H",
		"ChopperLight_RP_idleF_H",
		"ChopperLight_RP_idleG_H",
		"ChopperLight_RP_idleH_H",
		"ChopperLight_RP_idleI_H"
	];

	private _bed =
	[
		//"Patient_Van_02_Medevac_Front",
		//"Patient_Van_02_Medevac_Back",
		"UnconsciousReviveDefault_C",
		"passenger_injured_medevac_truck03"
	];

	private _bar =
	[
		"Gunner_MBT_01_arty_F_out",
		"Gunner_MBT_02_cannon_F_out",
		"Gunner_APC_tracked_01_aa_F_out"
	];


	private _str = switch ( _mdl ) do
	{
		case"vn_ch_mod_c":{ selectRandom _chair };
		case"vn_b_prop_cot_01":{ selectRandom _bed };
		case"vn_b_prop_cot_02":{ selectRandom _bed };
		case"vn_bar_01_lawnchair_01":{ selectRandom _beachChair };
		case"vn_bar_01_campchair_01":{ selectRandom _chair };
		case"vn_bar_01_bar_01":{ selectRandom _bar };
		case"vn_bar_01_bar_02":{ selectRandom _bar };
		case"vn_us_common_bench_01":{ selectRandom _chair };
		default{ selectRandom _chair };
	};
[ _str , _mdl ];
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

{
		_sel = _x;
		_selPos = selectionPosition [ _b , _sel , 1 , true ];
		_selDir = _b selectionVectorDirAndUp [ _sel , 1 ];
		_selPos = [ _selPos#0 , _selPos#1 , ( (_selPos#2) + 0.55 ) ];

		//WIP
		switch ( true ) do
		{
			case ( "vn_b_prop_prc77_01" in _x ) :
			{
					//systemChat "vn_prc77";
					private _t = createTrigger [ "EmptyDetector" , [0,0,0] , false ];
					(_b getVariable"PF")pushBack _t;
					_t setPos(_b modelToWorld(selectionPosition[_b,_sel,1,true]));
					_t setTriggerText "snd";
					_t setTriggerArea [ 50 , 50 , 0 , true ];
					_t setTriggerActivation [ "ANYPLAYER" , "PRESENT" , true ];
					_t setTriggerTimeout [ 5 , 5 , 5 ];
					_t setTriggerStatements[
					//COND
					"this" ,
	
					//ACT
					"
					{deleteVehicle _x}forEach ( thisTrigger nearObjects [ '#soundonvehicle' , 2 ] );
					thisTrigger spawn
					{
						while { triggerActivated _this && { !isNull _this } } do
						{
							systemChat 'vn_prc77 playing';
							private _song=selectRandom['vn_macv_radio_1','vn_macv_radio_2','vn_macv_radio_3','vn_macv_radio_4','vn_macv_radio_5','vn_macv_radio_6','vn_macv_radio_7','vn_macv_radio_8','vn_macv_radio_9','vn_radiocom_tribute_01','vn_radiocom_tribute_02'];
							private _config = (configFile >> 'cfgsounds' >> _song);
							private _duration = getNumber (_config >> 'duration');
							_this say3D [ _song , 15 , 1 , 2 ];
							sleep _duration + 3.5;
							{deleteVehicle _x}forEach ( _this nearObjects [ '#soundonvehicle' , 2 ] );
						};
					};" ,
	
					//DEACT
					""];
			};

			case ( "vn_b_prop_fmradio_01" in _x ) :
			{
				//systemChat "vn_radio";
				private _t = createTrigger [ "EmptyDetector" , [0,0,0] , false ];
				(_b getVariable"PF")pushBack _t;
				_t setPos(_b modelToWorld(selectionPosition[_b,_sel,1,true]));
				_t setTriggerText "snd";
				_t setTriggerArea [ 30 , 30 , _bDir , true ];
				_t setTriggerActivation [ "ANYPLAYER" , "PRESENT" , true ];
				_t setTriggerTimeout [ 5 , 5 , 5 ];
				_t setTriggerStatements[
				//COND
				"this" ,
	
				//ACT
				"
				{deleteVehicle _x}forEach ( thisTrigger nearObjects [ '#soundonvehicle' , 2 ] );
				thisTrigger spawn
				{
					while { triggerActivated _this && { !isNull _this} } do
					{
						systemChat 'vn_radio playing';
						private _song=selectRandom['vn_drmm_song_os_01','vn_drmm_song_os_02','vn_drmm_song_os_03','vn_drmm_song_os_04','vn_drmm_song_os_05','vn_drmm_song_os_06','vn_drmm_song_os_07','vn_drmm_song_os_08','vn_drmm_song_os_09','vn_drmm_song_os_10','vn_drmm_song_os_11','vn_drmm_song_os_12','vn_drmm_song_os_13','vn_drmm_song_os_14','vn_drmm_song_01','vn_drmm_song_02','vn_drmm_song_03','vn_drmm_song_04','vn_drmm_song_05','vn_drmm_song_06','vn_drmm_song_07','vn_drmm_song_08','vn_drmm_song_09','vn_drmm_song_10','vn_drmm_song_11','vn_drmm_song_12','vn_drmm_song_13','vn_drmm_song_14','vn_drmm_song_15','vn_drmm_song_16','vn_drmm_song_17','vn_drmm_song_18','vn_drmm_song_19','vn_drmm_song_20','vn_drmm_song_21','vn_drmm_song_22','vn_drmm_song_23','vn_drmm_song_24','vn_drmm_song_25','vn_drmm_song_26'];
						private _config = (configFile >> 'cfgsounds' >> _song);
						private _duration = getNumber (_config >> 'duration');
						_this say3D [ _song , 25 , 1 , 2 ];
						sleep _duration+3.5;
						{ deleteVehicle _x }forEach ( _this nearObjects [ '#soundonvehicle' , 2 ] );
					};
				};" ,
	
				//DEACT
				""];
			};

			case ( "vn_radio" in _x ) :
			{
				//systemChat "vn_radio";
				private _t = createTrigger [ "EmptyDetector" , [0,0,0] , false ];
				(_b getVariable"PF")pushBack _t;
				_t setPos(_b modelToWorld(selectionPosition[_b,_sel,1,true]));
				_t setTriggerText "snd";
				_t setTriggerArea [ 30 , 30 , _bDir , true ];
				_t setTriggerActivation [ "ANYPLAYER" , "PRESENT" , true ];
				_t setTriggerTimeout [ 5 , 5 , 5 ];
				_t setTriggerStatements[
				//COND
				"this" ,
	
				//ACT
				"
				{deleteVehicle _x}forEach ( thisTrigger nearObjects [ '#soundonvehicle' , 2 ] );
				thisTrigger spawn
				{
					while { triggerActivated _this && { !isNull _this} } do
					{
						systemChat 'vn_radio playing';
						private _song=selectRandom['vn_drmm_song_os_01','vn_drmm_song_os_02','vn_drmm_song_os_03','vn_drmm_song_os_04','vn_drmm_song_os_05','vn_drmm_song_os_06','vn_drmm_song_os_07','vn_drmm_song_os_08','vn_drmm_song_os_09','vn_drmm_song_os_10','vn_drmm_song_os_11','vn_drmm_song_os_12','vn_drmm_song_os_13','vn_drmm_song_os_14','vn_drmm_song_01','vn_drmm_song_02','vn_drmm_song_03','vn_drmm_song_04','vn_drmm_song_05','vn_drmm_song_06','vn_drmm_song_07','vn_drmm_song_08','vn_drmm_song_09','vn_drmm_song_10','vn_drmm_song_11','vn_drmm_song_12','vn_drmm_song_13','vn_drmm_song_14','vn_drmm_song_15','vn_drmm_song_16','vn_drmm_song_17','vn_drmm_song_18','vn_drmm_song_19','vn_drmm_song_20','vn_drmm_song_21','vn_drmm_song_22','vn_drmm_song_23','vn_drmm_song_24','vn_drmm_song_25','vn_drmm_song_26'];
						private _config = (configFile >> 'cfgsounds' >> _song);
						private _duration = getNumber (_config >> 'duration');
						_this say3D [ _song , 25 , 1 , 2 ];
						sleep _duration+3.5;
						{ deleteVehicle _x }forEach ( _this nearObjects [ '#soundonvehicle' , 2 ] );
					};
				};" ,
	
				//DEACT
				""];
			};
			default{};
		};
	if ( floor random 3 == 1 ) then
	{
	if !( ( ( _x call _fiSel ) # 0 ) in ["vn_radio","vn_b_prop_fmradio_01","vn_b_prop_prc77_01"] ) then
	{
		//CREATE DUDE
		private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
		(_b getVariable"PF")pushBack _a;
		_a disableAI "all";
		_a setCaptive true;
		_a allowDamage false;
		[ _a , _b ] call PFL_vn_Dress;
		_a call _eh;
		_a enableMimics true;
		_a enableAI"anim";
		private _an = [ toLowerANSI typeOf _b , ( (_sel call _fiSel) # 0) ] call _anim;

		_a switchMove (_an#0);
		if ( (_an#0) in ["Patient_Van_02_Medevac_Front","Patient_Van_02_Medevac_Back","UnconsciousReviveDefault_C","passenger_injured_medevac_truck03"] )then
		{
			_a setMimic"unconscious";
		}else{
			_a setMimic ( selectRandom ["danger","combat","aware","hurt","neutral","safe"] );
		};
		_a disableCollisionWith _b;


		//X AND Y AXIS NEED TO BE IN RELATION TO AGENT, AFTER SETDIR&POS, NOT BUILDING/OBJECT!
		//X-AXIS
		private _xx = switch ( _an#1) do
		{
			case"vn_bar_01_campchair_01":{if((_an#0)in["gunner01_vtol01_vehicle","gunner02_vtol01_vehicle"])then{-0.25}else{0};};
			case"vn_bar_01_lawnchair_01":{if((_an#0)isEqualTo"passenger_sdv")then{0.22}else{0.3};};//0.21 or 0.23
			default{ 0 };
		};



		//Y-AXIS
		private _y = switch ( _an#1) do
		{
			case"vn_bar_01_campchair_01":{if((_an#0)in["gunner01_vtol01_vehicle","gunner02_vtol01_vehicle"])then{0.1}else{0};};
			//case"vn_bar_01_lawnchair_01":{if((_an#0)isEqualTo"ChopperLight_RP_idleA_H")then{0.35}else{0};};
			case"vn_bar_01_lawnchair_01":{if((_an#0)isEqualTo"passenger_sdv")then{0.35}else{0};};//0.15
			default{ 0 };
		};



		//Z-AXIS
		private _z = switch (_an#1) do
		{
			case"vn_b_prop_cot_01"://NO COVER
			{
				if((_an#0)in["Patient_Van_02_Medevac_Front","Patient_Van_02_Medevac_Back"])exitWith{-0.14};
				if((_an#0)isEqualTo"UnconsciousReviveDefault_C")exitWith{-0.15};//0.1
				if((_an#0)isEqualTo"passenger_injured_medevac_truck03")exitWith{-0.145};//0.144
				if !((_an#0)in["Patient_Van_02_Medevac_Front","Patient_Van_02_Medevac_Back","passenger_injured_medevac_truck03","UnconsciousReviveDefault_C"])exitWith{systemChat"cot_01 bugged?";0};
			};

			case"vn_b_prop_cot_02"://COVER
			{
				if((_an#0)in["Patient_Van_02_Medevac_Front","Patient_Van_02_Medevac_Back"])exitWith{-0.14};
				if((_an#0)isEqualTo"UnconsciousReviveDefault_C")exitWith{-0.14};//0.15
				if((_an#0)isEqualTo"passenger_injured_medevac_truck03")exitWith{-0.145};//0.145
				if !((_an#0)in["Patient_Van_02_Medevac_Front","Patient_Van_02_Medevac_Back","passenger_injured_medevac_truck03","UnconsciousReviveDefault_C"])exitWith{systemChat"cot_02 bugged?";0};
			};

			case"vn_ch_mod_c"://Woodchair
			{if((_an#0)in["gunner01_vtol01_vehicle","gunner02_vtol01_vehicle"])then{-0.15}else{-0.1};};//0.1

			case"vn_bar_01_campchair_01"://Small beachchair
			{if((_an#0)in["gunner01_vtol01_vehicle","gunner02_vtol01_vehicle"])then{-0.2}else{-0.145};};

			case"vn_bar_01_lawnchair_01"://Beachchair
			{
				if((_an#0)isEqualTo"passenger_sdv")then{-0.14}else{-0.18};//-0.36
				//if((_an#0)in["ChopperLight_RP_idleBored_H","ChopperLight_RP_idleBoredB_H","ChopperLight_RP_idleCtalk_H","ChopperLight_RP_idleDtalk_H","ChopperLight_RP_idleA_H","ChopperLight_RP_idleE_H","ChopperLight_RP_idleF_H","ChopperLight_RP_idleG_H","ChopperLight_RP_idleH_H","ChopperLight_RP_idleI_H"])then{-0.14}else{-0.36};
			};

			default{0.145};
		};



		//TODO: Only spawn if absolutely needed, based on model & animation
		private _vr = "Land_VR_CoverObject_01_kneelLow_F"createVehicleLocal[0,0,0];
		(_b getVariable"PF")pushBack _vr;
		{_vr setObjectMaterial[_x,""];_vr setObjectTexture[_x,""]}forEach[0,1];



		_vr setDir _dir;
		_vr setPos ( _b modelToWorld[ _selPos#0 , _selPos#1 , ( (_selPos#2) + (_z - (0.55) ) ) ] );
		_vr setPos ( _vr modelToWorld[ _xx , _y , 0 ] );
		_vr setObjectScale 0.5;


		//Set man direction & position
		_a setVectorDirAndUp _selDir;
		private _dir = getDir _a + _bDir + (
		switch ( _an#0 )do
		{
			case"Patient_Van_02_Medevac_Back":{0};
			case"UnconsciousReviveDefault_C":{0};
			case"Pilot_Plane_Civil_01":{90};
			case"passenger_sdv":{90};
			case"ChopperLight_RP_idleBored_H":{90};
			case"ChopperLight_RP_idleBoredB_H":{90};
			case"ChopperLight_RP_idleCtalk_H":{90};
			case"ChopperLight_RP_idleDtalk_H":{90};
			case"ChopperLight_RP_idleA_H":{90};
			case"ChopperLight_RP_idleE_H":{90};
			case"ChopperLight_RP_idleF_H":{90};
			case"ChopperLight_RP_idleG_H":{90};
			case"ChopperLight_RP_idleH_H":{90};
			case"ChopperLight_RP_idleI_H":{90};
			default{180};
		});

		private _dir = if ( _an#1 isEqualTo "vn_us_common_bench_01" ) then { _dir - 180 } else { _dir };
		_a setDir _dir;
		_a setPos ( _b modelToWorld [ (_selPos#0) + _xx , (_selPos#1) + _y , (_selPos#2) + _z ] );
			};
		};
	}forEach _selections;
}