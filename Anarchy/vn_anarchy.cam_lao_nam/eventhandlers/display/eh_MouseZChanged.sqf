/*
  Author: Aaron Clark

  Description:
	Mouse scroll wheel handler

  Example Usage:
	call vn_an_fnc_mousezchanged;

  Parameter(s):
*/
params ["_displayorcontrol", "_scroll"];

// allow rotation change if build mode enabled
if !(isNil "vn_an_buildMode") then
{
	vn_an_buildDirection = vn_an_buildDirection + _scroll;
};
