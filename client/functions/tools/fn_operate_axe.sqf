/*
    File: fn_operate_axe.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Executes "Axe" behaviour and cuts down trees, bushes, etc
    
    Parameter(s):
        _hitObject object to be cut down / hidden
    
    Returns:
        None
    
    Example(s):
        [_thingToWhack] call para_c_fnc_operate_axe
*/

// This gets added each hit. The tree is felled when the total is higher than its 
// bounding sphere radius. 
// - The highest tree is around 30 (6 whacks)
// - with a typical tree being 15 to 20 (3 to 4 whacks) 
// - and a bush being 5 to 1 (1 to 2 whacks)
private _axeWork = 5;
params ["_hitObject"];

if (!([_hitObject] call para_g_fnc_is_valid_axe_target)) exitWith {};

private _size = round((boundingBoxReal _hitObject) select 2);
private _oldProgress = player getVariable ["para_c_axe_progress", 0];
// private _currentPos = getPos player;
private _currentPos = getPos _hitObject;
private _savedPos = player getVariable "para_c_axe_progress_tree";

if (isNil "_savedPos") then
{   
    _savedPos = _currentPos;
    player setVariable["para_c_axe_progress_tree", _savedPos];
    
};

if !(_savedPos isEqualTo _currentPos) then
{
    // not the same tree, clear out the work
    _oldProgress = 0;
    player setVariable ["para_c_axe_progress", nil];
    player setVariable ["para_c_axe_progress_tree", nil];
};

private _newProgress = _oldProgress + _axeWork;
player setVariable ["para_c_axe_progress", _newProgress];

if(_newProgress >= _size) then
{

    ["fell_tree", [_hitObject]] call para_c_fnc_call_on_server;
    player setVariable ["para_c_axe_progress", nil];
    player setVariable ["para_c_axe_progress_tree", nil];
};
