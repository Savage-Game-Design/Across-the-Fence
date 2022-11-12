/*
    File: fn_operate_wrench.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Executes "Wrench" behaviour for melee target diagnostics
    
    Parameter(s):
        _hitObject object to be analysed
    
    Returns:
        None
    
    Example(s):
        [_thingToWhack] call para_c_fnc_operate_wrench
*/


params ["_hitObject"];

private _adminState = call BIS_fnc_admin;
if (_adminState > 0) then
{
    private _bbr = boundingBoxReal _hitObject;
    private _info = getModelInfo _hitObject;
    private _path = _info select 1;

    // systemChat "WRENCH";
    systemChat format ["target: %1", str(_hitObject)];
    systemChat format ["valid axe target : %1", [_hitObject] call para_g_fnc_is_valid_axe_target];
    systemChat format ["path : %1", str(_path)];
    systemChat format ["bounding box : %1", str(_bbr)];
    systemChat format ["bounding sphere : %1", _bbr select 2];
};

