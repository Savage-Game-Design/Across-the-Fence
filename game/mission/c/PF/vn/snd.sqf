isNil{params [ "_b" , "_s" , "_pos" ];

if ( _s isEqualTo "" ) exitWith{};

private _act = switch ( _s ) do
{

	case "chk" :
	{
		"if ( daytime<6 || { daytime > 16.5 } ) exitWith {};
		private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
		if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
		thisTrigger spawn
		{
			while { triggerActivated _this } do
			{
				playSound3D ['a3\Sounds_F\environment\animals\Chickens\Chicken_' + selectRandom ['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20'] + '.wss',getPosASL _this,false,getPosASL _this,1,1,35];
				sleep ( random[1,9,18] );
			};
			if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
		};"
	};

//playSound3D ['a3\Sounds_F\environment\animals\Goats\Goat_' + selectRandom ['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18'] + '.wss',_agent,false,getPosASL _agent,1,1,45];

	case "base" :
	{
		"if ( daytime<6 || { daytime > 16.5 } ) exitWith {};
		private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
		if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
		thisTrigger spawn
		{
			while { triggerActivated _this } do
			{
				_this say3D ( selectRandom [ 'vn_ambient_army_camp_sound_1' , 'vn_ambient_army_camp_sound_2' ] );
				for '_x' from 1 to 12 do
				{
					sleep 5;
					if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
				};
			};
			if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
		};"
	};

	case "vill" :
	{
		"if ( daytime<6 || { daytime > 16.5 } ) exitWith {};
		private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
		if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
		thisTrigger spawn
		{
			while { triggerActivated _this } do
			{
				_this say3D ( selectRandom [ 'vn_ambient_village_sound_1' , 'vn_ambient_village_sound_2' ] );
				for '_x' from 1 to 36 do
				{
					sleep 5;
					if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
				};
			};
			if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
		};"
	};

	case "mrkt" :
	{
		"if ( daytime<6 || { daytime > 16.5 } ) exitWith {};
		private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
		if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
		thisTrigger spawn
		{
			while { triggerActivated _this } do
			{
				_this say3D ( selectRandom [ 'vn_ambient_market_sound_1' , 'vn_ambient_market_sound_2' ] );
				for '_x' from 1 to 36 do
				{
					sleep 5;
					if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
				};
			};
			if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
		};"
	};

	case "song" :
	{
		"
		private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
		if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
		thisTrigger spawn
		{
			while { triggerActivated _this } do
			{
				private _song=selectRandom['vn_drmm_song_os_01','vn_drmm_song_os_02','vn_drmm_song_os_03','vn_drmm_song_os_04','vn_drmm_song_os_05','vn_drmm_song_os_06','vn_drmm_song_os_07','vn_drmm_song_os_08','vn_drmm_song_os_09','vn_drmm_song_os_10','vn_drmm_song_os_11','vn_drmm_song_os_12','vn_drmm_song_os_13','vn_drmm_song_os_14'];
				private _config = (configFile >> 'cfgsounds' >> _song);
				private _name = getText (_config >> 'name');
				private _duration = getNumber (_config >> 'duration');
				_b say3D [ _song , 40 , 1 , 2 ];
				sleep _duration;
			};
		};"
	};

	default { "" };
};



private _song=selectRandom['vn_drmm_song_os_01','vn_drmm_song_os_02','vn_drmm_song_os_03','vn_drmm_song_os_04','vn_drmm_song_os_05','vn_drmm_song_os_06','vn_drmm_song_os_07','vn_drmm_song_os_08','vn_drmm_song_os_09','vn_drmm_song_os_10','vn_drmm_song_os_11','vn_drmm_song_os_12','vn_drmm_song_os_13','vn_drmm_song_os_14'];
private _config = (configFile >> 'cfgsounds' >> _song);
private _name = getText (_config >> 'name');
private _duration = getNumber (_config >> 'duration');
sleep _duration;



private _time = switch ( _s ) do
{
	case "base" : {60};
	case "vill" : {180};
	case "mrkt" : {180};
	default {60};
};



private _t = createTrigger [ "EmptyDetector" , [0,0,0] , false ];
( if ( isNil "_pos" ) then { _t setPos ( getPosATL _b ) } else { _t setPos(_b modelToWorld _pos) } );
_t setTriggerText "snd";
_t setTriggerArea [ 50 , 50 , 0 , true ];
_t setTriggerActivation [ "ANYPLAYER" , "PRESENT" , true ];
_t setTriggerTimeout [ _time , _time , _time ];
_t setTriggerStatements[
//COND
"this" ,

//ACT
_act ,

//DEACT
(if(_s isEqualTo"song")then{"deleteVehicle _this"}else{""})];//TODO: A3 v2.14 adds command soundParams which gives sound duration passed

(_b getVariable"PF")pushBack _t;
}