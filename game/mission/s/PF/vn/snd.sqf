/*	AMBIENT SOUNDS FUNCTION
	Description:
		Spawns a trigger globally that plays sound when the player is nearby the source,
		otherwise it deletes itself.
*/
isNil{params [ "_b" , "_s" ];

if ( _s isEqualTo "" ) exitWith{};

private _act = switch ( _s ) do
{

	case "chk" : //Chicken sounds
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

	case "base" : //Military base sounds
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

	case "vill" : //Village sounds
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

	case "mrkt" : //Marketplace sounds
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

	case "song" : //Radio or loudspeaker music
	{
		"private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
		if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
		thisTrigger spawn
		{
			while { triggerActivated _this } do
			{
				_this say3D ( selectRandom [ 'vn_freedom_bird' , 'vn_ambient_market_sound_2' ] );
				for '_x' from 1 to 36 do
				{
					sleep 5;
					if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
				};
			};
			if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
		};"
	};

	default { "" };
};



private _time = switch ( _s ) do
{
	case "base" : {60};
	case "vill" : {180};
	case "mrkt" : {180};
	default {60};
};



private _t = createTrigger [ "EmptyDetector" , _b , false ];
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
""];

(_b getVariable"PF")pushBack _t;
}