//Land_vn_b_trench_bunker_06_02
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

private _anim = selectRandom[
"Patient_Van_02_Medevac_Back",
"UnconsciousReviveDefault_C",
"passenger_injured_medevac_truck03"
];

private _dir = if(_anim isEqualTo"passenger_injured_medevac_truck03")then{_dir}else{_dir+180};

private _offset = switch ( _anim ) do
{
	case"UnconsciousReviveDefault_C":{[-1.8,-0.15,0.43]};
	case"Patient_Van_02_Medevac_Back":{[-1.85,-0.15,0.3]};
	case"passenger_injured_medevac_truck03":{[-1.85,-0.15,0.42]};
};

private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a switchMove _anim;
_a call _dress;
_a call _eh;
_a setMimic"unconscious";
_a enableSimulation false;
_a setDir _dir;
_a setPos(_b modelToWorld _offset);

}