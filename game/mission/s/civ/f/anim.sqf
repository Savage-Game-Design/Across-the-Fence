/*	TODO:
	1. Mosque positions for call to prayer event
	2. Man walks to minaret tower to begin CTP?
	3. Animate with a Well
	4. Animate with weed plants
	5. Animate with poppy seeds
*/

params["_a","_b","_t"];
if(isNil{_b getVariable"anim"})then{_b setVariable["anim",[objNull,objNull,objNull,objNull,objNull]];(_b getVariable"anim")set[(floor random 5),_a]};
if(({isNull _x}count(_b getVariable"anim"))==0)exitWith{_a spawn civAI;_a setVariable["FSM",""];(server setVariable"civs")pushBack _a};
_slots=_b getVariable"anim";
_r=_slots findIf{isNull _x};
if(_a in _slots)then{_r=_slots find _a}else{_slots set[_r,_a]};
_a setVariable["FSM","anim"];
{_a disableAI _x}forEach["anim","move","path"];
private _dir=getDir _b;

switch _t do{
//TAKISTAN
//case"land_market_stalls_01_ep1":{if(dayTime>7&&dayTime<16)then{[_b,_t]call hajiMktSales}};
//case"land_market_stalls_02_ep1":{if(dayTime>7&&dayTime<16)then{[_b,_t]call hajiMktSales}};
case"land_vn_house_l_1_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[3,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[1.555,-1.45,-.62]);
	[_a,"medicStart"]remoteExecCall["switchAction"];
	_a setDir(_dir+110)};
	case 1:{_a setPos(_b modelToWorld[1.6,.6,-.5]);
	[_a,(selectRandom["c5efe_HonzaLoop","c5efe_MichalLoop"])]remoteExecCall["switchMove"];
	_a setDir(_dir+45)};
	case 2:{_a setPos(_b modelToWorld[.8,2.3,-.9]);
	[_a,"HubStandingUC_idle1"]remoteExecCall["switchMove"];
	_a setDir _dir};
	};};

case"land_vn_house_l_3_h_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-6,1,0]);
	_a playAction"SitDown";
	_a setDir(_dir+random 180)};
	case 1:{
	_a setPos(_b modelToWorld[-5,2.5,0]);
	[_a,"gunner_mortar"]remoteExecCall["switchAction"];
	_a setDir(_dir+300)};
	case 2:{_a setPos(_b modelToWorld[0,.48,-.22]);
	[_a,"medicStart"]remoteExecCall["switchAction"];
	_a setDir(_dir+337)};
	case 3:{_a setPos(_b modelToWorld[-2,2,0]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
};};

case"land_vn_house_l_3_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-6,1,0]);
	_a playAction"SitDown";
	_a setDir(_dir+random 180)};
	case 1:{
	_a setPos(_b modelToWorld[-5,2.5,0]);
	[_a,"gunner_mortar"]remoteExecCall["switchAction"];
	_a setDir(_dir+300)};
	case 2:{_a setPos(_b modelToWorld[0,.48,-.22]);
	[_a,"medicStart"]remoteExecCall["switchAction"];
	_a setDir(_dir+337)};
	case 3:{_a setPos(_b modelToWorld[-2,2,0]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
};};

case"land_vn_house_l_4_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[2,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[4,3.8,-1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+180)};
	case 1:{_a setPos(_b modelToWorld[0,3,-1]);
	_a playAction"SitDown";
	_a setDir(random 360)}
}};

case"land_vn_house_l_6_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[3,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-2.1,2.5,-1.6]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+180)};
	case 1:{_a setPos(_b modelToWorld[-1.1,2.5,-1.5]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+175)};
	case 2:{_a setPos(_b modelToWorld[-.55,-.6,-1.5]);
	[_a,"medicStartUp"]remoteExecCall["switchAction"];
	_a setDir(_dir+180)}
}};

case"land_vn_house_l_7_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[3,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-5.7,-4.9,-.9]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+80)};
	case 1:{_a setPos(_b modelToWorld[5.7,3,-1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
	case 2:{_a setPos(_b modelToWorld[4.2,-.2,0]);
	[_a,"medicStartUp"]remoteExecCall["switchAction"];
	_a setDir(_dir+270)};
	case 3:{_a setPos(_b modelToWorld[-3.5,3,-.5]);
	_a playAction"SitDown";
	_a setDir(_dir+180)}
}};

case"land_vn_house_l_8_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-3,4.8,-1]);
	[_a,"medicStartUp"]remoteExecCall["switchAction"];
	_a setDir(_dir+90)};
	case 1:{_a setPos(_b modelToWorld[-1,4,-1]);
	_a playAction"sitDown";
	_a setDir(_dir+270)};
	case 2:{_a setPos(_b modelToWorld[-3.2,-2.2,-1.5]);
	[_a,"medicStartUp"]remoteExecCall["switchAction"];
	_a setDir(_dir+190)};
	case 3:{_a setPos(_b modelToWorld[-3,-2,-1.5]);
	[_a,"gunner_mortar"]remoteExecCall["switchAction"];
	_a setDir(_dir+190)}
}};

case"land_vn_house_k_1_ep1":{
	_a setPos(_b modelToWorld[-1.4,5.9,1.5]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+165)};

case"land_vn_house_k_5_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[5,9]};
	switch(_r)do{
	case 0:{_a setPos(_b modelToWorld[2.5,1.1,1.5]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir-30)};
	case 1:{_a setPos(_b modelToWorld[-1.6,3.6,1.5]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir _dir};
	case 2:{_a setPos(_b modelToWorld[-.6,4.4,1.5]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
	case 3:{_a setPos(_b modelToWorld[-2.82,-.8,1.5]);
	[_a,(selectRandom["passenger_boat_holdleft","passenger_boat_holdleft2"])]remoteExecCall["switchAction"];
	_a setDir(_dir+180)};
	case 4:{_a setPos(_b modelToWorld[-.62,-.87,1.4]);
	[_a,(selectRandom["passenger_boat_holdright","passenger_boat_holdright2"])]remoteExecCall["switchAction"];
	[_a,"passenger_boat_holdright"]remoteExecCall["switchAction"];
	_a setDir(_dir+180)};
};};

case"land_vn_house_k_3_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[3,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[1.3,-3.2,-1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+90)};
	case 1:{_a setPos(_b modelToWorld[2.3,-2.4,-1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+180)};
	case 2:{_a setPos(_b modelToWorld[-2.9,-3.4,-.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+30)}
}};

case"land_vn_house_k_7_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-4.9,-1.1,3.2]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+140)};
	case 1:{_a setPos(_b modelToWorld[-6.7,2.55,3.2]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+255)};
	case 2:{_a setPos(_b modelToWorld[-6.8,3.4,3.2]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
	case 3:{_a setPos(_b modelToWorld[1.65,.09,0]);
	[_a,(selectRandom["passenger_boat_holdright","passenger_boat_holdright2"])]remoteExecCall["switchAction"];
	_a setDir(_dir+90)};
}};

case"land_vn_house_k_8_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[2,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-2.8,2.95,-2.6]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir _dir};
	case 1:{_a setPos(_b modelToWorld[-1.8,3.7,-2.6]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
};};

case"land_vn_house_k_6_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[5,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[.2,2.8,-1.6]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
	case 1:{_a setPos(_b modelToWorld[-.5,3.9,-1.6]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+180)};
	case 2:{_a setPos(_b modelToWorld[-5,4.2,1.5]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+125)};
	case 3:{_a setPos(_b modelToWorld[-4.8,4.2,3.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+170)};
	case 4:{_a setPos(_b modelToWorld[-4.7,1.6,3.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+110)}
}};

case"land_vn_house_c_5_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-4.1,3.8,-.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+145)};
	case 1:{_a setPos(_b modelToWorld[.7,4.2,-.8]); 
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"]; 
	_a setDir _dir};
	case 2:{_a setPos(_b modelToWorld[1.7,5,-.8]); 
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"]; 
	_a setDir(_dir+270)};
	case 3:{_a setPos(_b modelToWorld[-2,0,-.8]); 
	_a playAction"SitDown";
	_a setDir(_dir+random 270)}
}};

case"land_vn_house_c_5_v1_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-4.1,3.8,-.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+145)};
	case 1:{_a setPos(_b modelToWorld[.7,4.2,-.8]); 
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"]; 
	_a setDir _dir};
	case 2:{_a setPos(_b modelToWorld[1.7,5,-.8]); 
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+270)};
	case 3:{_a setPos(_b modelToWorld[-2,0,-.8]); 
	_a playAction"SitDown";
	_a setDir(_dir+random 270)}
}};

case"land_vn_house_c_11_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setPos(_b modelToWorld[-1.5,-1.4,-2.1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+120)};
	case 1:{_a setPos(_b modelToWorld[1.8,-1.5,-2.1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+210)};
	case 2:{_a setPos(_b modelToWorld[6.9,-1.6,-2.1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir(_dir+90)};
	case 3:{_a setPos(_b modelToWorld[7.7,-2.6,-2.1]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove"];
	_a setDir _dir}
}};

case"land_vn_house_c_10_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setDir(_dir+270);
	_a setPosATL(_b modelToWorld[-5.2,-3,-.55]);
	[_a,"InBaseMoves_table1"]remoteExecCall["switchMove",0,true]};
	case 1:{_a setDir(_dir+270);
	_a setPosATL(_b modelToWorld[-5,-3,-.55]);
	[_a,"LHD_krajPaluby"]remoteExecCall["switchMove",0,true]};
	case 2:{_a setDir _dir;
	_a setPosATL(_b modelToWorld[-1.6,-3.7,-.55]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 4:{_a setDir(_dir+90);
	_a setPosATL(_b modelToWorld[-2.3,-2.7,-.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]}
}};

case"land_vn_house_c_4_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setDir(_dir+270);
	_a setPosATL(_b modelToWorld[4.5,-1.7,-3.5]);
	[_a,"InBaseMoves_table1"]remoteExecCall["switchMove",0,true]};
	case 1:{_a setDir(_dir+270);
	_a setPosATL(_b modelToWorld[3.4,-1,-3.5]);
	[_a,"HubSittingChairC_idle2"]remoteExecCall["switchMove",0,true]};
	case 2:{_a setDir(_dir+300);
	_a setPosATL(_b modelToWorld[5,-5,-.3]);
	[_a,"Acts_CivilShocked_2"]remoteExecCall["switchMove",0,true]};
	case 3:{_a setDir(_dir+40);
	_a setPosATL(_b modelToWorld[-2,-5.5,-.3]);
	[_a,"Acts_CivilShocked_2"]remoteExecCall["switchMove",0,true]}
}};

case"land_vn_house_c_2_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setDir(_dir+180);
	_a setPosATL(_b modelToWorld[4,-4.8,.9]);
	[_a,"LHD_krajPaluby"]remoteExecCall["switchMove",0,true]};
	case 1:{_a setDir(_dir+200);
	_a setPosATL(_b modelToWorld[5.9,-3,.8]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 2:{_a setDir(_dir+180);
	_a setPosATL(_b modelToWorld[1,2,-2.3]);
	[_a,"InBaseMoves_table1"]remoteExecCall["switchMove",0,true]};
	case 3:{_a setDir(_dir+90);
	_a setPosATL(_b modelToWorld[-2.8,3.6,.6]);
	[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]}
}};

case"land_vn_house_c_3_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[4,9]};
	switch _r do{
	case 0:{_a setDir(_dir+270);
_a setPosATL(_b modelToWorld[-5.4,2,-3.8]);
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 1:{_a setDir(_dir+310);
_a setPosATL(_b modelToWorld[-4,-3.3,.6]);
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 2:{_a setDir(_dir+270);
_a setPosATL(_b modelToWorld[-6.8,3.56,.6]);
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 3:{_a setDir _dir;
_a setPosATL(_b modelToWorld[-7.9,2.8,.6]);
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]}
}};

case"land_vn_house_c_9_ep1":{
if(_r==0)then{(_b getVariable"anim")deleteRange[5,9]};
	switch _r do{
	case 0:{_a setDir _dir;
_a setPosATL(_b modelToWorld[.5,-3,-3.8]); 
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 1:{_a setDir(_dir+90);
_a setPosATL(_b modelToWorld[-.2,-2,-3.8]); 
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 2:{_a setDir(_dir+90);
_a setPosATL(_b modelToWorld[-3.3,.2,-3.8]); 
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 3:{_a setDir(_dir+180);
_a setPosATL(_b modelToWorld[-2.2,1,-3.8]); 
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]};
	case 4:{_a setDir _dir;
_a setPosATL(_b modelToWorld[.8,0,-3.8]); 
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]}
}};

case"land_vn_ind_fuelstation_build_ep1":{
_a setDir(_dir+170);
_a setPosATL(_b modelToWorld[-2.2,1.5,-1.3]); 
[_a,"HubSittingChairUB_idle1"]remoteExecCall["switchMove",0,true]
};

//DEFAULT CASE SHOULD DO A SWITCHCHECK FOR GETMODELINFO
case"p_fiberplant_ep1":{
switch _r do{
case 0:{_a setPos(_b modelToWorld[-.4,-2,-1.4]);_a setDir(_dir-10)};//.P3D
}};

default{{_a enableAI _x}forEach["anim","move","path"];_a moveTo(selectRandom(_b buildingPos -1));_a setVariable["FSM",""];(server getVariable"civs")pushBack _a}};
_a allowDamage true;_slots=nil;