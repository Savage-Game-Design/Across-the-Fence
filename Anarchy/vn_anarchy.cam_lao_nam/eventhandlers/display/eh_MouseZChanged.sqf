/*
  Author: Aaron Clark

  Description:
	Mouse scroll wheel handler

  Example Usage:
	call vn_mf_fnc_mousezchanged;

  Parameter(s):
*/
params ["_displayorcontrol", "_scroll"];

// allow rotation change if build mode enabled
if !(isNil "vn_mf_buildMode") then
{
	vn_mf_buildDirection = vn_mf_buildDirection + _scroll;
};
