/*
    File: fn_building_add_build_progress.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Adds to the build progress of a building
    
    Parameter(s):
        _building - Building to set the build progress on [OBJECT]
        _newProgress - Build progress between 0 and 1 [NUMBER]
        _updateObjects - Whether or not to update the objects to reflect the new build progress [BOOLEAN]
    
    Returns:
        None
    
    Example(s):
        [_building, 1] call para_s_fnc_building_add_build_progress
*/

params ["_building", "_progressChange", ["_updateObjects", true]];

private _oldProgress = _building getVariable ["para_g_build_progress", 0];
private _newProgress = (_oldProgress + _progressChange) min 1 max 0;
_building setVariable ["para_g_build_progress", _newProgress, true];


//Building has been built.
if (_newProgress >= 1 && _oldProgress < 1) then 
{
	[_building, _updateObjects] call para_s_fnc_building_on_constructed;
};

//Building has been dismantled from a built state.
if (_newProgress < 1 && _oldProgress >= 1) then 
{
	[_building, _updateObjects] call para_s_fnc_building_on_deconstructed;
};

if (_newProgress < 1 && _updateObjects) then 
{
	//Update animation
	private _animState = linearConversion [0,1,_newProgress,0.6,1,true];
	{
		private _phase = _x animationSourcePhase "hide_supply_source";
		if !(_phase isEqualTo _animState) then
		{
			_x animateSource ["hide_supply_source",_animState];
		};
	} forEach (_building getVariable ["para_g_objects", []]);
};
