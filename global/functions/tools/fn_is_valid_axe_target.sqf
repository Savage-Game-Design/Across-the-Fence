/*
    File: fn_is_valid_axe_target.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Given a melee target, determine if the axe is appropriate to deal with it.
    
    Parameter(s):
        None
    
    Returns:
        None
    
    Example(s):
        [_target] call para_g_fnc_is_valid_axe_target
*/

params ["_target"];
// Hard execption for christmas trees (no grinch allowed)
if (_target isKindOf "Land_vn_t_piceaabiesnativitatis_2s") exitWith {
  systemChat "You've been put on the naughty list";
  false;
};
private _info = getModelInfo _target;
private _path = _info select 1;
private _valid = [
    "\bush\", 
    "\tree\", 
    "\crop\", 
    "\shrub\", 
    "\treeparts\", 
    "vegetation_f_vietnam\burned\", 
    "vn_plants_pmc\misc\", 
    "vegetation_f_vietnam\dried\"
];

_valid findIf { _x in _path } > -1
