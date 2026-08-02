/*
[(player getVariable'PF_a'),civ_getDown]remoteExec['call',0];
[(player getVariable'PF_a'),civ_getUp]remoteExec['call',0];
[(player getVariable'PF_a'),civ_halt]remoteExec['call',0];
[(player getVariable'PF_a'),civ_goAway]remoteExec['call',0];
*/

PF_Interact={disableSerialization;params["_a"];
if(!isNil{player getVariable"civA"})exitWith{};
_d=findDisplay 46 createDisplay"RscDisplayEmpty";
	_d displayAddEventHandler["Unload",{params["_display"];playSound"ZoomOut";
		if!(isNil{player getVariable"civA"})then{
			if!(isNil{(player getVariable"civA")getVariable"Asked"})then{
				if!(animationState player isEqualTo"amovpercmstpslowwrfldnon")then{player setVariable["civA",nil]}
			}else{[]spawn{sleep 0.2;player setVariable["civA",nil]}}}}];
setMousePosition[.5,.5];
player setVariable["civA",_a];playSound"ZoomIn";
_getUp=_d ctrlCreate["RscShortcutButton",5550];
_getUp ctrlSetPosition[
0.481437*safezoneW+safezoneX,
0.2294*safezoneH+safezoneY,
0.0474375*safezoneW,
0.0814*safezoneH];
_getUp ctrlSetText'GET UP!';
_getUp ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');[_p,civ_getUp]remoteExec['call',[_id,2]];player setVariable['civA',nil]"];
_getUp ctrlCommit 0;

_getDwn=_d ctrlCreate["RscShortcutButton",5551];
_getDwn ctrlSetPosition[
0.481437*safezoneW+safezoneX,
0.6914*safezoneH+safezoneY,
0.0474375*safezoneW,
0.0792*safezoneH];
_getDwn ctrlSetText'GET DOWN!';
_getDwn ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');[_p,civ_getDown]remoteExec['call',[_id,2]];player setVariable['civA',nil]"];
_getDwn ctrlCommit 0;

_shoo=_d ctrlCreate["RscShortcutButton",5552];
_shoo ctrlSetPosition[
0.347376*safezoneW+safezoneX,
0.3394*safezoneH+safezoneY,
0.0474375*safezoneW,
0.0814*safezoneH];
_shoo ctrlSetText'GO AWAY!';
_shoo ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');[_p,civ_goAway]remoteExec['call',[_id,2]];player setVariable['civA',nil]"];
_shoo ctrlCommit 0;

_come=_d ctrlCreate["RscShortcutButton",5553];
_come ctrlSetPosition[
0.347376*safezoneW+safezoneX,
0.5792*safezoneH+safezoneY,
 0.0474375*safezoneW,
0.0814*safezoneH];
_come ctrlSetText'FOLLOW ME!';
_come ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');_p call civ_followMe;player setVariable['civA',nil]"];
_come ctrlCommit 0;

_halt=_d ctrlCreate["RscShortcutButton",5554];
_halt ctrlSetPosition[
0.605187*safezoneW+safezoneX,
0.3394*safezoneH+safezoneY,
0.0474375*safezoneW,
0.0814*safezoneH];
_halt ctrlSetText'HALT!';
_halt ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');[_p,civ_halt]remoteExec['call',[_id,2]];player setVariable['civA',nil]"];
_halt ctrlCommit 0;

_greet=_d ctrlCreate["RscShortcutButton",5555];
_greet ctrlSetPosition[
0.605187*safezoneW+safezoneX,
0.5792*safezoneH+safezoneY,
0.0474375*safezoneW,
0.0814*safezoneH];

if(!isNil{_a getVariable"Asked"})then{
_greet ctrlSetText"DETAIN";
_greet ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');_p spawn civ_detain;player setVariable['civA',nil]"]
}else{
_greet ctrlSetText"INTEL";
_greet ctrlAddEventHandler["mouseEnter","params['_ctrl'];(ctrlParent _ctrl)closeDisplay(ctrlIDC _ctrl);ctrlDelete _ctrl;_id=clientOwner;private _p=(player getVariable'civA');_p spawn civ_startAsk;"]};
_greet ctrlCommit 0
};

PF_Menu={
//TODO: If target is vehicle, tell driver to Stop / GTFO
//May need to readd EH within some exitWiths, in case of premature exit after removal of EH
if(inputAction"salute">.1)exitWith{};
_a=cursorObject;
if(player==_a)exitWith{};
if(isNull _a || typeOf _a!="C_Soldier_VR_F")then{
_e=player nearEntities["Man",9];
	if(count _e>0)then{
	_e apply{if(!(side _x isEqualTo civilian))then{_e=_e-[_x]}else{
	_front=[getPos player,getDir player,45,getPos _x]call BIS_fnc_inAngleSector;
	if(!_front)then{_e=_e-[_x]};
	if(count _e>0)then{_a=_e#0}}}}};_a;
if(isNull _a)exitWith{};
if(_a isKindOf"Man" && side _a==civilian)then{
if(player distance2D _a<9)then{_a call PF_Interact}else{titleText["He's too far away...","PLAIN DOWN"];titleFadeOut 3};
[]spawn{sleep 1;
if(isNil"PF_menuEH2")then{PF_menuEH2=findDisplay 46 displayAddEventHandler["KeyDown","if(inputAction'Salute'>0)then{findDisplay 46 displayRemoveEventHandler _thisEventHandler;player playAction'salute';[]call PF_Menu;}"]}}}
};

PF_menuEH1=findDisplay 46 displayAddEventHandler["KeyDown","if(inputAction'salute'>0)then{findDisplay 46 displayRemoveEventHandler _thisEventHandler;player playAction'salute';[]call PF_Menu;}"];