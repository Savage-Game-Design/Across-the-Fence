//Land_vn_hooch_02_02 ~ Mess
isNil{params["_b"];
_b setVariable["PF",[]];

private _dir=getDir _b;
private _patch = [
["\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f_01_ca.paa","\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f.rvmat"],
[]
];

private _eh = {
params [ "_a" ];
_a addEventHandler [ "AnimDone" ,
{
	params["_a","_an"];
	_a switchMove _an;
}];
};

_off=0.9;
for "_x" from 1 to 5 do
{
if(floor random 3==1)then
{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
[_a,_b] call PFL_vn_Dress;
_a call _eh;
_a setDir(_dir+90);
_a setPos(_b modelToWorld[0.5,_off,-0.55]);
_a switchMove(selectRandom["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
_off = _off - 0.9;
};

_off = 0.9;
for "_x"from 1 to 5 do
{
if(floor random 3==1)then
{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call PFL_vn_Dress;
_a call _eh;
_a setDir(_dir+270);
_a setPos(_b modelToWorld[1.9,_off,-0.55]);
_a switchMove(selectRandom["HubSittingChairUB_idle1","HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
_off = _off - 0.9;
};

_off = 0.9;
for "_x"from 1 to 5 do
{
if(floor random 3==1)then{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call PFL_vn_Dress;
_a call _eh;
_a setDir(_dir+90);
_a setPos(_b modelToWorld[-1.9,_off,-0.55]);
_a switchMove(selectRandom["HubSittingChairUB_idle1","HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
_off = _off - 0.9;
};

_off = 0.9;
for "_x"from 1 to 5 do
{
if(floor random 3==1)then{
private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
(_b getVariable"PF")pushBack _a;
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a call PFL_vn_Dress;
_a call _eh;
_a setDir(_dir+270);
_a setPos(_b modelToWorld[-0.7,_off,-0.55]);
_a switchMove(selectRandom["HubSittingChairUB_idle1","HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"]);
};
_off = _off - 0.9;
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
_a setDir(_dir+180);
_a setPos(_b modelToWorld[0,3,-0.55]);
_a enableAI"anim";
_a enableAI"target";
_a enableAI"autotarget";
}