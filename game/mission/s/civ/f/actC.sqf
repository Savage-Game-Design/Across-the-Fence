civ_halt={params["_a"];
if(isNull _a || !alive _a)exitWith{titleText["He's dead...","PLAIN DOWN"];titleFadeOut 3};
if(player distance _a>9)exitWith{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 3};
player playAction"HandSignalFreeze";
private _haltTxt=str selectRandom[
"<t size='2' shadow='2'>Halt!</t>",
"<t size='2' shadow='2'>Stop!</t>",
"<t size='2' shadow='2'>Hold it right there!</t>",
"<t size='2' shadow='2'>Freeze!</t>",
"<t size='2' shadow='2'>Stop moving!</t>"];
titleText[_haltTxt,"PLAIN DOWN",-1,true,true];titleFadeOut 3;
if!(side _a isEqualTo CIVILIAN)exitWith{};
[_a,"PATH"]remoteExec["disableAI"]};


civ_goAway={params["_a"];
if(isNull _a || !alive _a)exitWith{titleText["He's dead...","PLAIN DOWN"];titleFadeOut 3};
if(player distance _a>9)exitWith{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 3};
private _goAwayTxt=str selectRandom[
"<t size='2' shadow='2'>Go away!</t>",
"<t size='2' shadow='2'>Get out of here!</t>",
"<t size='2' shadow='2'>Move along!</t>",
"<t size='2' shadow='2'>Get the fuck out of here!</t>",
"<t size='2' shadow='2'>Get out of the way!</t>",
"<t size='2' shadow='2'>Get the fuck out of the way!</t>"];
player playAction"HandSignalPoint";
titleText[_goAwayTxt,"PLAIN DOWN",-1,true,true];titleFadeOut 3;
if!(side _a isEqualTo CIVILIAN)exitWith{};
_nH=_a nearObjects["House_EP1",150]select{count(_x buildingPos -1)>1};
if(count _nH==0)exitWith{};
private["_H"];
_H=selectRandom _nH;_HP=_H buildingPos -1;_HP=selectRandom _HP;
if(count waypoints _a>0)then{{deleteWaypoint((waypoints _a)#0)}forEach waypoints _a};
[_a,false]remoteExec["forceWalk"];[_a,"PATH"]remoteExec["enableAI"];[_a,"MOVE"]remoteExec["enableAI"];[_a,"UP"]remoteExec["setUnitPos"];[_a,"FULL"]remoteExec["setSpeedMode"];[_a,_HP]remoteExec["moveTo"]};


civ_getDown={params["_a"];
if(isNull _a || !alive _a)exitWith{titleText["He's dead...","PLAIN DOWN"];titleFadeOut 3};
if(player distance _a>9)exitWith{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 3};
if(unitPos _a isEqualTo"DOWN")exitWith{};
player playAction"HandSignalGetDown";
private _getDownTxt=str selectRandom[
"<t size='2' shadow='2'>Get down!</t>",
"<t size='2' shadow='2'>Get on the ground!</t>",
"<t size='2' shadow='2'>Get down on the ground!</t>"];
titleText[_getDownTxt,"PLAIN DOWN",-1,true,true];titleFadeOut 3;
if!(side _a isEqualTo CIVILIAN)exitWith{};
if!(isNil{_a getVariable"detained"})then{
if!(unitPos _a isEqualTo"DOWN")then{
[_a,"DOWN"]remoteExec["setUnitPos"];
[_a,"anim"]remoteExec["disableAI"];
[_a,selectRandom["Acts_AidlPsitMstpSsurWnonDnon01","Acts_AidlPsitMstpSsurWnonDnon02","Acts_AidlPsitMstpSsurWnonDnon03","Acts_AidlPsitMstpSsurWnonDnon04","Acts_AidlPsitMstpSsurWnonDnon05"]]remoteExec["playMoveNow",0,true]}else{
if(floor random 2==0)then{selectRandom[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow"]}else{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow"]}}}};


civ_getUp={params["_a"];
if(isNull _a || !alive _a)exitWith{titleText["He's dead...","PLAIN DOWN"];titleFadeOut 3};
if(player distance _a>9)exitWith{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 3};
if(unitPos _a isEqualTo"UP")exitWith{};
player playAction"HandSignalGetUp";
_getUpTxt=str selectRandom[
"<t size='2' shadow='2'>Get up!</t>",
"<t size='2' shadow='2'>Stand up!</t>",
"<t size='2' shadow='2'>On your feet!</t>"];
titleText[_getUpTxt,"PLAIN DOWN",-1,true,true];titleFadeOut 3;
if!(side _a isEqualTo CIVILIAN)exitWith{};
if(isNil{_a getVariable"detained"})then{[_a,"UP"]remoteExec["setUnitPos"];[_a,"AmovPpneMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon"]remoteExec["switchMove"]}};


civ_startAsk={
//TODO: Player tells server to adjust civ's "FSM" variable to "flee" temporarily while questioning/detained
params["_a"];
if(cursorTarget!=_a)exitWith{};
if(isNull _a || !alive _a)exitWith{titleText["He's dead...","PLAIN DOWN"];titleFadeOut 5};
if(player distance _a>5)exitWith{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 5};
if!(side _a isEqualTo CIVILIAN)exitWith{};
if(_a getVariable"Asked")exitWith{};
//if(_terp isEqualTo[])exitWith{titleText["You need an interpreter...","PLAIN DOWN"];titleFadeOut 5};
//private _myTrait=(!(_terp isEqualTo[]));

_a setVariable["Asked",true,true];
private _r=if(count(getPosATL _a nearEntities["Man",350]select{side _x in[east,independent]})>0)then{floor random 9}else{floor random 6};
private _hello=str selectRandom["<t size='2' shadow='2'>Hello!</t>",
"<t size='2' shadow='2'>Hey man, got a minute?</t>",
"<t size='2' shadow='2'>Hello there!</t>",
"<t size='2' shadow='2'>Hey there!</t>",
"<t size='2' shadow='2'>Hi!</t>",
"<t size='2' shadow='2'>Hey! Excuse me, sir!</t>",
"<t size='2' shadow='2'>Excuse me!</t>"];
private _noEnglish=selectRandom["(He shakes his head)","(He looks clueless)","(He seems confused)"];
private _askIntel=str selectRandom[
	"<t size='2' shadow='2'>Could you give us some intel?  We're here to help!</t>",
	"<t size='2' shadow='2'>Do you have any intel we can use?  We're here to help!</t>",
	"<t size='2' shadow='2'>Have you seen insurgents or heard any rumors?  We're here to restore Vietnam.</t>",
	"<t size='2' shadow='2'>Can you help us?  We want to defeat the insurgents ruining your country.</t>",
	"<t size='2' shadow='2'>If you give me some valuable information, I promise we'll protect you.</t>"];
private _iHaveNoIntel=str selectRandom[
	"<t size='2' shadow='2'>I haven't seen or heard anything.</t>",
	"<t size='2' shadow='2'>Sorry, I don't know anything.</t>",
	"<t size='2' shadow='2'>If there were rebels here, they're gone now.</t>",
	"<t size='2' shadow='2'>Search elsewhere.</t>"];
private _noGiveIntel=str selectRandom[
	"<t size='2' shadow='2'>I... I can't, please leave me alone.</t>",
	"<t size='2' shadow='2'>They'll kill me if I talk; I can't help you.</t>",
	"<t size='2' shadow='2'>They'll hurt my family if I help you!  I'm sorry!</t>",
	"<t size='2' shadow='2'>I don't want to get in the middle of things.</t>",
	"<t size='2' shadow='2'>I don't want to take sides, please just leave me be!</t>",
	"<t size='2' shadow='2'>You?  Need MY help?!  I think I'll just wait this war out...</t>",
	"<t size='2' shadow='2'>Please!  If they see me talking to you, they'll kill me AND my family!</t>"];

titleText[_hello,"PLAIN DOWN",-1,true,true];player setRandomLip true;_a allowDamage false;
sleep 1;
if(!weaponLowered player)then{player playMove"AmovPercMstpSrasWrflDnon_AmovPercMstpSlowWrflDnon"};
_a doWatch player;_a lookAt player;
sleep .5;
player playAction"gestureHi";_a doWatch player;player setRandomLip false;
sleep 1;
_a playAction"Stop";[_a,"PATH"]remoteExec["disableAI"];[_a,"MOVE"]remoteExec["disableAI"];
switch(floor random 3)do{
case 0:{player switchMove"HubStanding_idle1"};
case 1:{player switchMove"HubStanding_idle2"};
default{player switchMove"HubStanding_idle3"};
};
private _pDir=(_a getDir player);
sleep 1;
[_a,_pDir]remoteExec["setDir"];sleep .5;_a playAction"gestureHi";
sleep 1.5;
if(true)then{//if(_myTrait)then{
	//If elder, generate task and exit, instead of asking for intel
	if(uniform _a isEqualTo"U_C_FormalSuit_01_tshirt_black_F")exitWith{
	private _b=(nearestObjects[_a,["land_chapel_v1_f","land_chapel_v2_f","land_chapel_small_v1_f","land_chapel_small_v2_f","land_church_01_v1_f","land_church_01_v2_f"],40])#0;
	if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B",0,true];[]remoteExecCall["Ins_NewTask",2]}else{titleText["(This elder has already given us a task)","PLAIN DOWN",-1,true,true];playSound"FD_CP_Not_Clear_F";};
	player setVariable["civA",nil];
	sleep 1;
	player playMove"AmovPercMstpSlowWrflDnon";
	};
titleText[_askIntel,"PLAIN DOWN",-1,true,true];player setRandomLip true;
sleep 5;
player setRandomLip false;
sleep 1;
_a setRandomLip true;
	if(_r==1)then{playSound"FD_Finish_F";
		titleText["<t size='5' shadow='2'>(Acquiring Intel)</t>","PLAIN DOWN",-1,true,true];
		[_a,"Acts_PointingLeftUnarmed"]remoteExec["switchMove"];
		sleep 5;
		[_a,""]remoteExec["switchMove"];_a setRandomLip false;
		sleep 1;
		_a doWatch objNull;_a lookAt objNull;[_a,"PATH"]remoteExec["enableAI"];[_a,"MOVE"]remoteExec["enableAI"];
		sleep 1;
		player playMove"AmovPercMstpSlowWrflDnon";
		private _p=player;
		(name _p)remoteExec["Ins_NewIntel",2];//INTEL GIVEN
		}else{
		//He doesn't want to give intel
		[_a,"Acts_StandingSpeakingUnarmed"]remoteExec["switchMove"];
		titleText[_noGiveIntel,"PLAIN DOWN",-1,true,true];playSound"FD_CP_Not_Clear_F";
		sleep 4;
		[_a,""]remoteExec["switchMove"];_a setRandomLip false;
		sleep 1;
		_a doWatch objNull;_a lookAt objNull;[_a,"PATH"]remoteExec["enableAI"];[_a,"MOVE"]remoteExec["enableAI"];
		sleep 1;
		player playMove"AmovPercMstpSlowWrflDnon"
		};
}else{
titleText["<t size='2' shadow='2'>'Do you speak English?'</t>","PLAIN DOWN",-1,true,true];player setRandomLip true;
sleep 2;
player setRandomLip false;
sleep 1;
_a playAction"GestureNo";
sleep 1;
_a doWatch objNull;[_a,"PATH"]remoteExec["enableAI"];[_a,"MOVE"]remoteExec["enableAI"];_a setRandomLip false;_a lookAt objNull;
sleep 1;
player playMove"AmovPercMstpSlowWrflDnon";playSound"FD_CP_Not_Clear_F";titleText[_noEnglish,"PLAIN DOWN",-1,true,true]};
player setVariable["civA",nil];_a allowDamage true
};

civ_detain={params["_a"];
if(cursorTarget!=_a)exitWith{};
if(isNull _a || !alive _a)exitWith{titleText["He's dead...","PLAIN DOWN"];titleFadeOut 5};
if(player distance _a>5)exitWith{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 5};
if!(side _a isEqualTo CIVILIAN)exitWith{};
//private _terp=(player nearEntities["Man",8])select{!isNil{_x getVariable"terp"}};

//TODO: Add an array of cuffed animations the AI could be playing
//if(animationState _a in[])then{};
if(isNil{_a getVariable"detained"})then{
_a setVariable["detained",true,true];
playSound"assemble_target";
player switchMove"AmovPercMstpSrasWrflDnon_AinvPercMstpSrasWrflDnon_Putdown";
[_a,"anim"]remoteExecCall["disableAI",0,true];
[_a,"AmovPercMstpSnonWnonDnon_EaseIn"]remoteExecCall["switchMove",0,true];
}else{
_a setVariable["detained",nil,true];
playSound"assemble_target";
[_a,"anim"]remoteExecCall["enableAI",0,true];
if(animationState _a isEqualTo"amovpercmstpsnonwnondnon_easein")then{[_a,"AmovPercMstpSnonWnonDnon_EaseOut"]remoteExecCall["switchMove",0,true]};
if(animationState _a in["acts_aidlpsitmstpssurwnondnon01","acts_aidlpsitmstpssurwnondnon02","acts_aidlpsitmstpssurwnondnon03","acts_aidlpsitmstpssurwnondnon04","acts_aidlpsitmstpssurwnondnon05"])then{[_a,"Acts_AidlPsitMstpSsurWnonDnon_out"]remoteExecCall["playMoveNow",0,true]};
};};
/*
civ_detain={private _a=_this#0};
civ_release={private _a=_this#0};
civ_search={};
civ_followMe={};

HandSignalGetDown
HandSignalGetUp
HandSignalHold
HandSignalMoveForward
HandSignalMoveOut
HandSignalPoint
"\a3\dubbing_f_epa\a_in\90_Stop\a_in_90_stop_CH0_0.ogg"

//Laying on side, static, with hands tied behind back
"revive_secured"

//Sitting on floor with hands tied behind back
"Acts_AidlPsitMstpSsurWnonDnon01"
"Acts_AidlPsitMstpSsurWnonDnon02"
"Acts_AidlPsitMstpSsurWnonDnon03"
"Acts_AidlPsitMstpSsurWnonDnon04"
"Acts_AidlPsitMstpSsurWnonDnon05"
"Acts_AidlPsitMstpSsurWnonDnon_loop"
"Acts_AidlPsitMstpSsurWnonDnon_out"

//On knees with head down, arms tied behind back
"Acts_ExecutionVictim_Loop"
"Acts_ExecutionVictim_Unbow"

//Puts hands behind back, with transition in and out animations
"AmovPercMstpSnonWnonDnon_Ease" - Looping hands behind back
"AmovPercMstpSnonWnonDnon_EaseIn"
"AmovPercMstpSnonWnonDnon_EaseOut"

//Hands Behind Back Standing
"InBaseMoves_HandsBehindBack1"
"InBaseMoves_HandsBehindBack2"
"UnaErcPoslechVelitele1"
"UnaErcPoslechVelitele2"
"UnaErcPoslechVelitele3"
"UnaErcPoslechVelitele4"
*/