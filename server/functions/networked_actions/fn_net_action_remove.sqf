/*
    File: fn_net_action_remove.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Removes the networked action with the specific id.
		This removes it for all clients.
    
    Parameter(s):
        _id - Id of the action to remove.
    
    Returns:
		None
    
    Example(s):
		[_id] call para_s_fnc_net_action_remove
*/
params ["_id"];

#define KEY(keyName) ([_id, keyName] call para_g_fnc_net_action_varname)

localNamespace setVariable [KEY("object"), nil];
localNamespace setVariable [KEY("arguments"), nil];
localNamespace setVariable [KEY("script"), nil];
localNamespace setVariable [KEY("condition"), nil];
localNamespace setVariable [KEY("radius"), nil];
localNamespace setVariable [KEY("unconscious"), nil];

//Clear the JIP that adds the action.
remoteExec ["", KEY("JIP")];

//Remove the action from any current clients.
[_id] remoteExec ["para_c_fnc_net_action_remove", 0];