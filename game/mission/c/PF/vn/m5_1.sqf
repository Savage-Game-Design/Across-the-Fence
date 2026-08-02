//Land_vn_latrine_01
isNil{params["_b"];
_b setVariable["PF",[]];

	private _dir=getDir _b;
	
	private _dress = {
	params ["_a"];
	_a forceAddUniform"vn_b_uniform_macv_06_07";
	if(floor random 5==1)then{"vn_g_spectacles_02"};
	_a setFace (selectRandom baseFaces);	
	};
	
	private _eh = {
	params [ "_a" ];
	_a addEventHandler [ "AnimDone" ,
	{
		params["_a","_an"];
		_a switchMove _an;
	}];
	};

if (floor random 3==1)then
{
	private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"Acts_passenger_boat_rightrear";
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+90);
	_a setPos(_b modelToWorld[-0.82,0.54,-0.74]);
	_a disableCollisionWith _b;
};

if (floor random 3==1)then
{
	private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"Heli_Light_02_Gunner";
	_a call _dress;
	_a call _eh;
	_a setAnimSpeedCoef 0.3;
	_a setDir(_dir+90);
	_a setPos(_b modelToWorld[-0.67,-0.5,-0.74]);
	_a disableCollisionWith _b;
	_a enableAI"anim";
	_a enableAI"target";
	_a enableAI"autotarget";
	_a enableMimics true;
	_a setMimic "hurt";
};




private _t = createTrigger [ "EmptyDetector" , _b , false ];
_t setTriggerText "snd";
_t setTriggerArea [ 15 , 20 , 0 , true ];
_t setTriggerActivation [ "ANYPLAYER" , "PRESENT" , true ];
_t setTriggerTimeout [ 9 , 9 , 9 ];
_t setTriggerStatements[
//COND
"this" ,

//ACT
"private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
thisTrigger spawn
	{
		while { triggerActivated _this } do
		{
			playSound3D['A3\Missions_F_Oldman\Data\sound\Flies\Flies_02.wss',_this,false,getPosASL _this,1,1,10,0,true];
				sleep 9;
				if ( isNull _this ) exitWith { terminate _thisScript; };
		};
		if ( isNull _this ) exitWith { deleteVehicle _this; terminate _thisScript; };
	};" ,

//DEACT
""];
(_b getVariable"PF")pushBack _t;
}