/*
    File: fn_abort_building.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	    Toggles var to true if key pressed

    Parameter(s): none

    Returns:
	    Always returns false [BOOL]

    Example(s):
	    call para_c_fnc_abort_building
*/

if (!isNil "para_l_placing_script") then
{
	terminate para_l_placing_script;
	if (!isNil "para_l_placing_object" && {!(isNull para_l_placing_object)}) then
	{
		{
			detach _x;
			deleteVehicle _x;
		} forEach attachedObjects para_l_placing_object;
		deleteVehicle para_l_placing_object;
		[player,para_l_building_action_id] call BIS_fnc_holdActionRemove;
	};
};

if (!isNil "para_l_placing_click_handler") then {
	(findDisplay 46) displayRemoveEventHandler ["MouseButtonUp", para_l_placing_click_handler];
	para_l_placing_click_handler = nil;
};

false;
