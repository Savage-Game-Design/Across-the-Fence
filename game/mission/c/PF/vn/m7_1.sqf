//terminal
isNil{params["_b"];
_b setVariable["PF",[]];
private _dir = getDir _b;

	private _dress = {
	params ["_a"];
	_a forceAddUniform(selectRandom["vn_b_uniform_macv_01_07","vn_b_uniform_macv_04_07","vn_b_uniform_macv_05_07"]);
	if(floor random 5==1)then{"vn_g_spectacles_02"};
	_a setFace (selectRandom baseFaces);

	_p = (selectRandom((configProperties [configFile >> "CfgUnitInsignia" , "true" ])select{ "vn_b_insignia_" in str _x  }));
	private _patch = [getText(_p>>"texture"),getText(_p>>"material")];

	_a setObjectTexture[2,(_patch#0)];
	_a setObjectMaterial[3,(_patch#1)];
	
	_a setUnitLoadout(selectRandom
	[
	[["vn_m16","","","",["vn_m16_20_mag",18],[],""],[],[],["vn_b_uniform_macv_05_07",[]],["vn_b_vest_usarmy_03",[]],["",[]],"vn_b_helmet_m1_14_01","",[],["","","","","",""]],//Rifleman1
	[["vn_m16","","","",["vn_m16_20_mag",18],[],""],[],[],["vn_b_uniform_macv_05_07",[]],["vn_b_vest_usarmy_03",[]],["",[]],"vn_b_helmet_m1_14_01","",[],["","","","","",""]]//Rifleman1
	]);
	};
	
	private _anim =
	{
	selectRandom(switch(_this)do
	{
	case 0:
	{
		[
		 "Passenger_Van_02_Transport_Left_1",
		 "Passenger_Van_02_Transport_Left_2",
		 "Passenger_Van_02_Transport_Left_3"
		]
	 };
	case 1:
	{
		[
		   "Passenger_Van_02_Transport_Right_1",
		   "Passenger_Van_02_Transport_Right_2",
		   "Passenger_Van_02_Transport_Right_3"
		]
	};
	 
	default{
		[
			"passenger_apc_generic01",
			"passenger_apc_generic02",
			"passenger_apc_generic03",
			"passenger_apc_generic03_low",
			"passenger_apc_generic04",
			"passenger_apc_generic04still",
			"passenger_apc_narrow_generic01",
			"passenger_apc_narrow_generic02",
			"passenger_apc_narrow_generic03",
			"passenger_generic01_foldhands"
		]
	};
	});
	};
	
	
	private _eh = {
	params [ "_a" ];
	_a addEventHandler [ "AnimDone" ,
	{
		params["_a","_an"];
		_a switchMove _an;
	}];
	};


_offX = -2.05;
_offY = -0.6;
_num = 0;
for "_x" from 1 to 28 do
{
	_num = _num + 1;

	switch(_num)do
	{
		case 8:{_offX=-2.05;_offY=_offY-2.6;};
		case 15:{_offX=-2.05;_offY=_offY+1;};
		case 22:{_offX=-2.05;_offY=_offY-2.6;};
		default{};
	};

	if !( _num in [4,11,18,25] || {floor random 3==1} )then
	{
		private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
		(_b getVariable"PF")pushBack _a;
		_a disableAI"all";
		_a setCaptive true;
		_a allowDamage false;
		switch(_num)do
		{
			case 1:{_a switchMove(0 call _anim)};
			case 7:{_a switchMove(1 call _anim)};
			case 14:{_a switchMove(0 call _anim)};
			case 21:{_a switchMove(1 call _anim)};
			default{_a switchMove(2 call _anim)};
		};
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+(if(_num<15)then{180}else{0}));
	_a setPos(_b modelToWorld[_offX,_offY,-3.7]);
	_a disableCollisionWith _b;
	};
_offX = _offX+0.75;
};
}