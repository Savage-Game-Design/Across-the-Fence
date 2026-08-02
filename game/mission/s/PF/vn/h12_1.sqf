//land_vn_market_stalls_02_ep1
isNil{params["_b"];
private _dir = getDir _b;

//private _nearTriggers=((getPos _b)nearObjects["EmptyDetector",25])select{triggerText _x in["mkt","dog"]};//Potential optimization for later on
//if(_nearTriggers isEqualTo[])then{
//NEEDS TO BE REMOTELY EXECUTED!!!
/*
private _t=createTrigger["EmptyDetector",_b,false];
_t setTriggerText"mkt";
_t setTriggerArea[50,50,0,true];
_t setTriggerActivation["ANYPLAYER","PRESENT",true];
_t setTriggerTimeout[14,14,14];
_t setTriggerStatements[
//COND
"this",

//ACT
"if ( daytime<6 || { daytime > 16.5 } ) exitWith {};
private _exists = thisTrigger nearObjects [ '#soundonvehicle' , 2 ];
if ( count _exists > 0 ) then { deleteVehicle (_exists#0) };
thisTrigger spawn
{
	while { triggerActivated _this } do
	{
		_this say3D ( selectRandom [ 'vn_ambient_market_sound_1' , 'vn_ambient_market_sound_2' ] );
		sleep 14;
	};
};",

//DEACT
""];
*/
_b setVariable["PF",[]];
//};

private _EHs=
{
	params [ "_c" ];
	
	_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"AnimDone";_a removeAllEventHandlers"FiredNear";}];

/*
	_c addEventHandler["AnimDone",
	{
		params[ "_c" , "_an" ];
		if ( !alive _c ) exitWith { _c removeEventHandler ["AnimDone",_thisEventHandler]; };
		[_c,_an]remoteExec["switchMove",0,_c];
	}];
*/
	
	_c addEventHandler["FiredNear",{
	params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];_a removeAllEventHandlers"AnimDone";
	{_a enableAI _x}forEach["anim","teamSwitch","move","path"];
	switch(floor random 2)do{
	case 0:{[_a,"ApanPercMstpSnonWnonDnon_G01"]remoteExec["switchMove",0,_a]};
	case 1:{[_a,"ApanPknlMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
	case 2:{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
	default{};};
	_a forceWalk false;_a forceSpeed 13;
	_a setDestination [ ( _a getPos [ 99 , ( getDir _f + 180 ) ] ) , "LEADER PLANNED" , true ];
	}];
};

private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a disableAI"all";(_b getVariable"PF")pushBack _a;//_a setVariable["FSM","anim"];
{_a call _x}forEach[civF,civG,civH,civU,_EHs];
_a setPos(_b modelToWorld[7,2.3,-0.9]);
[_a,"Acts_B_out2_briefing"]remoteExec["switchMove",0,_a];
_a addEventHandler["AnimDone",{[(_this#0),"Acts_B_out2_briefing"]remoteExec["switchMove",0,(_this#0)]}];
_a setDir _dir;
if(floor random 2==0)then{
private _a1=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a1 disableAI"all";(_b getVariable"PF")pushBack _a1;//_a1 setVariable["FSM","anim"];
{_a1 call _x}forEach[civF,civG,civH,civU,_EHs];
_a1 setPos(_b modelToWorld[5,2.7,-0.9]);
_a1 setDir (_dir+140);
[_a1,"HubBriefing_think"]remoteExec["switchMove",0,_a1];
_a1 addEventHandler["AnimDone",{[(_this#0),(selectRandom["HubBriefing_think","HubBriefing_talkAround"])]remoteExec["switchMove",0,(_this#0)]}]};
if(floor random 2==0)then{
private _a2=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a2 disableAI"all";(_b getVariable"PF")pushBack _a2;//_a2 setVariable["FSM","anim"];
{_a2 call _x}forEach[civF,civG,civH,civU,_EHs];
_a2 setPos(_b modelToWorld[7.2,3.2,-0.9]);
_a2 setDir(_dir+180);
[_a2,"HubBriefing_loop"]remoteExec["switchMove",0,_a2];
_a2 addEventHandler["AnimDone",{[(_this#0),(selectRandom["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch"])]remoteExec["switchMove",0,(_this#0)]}]};
if(floor random 2==0)then{
private _a3=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a3 disableAI"all";(_b getVariable"PF")pushBack _a3;//_a3 setVariable["FSM","anim"];
{_a3 call _x}forEach[civF,civG,civH,civU,_EHs];
_a3 setPos(_b modelToWorld[6,3,-0.9]);
_a3 setDir(_dir+140);
[_a3,"HubStandingUC_move1"]remoteExec["switchMove",0,_a3];
_a3 addEventHandler["AnimDone",{[(_this#0),(selectRandom["HubStandingUC_move1","HubStandingUC_idle1","HubStandingUC_idle2","HubStandingUC_idle3"])]remoteExec["switchMove",0,(_this#0)]}]};

private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a disableAI"all";(_b getVariable"PF")pushBack _a;//_a setVariable["FSM","anim"];
{_a call _x}forEach[civF,civG,civH,civU,_EHs];
_a setPos(_b modelToWorld[2,1.5,-0.9]);
[_a,"Acts_PointingLeftUnarmed"]remoteExec["switchMove",0,_a];
_a setDir(_dir-25);
if(floor random 2==0)then{
private _a1=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a1 disableAI"all";(_b getVariable"PF")pushBack _a1;//_a1 setVariable["FSM","anim"];
{_a1 call _x}forEach[civF,civG,civH,civU,_EHs];
_a1 setPos(_b modelToWorld[3,2.7,-0.9]);
_a1 setDir (_dir+180);
[_a1,"LHD_krajPaluby"]remoteExec["switchMove",0,_a1];
_a1 addEventHandler["AnimDone",{[(_this#0),"LHD_krajPaluby"]remoteExec["switchMove",0,(_this#0)]}]};

private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a disableAI"all";(_b getVariable"PF")pushBack _a;//_a setVariable["FSM","anim"];
{_a call _x}forEach[civF,civG,civH,civU,_EHs];
_a setPos(_b modelToWorld[-3.4,1.2,-0.9]);
[_a,"passenger_flatground_generic05"]remoteExec["switchAction",0,_a];
_a setDir(_dir+45);

private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a disableAI"all";(_b getVariable"PF")pushBack _a;//_a setVariable["FSM","anim"];
{_a call _x}forEach[civF,civG,civH,civU,_EHs];
_a setPos(_b modelToWorld[-6,2,-0.9]);
[_a,"Acts_JetsCrewaidF_idle2"]remoteExec["switchAction",0,_a];
_a addEventHandler["AnimDone",{[(_this#0),"Acts_JetsCrewaidF_idle2"]remoteExec["switchMove",0,(_this#0)]}];
_a setDir _dir;
if(floor random 2==0)then{
private _a1=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a1 disableAI"all";(_b getVariable"PF")pushBack _a1;//_a1 setVariable["FSM","anim"];
{_a1 call _x}forEach[civF,civG,civH,civU,_EHs];
_a1 setPos(_b modelToWorld[-5,2.7,-0.9]);
_a1 setDir (_dir+180);
[_a1,"HubStandingUC_move1"]remoteExec["switchMove",0,_a1];
_a1 addEventHandler["AnimDone",{[(_this#0),(selectRandom["HubStandingUC_move1","HubStandingUC_idle1","HubStandingUC_idle2","HubStandingUC_idle3"])]remoteExec["switchMove",0,(_this#0)]}];};
[_b,"mrkt"]call PF_snd;
}