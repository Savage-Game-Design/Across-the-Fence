/*
	File: config.hpp
	Author:  Savage Game Design
	Public: No
	
	Description:
		Handles notifications.
		@internal
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/


private _max = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "maxOnScreen");

private _handle = localNamespace getVariable ["#para_c_var_notificationOverlay_handle", scriptNull];

if (_handle isEqualTo scriptNull) then {
	call para_c_fnc_notificationNext;
	private _newHandle = [] spawn para_c_fnc_notificationLoop;
	localNamespace setVariable ["#para_c_var_notificationOverlay_handle", _newHandle];
} else {
	private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
	if ((count _actives) >= _max) then {
		call para_c_fnc_notificationRush;
	} else {
		call para_c_fnc_notificationNext;
	};
};
