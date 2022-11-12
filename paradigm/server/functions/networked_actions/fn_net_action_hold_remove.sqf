/*
    File: fn_net_action_hold_remove.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Deletes a hold action with the given id - this removes the action for all clients.
    
    Parameter(s):
        _id - Id of the hold action to remove.
    
    Returns:
        None
    
    Example(s):
        [_myId] call para_s_fnc_net_action_hold_remove
*/

params ["_id"];

#define KEY(keyName) ([_id, keyName] call para_g_fnc_net_action_varname)

missionNamespace setVariable [KEY("codeStart"), nil];
missionNamespace setVariable [KEY("codeCompleted"), nil];
missionNamespace setVariable [KEY("codeInterrupted"), nil];
missionNamespace setVariable [KEY("arguments"), nil];
missionNamespace setVariable [KEY("removeCompleted"), nil];

//Clear the JIP that adds the action.
remoteExec ["", KEY("JIP")];

//Remove the action from any current clients.
[_id] remoteExec ["para_c_fnc_net_action_hold_remove", 0];