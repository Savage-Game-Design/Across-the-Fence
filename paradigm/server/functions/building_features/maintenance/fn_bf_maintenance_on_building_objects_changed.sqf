/*
    File: fn_bf_maintenance_on_building_objects_changed.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Adds vehicle maintenance actions to objects.
    
    Parameter(s):
        _building - Building whose objects have changed [NAMESPACE]
        _newObjects - New objects attached to the building [ARRAY]
    
    Returns:
        None
    
    Example(s):
        See building features config
*/

params ["_building", "_newObjects"];

private _config = [_building] call para_g_fnc_get_building_config;
private _canRearm = getNumber (_config >> "features" >> "maintenance" >> "canRearm");
private _canRepair = getNumber (_config >> "features" >> "maintenance" >> "canRepair");
private _canRefuel = getNumber (_config >> "features" >> "maintenance" >> "canRefuel");

if (_canRepair > 0) then
{
    {
        [[_x], "para_c_fnc_bf_maintenance_add_repair_action", 0, _x] call para_s_fnc_remoteExecCall_jip_obj_stacked;
        [_x, 0] remoteExecCall ["setRepairCargo", _x];
    } forEach _newObjects;
};

if (_canRefuel > 0) then
{
    {
        [[_x], "para_c_fnc_bf_maintenance_add_refuel_action", 0, _x] call para_s_fnc_remoteExecCall_jip_obj_stacked;
        [_x, 0] remoteExecCall ["setFuelCargo", _x];
    } forEach _newObjects;
};

if (_canRearm > 0) then
{
    {
        [[_x], "para_c_fnc_bf_maintenance_add_rearm_action", 0, _x] call para_s_fnc_remoteExecCall_jip_obj_stacked;
        [_x, 0] remoteExecCall ["setAmmoCargo", _x];
    } forEach _newObjects;
};

