//Land_vn_hootch_01_11
isNil{params["_b"];
_b setVariable["PF",[]];

	private _dir=getDir _b;
	private _patch = [
	["\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f_01_ca.paa","\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f.rvmat"],
	[]
	];

	private _dress = {
	params ["_a"];
	_a forceAddUniform(selectRandom["vn_b_uniform_macv_01_07","vn_b_uniform_macv_04_07","vn_b_uniform_macv_05_07"]);
	if(floor random 5==1)then{"vn_g_spectacles_02"};
	_a setFace (selectRandom baseFaces);

	_p = (selectRandom((configProperties [configFile >> "CfgUnitInsignia" , "true" ])select{ "vn_b_insignia_" in str _x  }));
	private _patch = [getText(_p>>"texture"),getText(_p>>"material")];

	_a setObjectTexture[2,(_patch#0)];
	_a setObjectMaterial[3,(_patch#1)];

	};

	private _eh = {
	params [ "_a" ];
	_a addEventHandler [ "AnimDone" ,
	{
		params["_a","_an"];
		_a switchMove _an;
	}];
	};
_num = 0;

//1
if (floor random 3==1)then
{
	private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"passenger_flatground_3_Idle_Unarmed_Idling";
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+160);
	_a setPos(_b modelToWorld[1.5,-0.6,-0.55]);
	_num = _num + 1;
};

//2
if (floor random 3==1)then
{
	private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"passenger_flatground_4_Idle_Unarmed_Idling";
	_a call _dress;
	_a call _eh;
	_a setAnimSpeedCoef 0.3;
	_a setDir(_dir+90);
	_a setPos(_b modelToWorld[-2.6,1.3,-0.55]);
};

//3
if (floor random 3==1)then
{
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"c5efe_HonzaLoop";
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+302);
	_a setPos(_b modelToWorld[-0.5,2,-0.55]);
};

//4
if (floor random 3==1)then
{
private _bed="Land_VR_Block_05_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _bed;
_bed setDir(_dir+90);
_bed setPos(_b modelToWorld[-1.8,2.1,-2.6]);
_bed setObjectScale 0.2;
{_bed setObjectMaterial[_x,""]}forEach[0,1];
{_bed setObjectTexture[_x,""]}forEach[0,1];
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a switchMove"Patient_Van_02_Medevac_Back";
_a call _dress;
_a call _eh;
_a setDir(_dir+270);
_a setMimic"unconscious";
_a setPos(_b modelToWorld[-1.9,2,-0.2]);
_num = _num + 1;
};

//5
if (floor random 3==1)then
{
private _seat="Land_VR_CoverObject_01_kneelLow_F"createVehicleLocal[0,0,0];
_seat setDir _dir;
_seat setPos(_b modelToWorld[-1.2,4.3,-0.6]);
{_seat setObjectMaterial[_x,""]}forEach[0,1];
{_seat setObjectTexture[_x,""]}forEach[0,1];
(_b getVariable"PF")pushBack _seat;
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"passenger_apc_generic04";
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+70);
	_a setPos(_b modelToWorld[-1.43,4.15,-0.04]);
	_num = _num + 1;
};

//6
if (floor random 3==1)then
{
private _seat="Land_VR_CoverObject_01_kneelLow_F"createVehicleLocal[0,0,0];
_seat setDir _dir;
_seat setPos(_b modelToWorld[-1.5,-1.71,-0.6]);
{_seat setObjectMaterial[_x,""]}forEach[0,1];
{_seat setObjectTexture[_x,""]}forEach[0,1];
(_b getVariable"PF")pushBack _seat;
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"passenger_scooter_01";
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+90);
	_a setPos(_b modelToWorld[-1.5,-1.71,-0.04]);
	_num = _num + 1;
};

//7
if ((floor random 3==1)&&{_num<6})then
{
private _seat="Land_VR_CoverObject_01_kneelLow_F"createVehicleLocal[0,0,0];
_seat setDir _dir;
_seat setPos(_b modelToWorld[1.9,-1.71,-0.6]);
{_seat setObjectMaterial[_x,""]}forEach[0,1];
{_seat setObjectTexture[_x,""]}forEach[0,1];
(_b getVariable"PF")pushBack _seat;
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"Acts_passenger_flatground_leanright";
	_a call _dress;
	_a call _eh;
	_a setDir(_dir+270);
	_a setPos(_b modelToWorld[1.83,-1.7,-0.04]);
	_num = _num + 1;
};

//8
if ((floor random 3==1)&&{_num<6})then
{
private _bed="Land_VR_Block_05_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _bed;
_bed setDir(_dir+90);
_bed setPos(_b modelToWorld[-1.8,0.3,-2.42]);
_bed setObjectScale 0.2;
{_bed setObjectMaterial[_x,""]}forEach[0,1];
{_bed setObjectTexture[_x,""]}forEach[0,1];
(_b getVariable"PF")pushBack _seat;
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"passenger_injured_medevac_truck03";
	_a call _dress;
	_a call _eh;
	_a setMimic"unconscious";
	_a setDir(_dir+70);
	_a setPos(_b modelToWorld[-1.9,0.3,0]);
	_num = _num + 1;
};

//9
if ((floor random 3==1)&&{_num<6})then
{
private _bed="Land_VR_Block_05_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _bed;
_bed setDir(_dir+90);
_bed setPos(_b modelToWorld[1.8,2.3,-2.5]);
_bed setObjectScale 0.2;
{_bed setObjectMaterial[_x,""]}forEach[0,1];
{_bed setObjectTexture[_x,""]}forEach[0,1];
(_b getVariable"PF")pushBack _seat;
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"Patient_Van_02_Medevac_Front";
	_a call _dress;
	_a call _eh;
	_a setMimic"unconscious";
	_a setDir(_dir+270);
	_a setPos(_b modelToWorld[1.8,2.3,-0.1]);
	_num = _num + 1;
};
	
//10
if ((floor random 3==1)&&{_num<6})then
{
private _bed="Land_VR_Block_05_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _bed;
_bed setDir(_dir+90);
_bed setPos(_b modelToWorld[1.8,0.25,-2.5]);
_bed setObjectScale 0.2;
{_bed setObjectMaterial[_x,""]}forEach[0,1];
{_bed setObjectTexture[_x,""]}forEach[0,1];
(_b getVariable"PF")pushBack _seat;
   private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
	(_b getVariable"PF")pushBack _a;
	_a disableAI"all";
	_a setCaptive true;
	_a allowDamage false;
	_a switchMove"UnconsciousReviveDefault_C";
	_a call _dress;
	_a call _eh;
	_a setMimic"unconscious";
	_a setDir(_dir+270);
	_a setPos(_b modelToWorld[1.8,0.25,-0.1]);
	_num = _num + 1;
};

}