private _a=_this#0;private _b=_this#1;
_a disableConversation true;_a setSpeaker"NoVoice";_a enableAttack false;_a enableFatigue false;_a enableStamina false;
_a setSkill 0;_a allowFleeing 0;_a setVariable["BIS_noCoreConversations",true];

if(dayTime<6 || dayTime>18)then{_a playAction"SitDown"};

if(toLowerANSI typeOf _b in ["land_house_c_4_ep1","land_vn_house_c_12_ep1","land_vn_house_c_9_ep1","land_vn_house_c_3_ep1","land_vn_house_c_2_ep1","land_vn_house_c_1_ep1","land_vn_house_c_1_v2_ep1"] || floor random 3==1)then{
[_a,_b,toLower(typeOf _b)]call civAnim;_a enableSimulation true;_a hideObjectGlobal false
};


if(floor random 99==1)exitWith{
_a spawn civJihad;
[_a,_b]spawn civAI;
_a forceWalk false;
_a forceSpeed 11};

_a addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];_a removeAllEventHandlers"AnimDone";
if(_a getVariable"FSM"isEqualTo"flee")exitWith{};
_a setVariable["FSM","flee"];
private _civs=(server getVariable"civs");
_civs deleteAt(_civs find _a);
{_a enableAI _x}forEach["anim","teamSwitch","move","path"];
switch(floor random 2)do{
case 0:{[_a,"ApanPercMstpSnonWnonDnon_G01"]remoteExec["switchMove",0,_a]};
case 1:{[_a,"ApanPknlMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
case 2:{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]}};
if(_a getVariable"FSM"isEqualTo"anim")exitWith{};
_a forceSpeed 13;_a forceWalk false;
_a setDestination[(_a getPos [ 99+random 199 , (getDir _f) ]),"LEADER PLANNED",true];
}];

_a call civF;
_a call civU;
//_a call civV;
_a call civH;
//_a call civG;
[_a,_b]spawn civAI;