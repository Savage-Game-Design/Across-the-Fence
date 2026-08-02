params["_b","_bC","_bN","_rC"];private _zs=[];
if(isNil{_b getVariable"civB"})then{
//if((toLowerANSI typeOf _b)in["land_vn_market_stalls_01_ep1","land_vn_market_stalls_02_ep1"])exitWith{if((daytime<6)||(daytime>16)||(rain>0.3))exitWith{};(server getVariable"civB")pushBack _b;[_b]call hajiMktSales;};
if(floor random _rC==2)then{
(server getVariable"civB")pushBack _b;
for"_x"from 0 to(random _bN)do{
private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a enableSimulation false;_a hideObjectGlobal true;_a disableAI"ALL";_a allowDamage false;_a setVariable["FSM",""];
_a setPosATL(selectRandom(_b buildingPos -1));
_zs pushBack _a;(server getVariable"civs")pushBack _a;
[_a,_b]call civInit}};
}else{
private _v=_b getVariable"civB";
if(_v isEqualTo[])exitWith{};_b setVariable["civB",[]];(server getVariable"civB")pushBack _b;
for"_x"from 0 to(count _v-1)do{
private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a enableSimulation false;_a hideObjectGlobal true;_a disableAI"ALL";_a allowDamage false;_a setVariable["FSM",""];
_a setPosATL(selectRandom(_b buildingPos -1));
_zs pushBack _a;(server getVariable"civs")pushBack _a;//POSSIBLY WHERE DUPLICATE AGENT IS ADDED TO ARRAY?
[_a,_b]call civInit};};
_b setVariable["civB",_zs];
/*	BROKEN: Trigger keeps spamming sound effects, rather than playing 1 every 180s
if ( floor random 2==1 && { ( ( _b getVariable"civB" ) findIf { typeOf _x isEqualTo "EmptyDetector" } ) == -1 } ) then
{
	private _t=createTrigger [ "EmptyDetector", _b buildingPos 0 , false ];
	(_b getVariable "civB") pushBack _t;
	_t setTriggerText"";
	_t setTriggerArea[50,50,0,true];
	_t setTriggerActivation["ANYPLAYER","PRESENT",true];
	_t setTriggerTimeout[180,180,180];
	_t setTriggerStatements[
	//COND
	"this",

	//ACT
	"if ( daytime < 6 || daytime > 16 ) exitWith {};
	private _exists=thisTrigger nearObjects['#soundonvehicle',2];
	if ( count _exists > 0 )then
	{
		deleteVehicle ( _exists#0 )
	};
	thisTrigger spawn
	{
		while { triggerActivated _this } do
		{
			_this say3D ( selectRandom [ 'vn_ambient_village_sound_1' , 'vn_ambient_village_sound_2' ] );
			sleep 3*60;
		};
	};",

	//DEACT
	""];
};
*/