params["_a"];
_a setVariable["FSM",nil];
_a call civF;
_a addVest"vn_o_vest_08";
private _aPos=getPosATL _a;
private _tar=objNull;

//_a removeAllEventHandlers"FiredNear";
//[_a,"FiredNear"]remoteExec["removeAllEventHandlers",0,true];
//[_a,"MPKilled"]remoteExec["removeAllMPEventHandlers",0,true];
//_a remoteExec["removeAllActions",0,true];

//systemChat"Spawned Jihad";
_a setDamage 0;_a forceSpeed 9;
_a setUnitPos"UP";_a setBehaviour"AWARE";_a setSpeedMode"FULL";_a setCombatMode"RED";_a disableAI"all";
{_a enableAI _x}forEach["anim","path","move","teamSwitch"];//_a setAnimSpeedCoef 1;
if(toLowerANSI(animationState _a)in["apanpercmstpsnonwnondnon_g01","apanpknlmstpsnonwnondnon_g01","apanppnemstpsnonwnondnon_g01"])then{[_a,""]remoteExec["switchMove"]};
_a call civU;
for"_i"from 1 to 9 do{_a addItemToVest"vn_rgd5_grenade_mag"};//_a addItem"MobilePhone";
_a addMagazine"vn_mine_satchel_remote_02_mag";

sleep 20;
_a forceWalk false;
waitUntil{sleep 2;alive _a&&(count((_aPos nearEntities["SoldierWB",99])select{isPlayer _x})>0)};
private _tar=((_aPos nearEntities["SoldierWB",99])select{isPlayer _x});_tar sort true;_tar=_tar#0;

while{(!isNull _a && !isNull _tar)&&(alive _a&&alive _tar)}do{
_a setDestination[getPosATL _tar,"LEADER PLANNED",true];
sleep 1;
if(_a distance _tar>5)then{_a setDestination[getPosATL _tar,"LEADER PLANNED",true]};
	if(_a distance _tar<6)exitWith{[_a,"vn_sam_vccomba_003"]remoteExecCall["say3D"];
	sleep 2;
	if(alive _a)exitWith{
	createVehicle["HelicopterExploBig",getPosATL _a,[],0,"can_collide"];_a setDamage 1}}};

//if(isNull _tar || !alive _tar)then{systemChat"Jihad: Loop";[_a,_aPos]spawn _seekTar};