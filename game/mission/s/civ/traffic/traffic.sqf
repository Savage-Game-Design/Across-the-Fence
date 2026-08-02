if(!isServer)exitWith{};
PT_Cars=[];

waitUntil{
sleep 9;
if(PT_Dbug)then{hintSilent format["Cars Spawned: %1",count PT_Cars]};
if(count allPlayers>0)then{
	{
	if(count PT_Cars>=PT_MaxC)exitWith{};
	private _p=_x;

	private _nearC=PT_Cars select{_x distance _p<=PT_MaxD};
	
	private _r=[];
	private _pPos=getPosWorld _p;
	private _roads=_pPos nearRoads 2000;//PT_MaxD
	if(count _roads>0)then{
	{_r pushBack[_pPos distance _x,_x]}forEach _roads;
	_r sort false;
	_r=(selectRandom(_r select{(_pPos distance(_x#1))>1000 && !((_x#1)inArea baseTr)}))#1;//PT_MaxD/2 - //Select farthest road segment not within base - _r == selected road object [0 = distance, 1 = road obj]

	if(!isNull _r)then{
		private _rConn=roadsConnectedTo _r;
		_rDir=0;
		if(_rConn isEqualTo[])then{_rDir=getDir _r}else{_rDir=_r getDir(_rConn#0)};
		//private _pos=[(getPosATL _r select 0)-5*sin(random 359),(getPosATL _r select 1)-5*cos(random 359)]; 
		private _rPos=getPosATL _r;
				
				//Spawn Car / Agent
				if(count PT_Cars>=PT_MaxC)exitWith{};//Redundant?
				private _c=createVehicle[(selectRandom PT_cList),[0,0,0],[],0,"can_collide"];
				_c allowDamage false;_c setDamage 0;clearItemCargoGlobal _c;clearBackpackCargoGlobal _c;_c lock 3;_c setDir(if(isNil"_rDir")then{0}else{_rDir});_c engineOn true;
				PT_Cars pushBack _c;
				sleep 0.2;
				private _a=createAgent[PT_Man,[0,0,0],[],0,"can_collide"];//Spawn a setCaptive CSAT Survivor for Middle East
				//_a disableAI"ALL";
				{_a enableAI _x}forEach["ANIM","LIGHTS","MOVE","PATH"];//TEAMSWITCH
				_a call PT_initCiv;
				sleep 0.1;
				_a moveInDriver _c;_a forceSpeed PT_Speed;
				sleep 0.1;
				//_a forceFollowRoad true;
				_a engineOn true;//_c setEffectiveCommander _a;//forceSpeed > limitSpeed?
				if(PT_Cargo)then{_c call PT_cCargo};
				_c setDir(if(isNil"_rDir")then{0}else{_rDir});
				_c setPosATL[_rPos#0,_rPos#1,0.15];
				//_c setEffectiveCommander _a;
				sleep 1;
				_a addEventHandler["FiredNear",{params["_a"];_a removeEventHandler["FiredNear",_thisEventHandler];_a forceSpeed 120;_a setVariable["PT_Panic",true]}];
				if(alive _a && alive _c)then{[_a,_c]spawn{sleep 3;_this execFSM"s\civ\traffic\civT.fsm"};_c allowDamage true;_c setDamage 0;}else{deleteVehicle _a;deleteVehicle _c;PT_Cars=PT_Cars-[_c]};
				sleep 6;
				if(!alive _a)then{deleteVehicle _a;deleteVehicle _c;PT_Cars=PT_Cars-[_c]};
				};};
	}forEach allPlayers;
sleep 1;
//Cleanup Check
	{private _c=_x;
	if(allPlayers findIf{_x distance _c<PT_MaxD+999}<0)then{
		PT_Cars=PT_Cars-[_c];
		{deleteVehicle _x}forEach crew _c;
		deleteVehicle _c;
		};
	}forEach PT_Cars};
FALSE};
sleep 15;
0 call compileFinal(preprocessFileLineNumbers"s\civ\traffic\init.sqf");diag_log"Civ: Traffic script restarting";