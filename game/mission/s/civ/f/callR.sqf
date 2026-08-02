params["_r","_rPos"];private["_zs","_a"];private _zs=[];
if(floor random _rC==2)then
{
	( server getVariable"civR" )pushBack _r;
	private _a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
	_a enableSimulation false;_a hideObjectGlobal true;_a disableAI"ALL";_a allowDamage false;
	_a setVariable["FSM","road"];
	_a setDir ( getDir _r );
	_a setPosATL _rPos;
	_zs pushBack _a;
	( server getVariable "civs" ) pushBack _a;
	[_a,_r] call civInit;
};
server getVariable["civR",[_r,]];