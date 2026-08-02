//Land_vn_barracks_03_03 ~ Mess2
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

_off=5.5;
for "_x" from 1 to 19 do
{
if !( _x in [3,6,9,12,15,18] ) then
{
if(floor random 3==1)then{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call _dress;
_a call _eh;
_a setDir(_dir+90);
_a setPos(_b modelToWorld[0.85,_off,-2.15]);
_a switchMove(selectRandom["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
};
_off = _off - 0.7;
};

_off=5.5;
for "_x" from 1 to 19 do
{
if !( _x in [3,6,9,12,15,18] ) then
{
if(floor random 3==1)then{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call _dress;
_a call _eh;
_a setDir(_dir+270);
_a setPos(_b modelToWorld[2.2,_off,-2.15]);
_a switchMove(selectRandom["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
};
_off = _off - 0.7;
};

_off=5.5;
for "_x" from 1 to 19 do
{
if !( _x in [3,6,9,12,15,18] ) then
{
if(floor random 3==1)then{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call _dress;
_a call _eh;
_a setDir(_dir+90);
_a setPos(_b modelToWorld[-2.3,_off,-2.15]);
_a switchMove(selectRandom["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
};
_off = _off - 0.7;
};


_off=5.5;
for "_x" from 1 to 19 do
{
if !( _x in [3,6,9,12,15,18] ) then
{
if(floor random 3==1)then{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call _dress;
_a call _eh;
_a setDir(_dir+270);
_a setPos(_b modelToWorld[-0.95,_off,-2.15]);
_a switchMove(selectRandom["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
};
_off = _off - 0.7;
};

private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a forceAddUniform"vn_b_uniform_macv_06_07";
_a addHeadgear"vn_b_bandana_01";
_a setFace(selectRandom baseFaces);
_a switchMove"AmovPercMstpSnonWnonDnon";
_a setDir(_dir+170);
_a setPos(_b modelToWorld[0.5,8.5,-2.15]);
_a enableAI"anim";
_a enableMimics true;
_a setMimic"safe";
}