/*
    File: fn_bf_respawn_on_nonfunctional.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Called when a respawn building stops functioning.
        Disables the respawn point.
    
    Parameter(s):
        _building - Building that stopped being functional. [OBJECT]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params ["_building"];

private _objects = _building getVariable "para_g_objects";

{
	if (_x getVariable ["vn_drm_toggle",false]) then
	{
		// Toggle off
		_x setVariable ["vn_drm_toggle", false, true];
		// Send request to all clients to stop audio
		[_x] remoteExec ["vn_fnc_drm_delete_audio",0,_x];
	};

} forEach _objects;


