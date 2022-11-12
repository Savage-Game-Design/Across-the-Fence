/*
    File: fn_net_action_fire.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Remove executed by clients fire a networked action.
		Must use rehandler, as it uses the _player variable.
    
    Parameter(s):
		_actionId - Id of the action [STRING]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

params ["_actionId"];

#define KEY(keyName) ([_actionId, keyName] call para_g_fnc_net_action_varname)

private _caller = _player;
private _originalTarget = localNamespace getVariable KEY("object");
private _arguments = localNamespace getVariable KEY("arguments");
private _script = localNamespace getVariable KEY("script");
private _condition = localNamespace getVariable KEY("condition");
private _radius = localNamespace getVariable KEY("radius");
private _unconscious = localNamespace getVariable KEY("unconscious");

//Check if the player is near enough to the object. Adding 5m in case there's a difference in positions on the different machines.
//Shouldn't happen, as this is enforced clientsidde.
if (_player distance _originalTarget > (_radius + 5)) exitWith {
	["You are too far away to do that."] remoteExec ["systemChat", player];
};

//This shouldn't happen, as it should be checked clientside.
//If it does, let the player know, as it's probably a scripting error.
if (!_unconscious && lifeState _player == "INCAPACITATED") exitWith {
	["Cannot do that while unconscious"] remoteExec ["systemChat", player];
};

//Validate that the player is allowed to run this.
private _target = vehicle _originalTarget;
private _canRun = _caller call _condition;
if (canRun isEqualType true && {!canRun}) exitWith {
	//If the player can't run the action, let them know (this shouldn't happen, if it does, it's a scripting bug) and abort.
	["Cannot trigger action"] remoteExec ["systemChat", player];
};

//All checks passed! Call the function.
[_originalTarget, _caller, _actionId, _arguments] call _script