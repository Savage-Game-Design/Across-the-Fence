/*
    File: fn_ai_run_behaviours_all_groups.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Executes main AI behaviour on all appropriate groups, once.
    
    Parameter(s):
		None
    
    Returns:
		None
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

{
	private _group = _x;
	//Call this every loop, because it'll abort if the group is already initialised.
	[_group] call para_g_fnc_ai_behaviour_init;
	//Don't execute on empty groups, it's a total waste.
	if (count units _group > 0) then {
		[_group] call para_g_fnc_behaviour_main;
	};
} forEach (allGroups select {local _x && {_x getVariable ["behaviourEnabled", false]}});